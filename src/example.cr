require "./result"

struct Person
  property first_name : String, last_name : String

  def initialize(@first_name, @last_name)
  end
end

alias PersonResult = Result(Person, String)

# wrapping values:

e = PersonResult.error("will cascade through")
v = PersonResult.ok(Person.new(first_name: "Erica", last_name: "Strange"))

puts e.is_a?(PersonResult) # => true
puts v.is_a?(PersonResult) # => true

# querying success
puts e.ok? # => false
puts v.ok? # => true

puts e.error? # => true
puts v.error? # => false

# unwrapping the Result

puts e.error # => "will cascade through" : String
puts v.value # => Person(@first_name:"Erica", @last_name:"Strange")

# puts e.value # => raises ResultError
# puts v.error # => raises ResultError

# chaining results

puts e.and_then { |r| v }.ok? # => false
puts e.or_else { |r| v }.ok?  # => true

new_v = v.and_then { |r| r.first_name = "Tom"; PersonResult.ok(r) }
  .and_then { |r| r.last_name = "Collins"; PersonResult.ok(r) }

puts new_v.ok?   # => true
puts new_v.value # => Person(@first_name: "Tom", @last_name: "Collins")

puts v.and_then { |r| e }.ok?  # => false
puts v.and_then { |r| e } == e # => true
