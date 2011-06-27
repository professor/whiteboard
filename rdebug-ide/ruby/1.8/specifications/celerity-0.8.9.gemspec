# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{celerity}
  s.version = "0.8.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jari Bakken", "T. Alexander Lystad", "Knut Johannes Dahle"]
  s.date = %q{2011-03-28}
  s.description = %q{Celerity is a JRuby wrapper around HtmlUnit – a headless Java browser with JavaScript support. It provides a simple API for programmatic navigation through web applications. Celerity provides a superset of Watir's API.}
  s.email = %q{jari.bakken@gmail.com}
  s.homepage = %q{http://github.com/jarib/celerity}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{celerity}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Celerity is a JRuby library for easy and fast functional test automation for web applications.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<sinatra>, [">= 1.0"])
      s.add_development_dependency(%q<mongrel>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.0.0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 1.0"])
      s.add_dependency(%q<mongrel>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.0.0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 1.0"])
    s.add_dependency(%q<mongrel>, [">= 0"])
  end
end
