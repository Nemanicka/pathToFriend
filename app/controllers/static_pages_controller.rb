class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def recieveJSON
    render nothing: true
    puts "=================OO===================="
    puts params
    puts "=================OO===================="
  end
end
