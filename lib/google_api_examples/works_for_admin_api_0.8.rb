#source: https://developers.google.com/api-client-library/ruby/auth/service-accounts

require 'google/api_client'

SCOPE = [
  'https://www.googleapis.com/auth/admin.directory.user',
  'https://www.googleapis.com/auth/admin.directory.orgunit',
  'https://www.googleapis.com/auth/admin.directory.group'
]

def read_key
  if (ENV['WHITEBOARD_GOOGLE_PRIVATE_KEY'])
    key = OpenSSL::PKey::RSA.new(ENV['WHITEBOARD_GOOGLE_PRIVATE_KEY'], 'notasecret')
  else
    key = Google::APIClient::KeyUtils.load_from_pkcs12('/Users/tsedano/Documents/rails/googleauth_test/api-project-whiteboard.p12', 'notasecret')
  end

  return key
end

key = read_key()
auth_client = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience => 'https://accounts.google.com/o/oauth2/token',
  :scope => SCOPE,
  :issuer => ENV['WHITEBOARD_GOOGLE_ISSUER'], #'numbes-letterls@developer.gserviceaccount.com'
  :sub => 'rails.app@west.cmu.edu',
  :signing_key => key)

auth_client.fetch_access_token!

api_client = Google::APIClient.new(
  :application_name => 'OAuth 2.0 with Ruby example',
  :application_version => '1.0.0'
)

directory_api = api_client.discovered_api('admin', 'directory_v1')

results = api_client.execute(
  :api_method => directory_api.users.get,
  :authorization => auth_client,
  :parameters => {
    :userKey => 'todd.sedano@west.cmu.edu',
    # :viewType => 'DOMAIN_PUBLIC'
  }
)
puts results.response.body
puts results.data.primary_email
puts results.data.org_unit_path
puts results.data.name.full_name

groups = api_client.execute(
  :api_method => directory_api.groups.list,
  :authorization => auth_client,
  :parameters => {
    :domain => 'west.cmu.edu'
  }
)
groups.data.groups[0]
groups.data.groups[0].email

group0 = api_client.execute(
  :api_method => directory_api.members.list,
  :authorization => auth_client,
  :parameters => {
    :groupKey => 'phd-students@west.cmu.edu'
  }
)
group0.data.members[0].email


#
# # List the first 10 users in the domain
# results = api_client.execute(
#   :api_method => directory_api.users.list,
#   :authorization => auth_client,
#   :parameters => {
#     :domain => 'west.cmu.edu',
#     # :customer => 'my_customer',
#     :maxResults => 10,
#     :orderBy => 'email',
#     :viewType => 'domain_public' })
# puts results.response.body
# puts "Users:"
# puts "No users found" if results.data.users.empty?
# results.data.users.each { |user| puts "- #{user.primary_email} (#{user.name.full_name})" }

