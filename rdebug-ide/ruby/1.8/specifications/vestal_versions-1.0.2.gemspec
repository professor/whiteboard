# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{vestal_versions}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["laserlemon"]
  s.date = %q{2010-01-12}
  s.description = %q{Keep a DRY history of your ActiveRecord models' changes}
  s.email = %q{steve@laserlemon.com}
  s.files = ["test/changes_test.rb", "test/conditions_test.rb", "test/configuration_test.rb", "test/control_test.rb", "test/creation_test.rb", "test/options_test.rb", "test/reload_test.rb", "test/reset_test.rb", "test/reversion_test.rb", "test/schema.rb", "test/tagging_test.rb", "test/test_helper.rb", "test/users_test.rb", "test/version_test.rb", "test/versioned_test.rb", "test/versions_test.rb"]
  s.homepage = %q{http://github.com/laserlemon/vestal_versions}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Keep a DRY history of your ActiveRecord models' changes}
  s.test_files = ["test/changes_test.rb", "test/conditions_test.rb", "test/configuration_test.rb", "test/control_test.rb", "test/creation_test.rb", "test/options_test.rb", "test/reload_test.rb", "test/reset_test.rb", "test/reversion_test.rb", "test/schema.rb", "test/tagging_test.rb", "test/test_helper.rb", "test/users_test.rb", "test/version_test.rb", "test/versioned_test.rb", "test/versions_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.1.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.1.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.1.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
