# Installation instructions
puts '=' * 80
puts <<EOF

MORNING GLORY CONFIG

See the github wiki for more detailed configuration information at:
http://wiki.github.com/adamburmister/morning_glory/

= Morning Glory =
You will need to manually create & configure your config/morning_glory.yml file.
Sample config/morning_glory.yml:

  --- 
  production: 
    delete_prev_rev: true
    bucket: cdn.production.yoursite.com
    s3_logging_enabled: true
    enabled: true
    asset_directories: 
    - images
    - javascripts
    - stylesheets
    revision: "20100316165112"
  staging: 
    bucket: cdn.staging.yoursite.com
    enabled: true
  testing: 
    enabled: false
  development: 
    enabled: false


= Amazon AWS =
You will need to manually create & configure your config/s3.yml file.
This file contains your access credentials for accessing the Amazon S3 service.
Sample config/s3.yml:

  ---
  production:
    access_key_id: YOUR_ACCESS_KEY
    secret_access_key: YOUR_SECRET_ACCESS_KEY
  staging:
    access_key_id: YOUR_ACCESS_KEY
    secret_access_key: YOUR_SECRET_ACCESS_KEY

EOF
puts '=' * 80