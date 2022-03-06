class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name
  validates_presence_of :percent
  validates_presence_of :threshold

  validates :percent, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :threshold, numericality: { greater_than: 0, only_integer: true }
end
