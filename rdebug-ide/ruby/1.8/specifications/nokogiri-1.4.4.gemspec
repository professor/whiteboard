# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nokogiri}
  s.version = "1.4.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Patterson", "Mike Dalessio"]
  s.date = %q{2010-11-15}
  s.default_executable = %q{nokogiri}
  s.description = %q{Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser.  Among Nokogiri's
many features is the ability to search documents via XPath or CSS3 selectors.

XML is like violence - if it doesn’t solve your problems, you are not using
enough of it.}
  s.email = ["aaronp@rubyforge.org", "mike.dalessio@gmail.com"]
  s.executables = ["nokogiri"]
  s.extensions = ["ext/nokogiri/extconf.rb"]
  s.files = ["test/test_reader.rb", "test/test_css_cache.rb", "test/test_encoding_handler.rb", "test/decorators/test_slop.rb", "test/test_memory_leak.rb", "test/xml/test_document_encoding.rb", "test/xml/test_relax_ng.rb", "test/xml/test_text.rb", "test/xml/test_node_reparenting.rb", "test/xml/test_syntax_error.rb", "test/xml/test_unparented_node.rb", "test/xml/test_node_encoding.rb", "test/xml/test_reader_encoding.rb", "test/xml/test_processing_instruction.rb", "test/xml/test_cdata.rb", "test/xml/test_node.rb", "test/xml/test_builder.rb", "test/xml/test_namespace.rb", "test/xml/test_document.rb", "test/xml/test_element_content.rb", "test/xml/test_document_fragment.rb", "test/xml/test_entity_reference.rb", "test/xml/test_attr.rb", "test/xml/test_dtd.rb", "test/xml/sax/test_parser.rb", "test/xml/sax/test_parser_context.rb", "test/xml/sax/test_push_parser.rb", "test/xml/test_element_decl.rb", "test/xml/test_node_attributes.rb", "test/xml/test_xpath.rb", "test/xml/test_node_set.rb", "test/xml/test_parse_options.rb", "test/xml/test_entity_decl.rb", "test/xml/node/test_save_options.rb", "test/xml/node/test_subclass.rb", "test/xml/test_attribute_decl.rb", "test/xml/test_schema.rb", "test/xml/test_dtd_encoding.rb", "test/xml/test_comment.rb", "test/test_nokogiri.rb", "test/html/test_document_encoding.rb", "test/html/test_node_encoding.rb", "test/html/test_node.rb", "test/html/test_builder.rb", "test/html/test_document.rb", "test/html/test_document_fragment.rb", "test/html/sax/test_parser.rb", "test/html/sax/test_parser_context.rb", "test/html/test_named_characters.rb", "test/html/test_element_description.rb", "test/ffi/test_document.rb", "test/test_convert_xpath.rb", "test/test_soap4r_sax.rb", "test/css/test_nthiness.rb", "test/css/test_parser.rb", "test/css/test_tokenizer.rb", "test/css/test_xpath_visitor.rb", "test/xslt/test_custom_functions.rb", "test/test_xslt_transforms.rb", "bin/nokogiri", "ext/nokogiri/extconf.rb"]
  s.homepage = %q{http://nokogiri.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{nokogiri}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser}
  s.test_files = ["test/test_reader.rb", "test/test_css_cache.rb", "test/test_encoding_handler.rb", "test/decorators/test_slop.rb", "test/test_memory_leak.rb", "test/xml/test_document_encoding.rb", "test/xml/test_relax_ng.rb", "test/xml/test_text.rb", "test/xml/test_node_reparenting.rb", "test/xml/test_syntax_error.rb", "test/xml/test_unparented_node.rb", "test/xml/test_node_encoding.rb", "test/xml/test_reader_encoding.rb", "test/xml/test_processing_instruction.rb", "test/xml/test_cdata.rb", "test/xml/test_node.rb", "test/xml/test_builder.rb", "test/xml/test_namespace.rb", "test/xml/test_document.rb", "test/xml/test_element_content.rb", "test/xml/test_document_fragment.rb", "test/xml/test_entity_reference.rb", "test/xml/test_attr.rb", "test/xml/test_dtd.rb", "test/xml/sax/test_parser.rb", "test/xml/sax/test_parser_context.rb", "test/xml/sax/test_push_parser.rb", "test/xml/test_element_decl.rb", "test/xml/test_node_attributes.rb", "test/xml/test_xpath.rb", "test/xml/test_node_set.rb", "test/xml/test_parse_options.rb", "test/xml/test_entity_decl.rb", "test/xml/node/test_save_options.rb", "test/xml/node/test_subclass.rb", "test/xml/test_attribute_decl.rb", "test/xml/test_schema.rb", "test/xml/test_dtd_encoding.rb", "test/xml/test_comment.rb", "test/test_nokogiri.rb", "test/html/test_document_encoding.rb", "test/html/test_node_encoding.rb", "test/html/test_node.rb", "test/html/test_builder.rb", "test/html/test_document.rb", "test/html/test_document_fragment.rb", "test/html/sax/test_parser.rb", "test/html/sax/test_parser_context.rb", "test/html/test_named_characters.rb", "test/html/test_element_description.rb", "test/ffi/test_document.rb", "test/test_convert_xpath.rb", "test/test_soap4r_sax.rb", "test/css/test_nthiness.rb", "test/css/test_parser.rb", "test/css/test_tokenizer.rb", "test/css/test_xpath_visitor.rb", "test/xslt/test_custom_functions.rb", "test/test_xslt_transforms.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<racc>, [">= 0"])
      s.add_development_dependency(%q<rexical>, [">= 0"])
      s.add_development_dependency(%q<rake-compiler>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 1.6.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.2"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<racc>, [">= 0"])
      s.add_dependency(%q<rexical>, [">= 0"])
      s.add_dependency(%q<rake-compiler>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 1.6.0"])
      s.add_dependency(%q<hoe>, [">= 2.6.2"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<racc>, [">= 0"])
    s.add_dependency(%q<rexical>, [">= 0"])
    s.add_dependency(%q<rake-compiler>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 1.6.0"])
    s.add_dependency(%q<hoe>, [">= 2.6.2"])
  end
end
