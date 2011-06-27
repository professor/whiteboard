# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mechanize}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Patterson", "Mike Dalessio"]
  s.date = %q{2010-02-08}
  s.description = %q{The Mechanize library is used for automating interaction with websites. 
Mechanize automatically stores and sends cookies, follows redirects,
can follow links, and submit forms.  Form fields can be populated and
submitted.  Mechanize also keeps track of the sites that you have visited as
a history.}
  s.email = ["aaronp@rubyforge.org", "mike.dalessio@gmail.com"]
  s.files = ["test/chain/test_argument_validator.rb", "test/chain/test_auth_headers.rb", "test/chain/test_custom_headers.rb", "test/chain/test_header_resolver.rb", "test/chain/test_parameter_resolver.rb", "test/chain/test_request_resolver.rb", "test/chain/test_response_reader.rb", "test/test_authenticate.rb", "test/test_bad_links.rb", "test/test_blank_form.rb", "test/test_checkboxes.rb", "test/test_content_type.rb", "test/test_cookie_class.rb", "test/test_cookie_jar.rb", "test/test_cookies.rb", "test/test_encoded_links.rb", "test/test_errors.rb", "test/test_field_precedence.rb", "test/test_follow_meta.rb", "test/test_form_action.rb", "test/test_form_as_hash.rb", "test/test_form_button.rb", "test/test_form_no_inputname.rb", "test/test_forms.rb", "test/test_frames.rb", "test/test_get_headers.rb", "test/test_gzipping.rb", "test/test_hash_api.rb", "test/test_history.rb", "test/test_history_added.rb", "test/test_html_unscape_forms.rb", "test/test_if_modified_since.rb", "test/test_keep_alive.rb", "test/test_links.rb", "test/test_mech.rb", "test/test_mech_proxy.rb", "test/test_mechanize_file.rb", "test/test_meta.rb", "test/test_multi_select.rb", "test/test_no_attributes.rb", "test/test_option.rb", "test/test_page.rb", "test/test_pluggable_parser.rb", "test/test_post_form.rb", "test/test_pretty_print.rb", "test/test_radiobutton.rb", "test/test_redirect_limit_reached.rb", "test/test_redirect_verb_handling.rb", "test/test_referer.rb", "test/test_relative_links.rb", "test/test_request.rb", "test/test_response_code.rb", "test/test_save_file.rb", "test/test_scheme.rb", "test/test_select.rb", "test/test_select_all.rb", "test/test_select_none.rb", "test/test_select_noopts.rb", "test/test_set_fields.rb", "test/test_ssl_server.rb", "test/test_subclass.rb", "test/test_textarea.rb", "test/test_upload.rb", "test/test_util.rb", "test/test_verbs.rb"]
  s.homepage = %q{http://mechanize.rubyforge.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{mechanize}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{The Mechanize library is used for automating interaction with websites}
  s.test_files = ["test/chain/test_argument_validator.rb", "test/chain/test_auth_headers.rb", "test/chain/test_custom_headers.rb", "test/chain/test_header_resolver.rb", "test/chain/test_parameter_resolver.rb", "test/chain/test_request_resolver.rb", "test/chain/test_response_reader.rb", "test/test_authenticate.rb", "test/test_bad_links.rb", "test/test_blank_form.rb", "test/test_checkboxes.rb", "test/test_content_type.rb", "test/test_cookie_class.rb", "test/test_cookie_jar.rb", "test/test_cookies.rb", "test/test_encoded_links.rb", "test/test_errors.rb", "test/test_field_precedence.rb", "test/test_follow_meta.rb", "test/test_form_action.rb", "test/test_form_as_hash.rb", "test/test_form_button.rb", "test/test_form_no_inputname.rb", "test/test_forms.rb", "test/test_frames.rb", "test/test_get_headers.rb", "test/test_gzipping.rb", "test/test_hash_api.rb", "test/test_history.rb", "test/test_history_added.rb", "test/test_html_unscape_forms.rb", "test/test_if_modified_since.rb", "test/test_keep_alive.rb", "test/test_links.rb", "test/test_mech.rb", "test/test_mech_proxy.rb", "test/test_mechanize_file.rb", "test/test_meta.rb", "test/test_multi_select.rb", "test/test_no_attributes.rb", "test/test_option.rb", "test/test_page.rb", "test/test_pluggable_parser.rb", "test/test_post_form.rb", "test/test_pretty_print.rb", "test/test_radiobutton.rb", "test/test_redirect_limit_reached.rb", "test/test_redirect_verb_handling.rb", "test/test_referer.rb", "test/test_relative_links.rb", "test/test_request.rb", "test/test_response_code.rb", "test/test_save_file.rb", "test/test_scheme.rb", "test/test_select.rb", "test/test_select_all.rb", "test/test_select_none.rb", "test/test_select_noopts.rb", "test/test_set_fields.rb", "test/test_ssl_server.rb", "test/test_subclass.rb", "test/test_textarea.rb", "test/test_upload.rb", "test/test_util.rb", "test/test_verbs.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.2.1"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.2.1"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.2.1"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
