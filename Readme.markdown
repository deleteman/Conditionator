
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
precondition_for :my_method, [:precondition_method1, :precondition_method2]
postcondition_for :my_other_method, :postcondition_method
```
###So, what happens when a pre-condition is not met?

That's a good question! When a pre-condition is not met, an exception is thrown for you to catch. The name of the exception is ```Conditionator::PreconditionsNotMet```

##And finally...

... if you have questions, suggestions or just feel like writing an e-mail to some random guy, drop me a line at deleteman[at]gmail[dot]com

##Disclaimer

Btw, this is an "in-development" project born out of a simple idea, so if you find problems and things to improve, don't hate me, fork me ;)
