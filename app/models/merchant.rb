class Merchant < ApplicationRecord
  has_many :items
  has_many :discounts
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name
  validates_presence_of :status

  enum status: { "disabled" => 0, "enabled" => 1 }

  def ready_items
     invoice_items.where.not(status: 2)
     .joins(:invoice).order("invoices.created_at")
  end

  def ordered_items
    items.order(:name)
  end

  def self.enabled
    where(status: 1)
  end

  def self.disabled
    where(status: 0)
  end

  def top_five
    items.joins(invoices: :transactions)
    .where('transactions.result = 0')
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:id)
    .order("revenue DESC")
    .limit(5)
  end

  def self.top_merchant
    joins(items: [invoices: :transactions])
    .where('transactions.result = 0')
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:id)
    .order("revenue DESC")
    .limit(5)
  end

  def favorite_customers
    invoices.joins(:transactions, :customer)
    .where(transactions: {result: :success})
    .select('customers.*, transactions.count as transaction_count')
    .group('customers.id')
    .order('transaction_count desc')
    .limit(5)
  end

  def best_day
    items.joins(invoices: :transactions)
    .where('transactions.result = 0')
    .select('invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .group('invoices.created_at')
    .order('revenue desc')
    .order('invoices.created_at desc')
    .first&.created_at&.strftime("%A, %B %d, %Y")
  end
end
