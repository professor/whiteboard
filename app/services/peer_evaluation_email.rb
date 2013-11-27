class PeerEvaluationEmail


  def self.please_do_peer_evaluation_email

    courses_with_first_date = Course.first_email_on_peer_evaluation_is_today
    courses_with_second_date = Course.second_email_on_peer_evaluation_is_today
    sent_emails = 0

    courses_with_first_date.each do |course|
      course.teams.each do |team|
        puts "Team: " + team.name + " (" + team.id.to_s + ") "
        send_peer_evaluation_email(team, team.peer_evaluation_message_one, team.peer_evaluation_message_one)
        sent_emails += 1
      end
    end

    courses_with_second_date.each do |course|
      course.teams.each do |team|
        puts "Team: " + team.name + " (" + team.id.to_s + ") "
        send_peer_evaluation_email(team, I18n.t(:peer_evaluation_message_two_done), I18n.t(:peer_evaluation_message_two_incomplete))
        sent_emails += 1
      end
    end
    sent_emails
  end


  def self.send_peer_evaluation_email(team, done_message, incomplete_message)
    faculty = team.faculty_email_addresses()

    to_address_done = []
    to_address_incomplete = []
    team.members.each do |user|
      if PeerEvaluationReview.is_completed_for?(user.id, team.id)
        to_address_done << user.email
      else
        to_address_incomplete << user.email
      end
    end
    send_email(team, faculty, to_address_done, done_message) unless to_address_done.empty?
    send_email(team, faculty, to_address_incomplete, incomplete_message) unless to_address_incomplete.empty?
  end


  def self.send_email(team, faculty, to_address, message)
    options = {:to => to_address, :cc => faculty, :bcc => "rails.app@sv.cmu.edu",
               :subject => "peer evaluation for team #{team.name}",
               :message => message, :url => "http://whiteboard.sv.cmu.edu/peer_evaluation/edit_evaluation/#{team.id}", # + edit_peer_evaluation_path(team))
               :url_label => "Complete the survey now"}
    GenericMailer.email(options).deliver
  end




end
