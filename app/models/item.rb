class Item < ApplicationRecord
  include Filterable

  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  scope :filter_by_name, -> (name) { where("name ilike ?", "%#{name}%") }

  scope :filter_by_description, -> (description) { where("description ilike ?", "%#{description}%") }

  scope :filter_by_unit_price, -> (unit_price) { where("unit_price = ?", unit_price.to_f) }

  scope :filter_by_created_at, -> (created_at) { where("created_at = ?", "%#{created_at.to_date}%") }

  scope :filter_by_updated_at, -> (updated_at) { where("updated_at = ?", "%#{updated_at.to_date}%") }
end
