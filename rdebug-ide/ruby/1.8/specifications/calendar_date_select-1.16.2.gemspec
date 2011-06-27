# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{calendar_date_select}
  s.version = "1.16.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Shih-gian Lee", "Enrique Garcia Cota (kikito)", "Tim Charper", "Lars E. Hoeg"]
  s.date = %q{2010-03-28}
  s.description = %q{Calendar date picker for rails}
  s.email = %q{}
  s.files = ["spec/calendar_date_select/calendar_date_select_spec.rb", "spec/calendar_date_select/form_helpers_spec.rb", "spec/calendar_date_select/includes_helper_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/timcharper/calendar_date_select}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Calendar date picker for rails}
  s.test_files = ["spec/calendar_date_select/calendar_date_select_spec.rb", "spec/calendar_date_select/form_helpers_spec.rb", "spec/calendar_date_select/includes_helper_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
