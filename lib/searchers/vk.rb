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


class FoursquareSearcher
    @maxThreadNum

    @leftUsersHash
    @rightUsersHash
    @leftUsers   
    @rightUsers

    def initialize( attributes = {} )
        @leftUsersHash = Bitset.new( 500000000 );
        @rightUsersHash = Bitset.new( 500000000 );
        @leftUsers = Array.new
        @rightUsers = Array.new
        @maxThreadNum = 3

        @leftUsers << 1;
        @rightUsers << 7777777;
        puts "start"
        t1 = Time.now
        execEM();
        t2 = Time.now
        t = t2 - t1
        puts t
    end

    def execEMulti
        EventMachine.run do   
            multi = EventMachine::MultiRequest.new    
            
    
        #    multi.add (:vk1, EventMachine::HttpRequest.new('https://api.vk.com/method/friends.get').post) :body => {:user_id => 1 }
      #      multi.add (:vk2, EventMachine::HttpRequest.new('https://api.vk.com/method/friends.get').post) :body => {:user_id => 77777 } 
            multi.callback do     
                puts multi.responses[:callback]     
                puts multi.responses[:errback]     
                EventMachine.stop   
            end 
        end 
    end

    def execEM
            total = 0
            succeed = 0
            failed = 0
        EM.run do   
           # http = []
            counter = 0
            1.upto(100) do |x|
                counter+=1
          #  1.upto(5) do |x|
           #     puts x
                http = ( EM::HttpRequest.new('https://api.vk.com/method/friends.get', :connect_timeout => 2, :inactivity_timeout => 10 ).post :body => {:user_id => x } )
         #   end
        #    http.each do |x|
                http.errback { 
                    failed+=1
                    total +=1
                    p "Oops"; 
                    EM.stop if counter == 1
                    counter-=1;
                } 
       #     end
     #       http.each do |x|
                http.callback { 
                    succeed+=1
                    total+=1
                    p http.response;
                    puts counter
                    EM.stop if counter == 1
                    counter-=1;
                } 
      #      end
     #      end  
           
           end
        end   
        puts "succeed = #{succeed}/#{total}"  
        puts "failed = #{failed}/#{total}"  
        puts "Done."
    end
end
 test = FoursquareSearcher.new

