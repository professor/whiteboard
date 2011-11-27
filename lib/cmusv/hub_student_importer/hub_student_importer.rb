require 'spec_helper'
require 'ruby-rtf'

module HubStudentImporter
  extend self

  def import_rtf(src_file_path)
    rtf_source = File.open(src_file_path, "r") { |f| f.read }
    parser = RubyRTF::Parser.new
    document = parser.parse(rtf_source)
  end

  def import_html(src_file_path)
    
  end
end
