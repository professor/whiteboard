require 'rubygems'
require 'aws-sdk'
require 'fileutils'

desc "Create nondigest versions of all ckeditor digest assets"
task "assets:precompile" => :environment do
  AWS.config(
      :access_key_id =>  ENV['WHITEBOARD_S3_KEY'],
      :secret_access_key => ENV['WHITEBOARD_S3_SECRET']
  )
  # Get an instance of the S3 interface.
  s3 = AWS::S3.new

  fingerprint = /\-([0-9a-f]{32})\./
  for file in Dir["public/assets/ckeditor/**/*"]
    # Skip file unless it has a fingerprint
    next unless file =~ fingerprint

    # Get filename of this file without the digest
    # (example) public/assets/ckeditor/config.js
    nondigest = file.sub fingerprint, '.'

    # Create a filename relative to public/assets
    # (example) public/assets/ckeditor/config.js => ckeditor/config.js
    filename = nondigest.sub 'public/assets/', ''
    filename = filename.sub /.gz$/, ''          # Remove .gz for correct asset checking

    # Fetch the latest digest for this file from assets
    latest_digest = Rails.application.assets.find_asset(filename).digest

    # Debug information
    puts '---- ' + file + ' ----'

    # Compare digest of this file to latest digest
    # [1] is the enclosed capture in the fingerprint regex above
    this_digest = file.match(fingerprint)[1]
    if (this_digest == latest_digest)
      # This file's digest matches latest digest, copy
      puts 'Matching digest, copying ' + file
      FileUtils.cp file, nondigest, verbose: true
      # Upload a file.
      key = File.basename(nondigest)
      s3.buckets[ENV['WHITEBOARD_S3_ASSET_BUCKET']].objects[key].write(:file => nondigest)
      puts "Uploading file #{nondigest} to bucket #{ENV['WHITEBOARD_S3_ASSET_BUCKET']}."
    else
      # This file's digest doesn't match latest digest, ignore
      puts 'Latest digest: ' + latest_digest
      puts 'This digest:   ' + this_digest
      puts 'Non-matching digest, not copying ' + file
    end

    # Debug information
    puts '---- end ----'
  end
end