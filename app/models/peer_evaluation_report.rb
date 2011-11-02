class PeerEvaluationReport < ActiveRecord::Base

  def self.emailed_on(team_id)
    report = PeerEvaluationReport.find(:first, :conditions => {:team_id => team_id})
    report.email_date unless report.nil?
  end

end
