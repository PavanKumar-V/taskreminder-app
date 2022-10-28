class Avatar < ApplicationRecord
  has_one :users
  has_one_attached :image
end
