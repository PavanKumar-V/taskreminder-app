class Task < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true, comparison: { greater_than: :start_date }
  validates_length_of :title, minimum: 8, maximum: 20

  belongs_to :user
  has_many :starred_tasks, dependent: :destroy
  has_many :collaborators, dependent: :destroy

end
