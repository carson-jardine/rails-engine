class Merchant < ApplicationRecord
  include Filterable

  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  validates :name, presence: true

  scope :filter_by_name, -> (name) { where("name ilike ?", "%#{name}%") }

  scope :filter_by_created_at, -> (created_at) { where("created_at = ?", "%#{created_at.to_date}%") }

  scope :filter_by_updated_at, -> (updated_at) { where("updated_at = ?", "%#{updated_at.to_date}%") }

  def self.most_revenue(quantity)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .select("merchants.*, merchants.name, SUM(invoice_items.unit_price * invoice_items.quantity) AS total")
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .group("merchants.id")
    .order("total DESC")
    .limit(quantity)
  end

  def self.most_items(quantity)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .select("merchants.*, merchants.name, SUM(invoice_items.quantity) AS num_items")
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .group("merchants.id")
    .order("num_items DESC")
    .limit(quantity)
  end

  # def self.revenue_by_date_range(start_date, end_date)
  #   Merchant.joins(invoices: [:invoice_items, :transactions])
  #   .merge(Transaction.successful)
  #   .merge(Invoice.shipped)
  #   .where('DATE(invoices.created_at) BETWEEN ? AND ?', start_date, end_date)
  #   .sum("invoice_items.unit_price * invoice_items.quantity")
  # end
end
