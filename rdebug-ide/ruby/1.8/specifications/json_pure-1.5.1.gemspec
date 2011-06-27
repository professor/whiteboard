# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{json_pure}
  s.version = "1.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Frank"]
  s.date = %q{2011-01-25}
  s.default_executable = %q{edit_json.rb}
  s.description = %q{This is a JSON implementation in pure Ruby.}
  s.email = %q{flori@ping.de}
  s.executables = ["edit_json.rb", "prettify_json.rb"]
  s.files = ["./tests/test_json_encoding.rb", "./tests/test_json_addition.rb", "./tests/test_json.rb", "./tests/test_json_string_matching.rb", "./tests/test_json_generate.rb", "./tests/test_json_unicode.rb", "./tests/test_json_fixtures.rb", "bin/edit_json.rb", "bin/prettify_json.rb"]
  s.homepage = %q{http://flori.github.com/json}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{json}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{JSON Implementation for Ruby}
  s.test_files = ["./tests/test_json_encoding.rb", "./tests/test_json_addition.rb", "./tests/test_json.rb", "./tests/test_json_string_matching.rb", "./tests/test_json_generate.rb", "./tests/test_json_unicode.rb", "./tests/test_json_fixtures.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
