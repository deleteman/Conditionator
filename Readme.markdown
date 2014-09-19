
#Conditionator

The Conditionator gem is a Ruby gem that allows you to easily set *pre* and *post* conditions for all of your methods.
Using Conditionator, the developer can focus on coding methods without adding extra code in separate places to make sure that all conditions are met and that the method will execute correctly, thus assigning the responsibility of checking for the correct conditions to a different and reusable method.

Conditionator also allows you to easily queue method executions, while making sure that post-condition methods are always executed.

##How does it work?

Using Conditionator is very simple and straight-forward:

###Installation:

This gem is hosted on rubygems.org, so to install it you just run the command:

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
If you want a more in-depth example, checkout the code in the "sample" folder.

**Please note**

As of writing this, the gem works correctly only with instance methods; class methods have not been tested yet.

####Attributes

####precondition_for:
- Method to be pre-conditioned: This can be a single method or an array of methods.
- Pre-condition method: This can be a single method or an array of methods.
- Options (**optional**): Hash with options that affect the behavior of the pre-conditions:
    - *failsafe*: Method to execute instead of the original method if one of the pre-conditions fails. **Warning** The return value of this method will be returned instead of that of the original method. Please note that the failsafe method should have the same signature as the original method, since the same parameters will be passed on to it.
    - *mute*: If set to true, and if one of the pre-conditions fails, an exception will NOT be thrown.


**Using the failsafe method**

For a full, detailed example, please refer to sample/sample-failsafe.rb

```ruby
class WelcomeMessage
  include Conditionator

  precondition_for :say_hi, :user_is_old?, {:failsafe => :say_hi_first_time}

  def say_hi user
    puts "Hello #{user.name}, welcome back!"
  end

  #Returns false if this is the first time the user has logged in to our system
  def user_is_old? user
    return user.logins_number > 1
  end

  def say_hi_first_time user
    puts "Hey #{user.name}! Welcome to the system, we hope you enjoy your time with us!"
  end

end
```


####postcondition_for:
- Method to be postconditioned: This can be a single method or an array of methods.
- Post-condition method: This can be a single method or an array of methods.

###Defining your *pre* and *post* condition methods 

These are just regular methods inside your class and can have any code you wish, but keep in mind the arguments for these methods:
- The pre-condition methods **should** take the same arguments as the original method.
- The post-condition methods may take the arguments of the original method and it's result, but it's not a necessity. You may use the postcondition methods to perform some tasks after a successful method call. If you don't care about the parameters sent, you can ignore them when declaring your method, like this:

```ruby
def my_postcondition_method *p
  puts "I'm ignoring the parameters that I receive, so I can be used with different methods without causing any trouble..."
end
```
**Remember** that your post-conditions are tied to your original method. This means that if the pre-conditions fail, and your method is not executed, then the post-conditions won't be executed either.

###So...what happens when a pre-condition is not met?

That's a good question! 
When a pre-condition is not met, one of several things might happen, depending on how you configured your pre-conditions:

- The default behavior is that an exception will be thrown for you to catch. The name of the exception would be ```Conditionator::PreconditionsNotMet```
- If you specified the ```:mute ``` option, as mentioned above, then nothing will happen, and your method will not execute. 
- If you specified a failsafe method, then that method will be executed instead.

##And finally...

...if you have questions, suggestions or just feel like writing an e-mail to some random guy, drop me a line at deleteman[at]gmail[dot]com.

##Disclaimer

BTW, this is an "in-development" project born out of a simple idea, so if you find some problems and things to improve upon, don't hate me; fork me. ;)
