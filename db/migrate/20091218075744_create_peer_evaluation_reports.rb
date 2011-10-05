class CreatePeerEvaluationReports < ActiveRecord::Migration
  def self.up
    create_table :peer_evaluation_reports do |t|
      t.integer :team_id
      t.integer :recipient_id
      t.text :feedback
      t.datetime :email_date

      t.timestamps
    end
  end

  def self.down
    drop_table :peer_evaluation_reports
  end
end
