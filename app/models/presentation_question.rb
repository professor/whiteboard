class PresentationQuestion < ActiveRecord::Base

  def self.existing_questions
    where(:deleted => false)
  end
end
