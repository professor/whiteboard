# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-debug-ide}
  s.version = "0.4.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Markus Barchfeld, Martin Krauskopf"]
  s.autorequire = %q{ruby-debug-base}
  s.date = %q{2009-05-20}
  s.default_executable = %q{rdebug-ide}
  s.description = %q{An interface which glues ruby-debug to IDEs like Eclipse (RDT) and NetBeans.}
  s.email = %q{rubyeclipse-dev-list@sourceforge.net}
  s.executables = ["rdebug-ide"]
  s.files = ["bin/rdebug-ide"]
  s.homepage = %q{http://rubyforge.org/projects/debug-commons/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.2")
  s.rubyforge_project = %q{debug-commons}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{IDE interface for ruby-debug.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-debug-base>, ["~> 0.10.3.0"])
    else
      s.add_dependency(%q<ruby-debug-base>, ["~> 0.10.3.0"])
    end
  else
    s.add_dependency(%q<ruby-debug-base>, ["~> 0.10.3.0"])
  end
end
