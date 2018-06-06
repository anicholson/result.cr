class ResultError < Exception; end

abstract class Result(V, E)
  abstract def value : V
  abstract def error : E

  abstract def ok? : Boolean
  abstract def error? : Boolean

  abstract def andThen(&block : self -> self) : self
  abstract def orElse(&block : self -> self) : self
end

class Ok(V, E) < Result(V, E)
  def initialize(@value : V)
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
  def initialize(@error : E)
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
