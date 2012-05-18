
#Conditionator

The Conditionator gem is a Ruby gem that allows you to easily set pre and post conditions for all of your methods.
Using Conditionator, the develper can focus on coding methods without adding in lines to make sure that all conditions are met and that the method will execute correctly. Thus assigning the responsability of checking for the correct conditions to a different and reusable method.

Conditionator also allows you to easily queue method executions, making sure, post-condition methods are allways executed.

##How does it work?

Using Conditionator is simple and very striaght-forward:

###Installation:

The gem is hosted on RubyGems.org, so to install it you just run the command:

```gem install conditionator```

###Using Conditionator

After installing the gem, setup your conditions like this:

```ruby
class MyClass 
	include Conditionator

	precondition_for :my_method, [:precondition_method1, :precondition_method2]
	postcondition_for :my_other_method, :postcondition_method

end
```
If you want a more in-depth example, checkout the "sample" folder.

**Please note**

That right now, the gem works correctly with instance level methods, instance level methods have not been tested yet.


####Attributes

####precondition_for:
- Method to be preconditioned: This can be a single method or an array of methods.
- Precondition method: This can be a single method or an array of methods.
- Options (optional): Hash with options that affect the behavior of the preconditions:
    - Failsafe: Method to execute instead of the original one if one of the preconditions fails. **Warning** The return value of this method will be returned instead of the original method. Please note that the failsafe method should have the same signature as the original method, since the same parameters will be passed on to it.
    - Mute: If set to true, and one of the preconditions fails, the exception will not be thrown.


**Using the failsafe method**

For a full example, please refer to sample/sample-failsafe.rb

```ruby
class WelcomeMessage
  include Conditionator

  precondition_for :say_hi, :user_is_old?, {:failsafe => :say_hi_first_time}

  def say_hi user
    puts "Hello #{user.name} welcome back!"
  end

  #returns false if this is the first time the user has logged in to our system
  def user_is_old? user
    return user.logins_number > 1
  end

  def say_hi_first_time user
    puts "Hey #{user.name}! Welcome to the system, we hope you enjoy your time with us!"
  end

end
```


####postcondition_for:
- Method to be preconditioned: This can be a single method or an array of methods.
- Postcondition method: This can be a single method or an array of methods.

###Defining your pre and post condition methods 

These are just regular methods inside your class, the only consideration that you'll need to have are their attributes:

- The precondition methods will take the same arguments as the original method.
- The postcondition methods will take the arguments of the original method and the it's result.

If you don't care about the parameters sent, you can ignore them when declaring your method, like this:

```ruby
def my_postcondition_method *p
  puts "I'm ignoring the parameters that I receive, so I can be used with different methods without causing any trouble..."
end
```

###So, what happens when a pre-condition is not met?

That's a good question! 
When a pre-condition is not met, one of several things might happen, depending on how you configured the preconditions:

- The default behavior is that an exception will be thrown for you to catch. The name of the exception is ```Conditionator::PreconditionsNotMet```
- If you specified the ```ruby :mute ``` option, as mentioned above, then nothing will happen, and your method will not execute. 
- If you specified a failsafe method, then that method will be executed instead.

##And finally...

... if you have questions, suggestions or just feel like writing an e-mail to some random guy, drop me a line at deleteman[at]gmail[dot]com

##Disclaimer

Btw, this is an "in-development" project born out of a simple idea, so if you find problems and things to improve, don't hate me, fork me ;)
