require "json"
require "koala"
require "gon"
require "vk"

class StaticPagesController < ApplicationController
    include ActionController::Live
    Mime::Type.register "text/event-stream", :stream


  def home
  end

  def recieveJSON
    puts params.class
    puts params  

    firstId = params["firstId"]

    secondId = params["secondId"]

    response.headers['Content-Type'] = 'text/event-stream'

    vksearcher = Vksearcher.new( firstId, secondId, response.stream )

    msg = {:status => "finished"}.to_json
    
    response.stream.write "data: #{msg}\n\n"

    response.stream.close

    render nothing: true
  end

end
