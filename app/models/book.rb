class Book < ApplicationRecord
  enum :status, %w[to_read reading completed]

  belongs_to :author

  validates :title, presence: true
  validates :title, uniqueness: true
end
