require_relative "DSQueue"
require "bitset"
require "typhoeus"


class Fetcher
    @qNewFetched
    @@fetched
    @threadPool


    def initialize( attribs = {} )
        @@fetched = Bitset.new( 1000000000 )
        @threadPool = Array.new
    end    

       def fetchFriends( queue )
        @qNewFetched = DSQueue.new
        total = 0
        succeed = 0
        failed = 0

        t1 = Time.now
        EM.run do   
            counter = 0

            puts "test11"
            queue.each_with_index do |el, ind|
            EM.stop if queue.size == 0
                userStack = el
                #queue.pop()
             #       puts "userStack = #{userStack}, size = #{ind}/#{queue.size}" 
                id = userStack[0]
                
                counter+=1
                     
                
 
                http = ( EM::HttpRequest.new('https://api.vk.com/method/friends.get', :connect_timeout => 10, :inactivity_timeout => 15 ).post :body => {:user_id => id } )
#                finish = true if( found == true and userStack.size != queue.front().size ) 
                http.errback { 
                    failed+=1
                    total +=1
                    p "Oops"; 
                    EM.stop if counter == 1
                    counter-=1;
                } 
                http.callback {
                    #p "seccess"
                    succeed+=1
                    total+=1
                    a = JSON.parse(http.response)["response"]
                    if a != nil

                #    puts "for #{userStack[0]} res = #{a.to_s} "


                        userStack.unshift( nil )


                   # puts "----------------"
                   # puts "class = #{a.class}"
                    #puts a
                    #puts "http = #{http.response}"
                   # puts "----------------"
    
#                    @qNewFetched.push( userStack )
          #          if ( opbitset[id] == 1 ) do
           #             found = true
            #        end
                    #a.each { |x| print " #{x}; " ;  userStack[0]=x;  @qNewFetched.push(userStack)  }
                        tt1 = Time.now
                        a.each do |x|
                            if @@fetched[x] != 1
                                @@fetched[x] = 1
                                us = Array.new(userStack);  
                                us[0]=x;  
                                @qNewFetched.push(us)
                            end
                        end
                        tt2 = Time.now
                        tt = tt2 -tt1
                        puts "iterating  time = #{tt}"
                    end
                    EM.stop if counter == 1
                    counter-=1;
                }
           end
        end
        t2 = Time.now
        t = t2 -t1
        puts "fetching time = #{t}"
        puts "succeed = #{succeed}/#{total}"  
        puts "failed = #{failed}/#{total}"  
        puts "Done."
        @qNewFetched.sort_by! { |x| x.first  }
        return @qNewFetched
    end      

end
