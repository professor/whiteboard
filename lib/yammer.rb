#require 'oauth/consumer'

# consumer      = OAuth::Consumer.new(CONSUMER_KEY, SECRET, {:site=>"https://www.yammer.com"})
# request_token = consumer.get_request_token
# request_token.authorize_url # go to that url and hit authorize.  then copy the oauth_verifier code on that page.
# access_token  = request_token.get_access_token(:oauth_verifier => "OAUTH VERIFIER CODE FROM PRIOR STEP")
# response      = access_token.get '/api/v1/messages.json'
# puts response.body


     require 'oauth/consumer'

def first_time_setup
#  Run this from IRB

#     consumer      = OAuth::Consumer.new(CONSUMER_KEY, SECRET, {:site=>"https://www.yammer.com"})
       consumer      = OAuth::Consumer.new("JUbt0bVxzf7WSbMvHACAA", "kZ8UzOCw3A3Fu696XU1lZWwoLvzgsHzTrAs5CRrxfo", {:site=>"https://www.yammer.com"})
     request_token = consumer.get_request_token
     request_token.authorize_url # go to that url and hit authorize.  then copy the oauth_verifier code on that page.
     access_token  = request_token.get_access_token(:oauth_verifier => "8DA8")
# access_token.token
# access_token.secret
#
end


  consumer      = OAuth::Consumer.new("JUbt0bVxzf7WSbMvHACAA", "kZ8UzOCw3A3Fu696XU1lZWwoLvzgsHzTrAs5CRrxfo", {:site=>"https://www.yammer.com"})
  access_token = OAuth::AccessToken.new(consumer, '1EmlUV7M0XFjJbSZTq00A', 'Ji246TDE2eErPFnstgpSCgG5mBz4piq0ki3u6qjEQ')
  response      = access_token.get '/api/v1/messages.json'

#     response = access_token.post '/api/v1/users.json'

response=access_token.post('/api/v1/users',"user[email]=delete.me0706a@sv.cmu.edu")

response=access_token.post('/api/v1/messages/', {:body => 'this is a test message'})


response=access_token.post('/api/v1/users', {:email => "delete.me0706a@sv.cmu.edu", :full_name => "Delete Me" })



     puts response.body