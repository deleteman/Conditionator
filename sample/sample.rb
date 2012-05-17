#!/usr/bin/env ruby
require 'conditionator'

class MyClass 
	include Conditionator

	precondition_for :custom_division, :is_division_possible?
	postcondition_for :custom_division, :say_thanks

	#Custom division method, just cause I can.
	def custom_division a, b
	 return a / b 
	end

	def is_division_possible? a, b
		if a.is_a?(Integer) && b.is_a?(Integer)
			if b > 0
				return true
			end
		end
		return false
	end

	# If we don't need the original parameters, we can just ignore them, but we DO want the return value of the method,
	# so we declare that one
	def say_thanks *, result
		puts "Thanks for trying me! BTW, the result of your division was: #{result}"
	end

end

test = MyClass.new
begin
	result = test.custom_division(20,3)
rescue 
	puts "This isn't working correctly..."
end

begin
	result = test.custom_division(2,0)
rescue 
	puts "There was a problem executing the division... check your numbers"
end