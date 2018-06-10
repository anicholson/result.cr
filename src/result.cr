class ResultError < Exception; end

abstract class Result(V, E)
  abstract def value : V
  abstract def error : E

  abstract def ok? : Boolean
  abstract def error? : Boolean

  abstract def andThen(&block : V -> Result(V,E)) : Result(V,E)
  abstract def orElse(&block :  E -> Result(V,E)) : Result(V,E)

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

    def andThen(&block : V -> Result(V,E)) : Result(V,E)
      yield self.value
    end

    def orElse(&block : E -> Result(V,E)) : Result(V,E)
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

    def andThen(&block : V -> Result(V,E)) : Result(V,E)
      self
    end

    def orElse(&block : E -> Result(V,E)) : Result(V,E)
      yield self.error
    end
  end

  def self.ok(value : V) : self
    Ok(V, E).new(value)
  end

  def self.error(error : E) : self
    Error(V, E).new(error)
  end
end
