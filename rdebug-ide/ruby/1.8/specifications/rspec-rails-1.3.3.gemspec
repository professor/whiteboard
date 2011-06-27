# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-rails}
  s.version = "1.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["RSpec Development Team"]
  s.date = %q{2010-10-08}
  s.description = %q{Behaviour Driven Development for Ruby on Rails.}
  s.email = ["rspec-devel@rubyforge.org"]
  s.homepage = %q{http://rspec.info}
  s.post_install_message = %q{**************************************************

  Thank you for installing rspec-rails-1.3.3

  If you are upgrading, do this in each of your rails apps
  that you want to upgrade:

    $ ruby script/generate rspec

  Please be sure to read History.rdoc and Upgrade.rdoc
  for useful information about this release.

**************************************************
}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rspec}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{rspec-rails 1.3.3}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, ["= 1.3.1"])
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
      s.add_development_dependency(%q<cucumber>, [">= 0.3.99"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.2"])
    else
      s.add_dependency(%q<rspec>, ["= 1.3.1"])
      s.add_dependency(%q<rack>, [">= 1.0.0"])
      s.add_dependency(%q<cucumber>, [">= 0.3.99"])
      s.add_dependency(%q<hoe>, [">= 2.6.2"])
    end
  else
    s.add_dependency(%q<rspec>, ["= 1.3.1"])
    s.add_dependency(%q<rack>, [">= 1.0.0"])
    s.add_dependency(%q<cucumber>, [">= 0.3.99"])
    s.add_dependency(%q<hoe>, [">= 2.6.2"])
  end
end
