require 'google/api_client'

class GoogleWrapper

  SCOPE = [
    'https://www.googleapis.com/auth/admin.directory.user',
    'https://www.googleapis.com/auth/admin.directory.orgunit',
    'https://www.googleapis.com/auth/admin.directory.group'
  ]

  def self.retrieve_all_groups
    authorization, api_client = setup_client()
    directory_api = api_client.discovered_api('admin', 'directory_v1')
    groups = api_client.execute(
      :api_method => directory_api.groups.list,
      :authorization => authorization,
      :parameters => {
        :domain => 'west.cmu.edu'
      }
    )
    groups.data.groups
  end

  def self.retrieve_all_members(mailing_list)
    authorization, api_client = setup_client()
    directory_api = api_client.discovered_api('admin', 'directory_v1')
    group = api_client.execute(
      :api_method => directory_api.members.list,
      :authorization => authorization,
      :parameters => {
        :groupKey => mailing_list
      }
    )
    group.data.members
  end

  def self.create_user(email, first_name, last_name, password, org_unit_path)
    authorization, api_client = setup_client()
    directory_api = api_client.discovered_api('admin', 'directory_v1')

    new_user = directory_api.users.insert.request_schema.new( {
      :primaryEmail => email,
      :name => {
        :givenName => first_name,
        :familyName => last_name
      },
      :suspended => false,
      :password => password,
      :changePasswordAtNextLogin => true,
      :orgUnitPath => org_unit_path
    })

    created_user = api_client.execute(
      :api_method => directory_api.users.insert,
      :authorization => authorization,
      :body_object => new_user
    )
    created_user
  end

  #private
  def self.read_key
    if (ENV['WHITEBOARD_GOOGLE_PRIVATE_KEY'])
      key = OpenSSL::PKey::RSA.new(ENV['WHITEBOARD_GOOGLE_PRIVATE_KEY'], 'notasecret')
    else
      puts 'WHITEBOARD_GOOGLE_PRIVATE_KEY is not set'
    end
    key
  end

  def self.setup_client
    key = read_key()
    authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => SCOPE,
      :issuer => ENV['WHITEBOARD_GOOGLE_ISSUER'], #'numbes-letterls@developer.gserviceaccount.com'
      :sub => 'rails.app@west.cmu.edu',
      :signing_key => key)

    authorization.fetch_access_token!

    api_client = Google::APIClient.new(
      :application_name => 'CMU Whiteboard',
      :application_version => '1.0.0'
    )
    return authorization, api_client
  end
end

#This code works for a person's email address or a team's distribution list
def switch_sv_to_west(email_address)
  return nil if email_address.nil?
  (name, domain) = email_address.split('@')
  if(domain == 'sv.cmu.edu')
    email_address = name + '@west.cmu.edu'
  end
  return email_address
end

def switch_west_to_sv(email_address)
  return nil if email_address.nil?
  (name, domain) = email_address.split('@')
  if(domain == 'west.cmu.edu')
    email_address = name + '@sv.cmu.edu'
  end
  return email_address
end
