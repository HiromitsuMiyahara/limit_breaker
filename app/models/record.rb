class Record < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :start_time, presence: true
  validates :part, presence: true
  validates :place, presence: true
  validates :exercise, presence: true
  validates :rep, presence: true
  validates :set, presence: true
  
  enum part_select: { chest: 0, back: 1, shoulder: 2, arm: 3, stomach: 4, leg: 5}
end
