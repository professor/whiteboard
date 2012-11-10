class DeliverableGrade < ActiveRecord::Base
  belongs_to :user
  belongs_to :deliverable

  validates :user_id, presence: true
  validates :deliverable_id, presence: true
  validates :grade, numericality: { greater_than_or_equal_to: 0 }, presence: true
end
