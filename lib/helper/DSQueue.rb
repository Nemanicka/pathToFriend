require 'forwardable'


class DSQueue
    include Enumerable
    extend Forwardable


    @q
    def_delegators :@q, :each, :push, :sort_by!


    def initialize( attributes = {} )
        @q = Array.new
    end

    def push(arg)
        @q.push(arg)
    end

    def pop
        res = @q.first
        @q.delete_at(0)
        return res
    end

    def front
        return @q.first
    end

    def get_a
        return @q
    end

    def size
        return @q.size
    end

  #  def sort_by_first
  #      @q.sort_by {|x| x.first }
  #  end

    def [](key)
        return @q[key]
    end

    def clear
        @q.clear
    end

end

