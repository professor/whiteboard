# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-debug-base}
  s.version = "0.10.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kent Sibilev"]
  s.date = %q{2008-11-16}
  s.description = %q{ruby-debug is a fast implementation of the standard Ruby debugger debug.rb. It is implemented by utilizing a new Ruby C API hook. The core component  provides support that front-ends can build on. It provides breakpoint  handling, bindings for stack frames among other things.}
  s.email = %q{ksibilev@yahoo.com}
  s.extensions = ["ext/extconf.rb"]
  s.files = ["test/base/base.rb", "test/base/binding.rb", "test/base/catchpoint.rb", "ext/extconf.rb"]
  s.homepage = %q{http://rubyforge.org/projects/ruby-debug/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.2")
  s.rubyforge_project = %q{ruby-debug}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Fast Ruby debugger - core component}
  s.test_files = ["test/base/base.rb", "test/base/binding.rb", "test/base/catchpoint.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<linecache>, [">= 0.3"])
    else
      s.add_dependency(%q<linecache>, [">= 0.3"])
    end
  else
    s.add_dependency(%q<linecache>, [">= 0.3"])
  end
end
