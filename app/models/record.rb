class Record < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :date, presence: true
  validates :part, presence: true
  validates :place, presence: true
  validates :exercise, presence: true
  validates :rep, presence: true
  validates :set, presence: true
end
