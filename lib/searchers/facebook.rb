
require "net/http"
require "curb"
require "addressable/uri"
require "json"
require "koala"


class FacebookSearcher

    @cookies = {}

#    before_filter :parse_facebook_cookies


    def initialize( attributes = {} )
        geocode = "50.45025,30.523889, 20km"
        facebook_cookies()
    end

    def facebook_cookies     
        
     #   @oauth ||= Koala::Facebook::OAuth.new( 1594269097518324 , "7ef03d79be1d5888ae89b2d927b37d44" ).url_for_oauth_code()
        @updates = Koala::Facebook::RealtimeUpdates.new(:app_id => 1594269097518324, :secret => "7ef03d79be1d5888ae89b2d927b37d44")
        
     #   @access_token = @oauth.get_access_token()
     #   puts @access_token
    end 
    
    def index  
        @access_token = facebook_cookies['access_token']   
        @graph = Koala::Facebook::GraphAPI.new(@access_token)
    end



    def getRESTTweets ( geocode )
        
    end

    def getStreamTweets( geocode )
    end


end


 test = FacebookSearcher.new
 


