require 'conditionator/hooks'

#Main module, including this module in your class will attach it the methods 
module Conditionator

	def self.included base
		base.send :include, ConditionatorHook
		def base.new(*)
			super.tap(&:load_conditions)
		end
	end
end