require './lib/conditionator.rb'

Gem::Specification.new do |s|
	s.name = "Conditionator"
	s.version = Conditionator::VERSION
	s.date = "2012-05-18"
	s.summary = "Add pre and post conditions to your methods"
	s.description = "This gem allows you to set pre and post conditions to your methods, in order to assure their successfull excecution"
	s.authors = ["Fernando Doglio"]
	s.files = ["lib/conditionator.rb", "lib/conditionator/hooks.rb"]
	s.email = "deleteman@gmail.com"
  s.homepage = "https://github.com/deleteman/conditionator"
  s.required_ruby_version = '>= 1.9.2'
end