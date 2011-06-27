# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{taps}
  s.version = "0.3.23"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ricardo Chimal, Jr."]
  s.date = %q{2011-04-06}
  s.description = %q{A simple database agnostic import/export app to transfer data to/from a remote database.}
  s.email = %q{ricardo@heroku.com}
  s.executables = ["taps", "schema"]
  s.files = ["bin/taps", "bin/schema"]
  s.homepage = %q{http://github.com/ricardochimal/taps}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{simple database import/export app}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.0.1"])
      s.add_runtime_dependency(%q<rest-client>, ["< 1.7.0", ">= 1.4.0"])
      s.add_runtime_dependency(%q<sequel>, ["~> 3.20.0"])
      s.add_runtime_dependency(%q<sinatra>, ["~> 1.0.0"])
      s.add_runtime_dependency(%q<sqlite3-ruby>, ["~> 1.2"])
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 1.0.1"])
      s.add_dependency(%q<rest-client>, ["< 1.7.0", ">= 1.4.0"])
      s.add_dependency(%q<sequel>, ["~> 3.20.0"])
      s.add_dependency(%q<sinatra>, ["~> 1.0.0"])
      s.add_dependency(%q<sqlite3-ruby>, ["~> 1.2"])
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.0.1"])
    s.add_dependency(%q<rest-client>, ["< 1.7.0", ">= 1.4.0"])
    s.add_dependency(%q<sequel>, ["~> 3.20.0"])
    s.add_dependency(%q<sinatra>, ["~> 1.0.0"])
    s.add_dependency(%q<sqlite3-ruby>, ["~> 1.2"])
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end
