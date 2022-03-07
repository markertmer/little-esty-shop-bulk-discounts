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

  def invoice_revenue(invoice_id)
    invoice_items.joins(:item, :invoice)
    .where("invoices.id = #{invoice_id}")
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def dddddiscounted_invoice_revenue(invoice_id)
    possible_discounts = Merchant.joins(:discounts, items: :invoices)
                          .where("merchants.id = #{self.id} and invoices.id = #{invoice_id} and sum(invoice_items.quantity) >= discounts.threshold")
                          .select('discounts.*, sum(invoice_items.quantity)')
                          .group('invoice_items.item_id')
                          binding.pry
    if possible_discounts.empty?
      discount = 0
    else
      discount = get_discount(possible_discounts)
    end
    invoice_revenue(invoice_id) - discount
  end

  def ggggget_discount(possible_discounts)
    possible_discounts
    # .select('invoice_items.quantity * invoice_items.unit_price * (1 - discounts.percent / 100) as discounted_rev')
    .select('count * invoice_items.unit_price * (1 - discounts.percent / 100) as discounted_rev')
    .order('discounted_rev')
    .first
    .discounted_rev
  end

  def discounted_invoice_revenue(invoice_id)
    possible_discounts = Merchant.joins(:discounts, items: :invoices)
    .where("merchants.id = #{self.id} and invoices.id = #{invoice_id}")
    .select("discounts.*, sum(invoice_items.quantity) * invoice_items.unit_price * (1 - discounts.percent / 100) as discounted_rev")
    .group('invoice_items.item_id, invoice_items.unit_price, discounts.percent')
    .order('discounted_rev') #.first.discounted_rev
    # binding.pry
  end
end

    # Merchant.joins(:discounts, items: :invoices)
    # .where("merchants.id = #{self.id} and invoices.id = #{invoice_id} and invoice_items.quantity >= discounts.threshold")
    # .select('invoice_items.quantity * invoice_items.unit_price * (1 - discounts.percent / 100) as discounted_rev')
    # .order('discounted_rev')
    # .first
    # .discounted_rev
