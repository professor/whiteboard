# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{shoulda}
  s.version = "2.11.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tammer Saleh", "Joe Ferris", "Ryan McGeary", "Dan Croak", "Matt Jankowski"]
  s.date = %q{2010-08-01}
  s.default_executable = %q{convert_to_should_syntax}
  s.description = %q{Making tests easy on the fingers and eyes}
  s.email = %q{support@thoughtbot.com}
  s.executables = ["convert_to_should_syntax"]
  s.files = ["bin/convert_to_should_syntax"]
  s.homepage = %q{http://thoughtbot.com/community/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{shoulda}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Making tests easy on the fingers and eyes}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
