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
  


        @result = Array.new
#        @lUserHash = Bitset.new 1000000000 
#        @rUserHash = Bitset.new 1000000000 
#        @fetched = Bitset.new 10000000 
#        @finish1 = false        
#        @finish2 = false     
#
    #    user1 = getUidFromScreenName("1")
        #user1 = getUidFromScreenName("id13249892")
        user1 = getUidFromScreenName("id78040149")
        puts user1
        #user2 = getUidFromScreenName("xenachujah")
      #  user2 = getUidFromScreenName("id7974949")
    #    user2 = getUidFromScreenName("77777")
     #   user2 = getUidFromScreenName("vozcantante")
        user2 = getUidFromScreenName("id306490973")
#        puts user2

      
        
        @@resTotal = 0

        @q1 = DSQueue.new
        @q1.push( [user1] )
        
        @q2 = DSQueue.new
        @q2.push( [ user2] )
        u =  getUidFromScreenName("vozcantante")
        puts u



 #       @q3 = DSQueue.new

       
        #@leftStack = Array.new
        #@rightStack = Array.new
        
#        threads = []
        
#        threads << Thread.new {
#

        fet1 = Fetcher.new
        fet2 = Fetcher.new
        
#        @q1 = fet1.fetchFriends(@q1)
#        puts @q1.get_a.to_s
    
#        fet2 = Fetcher.new
#        fet3 = Fetcher.new
#        while true do
    times = 0
    t1 = Time.now
    while( true ) do
        times+=1

        puts "@q1 #{times}"
         @q1 = fet1.fetchFriends(@q1)
#        puts "q1 = #{@q1.get_a.to_s}"
 #       puts @q1.get_a.to_s
         searchCommon( @q1, @q2 )
#            puts "test1"
            if( @result.size != 0 )
 #               puts "res f = #{@result.size}"
                extendResult
                puts @result
                break
            end
         puts "test X"    
        
        
        puts "@q2 #{times}"
    
         @q2 = fet2.fetchFriends(@q2)
         puts "test Y"   
#        puts "q2 = #{@q2.get_a.to_s}"
    #    puts "++++++++++++++++++++++++++"
    #    puts @q2.get_a.to_s
    #    puts "=========================="
    #    puts @q1.get_a.to_s
         searchCommon( @q1, @q2 )
            puts "test2"
            if( @result.size != 0 )
#                puts "res s = #{@result.size}"
                extendResult
                puts @result
                break
            end
    end

    t2 = Time.now
    t = t2 - t1
    puts "time = #{t}"
#            @q2.get_a.map! { |x| x[0]  }
#            puts @q2.get_a.to_s

#            @q3 = fet3.fetchFriends(@q2)
            
            

=begin            @q2 = fet2.fetchFriends(@q2)
            searchCommon( @q1, @q2 )
        
            if( @result.size != 0 )
                extendResult
                puts @result
                return
            end
#            sleep(1)
=end            
#        end
    end
    
    def extendResult
        puts "extending..."
#        puts @result[0].size
#        puts @result[1].size

        @result.map! { |x| x.map! { |id| getUserByUid(id) } }
        puts "extended"
    end

    def getUserByUid(uid)
        @vk = VkontakteApi::Client.new
        uri = URI( "https://api.vk.com/method/users.get")
        res = Net::HTTP.post_form( uri, 'user_ids' => uid, 'version' => '5.33')
        res =  JSON.parse(res.body)
        return res["response"][0]
    end


    def searchCommon( q1, q2 )
        ptr1 = 0
        ptr2 = 0

        while( ptr1<q1.size and ptr2<q2.size ) do
#            puts "ptr1 = #{ptr1}, q1 size = #{q1.size}"
#            puts "ptr2 = #{ptr2}, q2 size = #{q2.size}"
            if q1[ptr1][0] > q2[ptr2][0]
                ptr2+=1
            elsif q1[ptr1][0] < q2[ptr2][0]
                ptr1+=1
            elsif
                addToResult( q1[ptr1], q2[ptr2] ) 
                ptr1+=1
                ptr2+=1
            end
        end
        puts "out"
    end

    def getUidFromScreenName( name )        
        @vk = VkontakteApi::Client.new
        uri = URI( "https://api.vk.com/method/users.get")
        res = Net::HTTP.post_form( uri, 'user_ids' => name, 'version' => '5.33')
        res =  JSON.parse(res.body)
        return res["response"][0]["uid"]
    end


    def addToResult( arr1, arr2 )
        @@resTotal+=1
        puts @@resTotal
        puts ("arr1 = #{arr1.to_s}")
        puts ("arr2 = #{arr2.to_s}")
        puts "-----"
        chain = arr2
        1.upto(arr1.size()-1) { |x| chain.unshift( arr1[x] ) }
        puts "chain size = #{chain.size}"
        puts chain
        @result.push(chain)
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

