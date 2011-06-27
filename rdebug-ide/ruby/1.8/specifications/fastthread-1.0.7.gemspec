# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fastthread}
  s.version = "1.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["MenTaLguY <mental@rydia.net>"]
  s.date = %q{2009-04-07}
  s.description = %q{Optimized replacement for thread.rb primitives}
  s.email = %q{mental@rydia.net}
  s.extensions = ["ext/fastthread/extconf.rb"]
  s.files = ["test/test_all.rb", "ext/fastthread/extconf.rb"]
  s.homepage = %q{}
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{mongrel}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Optimized replacement for thread.rb primitives}
  s.test_files = ["test/test_all.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
