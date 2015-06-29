require "json"
require "koala"
require "gon"
require "vk"

class StaticPagesController < ApplicationController
    include ActionController::Live
    Mime::Type.register "text/event-stream", :stream

  $streamStarted = false
  $stream = nil


  def home
  end

  def help
  end

  def startStream
    puts "=================()===================="
puts response.class
    response.headers['Content-Type'] = 'text/event-stream'
puts "test1"

#    a = {:Hello => "hello"}
#    a = a.to_json
    
    $stream = response.stream
    
    $streamStarted = true

    10.times {
      sleep(1)
    }
    ensure
    $stream.close
    $streamStarted = false
    puts "=================OO===================="
    render nothing: true
  end

  def recieveJSON
    render nothing: true
    puts params.class
    puts params  

    firstId = params["firstId"]
    secondId = params["secondId"]

    while( !$streamStarted ) do
        puts "waiting for the stream"
        sleep(0.3)
    end
    vksearcher = Vksearcher.new( firstId, secondId, $stream )

  end

end
