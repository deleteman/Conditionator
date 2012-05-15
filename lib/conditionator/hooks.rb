module Conditionator

	class PreconditionsNotMet < Exception
	end

private
	def conditions type
		conds = {}
		data = self.class.data
	
		data[self.class.name].each do |method, filter|
			if filter.key? type
				conds[method] = [] if conds[method].nil?
				conds[method] = filter[type][:methods]
			end 
		end
		conds
	end

	def self.included(base)
		base.send :extend, ClassLevelConditionator
	end

public	
	#Returns a list of all preconditions, grouped by the method they're a precondition to.
	def preconditions
		conditions :pre
	end

	def postconditions
		conditions :post
	end

	#Creates all methods needed for the hooks to take place.
	def load_conditions

		_data = self.class.data
		_data[self.class.name] = {} if _data[self.class.name].nil?
	
		_data[self.class.name].each { |method, type|
			type.each { |_when, data|
				
				arr_methods = data[:methods]
	
				if !self.respond_to? "#{method}_with_#{_when}_cond".to_sym
					self.class.send :define_method, "#{method}_with_#{_when}_cond".to_sym do |*p|
						if(_when == :pre)
							returns = arr_methods.collect do |m| 
								self.send(m) ? true : false
							end
							returns.uniq!
							if returns.length == 1 and returns.include? true	
								data[:block].call(self) if !data[:block].nil?
							else
								raise PreconditionsNotMet
							end
						end 
						self.send "#{method}_without_#{_when}_cond".to_sym, *p
						if(_when == :post)
							arr_methods.each do |m| self.send m end
							data[:block].call(self) if !data[:block].nil?
						end 

					end
					self.class.send :alias_method, "#{method}_without_#{_when}_cond".to_sym, method
					self.class.send :alias_method, method, "#{method}_with_#{_when}_cond".to_sym
				end
			}
		}
	end

	module ClassLevelConditionator
	private

		#Adds a pre or post condition to the list of conditions to be used
		def add_condition_for type, for_method, conditions
			key = self.name.to_s
			if conditions.is_a? Array
				condition_list = conditions
			else
				condition_list = [conditions]
			end

			_data = data
			_data[key] = {} if _data[key].nil? #HookData.new if data[key].nil?
			_data[key][for_method] = Hash.new if _data[key][for_method].nil?

			_data[key][for_method][type] = Hash.new if _data[key][for_method][type].nil?
			_data[key][for_method][type][:methods] = condition_list
		end


	public
		def data
			@data = {} if @data.nil?
			@data 
		end
		def data=(value)
			@data = value
		end

		#Adds a precondition for the method 'method_name'
		#method_name can be an array of methods, in which case, we add the same
		#preconditions for all methos inside it.
		def precondition_for method_name, preconditions
			if method_name.is_a? Array 
				method_name.each do |m| 
					add_condition_for :pre, m, preconditions
				end
			else
				add_condition_for :pre, method_name, preconditions
			end
		end

		def postcondition_for method_name, conditions
			if method_name.is_a? Array
				method_name.each do |m|
					add_condition_for :post, m, conditions
				end
			else
				add_condition_for :post, method_name, conditions
			end
		end


	end


end
