# result.cr

The Result Monad, in Crystal.
[![Build Status](https://travis-ci.org/anicholson/result.cr.svg?branch=master)](https://travis-ci.org/anicholson/result.cr)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  result:
    github: anicholson/result.cr
```

## Usage

```crystal
require "result/result"

struct Person
  property first_name : String, last_name : String

  def initialize(@first_name, @last_name)
  end
end

alias PersonResult = Result(Person,String)

# wrapping values:

e = PersonResult.error("will cascade through")
v = PersonResult.ok(Person.new(first_name: "Erica", last_name: "Strange"))

e.is_a?(PersonResult) # => true
v.is_a?(PersonResult) # => true

# querying success
e.ok?    # => false
v.ok?    # => true

e.error? # => true
v.error? # => false

# unwrapping the Result

e.error # => "will cascade through" : String
v.value # => Person(@first_name:"Erica", @last_name:"Strange")

e.value # => raises ResultError
v.error # => raises ResultError

# chaining results

e.andThen {|r| v }.ok? # => false
e.orElse  {|r| v }.ok? # => true

new_v = v.andThen {|r| r.first_name = "Tom"; PersonResult.ok(r) }
        .andThen {|r| r.last_name  = "Collins"; PersonResult.ok(r) }

new_v.ok?   # => true
new_v.value # => Person(@first_name: "Tom", @last_name: "Collins")

v.andThen {|r| e }.ok?  # => false
v.andThen {|r| e } == e # => true

```

## Contributing

1. Fork it ( https://github.com/anicholson/result.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [anicholson](https://github.com/anicholson) Andy Nicholson - creator, maintainer
