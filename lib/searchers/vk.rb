
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
require "em-http-request"
require "fetcher"
require "DSQueue"


class Vksearcher
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
    @stream = nil

    def initialize( firstId, secondId, stream, attributes = {} )
    puts "+++++++++++++++++Initialized++++++++++++++++++"
    puts "firstId = #{firstId}"
    puts "secondId = #{secondId}"
    begin
        @stream = stream

        @result = Array.new
        user1 = getUidFromScreenName(firstId)
        user2 = getUidFromScreenName(secondId)
        @@resTotal = 0

        @q1 = DSQueue.new
        @q1.push( [user1] )
        
        @q2 = DSQueue.new
        @q2.push( [ user2] )
        u =  getUidFromScreenName("vozcantante")
        puts u
        
        @threads = Array.new

        fet1 = Fetcher.new
        fet2 = Fetcher.new
        
        times = 0
        t1 = Time.now
        while( true ) do
        times+=1

        
#        puts "@q1 #{times}"
         @q1 = fet1.fetchFriends(@q1)
#        puts "q1 = #{@q1.get_a.to_s}"
 #       puts @q1.get_a.to_s
         searchCommon( @q1, @q2 )
#            puts "test1"
            if( @result.size != 0 )
 #               puts "res f = #{@result.size}"
                extendResult
#                puts @result
                break
            end
         puts "common not found"    
        
        writeStream( {:addChain => true} )
#        puts "@q2 #{times}"
    
         @q2 = fet2.fetchFriends(@q2)
         searchCommon( @q1, @q2 )
            if( @result.size != 0 )
#                puts "res s = #{@result.size}"
                extendResult
#                puts @result
                break
            end
         puts "common not found"    
        writeStream( {:addChain => true} )
    end

    t2 = Time.now
    t = t2 - t1
    puts "time = #{t}"


    rescue => ex
        writeErrorStream( ex.message )

    end
    end

    def writeStream( m = {} )
        m = m.to_json
        puts "******going to push*****"
        @stream.write "data: #{m}\n\n" 
        puts "...pushed"
    end

    def writeErrorStream( m = {} )
        errorMessage = { :error => m }.to_json
        
        @stream.write "data: #{errorMessage}\n\n" 
    end

    def extendResult
        t1 = Time.now 
        @result.each_with_index do |el, ind|
        @threads << Thread.new {
            subthreads = []
            el.each_with_index do |subEl, subInd|
            subthreads << Thread.new {
                @vk = VkontakteApi::Client.new
                uri = URI( "https://api.vk.com/method/users.get")
                res = Net::HTTP.post_form( uri, 'user_ids' => subEl, 'version' => '5.33')
                res =  JSON.parse(res.body)
               @result[ind][subInd] = res["response"][0]
               #puts  res["response"][0]
            }
            end
            subthreads.each &:join
            puts "res = #{el}"
            writeStream( { :chain => el } );
        }.run
        end
        @threads.each &:join
        t2 = Time.now
        t = t2 - t1
        puts " ext time =   #{t}"
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
        raise "vk api error, response #{res}" if res.nil?
        res =  JSON.parse(res.body)
        if res["response"].nil? or res["response"][0].nil? or res["response"][0]["uid"].nil?
           raise "response parsing error, response  #{res}"
        end
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
         puts "callback lol"
    end
end



# test = FoursquareSearcher.new

