class Merchant < ApplicationRecord
  include Filterable

  has_many :invoices
  has_many :items

  validates :name, presence: true

  scope :filter_by_name, -> (name) { where("name ilike ?", "%#{name}%") }
  #
  scope :filter_by_created_at, -> (created_at) { where("created_at = ?", "%#{created_at.to_date}%") }

  scope :filter_by_updated_at, -> (updated_at) { where("updated_at = ?", "%#{updated_at.to_date}%") }
end
