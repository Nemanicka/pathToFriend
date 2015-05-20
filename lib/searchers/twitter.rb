 #https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=LPOO1Y3SF1IRX04VJZC53XKKQQHCAMIQSB1SQ1BWYDFY1BSV&client_secret=3WL0SL5JODGZDJD1PNVRJPQ4JQAVN2SW42AUBQJIMMXZ3VE2&v=20120609

require "net/http"
require "curb"
require "addressable/uri"
require "json"
require "twitter"

class FoursquareSearcher

    def initialize( attributes = {} )
        geocode = "50.45025,30.523889, 20km"
    
        @client = Twitter::Streaming::Client.new do |config|   
            config.consumer_key = "RtZzMs8aNhEsmCs1uqpUc7kbm"   
            config.consumer_secret = "6IQnIVDRNKKRK2u01DFxBtUT8wrGeu6hxUAWORz4jeNDF3E1fw"   
            config.access_token = "808599781-6161951XO8DVGE5HzdLvU6C4jb754UVhqRg0GX3R"   
            config.access_token_secret = "DiW3zMENZ2VuAPkdSPwnhk8zLBrcraEYccAIQw4kgqtpH" 
        end
#        getRESTTweets( geocode );

        getStreamTweets( geocode )

#        puts curb.url
#        curb.http_get()
#        parsed_answer = JSON.parse( curb.body_str );
    end

    def getRESTTweets ( geocode )
        
        clientREST = Twitter::REST::Client.new( @client.credentials )
        
#        clientREST = @client
        
        obj = clientREST.search( "", { :geocode => geocode } )
        objh = obj.to_h;
        counter = 0
        objh[:statuses].each {|x| puts x[:text]; counter+=1   }
     
        puts counter 
    end

    def getStreamTweets( geocode )
#        clientStream = Twitter::Streaming::Client.new( @client.credentials )
#        puts @client.credentials
#:locations => geocode
        @client.filter( { :track => "lol",  :location => geocode } ) do |x|
#        @client.filter( :track => "lal,lol" ) do |x|
            puts x.text if x.is_a?(Twitter::Tweet)
        end
    end


end


 test = FoursquareSearcher.new
 


