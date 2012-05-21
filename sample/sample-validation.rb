#!/usr/bin/env ruby
require 'conditionator'
require 'date'

#The current example attempts to show the capabilities of this gem, by simulating the pre-save validation
#provided by AR models

class User
  include Conditionator

  #Before saving, we'll make sure that all attributes are correct, otherwise, we'll collect and return the error messages
  precondition_for :save, :check_attributes, {:failsafe => :get_error_msgs}
  #After saving, we'll perform some calculations using our attributes
  postcondition_for :save, :calculate_age

  attr_accessor :name, :birthdate, :age, :address

  def initialize(p)
    @name = p[:name]
    @birthdate = p[:birthdate]
    @address = p[:address]
    @error_msgs = []
  end

  def save
    #complex code to save our user...
    "We're saving the user into our persistance layer (whatever that is...)"
  end

  def check_attributes
    @error_msgs.push("Name can't be empty")       if @name.nil?
    begin
      Date.parse(@birthdate)
    rescue TypeError
      @error_msgs.push("Date can't be blank")
    rescue ArgumentError
      @error_msgs.push("The date is invalid")
    rescue 
      @error_msgs.push("Birthdate is invalid")
    end
    @error_msgs.push("Address can't be empty")    if @address.nil?

    return @error_msgs.length == 0
  end

  def get_error_msgs
    retstr = "There were some errors during the validation step: "
    retstr += @error_msgs.join("\n")
    return retstr
  end

  def calculate_age(*)
   now = Time.now.utc.to_date
   date = Date.parse(@birthdate)
   new_date = Date.new(now.year, date.month, date.day)
   @age = now.year - date.year - (new_date > now ? 1 : 0)
   #we save the user again, but ignoring the conditions (pre or post)
   save_without_cond
  end
end

#Valid user
user1 = User.new({:name => "Fernando Doglio", :birthdate => '24th Oct 1983', :address => 'My address in Uruguay'})
#This user can't be saved, it has no birth date
user2 = User.new({:name => "John Smith", :address => 'My address in Uruguay'})
#This user can't be saved, it's birthdate string is invalid
user3 = User.new({:name => "Jason Borgias", :birthdate => '32Oct 1983', :address => '8 little street'})

puts user1.save #works
puts user2.save #validation error
puts user3.save #validation error