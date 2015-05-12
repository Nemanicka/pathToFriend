

 #https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=LPOO1Y3SF1IRX04VJZC53XKKQQHCAMIQSB1SQ1BWYDFY1BSV&client_secret=3WL0SL5JODGZDJD1PNVRJPQ4JQAVN2SW42AUBQJIMMXZ3VE2&v=20120609

require "net/http"
require "curb"
require "addressable/uri"


class FoursquareSearcher

    def initialize( attributes = {} )
        curb = Curl::Easy.new
        curb.url = "https://api.foursquare.com/v2/venues/"
    end

    def constructUrl ( location )
        baseUrl = "https://api.foursquare.com/v2/venues/search?"
        params = Addressable::URI.new
        params.query_values = { :ll => location.join(",").to_s,
                                :client_id => "LPOO1Y3SF1IRX04VJZC53XKKQQHCAMIQSB1SQ1BWYDFY1BSV",
                                :client_secret => "3WL0SL5JODGZDJD1PNVRJPQ4JQAVN2SW42AUBQJIMMXZ3VE2",
                                :v => "20120609"
                              }
        puts baseUrl + params.query
    end


end


 test = FoursquareSearcher.new
 test.constructUrl( [ 40.7, -74 ] )
 


