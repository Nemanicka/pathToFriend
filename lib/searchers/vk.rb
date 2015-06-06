 #https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=LPOO1Y3SF1IRX04VJZC53XKKQQHCAMIQSB1SQ1BWYDFY1BSV&client_secret=3WL0SL5JODGZDJD1PNVRJPQ4JQAVN2SW42AUBQJIMMXZ3VE2&v=20120609

require "net/http"
require "curb"
require "addressable/uri"
require "json"
require "vkontakte_api"
require "bitset"
require "thread"
#require "delayed_job_active_record"
require "sidekiq"
require "sidekiq/api"
require "time"
require "concurrent"
require "fiber"
require 'eventmachine' 
require 'em-http-request'



class DSQueue
    @q

    def initialize( attributes = {} )
        @q = Array.new
    end

    def push(arg)
        @q.push(arg)
    end

    def pop
        res = @q.first
        @q.delete_at(0)
        return res
    end

    def front
        return @q.first
    end

    def to_s
        return @q.to_s
    end

    def size
        return @q.size
    end

end



class FoursquareSearcher
    @maxThreadNum

    @usersHash
    @rUserHash
    @lUserHash
    @leftUsers   
    @rightUsers
    @result    
    @finish1
    @finish2
    @q1
    @q2
    @found

    def initialize( attributes = {} )
  


        @result = Array.new
        @lUserHash = Bitset.new 1000000000 
        @rUserHash = Bitset.new 1000000000 
        @fetched = Bitset.new 10000000 
        @finish1 = false        
        @finish2 = false        


        @q1 = DSQueue.new
        @q1.push( [1] )
        
        @q2 = DSQueue.new
        @q2.push( [ 77777] )
       
        #@leftStack = Array.new
        #@rightStack = Array.new
        


        f1 = Fiber.new do |f|
        
            
            while @finish1 == false do 
                
            
            puts "f1"            
            fetchFriends( @q1, @lUserHash, @finish  )
            f.transfer f1
            Fiber.yield
            end
        end
        
        f2 = Fiber.new do |f|
        
        
            while @finish2 == false do
            
            puts "f2"            
            fetchFriends( @q2, @rUserHash, @finish )
            f.transfer f2
            Fiber.yield
            end
        end
        
        f1.resume f2
        
#            fetchFriends( @q1, @lUserHash )
#        @finish = false        
#            fetchFriends( @q2, @rUserHash )

        #q.push({2=>1})
        #q.push(2=>3)
        #q.push(2=>4)
        #puts q
        #q.push(5=>6)
        #puts q
        #a = q.pop()
        #puts "a =   #{a}"
        #puts q
        
    end
    
    def test( method )
        puts "test"
        method.call( )
    end

    def tcallback
        puts "works"
    end

    def fetchFriends( queue, mybitset, opbitset, finish, stack )
        total = 0
        succeed = 0
        failed = 0
        EM.run do   
            counter = 0
            while( finish == false ) do
                counter+=1
                userStack = queue.pop()
                    puts "first elem = #{userStack}, size = #{queue.size}" 
                id = userStack[0]
                
                next if @fetched[id] == 1     
                
                
 
                http = ( EM::HttpRequest.new('https://api.vk.com/method/friends.get', :connect_timeout => 10, :inactivity_timeout => 10 ).post :body => {:user_id => id } )
                finish = true if( found == true and userStack.size != queue.front().size ) 
                http.errback { 
                    failed+=1
                    total +=1
                    p "Oops"; 
                    EM.stop if counter == 1
                    counter-=1;
                } 
                http.callback {
                    succeed+=1
                    total+=1
                    a = JSON.parse(http.response)["response"]
                    userStack.unshift( id )
                    queue.push( userStack )
                    @fetched[id] = 1
                    mybitset[id] = 1
                    if ( opbitset[id] == 1 ) do
                        found = true
                    end
                    a.each { |x| bitset[x] = 1  }
                    EM.stop if counter == 1
                    counter-=1;
                }
           end
        end
        puts "succeed = #{succeed}/#{total}"  
        puts "failed = #{failed}/#{total}"  
        puts "Done."
    end
    
    def fetchFriendsErrCallback
        
    end

    def fetchFriendsCallback
   #     @succeed+=1
         puts "callback lol"
   #     @total+=1
   #     p self.response;
   #     puts @counter
   #     EM.stop if @counter == 1
   #                @counter-=1;
    
    end
end



 test = FoursquareSearcher.new

