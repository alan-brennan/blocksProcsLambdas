#### Blocks ####
# chunk of code to be excuted
# must be attached to a method call
# block is NOT a parmeter passed to a method
# can be defined with { } or do end
# a block can access local valiables within the block using ||
# blocks are not an object
# allows us to add unique actions to a method

# each is a method available on arrays, that accepts a block NB each method iterates over each element in the array, the block provides unique behaviour 
[ 1, 2, 3, 4].each {|number| puts number * 10 }

#or 

puts

[ 1, 2, 3, 4].each do
    |number| puts number * 10 
end

# map and times examples
puts 
# yield keyword, transfers control from the method to the block
# In Ruby, methods can take blocks implicitly and explicitly. Implicit block passing works by calling 
# the yield keyword in a method. The yield keyword is special. 
# It finds and calls a passed block, so you don't have to add the block to the list of arguments the method accepts.

def myEach (myArray)
    
    n = 0;
    while n < myArray.length
        yield(myArray[n])
        n = n + 1
    end
end

myEach ([1,2,3,4]) {|number| puts number * 10}

# break it down simply

def myMethod
    puts "i'm in my method"
    yield
    puts "i'm back again"
end

myMethod {puts "i'm in the block"}

#Notes 
# 1. All functions can accept a block
# 2. control is passed to the block using yield
# 3. try yield without passing a block - no block given (yield) (LocalJumpError)

# NB - blocks implicitly return the last evaluation to the method that called them, so no explicit return is required
puts 

def myWord
    wordOfTheDay = yield
    puts wordOfTheDay
end

myWord do
    "first Word"
   "second Word" # add a return her, nothing happens
end
puts 

# multiple calls to a blcok

def myMethod2
    puts "i'm in my method2"
    yield
    puts "i'm back again"
    yield
    puts "you guessed it, i'm back again"
end

myMethod2 {puts "i'm in the block"}

puts 
# block given method

def myMethod3
    puts "i'm in my method2"
    if block_given?
        yield
    end 
    puts "i'm back again"
end

myMethod3 #{puts "i'm in the block"}

puts 
# yielding with a parameter
def yieldParameter
    yield("this was passed by yield") if block_given? # brackets optional
end

yieldParameter {|someString| puts someString}

puts 
# yield a parameter to function
def yieldParameter2(myString)
    yield(myString) if block_given? # brackets optional
end

yieldParameter2("this was passed as a param to the function") {|someString| puts someString}

puts 
# pass 2 parameters
def yieldParameter3(myString, myInt)
    yield(myString, myInt) if block_given? # brackets optional
end

yieldParameter3("this was passed as a param to the function", 10) {|someString, someInt| puts "#{someString} and int = #{someInt}"}

puts 

# what happens if we don't pass the second parameter to block error or something else
def yieldParameter3(myString)
    yield myString if block_given? # brackets optional
end

yieldParameter3("this was passed as a param to the function") {|someString, someInt| puts "#{someString} and int = #{someInt}"}


#Yield to block in class to set variables
puts

class Car
    attr_accessor :color, :doors
  
    def initialize
      yield(self)
    end
end
  
  car = Car.new do |c|
    c.color = "Red"
    c.doors = 4
  end
  
  puts "My car's color is #{car.color} and it's got #{car.doors} doors."



puts 
# Procs - acts like a saved block

multipleBy10 = Proc.new { |number| puts number * 10}

myArray = [1, 2, 3, 4, 5]

myArray.each(&multipleBy10) # note the use of & to indicate that it's a block being passed.

myArray2 = [5 , 10, 15]
myArray2.each(&multipleBy10)

puts
#example

moneyGBP = [10.00, 20.00, 30.00, 40.00]

to_euro = Proc.new { |money| money * 1.18 }

p moneyGBP.map(&to_euro)

#example 2

ages = [10, 20, 45, 55, 67, 83 , 92]

is_old = Proc.new do |age|
    age > 60
