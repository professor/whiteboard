# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sequel}
  s.version = "3.20.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Evans"]
  s.date = %q{2011-02-01}
  s.default_executable = %q{sequel}
  s.description = %q{The Database Toolkit for Ruby}
  s.email = %q{code@jeremyevans.net}
  s.executables = ["sequel"]
  s.files = ["bin/sequel"]
  s.homepage = %q{http://sequel.rubyforge.org}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.4")
  s.rubyforge_project = %q{sequel}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{The Database Toolkit for Ruby}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
