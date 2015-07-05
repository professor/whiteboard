#source: https://developers.google.com/api-client-library/ruby/auth/service-accounts

require 'google/api_client'

key = Google::APIClient::KeyUtils.load_from_pkcs12('/Users/tsedano/Documents/rails/googleauth_test/api-project-whiteboard.p12', 'notasecret')
auth_client = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience => 'https://accounts.google.com/o/oauth2/token',
  :scope => 'https://www.googleapis.com/auth/sqlservice.admin',
  :issuer => ENV['WHITEBOARD_GOOGLE_ISSUER'], #'numbes-letterls@developer.gserviceaccount.com'
  :signing_key => key)

auth_client.fetch_access_token!

api_client = Google::APIClient.new(
  :application_name => 'OAuth 2.0 with Ruby example',
  :application_version => '1.0.0'
)

sqladmin = api_client.discovered_api('sqladmin', 'v1beta3')
result = api_client.execute(:api_method => sqladmin.instances.list,
  :parameters =>
    { 'project' => 'api-project-whiteboard' },
  :authorization => auth_client)

puts result.response.body
# binding.pry
