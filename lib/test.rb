require 'rails'
#
#a = ActiveRecord::Base.connection.execute("select distinct masters_program from people")
#
#
## s = 'Update users u set biography="I was raised by sheepherders on the hills of BoingBoing while they were selling chunky bacon. Because I have a ring, I need help with putting on my clothes. After working hard they promoted me to garbage man. They told me the reason for this new responsibility was show me the money. I looked for a treasure map and tools, but I never did find the fourteen minutes. Trash clearly is not multitudinous. I hope to put my real biography here one day." where created_at > "2010-07-18" and biography = ""'
# s = "Update users u set biography='I was raised by sheepherders on the hills of BoingBoing while they were selling chunky bacon. Because I have a ring, I need help with putting on my clothes. After working hard they promoted me to garbage man. They told me the reason for this new responsibility was show me the money. I looked for a treasure map and tools, but I never did find the fourteen minutes. Trash clearly is not multitudinous. I hope to put my real biography here one day.' where created_at > '2010-07-18' and biography = ""'
## ActiveRecord::Base.connection.execute(s)
#
#
##= ActiveRecord::Base.connection.execute("UPDATE effort_log_line_items SET course_id = 55 WHERE course_id = 66;")
#

fixme = []
  list = Person.find(:all)
list.each do |person|
  email = person.email
      unless email.blank?
        fixme << email if email.strip != email
  end
end

  puts fixme