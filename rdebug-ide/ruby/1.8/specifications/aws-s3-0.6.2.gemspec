# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{aws-s3}
  s.version = "0.6.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcel Molina Jr."]
  s.date = %q{2009-04-28}
  s.default_executable = %q{s3sh}
  s.description = %q{Client library for Amazon's Simple Storage Service's REST API}
  s.email = %q{marcel@vernix.org}
  s.executables = ["s3sh"]
  s.files = ["test/acl_test.rb", "test/authentication_test.rb", "test/base_test.rb", "test/bucket_test.rb", "test/connection_test.rb", "test/error_test.rb", "test/extensions_test.rb", "test/fixtures/buckets.yml", "test/fixtures/errors.yml", "test/fixtures/headers.yml", "test/fixtures/logging.yml", "test/fixtures/loglines.yml", "test/fixtures/logs.yml", "test/fixtures/policies.yml", "test/fixtures.rb", "test/logging_test.rb", "test/mocks/fake_response.rb", "test/object_test.rb", "test/parsing_test.rb", "test/remote/acl_test.rb", "test/remote/bittorrent_test.rb", "test/remote/bucket_test.rb", "test/remote/logging_test.rb", "test/remote/object_test.rb", "test/remote/test_file.data", "test/remote/test_helper.rb", "test/response_test.rb", "test/service_test.rb", "test/test_helper.rb", "bin/s3sh"]
  s.homepage = %q{http://amazon.rubyforge.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{amazon}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Client library for Amazon's Simple Storage Service's REST API}
  s.test_files = ["test/acl_test.rb", "test/authentication_test.rb", "test/base_test.rb", "test/bucket_test.rb", "test/connection_test.rb", "test/error_test.rb", "test/extensions_test.rb", "test/fixtures/buckets.yml", "test/fixtures/errors.yml", "test/fixtures/headers.yml", "test/fixtures/logging.yml", "test/fixtures/loglines.yml", "test/fixtures/logs.yml", "test/fixtures/policies.yml", "test/fixtures.rb", "test/logging_test.rb", "test/mocks/fake_response.rb", "test/object_test.rb", "test/parsing_test.rb", "test/remote/acl_test.rb", "test/remote/bittorrent_test.rb", "test/remote/bucket_test.rb", "test/remote/logging_test.rb", "test/remote/object_test.rb", "test/remote/test_file.data", "test/remote/test_helper.rb", "test/response_test.rb", "test/service_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xml-simple>, [">= 0"])
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
    else
      s.add_dependency(%q<xml-simple>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<mime-types>, [">= 0"])
    end
  else
    s.add_dependency(%q<xml-simple>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<mime-types>, [">= 0"])
  end
end
