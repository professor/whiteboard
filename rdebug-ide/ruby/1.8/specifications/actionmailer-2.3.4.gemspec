# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{actionmailer}
  s.version = "2.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Heinemeier Hansson"]
  s.autorequire = %q{action_mailer}
  s.date = %q{2009-09-03}
  s.description = %q{Makes it trivial to test and deliver emails sent from a single service layer.}
  s.email = %q{david@loudthinking.com}
  s.homepage = %q{http://www.rubyonrails.org}
  s.require_paths = ["lib"]
  s.requirements = ["none"]
  s.rubyforge_project = %q{actionmailer}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Service layer for easy email delivery and testing.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, ["= 2.3.4"])
    else
      s.add_dependency(%q<actionpack>, ["= 2.3.4"])
    end
  else
    s.add_dependency(%q<actionpack>, ["= 2.3.4"])
  end
end
