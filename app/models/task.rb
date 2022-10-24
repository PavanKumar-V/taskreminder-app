class Task < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true, comparison: { greater_than: :start_date }
  validates_length_of :title, minimum: 10, maximum: 20
  has_many :starred_tasks, dependent: :destroy
end
