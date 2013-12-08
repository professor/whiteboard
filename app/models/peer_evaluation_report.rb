class PeerEvaluationReport < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  def self.emailed_on(team_id)
    report = PeerEvaluationReport.where(:team_id => team_id).first
    report.email_date unless report.nil?
  end

end
