require 'rubygems'
require 'rake'

namespace :cmu do
  desc "Create an email notification about Peer Evaluation"
  task(:please_do_peer_evaluation_email => :environment) do

    puts "hello"
    number = PeerEvaluationEmail.please_do_peer_evaluation_email()
    puts "Examined Peer Evaluation dates to see if any emails should be sent. #{number} emails were sent"

end
end