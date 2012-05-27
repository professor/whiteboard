require 'aws-sdk'

namespace :cmu do

  #The buckets were created by hand. We are recording here the need to make the buckets versioned for page_attachment
  #Technically, this isn't needed in the development environment
  desc 'UNTESTED -- Creates the buckes needed by amazon s3'
  task :setup_aws_buckets do |t, args|
    s3 = AWS::S3.new(:access_key_id => '', :secret_access_key => '')
    bucket = s3.buckets['cmusv-rails-development']
    bucket = s3.buckets['cmusv-rails-test']
    bucket = s3.buckets['cmusv-rails-production']
    bucket.enable_versioning
    response = bucket.versioned?
    #verify response is true
  end

end




# Here is how to look at versions of s3 objects
#
#
#o2 = bucket.objects['page_attachments/2/IMG_9556.jpg']
# => <AWS::S3::S3Object:cmusv-rails-development/page_attachments/2/IMG_9556.jpg>
#
#o2.versions.each do |version| puts version.version_id end
#
#
#ruby-1.9.2-p180 > $stdout = File.new('console.out', 'w')
#ruby-1.9.2-p180 > o2.versions.latest.read
#ruby-1.9.2-p180 > $stdout = tmp


# Here is how to undlete a deleted file
#
#  object = bucket.objects['people/photo/633/profile/TrevorUmeda.jpg']
#  object.versions.latest.delete
#
#  or
#  bucket.objects['people/photo/589/profile/SionChaudhuri.jpg'].versions.latest.delete

# You probably want to verify the version history
#  object.versions.each do |version| puts version.version_id end
# vLG2iXXhzlJ14a6r3XqHiQqJQpmwTRYA
# null
#  => nil
#  object.versions.each do |version| puts version.delete_marker? end
#  true
#  false
# object.versions['null'].url_for(:read)   (and see in browser)