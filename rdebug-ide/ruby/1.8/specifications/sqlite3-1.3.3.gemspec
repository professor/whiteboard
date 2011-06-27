# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sqlite3}
  s.version = "1.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jamis Buck", "Luis Lavena", "Aaron Patterson"]
  s.date = %q{2011-01-16}
  s.description = %q{This module allows Ruby programs to interface with the SQLite3
database engine (http://www.sqlite.org).  You must have the
SQLite engine installed in order to build this module.

Note that this module is NOT compatible with SQLite 2.x.}
  s.email = ["jamis@37signals.com", "luislavena@gmail.com", "aaron@tenderlovemaking.com"]
  s.extensions = ["ext/sqlite3/extconf.rb"]
  s.files = ["test/test_backup.rb", "test/test_collation.rb", "test/test_database.rb", "test/test_database_readonly.rb", "test/test_deprecated.rb", "test/test_encoding.rb", "test/test_integration.rb", "test/test_integration_open_close.rb", "test/test_integration_pending.rb", "test/test_integration_resultset.rb", "test/test_integration_statement.rb", "test/test_sqlite3.rb", "test/test_statement.rb", "test/test_statement_execute.rb", "ext/sqlite3/extconf.rb"]
  s.homepage = %q{http://github.com/luislavena/sqlite3-ruby}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubyforge_project = %q{sqlite3}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{This module allows Ruby programs to interface with the SQLite3 database engine (http://www.sqlite.org)}
  s.test_files = ["test/test_backup.rb", "test/test_collation.rb", "test/test_database.rb", "test/test_database_readonly.rb", "test/test_deprecated.rb", "test/test_encoding.rb", "test/test_integration.rb", "test/test_integration_open_close.rb", "test/test_integration_pending.rb", "test/test_integration_resultset.rb", "test/test_integration_statement.rb", "test/test_sqlite3.rb", "test/test_statement.rb", "test/test_statement_execute.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.7.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.8.0"])
    else
      s.add_dependency(%q<rake-compiler>, ["~> 0.7.0"])
      s.add_dependency(%q<hoe>, [">= 2.8.0"])
    end
  else
    s.add_dependency(%q<rake-compiler>, ["~> 0.7.0"])
    s.add_dependency(%q<hoe>, [">= 2.8.0"])
  end
end
