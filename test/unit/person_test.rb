require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  def test_parse_twiki
    names = Person.parse_twiki("StudentSam")
    assert_equal(names[0], "Student")
    assert_equal(names[1], "Sam")

    names = Person.parse_twiki("TestUser4")
    assert_equal(names[0], "Test")
    assert_equal(names[1], "User4")

    names = Person.parse_twiki("1234")
    assert_nil(names)

    #hyphenated lastname
    names = Person.parse_twiki("DenaHaritosTsamitis")
    assert_equal(names[0], "Dena")
    assert_equal(names[1], "HaritosTsamitis")

    #scottish lastname
    names = Person.parse_twiki("GordonMcCreight")
    assert_equal(names[0], "Gordon")
    assert_equal(names[1], "McCreight")

  end


  def test_create_google_email
    google_username = "Ender.Wiggins"
    google_email_address = google_username + "@" + ENV['GOOGLE_DOMAIN']

    normal_user = Person.new(:first_name => "Ender",
                   :last_name => "Wiggins",
                 :email => google_email_address)
    assert normal_user.save()


    # Normally we would want to establish the precondition of this test,
    # that the user doesn't exit. We could query google to see the user exists,
    # delete them from the system, and then add them back to the system.
    # However, Google prevents a user to be added who was recently deleted.
    #
    # Therefore, if the user already exists, we will delete them and end the
    # test, thus establishing the precondition so that the next time the test
    # is executed, it will test the desired normal flow of creating the user.
    user_exists = true
    begin
      google_user = google_apps_connection.retrieve_user(google_username)
    rescue GDataError => e
      user_exists = false
    end
    if user_exists
      google_apps_connection.delete_user(google_username)
      return      
    end

    google_user = normal_user.create_google_email("just4now")
    if google_user.is_a?(String)
      return
    end
    google_user = google_apps_connection.retrieve_user(google_username)
    assert_not_nil google_user
    assert_equal google_user.given_name, normal_user.first_name
    assert_equal google_user.family_name, normal_user.last_name
    assert_equal google_user.admin, "false"
    google_apps_connection.delete_user(google_username)
  end
  
  def test_create_google_email_for_pittsburgh_user
    email_address = "Andrew.Carnegie@andrew.cmu.edu"

    normal_user = Person.new(:first_name => "Andrew",
                   :last_name => "Carnegie",
                 :email => email_address)
    assert normal_user.save()
    
    google_user = normal_user.create_google_email("just4now")
    assert google_user.is_a?(String)
  end

end
