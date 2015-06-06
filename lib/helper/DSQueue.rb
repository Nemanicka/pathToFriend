
class DSQueue
    @q

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

    def to_s
        return @q.to_s
    end

    def size
        return @q.size
    end

end

