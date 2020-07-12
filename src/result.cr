require "version_tools"

class ResultError < Exception; end

abstract class Result(V, E)
  abstract def value : V
  abstract def error : E

  with_crystal_version("0.35.0") do
    greater_or_equal do
      abstract def ok? : Bool
      abstract def error? : Bool
    end

    lesser do
      abstract def ok? : Boolean
      abstract def error? : Boolean
    end
  end

  abstract def and_then(&block : V -> Result(V, E)) : Result(V, E)
  abstract def or_else(&block : E -> Result(V, E)) : Result(V, E)

  class Ok(V, E) < Result(V, E)
    protected def initialize(@value : V)
    end

    def value : V
      @value
    end

    def error : E
      raise ResultError.new("Ok has no error")
    end

    with_crystal_version("0.35.0") do
      greater_or_equal do
        def ok? : Bool
          true
        end

        def error? : Bool
          false
        end
      end
      lesser do
        def ok? : Boolean
          true
        end

        def error? : Boolean
          false
        end
      end
    end

    def and_then(&block : V -> Result(V, E)) : Result(V, E)
      yield self.value
    end

    def or_else(&block : E -> Result(V, E)) : Result(V, E)
      self
    end
  end

  class Error(V, E) < Result(V, E)
    protected def initialize(@error : E)
    end

    def error : E
      @error
    end

    def value : V
      raise ResultError.new("Error has no value")
    end

    with_crystal_version("0.35.0") do
      greater_or_equal do
        def ok? : Bool
          false
        end

        def error? : Bool
          true
        end
      end
      lesser do
        def ok? : Boolean
          false
        end

        def error? : Boolean
          true
        end
      end
    end

    def and_then(&block : V -> Result(V, E)) : Result(V, E)
      self
    end

    def or_else(&block : E -> Result(V, E)) : Result(V, E)
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
