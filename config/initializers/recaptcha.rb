Recaptcha.configure do |config|

  # You need to register an account with http://www.google.com/recaptcha to get a public and private key
  config.public_key  = ENV["RECAPTCHA_PUBLIC_KEY"]
  config.private_key = ENV["RECAPTCHA_PRIVATE_KEY"]
end