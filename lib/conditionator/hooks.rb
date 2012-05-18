module ConditionatorHooks

  class PreconditionsNotMet < StandardError
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

  def failsafe_for method
    self.class.data[self.class.name][method][:pre][:failsafe]
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
            execute_method = true
            if(_when == :pre)
              returns = arr_methods.collect do |m| 
                self.send(m, *p) ? true : false
              end
              returns.uniq!

              #if one of the preconditions returned false, we act accordingly
              if returns.include? false
                execute_method = false
                if !data[:failsafe].nil? #if we had setup a failsafe method, we use that
                  ret_value = self.send(data[:failsafe], *p) #if we execute the failsafe, that method will give us the returning value
                else #otherwise, we raise the exception if the dev didn't mute it
                  raise PreconditionsNotMet if !data[:mute]
                end
              end
            end 
            if execute_method
              ret_value = self.send "#{method}_without_#{_when}_cond".to_sym, *p
            end
            if(_when == :post)
              arr_methods.each do |m| 
                self.send m, *p, ret_value 
              end
            end 
            return ret_value
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
    def add_condition_for type, for_method, conditions, options = {}
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
      _data[key][for_method][type][:failsafe] = options[:failsafe]
      _data[key][for_method][type][:mute] = options[:mute]

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
    def precondition_for method_name, preconditions, options = {}
      if method_name.is_a? Array 
        method_name.each do |m| 
          add_condition_for :pre, m, preconditions, options
        end
      else
        add_condition_for :pre, method_name, preconditions, options
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
