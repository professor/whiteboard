require 'test_helper'

class EffortLogMailerTest < ActionMailer::TestCase
  tests EffortLogMailer

 def test_midweek_email
   user = users(:student_sam)
   saying = "Test test test!"

   assert ActionMailer::Base.deliveries.empty?


   # Send the email, then test that it got queued
#   email = EffortLogMailer.create_midweek_warning(saying, user)
   email = EffortLogMailer.deliver_midweek_warning(saying, user)
   assert !ActionMailer::Base.deliveries.empty?
   
   # Test the body of the sent email contains what we expect it to
   assert_equal [user.email], email.to
   assert_equal "Scotty Dog says: Test test test!", email.subject
   assert_match /you have not created an effort log or logged effort for this week/, email.body
 end



#  def test_midweek_warning
#    @expected.subject = 'EffortLogMailer#midweek_warning'
#    @expected.body    = read_fixture('midweek_warning')
#    @expected.date    = Time.now

#    assert_equal @expected.encoded, EffortLogMailer.create_midweek_warning().encoded
#    assert_equal @expected.encoded, EffortLogMailer.create_midweek_warning(@expected.date).encoded
#  end

end
