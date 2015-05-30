require "json"
require "koala"


class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def recieveJSON
    render nothing: true
    puts "=================OO===================="
    puts params.class
    #parseData = JSON.parse(params)
    if params["status"] == "connected"
    
    userId = params["authResponse"]["userID"]
    accToken = params["authResponse"]["accessToken"]
    #puts accToken

    graph = Koala::Facebook::API.new(accToken)
    res = graph.get_connections(userId, "public_profile/user_friends")
    puts res.raw_response
    end

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
