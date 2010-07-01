require 'rubygems'
require 'rake'
require 'fileutils'

namespace :cmu do
desc "Task for fixing 'invalid' entries in the database"
task(:examine_database => :environment) do

#      records = PeerEvaluationReport.find(:all)
    records = PeerEvaluationReview.find(:all)
    records.each do |row|
#          untrusted_string = row.feedback
      untrusted_string = row.answer
#      untrusted_string = row.question
      valid_string = cleanup_characters(untrusted_string)

      if(valid_string != untrusted_string)
        puts "id: #{row.id} (modifying) -------------------\n"
        #        puts "#{untrusted_string}"
        #        puts "\n--------------------------------------------"
        #        puts "#{valid_string}"
#                row.feedback = valid_string
##        row.answer = valid_string
#        row.question = valid_string
#        row.save
      end
    end
    puts "done"
  end

  private
  def cleanup_characters(untrusted_string)
    #Source: http://blog.grayproductions.net/articles/bytes_and_characters_in_ruby_18
    valid_string =  ""
    untrusted_string.each_byte {|c|
      case c
      when 226
      when 128
      when 153
        valid_string = valid_string + "'"
      else
        valid_string = valid_string + c.chr
      end
    }
    return valid_string
  end

end