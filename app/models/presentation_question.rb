class PresentationQuestion < ActiveRecord::Base

  def self.existing_questions
    where(:is_deleted => false)
  end
end
