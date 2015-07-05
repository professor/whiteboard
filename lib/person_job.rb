class PersonJob < Struct.new(:person_id, :create_google_email, :create_twiki_account, :create_active_directory_account)

  def perform
    User.perform_create_accounts(person_id, create_google_email, create_twiki_account, create_active_directory_account)
  end

end
