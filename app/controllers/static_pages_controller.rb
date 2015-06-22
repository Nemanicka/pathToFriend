require "json"
require "koala"
require "gon"

class StaticPagesController < ApplicationController
    include ActionController::Live
  def home
  end

  def help
  end

  def recieveJSON
    render nothing: true
    puts "=================()===================="
#    puts params.class
#    puts params
#response.stream.open
puts response.class
    response.headers['Content-Type'] = 'text/event-stream'
puts "test1"
   10.times {
        puts "lal"
      response.stream.write "hello world\n"
      sleep 1
    }

    puts "lol"
#    ensure
    response.stream.close 

    #parseData = JSON.parse(params)
=begin
 *  if params["status"] == "connected"
    
    userId = params["authResponse"]["userID"]
    accToken = params["authResponse"]["accessToken"]
    #puts accToken

    graph = Koala::Facebook::API.new(accToken)
    res = graph.get_connections(userId, "public_profile/user_friends")
    puts res.raw_response
    end
=end
    puts "=================OO===================="
  end

  def vkJSON
    render nothing: true
    if params["status"] == "connected"
    
    #userId = params["authResponse"]["userID"]
    #accToken = params["authResponse"]["accessToken"]
    #puts accToken

    #graph = Koala::Facebook::API.new(accToken)
    #res = graph.get_connections(userId, "public_profile/user_friends")
    #puts res.raw_response
    end

  end

end
