class Merchant < ApplicationRecord
  has_many :invoices

  validates :name, presence: true
end
