class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :discounts, through: :merchant

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  enum status: { "disabled" => 0, "enabled" => 1 }

  def self.enabled
    where(status: 1)
  end

  def self.disabled
    where(status: 0)
  end

  def money_made
    invoice_items.sum('quantity * unit_price')
  end

  def best_day
    invoices.joins(:invoice_items, :transactions)
      .where('transactions.result = 0')
      .select('invoices.*, SUM(invoice_items.unit_price * invoice_items.quantity)as revenue')
      .group(:id)
      .order("revenue DESC")
      .first&.created_at&.strftime("%A, %B %d, %Y")
  end
end
