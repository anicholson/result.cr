# result.cr

The Result Monad, in Crystal.

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

puts e.is_a?(PersonResult) # => true
puts v.is_a?(PersonResult) # => true

# querying success
puts e.ok?    # => false
puts v.ok?    # => true

puts e.error? # => true
puts v.error? # => false

# unwrapping the Result

puts e.error # => "will cascade through" : String
puts v.value # => Person(@first_name:"Erica", @last_name:"Strange")

#puts e.value # => raises ResultError
#puts v.error # => raises ResultError

# chaining results

puts e.andThen {|r| v }.ok? # => false
puts e.orElse  {|r| v }.ok? # => true

new_v = v.andThen {|r| r.first_name = "Tom"; PersonResult.ok(r) }
        .andThen {|r| r.last_name  = "Collins"; PersonResult.ok(r) }

puts new_v.ok?   # => true
puts new_v.value # => Person(@first_name: "Tom", @last_name: "Collins")

puts v.andThen {|r| e }.ok?  # => false
puts v.andThen {|r| e } == e # => true

```

## Contributing

1. Fork it ( https://github.com/anicholson/result.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [anicholson](https://github.com/anicholson) Andy Nicholson - creator, maintainer
