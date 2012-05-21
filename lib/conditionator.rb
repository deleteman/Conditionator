require 'conditionator/hooks'
	
#Main module, including this module in your class will attach it the methods 
module Conditionator
	VERSION = "0.3.1"

	def self.included base
		base.send :include, ConditionatorHooks
		def base.new(*)
			super.tap(&:load_conditions)
		end
	end
end