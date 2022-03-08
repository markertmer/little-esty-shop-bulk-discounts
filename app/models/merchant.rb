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

  # def discounted_invoice_revenue(invoice_id)
  #   potential_discounts = items.joins(:discounts, :invoice_items)
  #   .where("invoice_items.invoice_id = #{invoice_id}")
  #   .select('invoice_items.item_id, discounts.percent, discounts.threshold, invoice_items.unit_price, sum(invoice_items.quantity) as total')
  #   .group('invoice_items.item_id, discounts.percent, discounts.threshold, invoice_items.unit_price')
  #   .order(total: :desc)
  #
  #   invoice_revenue(invoice_id) - final_discount(potential_discounts)
  # end

  def final_discount(potential_discounts)
    discounts = Hash.new(0)

    potential_discounts.each do |data|
      next if data.percent == nil

      item_discount = (data.total * data.unit_price * data.percent.to_f / 100)

      if data.total >= data.threshold && item_discount > discounts[data.item_id]
        discounts[data.item_id] = item_discount
      end
    end

    discounts.values.sum
  end

  def discount_data(invoice_id)
    invoice_items.joins(item: :discounts)
    .where("invoice_id = #{invoice_id} and invoice_items.quantity >= discounts.threshold")
    .select('discounts.*,
      invoice_items.item_id,
      max(quantity * invoice_items.unit_price * discounts.percent / 100)
      as savings')
    .group('invoice_items.id, discounts.id')
  end

  def discounted_invoice_revenue(invoice_id)
    discounts = Hash.new(0)

    discount_data(invoice_id).each do |data|
      if data.savings > discounts[data.item_id]
        discounts[data.item_id] = data.savings.to_f
      end
    end

    invoice_revenue(invoice_id) - discounts.values.sum
  end

  def applied_discounts(invoice_id)
    discounts = Hash.new(0)

    discount_data(invoice_id).each do |data|
      if data.savings > discounts[data.item_id][0]
        discounts[data.item_id] = [data.savings, data.id]
      end
    end

    discounts.map do |key, value|
      Discount.find(value[1])
    end.uniq
  end

end
