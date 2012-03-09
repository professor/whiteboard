#require 'aws/s3'
#AWS::S3::Base.establish_connection!(
#  :access_key_id     => ENV['S3_KEY'] || 'thedefaultkey',
#  :secret_access_key => ENV['S3_SECRET'] || 'thedefaultsecret',
#  :bucket            => ENV['S3_BUCKET'] || 'thedefaultbucket'
#)
#
#
#require 'aws'
#
#include AWS
#config_path = File.expand_path(File.dirname(__FILE__)+"/../amazon_s3.yml")
#AWS.config(YAML.load(File.read(config_path)))
