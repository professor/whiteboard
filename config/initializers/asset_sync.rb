# Since this gem is only loaded with the assets group, we have to check to
# see if it's defined before configuring it.
if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_provider = 'AWS'
    config.aws_access_key_id = ENV['WHITEBOARD_S3_KEY']
    config.aws_secret_access_key =  ENV['WHITEBOARD_S3_SECRET']
    config.fog_directory = ENV['WHITEBOARD_S3_ASSET_BUCKET']

    # Fail silently.  Useful for environments such as Heroku
    config.fail_silently = false
  end
end
