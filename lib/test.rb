require 'rails'

a = ActiveRecord::Base.connection.execute("select distinct masters_program from people")

#= ActiveRecord::Base.connection.execute("UPDATE effort_log_line_items SET course_id = 55 WHERE course_id = 66;")


puts "hello"