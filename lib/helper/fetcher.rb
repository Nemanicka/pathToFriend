require_relative "DSQueue"
require "bitset"

class Fetcher
    @qNewFetched
    @@fetched
    def initialize( attribs = {} )
        @qNewFetched = DSQueue.new 
        @@fetched = Bitset.new( 1000000000 )
    end    

    
    def fetchFriends( queue )
        total = 0
        succeed = 0
        failed = 0
        EM.run do   
            counter = 0
            while( queue.size != 0 ) do
                counter+=1
                userStack = queue.pop()
                    puts "userStack = #{userStack}, size = #{queue.size}" 
                id = userStack[0]
                
                next if @@fetched[id] == 1     
                     
                
 
                http = ( EM::HttpRequest.new('https://api.vk.com/method/friends.get', :connect_timeout => 10, :inactivity_timeout => 10 ).post :body => {:user_id => id } )
#                finish = true if( found == true and userStack.size != queue.front().size ) 
                http.errback { 
                    failed+=1
                    total +=1
                    p "Oops"; 
                    EM.stop if counter == 1
                    counter-=1;
                } 
                http.callback {
                    p "seccess"
                    succeed+=1
                    total+=1
                    a = JSON.parse(http.response)["response"]
                    userStack.unshift( nil )
#                    @qNewFetched.push( userStack )
                    @@fetched[id] = 1
          #          if ( opbitset[id] == 1 ) do
           #             found = true
            #        end
                    a.each { |x| userStack[0]=x;  @qNewFetched.push(userStack)  }
                    EM.stop if counter == 1
                    counter-=1;
                }
           end
        end
        puts "succeed = #{succeed}/#{total}"  
        puts "failed = #{failed}/#{total}"  
        puts "Done."
        return @qNewFetched
    end

end
