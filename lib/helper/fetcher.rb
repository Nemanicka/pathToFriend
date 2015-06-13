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
        puts "total size to fetch = #{queue.size}"
        
        @qNewFetched = DSQueue.new 
        @threadPool.clear
        succeed = 0
        failed = 0
        counter = 0
        queue.each do |x|
        @threadPool << Thread.new {
                counter+=1
                userStack = x
#                    puts "userStack = #{userStack}, left = #{ queue.size - counter  }" 
#
#               
                puts "left = #{ queue.size - counter}" if counter%100 == 0
                id = userStack[0]
                puts " fetching for #{id} "
                if @@fetched[id] != 1
                    @@fetched[id] = 1
          #         next if @@fetched[id] == 1     
                    response = Typhoeus::Request.new(
                    "https://api.vk.com/method/friends.get",
                    params: {user_id: id}).run
 
                    response = JSON.parse(response.body)

                    callBack( response["response"], userStack ) unless response["response"].nil?
                    errorBack( response["error"]  ) unless response["error"].nil?
                end
       }.run
        end
        @threadPool.each &:join
        
        puts "Done."
        
        @qNewFetched.sort_by_first
        puts "--total fetched #{@qNewFetched.size} "
        return @qNewFetched
    end

    def errorBack( response )
        puts "oops: #{response}"
    end
   
    def callBack( response, userStack )
        userStack.unshift(nil)
        response.each do |x| 
            tmp = Array.new( userStack )
            tmp[0]=x;  
            @qNewFetched.push(tmp)
        end 
    end
end
