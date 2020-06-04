class Achievement < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
