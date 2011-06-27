# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-openid}
  s.version = "2.1.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["JanRain, Inc"]
  s.autorequire = %q{openid}
  s.date = %q{2010-07-22}
  s.email = %q{openid@janrain.com}
  s.files = ["admin/runtests.rb"]
  s.homepage = %q{http://github.com/openid/ruby-openid}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A library for consuming and serving OpenID identities.}
  s.test_files = ["admin/runtests.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
