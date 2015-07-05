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
