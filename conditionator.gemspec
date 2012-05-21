require './lib/conditionator.rb'
require 'date'

Gem::Specification.new do |s|
	s.name = "Conditionator"
	s.version = Conditionator::VERSION
	s.date = "#{Date.today.year}-#{'0' * ((Date.today.month < 10)?1:0)}#{Date.today.month}-#{Date.today.day}"
	s.summary = "Add pre and post conditions to your methods"
	s.description = "This gem allows you to set pre and post conditions to your methods, in order to assure their successfull excecution"
	s.authors = ["Fernando Doglio"]
	s.files = ["lib/conditionator.rb", "lib/conditionator/hooks.rb"]
	s.email = "deleteman@gmail.com"
  s.homepage = "https://github.com/deleteman/conditionator"
  s.required_ruby_version = '>= 1.9.2'
end