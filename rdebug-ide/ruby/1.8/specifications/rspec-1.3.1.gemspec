# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec}
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["RSpec Development Team"]
  s.date = %q{2010-10-08}
  s.description = %q{Behaviour Driven Development for Ruby.}
  s.email = ["rspec-devel@rubyforge.org"]
  s.executables = ["autospec", "spec"]
  s.files = ["bin/autospec", "bin/spec"]
  s.homepage = %q{http://rspec.info}
  s.post_install_message = %q{**************************************************

  Thank you for installing rspec-1.3.1

  Please be sure to read History.rdoc and Upgrade.rdoc
  for useful information about this release.

**************************************************
}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rspec}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{rspec 1.3.1}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<cucumber>, [">= 0.3"])
      s.add_development_dependency(%q<fakefs>, [">= 0.2.1"])
      s.add_development_dependency(%q<syntax>, [">= 1.0"])
      s.add_development_dependency(%q<diff-lcs>, [">= 1.1.2"])
      s.add_development_dependency(%q<heckle>, [">= 1.4.3"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.2"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<cucumber>, [">= 0.3"])
      s.add_dependency(%q<fakefs>, [">= 0.2.1"])
      s.add_dependency(%q<syntax>, [">= 1.0"])
      s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
      s.add_dependency(%q<heckle>, [">= 1.4.3"])
      s.add_dependency(%q<hoe>, [">= 2.6.2"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<cucumber>, [">= 0.3"])
    s.add_dependency(%q<fakefs>, [">= 0.2.1"])
    s.add_dependency(%q<syntax>, [">= 1.0"])
    s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
    s.add_dependency(%q<heckle>, [">= 1.4.3"])
    s.add_dependency(%q<hoe>, [">= 2.6.2"])
  end
end
