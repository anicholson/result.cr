class ResultError < Exception; end

abstract class Result(V, E)
  abstract def value : V
  abstract def error : E

  abstract def ok? : Boolean
  abstract def error? : Boolean

  abstract def andThen(&block : self -> self) : self
  abstract def orElse(&block : self -> self) : self

  class Ok(V, E) < Result(V, E)
    protected def initialize(@value : V)
    end

    getter value

    def error
      raise ResultError.new("Ok has no error")
    end

    def ok?
      true
    end

    def error?
      false
    end

    def andThen(&block : self -> self)
      yield self
    end

    def orElse(&block : self -> self)
      self
    end
  end

  class Error(V, E) < Result(V, E)
    protected def initialize(@error : E)
    end

    getter error

    def value
      raise ResultError.new("Error has no value")
    end

    def ok?
      false
    end

    def error?
      true
    end

    def andThen(&block : self -> self)
      self
    end

    def orElse(&block : self -> self)
      yield self
    end
  end

  def self.ok(value : V) : self
    Ok(V, E).new(value)
  end

  def self.error(error : E) : self
    Error(V, E).new(error)
  end
end
