require 'conditionator/hooks'

#Extends all objects to check for conditions
class Object
	include Conditionator

	class << self
		alias_method :old_new, :new

		def new *args
			o = old_new(*args)
			o.load_conditions
			o
		end
	end

end