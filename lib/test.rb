require 'rails'

a = ActiveRecord::Base.connection.execute("select distinct masters_program from people")

puts "hello"