# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rmagick}
  s.version = "2.13.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Hunter", "Omer Bar-or", "Benjamin Thomas"]
  s.date = %q{2010-04-05}
  s.description = %q{RMagick is an interface between Ruby and ImageMagick.}
  s.email = %q{rmagick@rubyforge.org}
  s.extensions = ["ext/RMagick/extconf.rb"]
  s.files = ["ext/RMagick/extconf.rb"]
  s.homepage = %q{http://rubyforge.org/projects/rmagick}
  s.require_paths = ["lib", "ext"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.5")
  s.requirements = ["ImageMagick 6.4.9 or later"]
  s.rubyforge_project = %q{rmagick}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Ruby binding to ImageMagick}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
