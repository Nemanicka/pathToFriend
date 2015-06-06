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
require_relative "../helper/fetcher"


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
  


#        @result = Array.new
#        @lUserHash = Bitset.new 1000000000 
#        @rUserHash = Bitset.new 1000000000 
#        @fetched = Bitset.new 10000000 
#        @finish1 = false        
#        @finish2 = false        


        @q1 = DSQueue.new
        @q1.push( [1] )
        
        @q2 = DSQueue.new
        @q2.push( [ 77777] )


       
        #@leftStack = Array.new
        #@rightStack = Array.new
        
#        threads = []
        
#        threads << Thread.new {
            fet1 = Fetcher.new
            @q1 = fet1.fetchFriends(@q1)
            puts @q1

#        }.run
        

#        threads << Thread.new { 
            fet2 = Fetcher.new

            @q2 = fet2.fetchFriends(@q2)

            puts @q2
#        }.run
        
#        threads.each { |x| x.join }        
        
=begin

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
=end        
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

