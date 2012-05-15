#!/usr/bin/env ruby
require 'conditionator'

class MyClass 

	precondition_for :my_method, :user_logged_in?
	postcondition_for :my_method, :say_thanks

	def user_logged_in?
		#false
		true
	end

	def say_thanks
		puts "Thanks for trying me!"
	end

	def my_method
		puts "Hey there, this method excecuted because the preconditions were met..."
	end

end

test = MyClass.new
begin
	test.my_method
rescue PreconditionsNotMet
	puts "The preconditions were not met, so nothing is being excecuted..."
end