#!/usr/bin/env ruby
require 'conditionator'

class WelcomeMessage
  include Conditionator

  precondition_for :say_hi, :user_is_old?, {:failsafe => :say_hi_first_time}

  def say_hi user
    puts "Hello #{user.name} welcome back!"
  end

  #returns false if this is the first time the user has logged in to our system
  def user_is_old? user
    return user.logins_number > 1
  end

  def say_hi_first_time user
    puts "Hey #{user.name}! Welcome to the system, we hope you enjoy your time with us!"
  end

end

class User
  attr_accessor :name, :logins_number

  def initialize attrs
    @name = attrs[:name]
    @logins_number = attrs[:logins_number]
  end

end

welcomer = WelcomeMessage.new
old_user = User.new({:name => "Fernando", :logins_number => 200})
new_user = User.new({:name => "John", :logins_number => 1})

welcomer.say_hi old_user
welcomer.say_hi new_user