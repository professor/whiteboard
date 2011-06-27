# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{actionpack}
  s.version = "2.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Heinemeier Hansson"]
  s.autorequire = %q{action_controller}
  s.date = %q{2009-09-03}
  s.description = %q{Eases web-request routing, handling, and response as a half-way front, half-way page controller. Implemented with specific emphasis on enabling easy unit/integration testing that doesn't require a browser.}
  s.email = %q{david@loudthinking.com}
  s.homepage = %q{http://www.rubyonrails.org}
  s.require_paths = ["lib"]
  s.requirements = ["none"]
  s.rubyforge_project = %q{actionpack}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Web-flow and rendering framework putting the VC in MVC.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["= 2.3.4"])
      s.add_runtime_dependency(%q<rack>, ["~> 1.0.0"])
    else
      s.add_dependency(%q<activesupport>, ["= 2.3.4"])
      s.add_dependency(%q<rack>, ["~> 1.0.0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["= 2.3.4"])
    s.add_dependency(%q<rack>, ["~> 1.0.0"])
  end
end
