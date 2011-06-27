# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mocha}
  s.version = "0.9.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Mead"]
  s.date = %q{2011-02-12}
  s.description = %q{      Mocking and stubbing library with JMock/SchMock syntax, which allows mocking and stubbing of methods on real (non-mock) classes.
}
  s.email = %q{mocha-developer@googlegroups.com}
  s.homepage = %q{http://mocha.rubyforge.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{mocha}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Mocking and stubbing library}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