end

p ages.select { |age| age > 60}
p ages.select(&is_old)


# Passing a block to our own method
puts 
def helloWorld
    puts "hello World"
    yield
end

procMessage = Proc.new do 
    puts "hello from the proc"
end

helloWorld { puts "hello from block as well"}
puts 
helloWorld(&procMessage)   # we can pass the block even though the method doesn't specify a paramanter to receive

# call a proc

5.times(&procMessage)

# you can call a proc directly as well, similar to a method
puts 
procMessage.call

puts 
# pass a ruby method as a proc
 p ["1", "2", "3" , "4"].map { |number| number.to_i}

 p ["1", "2", "3" , "4"].map(&:to_i)   # & indicates it's a block, : uses symbol to represent to_i 

p [1, 2, 3, 4].map(&:to_s)
puts

p [1,2,3,4,5,6,7].select(&:even?)
p [1,2,3,4,5,6,7].reject(&:odd?)

puts 
# call proc with parameters

def myMethod4(name, &myProc)
    puts "Your name is #{name}"
    myProc.call(name)
    yield(name)         #can also yield
end

say_hello = Proc.new do |name|
    puts "hello #{name}"
end

myMethod4("Alan", &say_hello)

say_goodbye = Proc.new do |name|
    puts "Good Bye #{name}"
end

myMethod4("Alan", &say_goodbye)

puts
puts

###### NOTE #########
# you can only pass one blcok and it must be the last arguement in the parameter list
#####################

# def myMethod5(name, &myProc, &myproc2)
#     puts "Your name is #{name}"
#     myProc.call(name)
#     myProc2.call(name)
#     yield(name)         #can also yield
# end

#myMethod5("Alan", &say_hello, &say_goodbye)


############### Lambdas #################

# 1. Lambdas are procs i.e. the derive from Proc class
 
by10_lambda = lambda { |number| number * 10}

p [1 ,2,3].map(&by10_lambda)
p by10_lambda.class 

# differences between lambda and procs

# 1. lambdas care about the number of arguements passed

my_proc = Proc.new { |name, age| "my name is #{name} and my age is #{age}"}
my_lambda = lambda { |name, age| "my name is #{name} and my age is #{age}"}

p my_proc.call("Alan")

# p my_lambda.call("Alan") ...gives an error

puts 
# 2. the 'return' from a proc returns for the complete function it was called from, i.e. it breaks out of the function

def lambdaDiff
    say_hello = lambda { return "from the proc"} # change this to a Proc and see what happens
    say_hello.call
    "You made it to the end of the method"
end

result = lambdaDiff
p result 

# Closures. In Ruby, procs and lambdas are closures. The term “closure” comes 
# from the early days of computer science; it refers to an object that is both an invocable function 
# and a variable binding for that function.
# When you create a proc or a lambda, the resulting Proc object holds not just 
# the executable block but also bindings for all the variables used by the block.

# According to Wikipedia, a closure is a technique for 
# implementing lexically scoped name binding in a language with first-class functions

# Return a lambda that retains or "closes over" the argument n
def multiplier(n) 
    lambda {|data| data.collect{|x| x*n } }
  end
doubler = multiplier(2)     # Get a lambda that knows how to double
puts doubler.call([1,2,3])  # Prints 2,4,6
  
# The multiplier method returns a lambda. Because this lambda is used outside of the 
# scope in which it is defined, we call it a closure; it encapsulates or “closes over” 
# (or just retains) the binding for the method argument n.

puts 
def my_method(&my_proc)
    count = 3
    my_proc.call
    yield
  end 
  count = 1
  my_proc = Proc.new { puts count }
  count = 2
  puts my_method(&my_proc)
  # 2

# Even though the proc was declared when count was 1, since it has a reference to count, it was automatically updated 
# when we wrote counter = 2. Also, the proc ignored the count = 3 
# line because since it is a closure, it already has its variables stored.