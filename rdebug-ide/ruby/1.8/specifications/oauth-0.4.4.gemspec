# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{oauth}
  s.version = "0.4.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pelle Braendgaard", "Blaine Cook", "Larry Halff", "Jesse Clark", "Jon Crosby", "Seth Fitzsimmons", "Matt Sanford", "Aaron Quint"]
  s.date = %q{2010-10-31}
  s.default_executable = %q{oauth}
  s.description = %q{OAuth Core Ruby implementation}
  s.email = %q{oauth-ruby@googlegroups.com}
  s.executables = ["oauth"]
  s.files = ["test/cases/oauth_case.rb", "test/cases/spec/1_0-final/test_construct_request_url.rb", "test/cases/spec/1_0-final/test_normalize_request_parameters.rb", "test/cases/spec/1_0-final/test_parameter_encodings.rb", "test/cases/spec/1_0-final/test_signature_base_strings.rb", "test/integration/consumer_test.rb", "test/test_access_token.rb", "test/test_action_controller_request_proxy.rb", "test/test_consumer.rb", "test/test_curb_request_proxy.rb", "test/test_em_http_client.rb", "test/test_em_http_request_proxy.rb", "test/test_helper.rb", "test/test_hmac_sha1.rb", "test/test_net_http_client.rb", "test/test_net_http_request_proxy.rb", "test/test_oauth_helper.rb", "test/test_rack_request_proxy.rb", "test/test_request_token.rb", "test/test_rsa_sha1.rb", "test/test_server.rb", "test/test_signature.rb", "test/test_signature_base.rb", "test/test_signature_plain_text.rb", "test/test_token.rb", "test/test_typhoeus_request_proxy.rb", "examples/yql.rb", "bin/oauth"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{oauth}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{OAuth Core Ruby implementation}
  s.test_files = ["test/cases/oauth_case.rb", "test/cases/spec/1_0-final/test_construct_request_url.rb", "test/cases/spec/1_0-final/test_normalize_request_parameters.rb", "test/cases/spec/1_0-final/test_parameter_encodings.rb", "test/cases/spec/1_0-final/test_signature_base_strings.rb", "test/integration/consumer_test.rb", "test/test_access_token.rb", "test/test_action_controller_request_proxy.rb", "test/test_consumer.rb", "test/test_curb_request_proxy.rb", "test/test_em_http_client.rb", "test/test_em_http_request_proxy.rb", "test/test_helper.rb", "test/test_hmac_sha1.rb", "test/test_net_http_client.rb", "test/test_net_http_request_proxy.rb", "test/test_oauth_helper.rb", "test/test_rack_request_proxy.rb", "test/test_request_token.rb", "test/test_rsa_sha1.rb", "test/test_server.rb", "test/test_signature.rb", "test/test_signature_base.rb", "test/test_signature_plain_text.rb", "test/test_token.rb", "test/test_typhoeus_request_proxy.rb", "examples/yql.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<actionpack>, [">= 2.3.5"])
      s.add_development_dependency(%q<rack>, [">= 1.0.0"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_development_dependency(%q<typhoeus>, [">= 0.1.13"])
      s.add_development_dependency(%q<em-http-request>, [">= 0.2.10"])
      s.add_development_dependency(%q<curb>, [">= 0.6.6.0"])
    else
      s.add_dependency(%q<actionpack>, [">= 2.3.5"])
      s.add_dependency(%q<rack>, [">= 1.0.0"])
      s.add_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_dependency(%q<typhoeus>, [">= 0.1.13"])
      s.add_dependency(%q<em-http-request>, [">= 0.2.10"])
      s.add_dependency(%q<curb>, [">= 0.6.6.0"])
    end
  else
    s.add_dependency(%q<actionpack>, [">= 2.3.5"])
    s.add_dependency(%q<rack>, [">= 1.0.0"])
    s.add_dependency(%q<mocha>, [">= 0.9.8"])
    s.add_dependency(%q<typhoeus>, [">= 0.1.13"])
    s.add_dependency(%q<em-http-request>, [">= 0.2.10"])
    s.add_dependency(%q<curb>, [">= 0.6.6.0"])
  end
end
