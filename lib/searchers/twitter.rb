 #https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=LPOO1Y3SF1IRX04VJZC53XKKQQHCAMIQSB1SQ1BWYDFY1BSV&client_secret=3WL0SL5JODGZDJD1PNVRJPQ4JQAVN2SW42AUBQJIMMXZ3VE2&v=20120609

require "net/http"
require "curb"
require "addressable/uri"
require "json"
require "twitter"

class FoursquareSearcher

    def initialize( attributes = {} )
        location = [ 50.45025, 30.523889 ]
    
        curb = Curl::Easy.new
        constructUrl( location );
#        puts curb.url
#        curb.http_get()
#        parsed_answer = JSON.parse( curb.body_str );
    end

    def constructUrl ( location )
        client = Twitter::REST::Client.new do |config|   
        config.consumer_key = "RtZzMs8aNhEsmCs1uqpUc7kbm"   
        config.consumer_secret = "6IQnIVDRNKKRK2u01DFxBtUT8wrGeu6hxUAWORz4jeNDF3E1fw"   
        config.access_token = "808599781-6161951XO8DVGE5HzdLvU6C4jb754UVhqRg0GX3R"   
        config.access_token_secret = "DiW3zMENZ2VuAPkdSPwnhk8zLBrcraEYccAIQw4kgqtpH" 
    end
        geocode = {:lat => 50.45025, :long => 30.523889, :radius => "20km" }
        lang = {:lang => "en"}
        
        obj = client.search( "my kiev", { :geocode => "50.45025,30.523889,20km"} )
#        obj = client.geo_search( {:lat => 50.45025, :long => 30.523889} )
        puts obj.to_h;
        
    end


end


 test = FoursquareSearcher.new
 


