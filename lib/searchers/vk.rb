 #https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=LPOO1Y3SF1IRX04VJZC53XKKQQHCAMIQSB1SQ1BWYDFY1BSV&client_secret=3WL0SL5JODGZDJD1PNVRJPQ4JQAVN2SW42AUBQJIMMXZ3VE2&v=20120609

require "net/http"
require "curb"
require "addressable/uri"
require "json"
require "vkontakte_api"
require "bitset"
require "thread"



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
        @maxThreadNum = 150        

        @leftUsers << 1;
        @rightUsers << 7777777;
        execute();
    end

    def execute()
        @vk = VkontakteApi::Client.new
     #   fields = [:first_name, :last_name, :screen_name]
        a = @vk.friends.get(uid: 1)
        puts a[3]
 #      puts a[3]
#       puts a;  
        a.each do |x| 
           # if Thread.list.size < @maxThreadNum
#            puts Thread.list.size
            Thread.new {
                b = @vk.friends.get( uid: x ) 
            }
           # end
        end

        
    end

end


 test = FoursquareSearcher.new

