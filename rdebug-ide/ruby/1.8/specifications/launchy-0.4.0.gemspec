# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{launchy}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Hinegardner"]
  s.date = %q{2011-02-26}
  s.default_executable = %q{launchy}
  s.description = %q{Launchy is helper class for launching cross-platform applications in a
fire and forget manner.

There are application concepts (browser, email client, etc) that are
common across all platforms, and they may be launched differently on
each platform.  Launchy is here to make a common approach to launching
external application from within ruby programs.}
  s.email = %q{jeremy@copiousfreetime.org}
  s.executables = ["launchy"]
  s.files = ["bin/launchy"]
  s.homepage = %q{http://copiousfreetime.rubyforge.org/launchy/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{copiousfreetime}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Launchy is helper class for launching cross-platform applications in a fire and forget manner}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0.8.1"])
      s.add_runtime_dependency(%q<configuration>, [">= 0.0.5"])
      s.add_development_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_development_dependency(%q<configuration>, ["~> 1.2.0"])
      s.add_development_dependency(%q<rspec-core>, ["~> 2.5.1"])
    else
      s.add_dependency(%q<rake>, [">= 0.8.1"])
      s.add_dependency(%q<configuration>, [">= 0.0.5"])
      s.add_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_dependency(%q<configuration>, ["~> 1.2.0"])
      s.add_dependency(%q<rspec-core>, ["~> 2.5.1"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0.8.1"])
    s.add_dependency(%q<configuration>, [">= 0.0.5"])
    s.add_dependency(%q<rake>, ["~> 0.8.7"])
    s.add_dependency(%q<configuration>, ["~> 1.2.0"])
    s.add_dependency(%q<rspec-core>, ["~> 2.5.1"])
  end
end
