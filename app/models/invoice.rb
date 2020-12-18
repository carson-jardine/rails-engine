class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  validates :status, presence: true

  scope :shipped, -> { where(status: 'shipped')}

  def self.revenue_by_date_range(start_date, end_date)
    Invoice.joins(:invoice_items, :transactions)
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .where('DATE(invoices.updated_at) BETWEEN ? AND ?', start_date, end_date)
    .sum('invoice_items.unit_price * invoice_items.quantity')
  end
end
