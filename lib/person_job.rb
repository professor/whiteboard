class PersonJob < Struct.new(:person_id, :create_google_email, :create_twiki_account, :create_active_directory_account)
  def perform
#    Delayed::Worker.logger.debug("person_id #{person_id}, create_google_email #{create_google_email}, create_twiki_account #{create_google_email}")

    person = Person.find(person_id)
    error_message = ""
    if create_google_email && person.google_created.blank?
       password = 'just4now' + Time.now.to_f.to_s[-4,4] # just4now0428
       status = person.create_google_email(password)
       if status.is_a?(String)
         error_message += "Google account not created for #{person.human_name}. " + status + " <br/>The password was " + password + "<br/><br/>"
       else
         # If we immediately send the email, google may say the account doesn't exist
         # Then send grid puts the user account on a black likst
         sleep 5
         PersonMailer.welcome_email(person, password).deliver
       end
    end
    if create_twiki_account && person.twiki_created.blank?
      status = person.create_twiki_account
      error_message +=  "TWiki account #{person.twiki_name} was not created.<br/><br/>" unless status
      status = person.reset_twiki_password
      error_message +=  'TWiki account password was not reset.<br/>' unless status
    end
    if create_active_directory_account && person.active_directory_account_created_at.blank?
      status = ActiveDirectory.create_active_directory_account(person)
      error_message +=  "Active directory account for #{person.human_name} was not created.<br/><br/>" unless status
    end


    if(!error_message.blank?)
 #     Delayed::Worker.logger.debug(error_message)
      puts error_message
      message = error_message
      GenericMailer.email(
        :to => ["help@sv.cmu.edu", "todd.sedano@sv.cmu.edu"],
        :from => "help@sv.cmu.edu",
        :subject => "PersonJob had an error on person id = #{person.id}",
        :message => message,
        :url_label => "Show which person",
        :url => "http://whiteboard.sv.cmu.edu/people/#{person.id}" #+ person_path(person)
      ).deliver
    end
  end
end