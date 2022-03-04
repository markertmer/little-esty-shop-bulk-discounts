require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'attributes' do
    it { should validate_presence_of :name }
  end

  it 'exists' do
    merchant = create(:merchant)
    expect(merchant).to be_a(Merchant)
    expect(merchant).to be_valid
  end

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:discounts) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  it '#ready_items' do
    merchant1 = create(:merchant)

    item1 = create(:item, merchant: merchant1)

    ii1 = create(:invoice_item, status: "shipped", item: item1)
    ii2 = create(:invoice_item, status: "packaged", item: item1)
    ii3 = create(:invoice_item, status: "pending", item: item1)

    expect(merchant1.ready_items).to eq([ii2, ii3])
  end

  it '#ordered_items' do
    merchant = create(:merchant)

    item1 = create(:item, merchant: merchant, name: "AAAA")
    item2 = create(:item, merchant: merchant, name: "BBBB")
    item3 = create(:item, merchant: merchant, name: "CCCC")

    expect(merchant.ordered_items).to eq([item1, item2, item3])
  end

  it "lists only enabled merchants" do
    @merchant1 = Merchant.create!(name: "The Tornado", status: 1)
    @merchant3 = Merchant.create!(name: "The Mornado", status: 1)
    @merchant2 = Merchant.create!(name: "The Vornado", status: 0)
    @merchant4 = Merchant.create!(name: "The Lornado", status: 0)
    expect(Merchant.enabled).to eq([@merchant1, @merchant3])
    expect(Merchant.enabled).to_not eq([@merchant2, @merchant4])
  end

  it "lists only disabled merchants" do
    @merchant1 = Merchant.create!(name: "The Tornado", status: 1)
    @merchant3 = Merchant.create!(name: "The Mornado", status: 1)
    @merchant2 = Merchant.create!(name: "The Vornado", status: 0)
    @merchant4 = Merchant.create!(name: "The Lornado", status: 0)
    expect(Merchant.disabled).to_not eq([@merchant1, @merchant3])
    expect(Merchant.disabled).to eq([@merchant2, @merchant4])
  end

  it "tests top five" do
    merchant1 = Merchant.create!(name: "The Tornado")
    item1 = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    item2 = merchant1.items.create!(name: "FunPants", description: "Cha + 20", unit_price: 2000)
    item3 = merchant1.items.create!(name: "FitPants", description: "Con + 20", unit_price: 150)
    item4 = merchant1.items.create!(name: "VeinyShorts", description: "Str + 20", unit_price: 1400)
    item5 = merchant1.items.create!(name: "SpringSocks", description: "DX + 20", unit_price: 375)
    item6 = merchant1.items.create!(name: "UnderRoos", description: "SNUG!", unit_price: 25)
    item7 = merchant1.items.create!(name: "SunStoppers", description: "Eclipse ready!", unit_price: 50)
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    customer2 = Customer.create!(first_name: "Larky", last_name: "Lark" )
    customer3 = Customer.create!(first_name: "Sparky", last_name: "Spark" )
    customer4 = Customer.create!(first_name: "Farky", last_name: "Fark" )
    invoice1 = customer1.invoices.create!(status: 0)
    invoice2 = customer2.invoices.create!(status: 0)
    invoice3 = customer3.invoices.create!(status: 0)
    invoice4 = customer4.invoices.create!(status: 0)
    invoice5 = customer4.invoices.create!(status: 0)

    invoice_item2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    invoice_item4 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 120, status: 1)
    invoice_item7 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item7.id, quantity: 15, unit_price: 50, status: 2)
    invoice_item3 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: item3.id, quantity: 5, unit_price: 125, status: 0)
    invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 2, unit_price: 125, status: 0)
    invoice_item6 = InvoiceItem.create!(invoice_id: invoice4.id, item_id: item6.id, quantity: 20, unit_price: 25, status: 2)
    invoice_item5 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 1)
    invoice_item8 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: item2.id, quantity: 1, unit_price: 2000, status: 1)
    invoice_item9 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item4.id, quantity: 3, unit_price: 1400, status: 2)

    transaction1 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    transaction2 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    transaction3 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)
    transaction4 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice4.id)
    transaction5 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice5.id)

    expect(merchant1.top_five).to eq([item2, item1, item4, item7, item3])
  end

  it "best_day: returns highest revenue date" do
    merchant1 = Merchant.create!(name: "The Tornado")
    item1 = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    item2 = merchant1.items.create!(name: "FunPants", description: "Cha + 20", unit_price: 2000)
    item3 = merchant1.items.create!(name: "FitPants", description: "Con + 20", unit_price: 150)
    item4 = merchant1.items.create!(name: "VeinyShorts", description: "Str + 20", unit_price: 1400)
    item5 = merchant1.items.create!(name: "SpringSocks", description: "DX + 20", unit_price: 375)
    item6 = merchant1.items.create!(name: "UnderRoos", description: "SNUG!", unit_price: 25)
    item7 = merchant1.items.create!(name: "SunStoppers", description: "Eclipse ready!", unit_price: 50)
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    customer2 = Customer.create!(first_name: "Larky", last_name: "Lark" )
    customer3 = Customer.create!(first_name: "Sparky", last_name: "Spark" )
    customer4 = Customer.create!(first_name: "Farky", last_name: "Fark" )

## Day 1 (Friday) / Invoice 1 Revenue = 8450 / technically the highest revenue day but the transaction fails
    invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
    invoice_item2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 2, unit_price: 125, status: 0)
    invoice_item9 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item4.id, quantity: 3, unit_price: 1400, status: 2)
    transaction1 = Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice1.id)
## Day 2 (Saturday) / Invoice 2 Revenue = 240
    invoice2 = customer2.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
    invoice_item4 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 120, status: 1)
    transaction2 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
## Day 2 (Saturday) / Invoice 3 Revenue = 4750 // Day 2 Total = 4990 // Day 2 is THE BEST DAY!!!!!!!!!!
    invoice3 = customer3.invoices.create!(status: 0, created_at: "2012-03-10 08:13:03")
    invoice_item7 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item7.id, quantity: 15, unit_price: 50, status: 2)
    invoice_item5 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 1)
    transaction3 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)
## Day 3 (Sunday) / Revenue = 500
    invoice4 = customer4.invoices.create!(status: 0, created_at: "2012-03-11 20:54:52")
    invoice_item6 = InvoiceItem.create!(invoice_id: invoice4.id, item_id: item6.id, quantity: 20, unit_price: 25, status: 2)
    transaction4 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice4.id)
## Day 4 (Sunday) / Revenue = 2625
    invoice5 = customer4.invoices.create!(status: 0, created_at: "2012-03-11 20:54:52")
    invoice_item3 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: item3.id, quantity: 5, unit_price: 125, status: 0)
    invoice_item8 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: item2.id, quantity: 1, unit_price: 2000, status: 1)
    transaction5 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice5.id)

    expect(merchant1.best_day).to eq("Saturday, March 10, 2012")

  end

  it "best_day: returns most recent date in case of tie" do
    merchant1 = Merchant.create!(name: "The Tornado")
    item1 = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    item2 = merchant1.items.create!(name: "FunPants", description: "Cha + 20", unit_price: 2000)
    item3 = merchant1.items.create!(name: "FitPants", description: "Con + 20", unit_price: 150)
    item4 = merchant1.items.create!(name: "VeinyShorts", description: "Str + 20", unit_price: 1400)
    item5 = merchant1.items.create!(name: "SpringSocks", description: "DX + 20", unit_price: 375)
    item6 = merchant1.items.create!(name: "UnderRoos", description: "SNUG!", unit_price: 25)
    item7 = merchant1.items.create!(name: "SunStoppers", description: "Eclipse ready!", unit_price: 50)
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    customer2 = Customer.create!(first_name: "Larky", last_name: "Lark" )
    customer3 = Customer.create!(first_name: "Sparky", last_name: "Spark" )
    customer4 = Customer.create!(first_name: "Farky", last_name: "Fark" )

## Day 1 (Friday) / Invoice 1 Revenue = 8450 / technically the highest revenue day but the transaction fails
    invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
    invoice_item2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 2, unit_price: 125, status: 0)
    invoice_item9 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item4.id, quantity: 3, unit_price: 1400, status: 2)
    transaction1 = Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice1.id)
## Day 2 (Saturday) / Invoice 2 Revenue = 240
    invoice2 = customer2.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
    invoice_item4 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 120, status: 1)
    transaction2 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
## Day 2 (Saturday) / Invoice 3 Revenue = 4750 // Day 2 Total = 4990
    invoice3 = customer3.invoices.create!(status: 0, created_at: "2012-03-10 08:13:03")
    invoice_item7 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item7.id, quantity: 15, unit_price: 50, status: 2)
    invoice_item5 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 1)
    transaction3 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)
## Day 3 (Sunday) / Revenue = 5000 / Tied for Best but not the most recent
    invoice4 = customer4.invoices.create!(status: 0, created_at: "2012-03-11 20:54:52")
    invoice_item6 = InvoiceItem.create!(invoice_id: invoice4.id, item_id: item6.id, quantity: 200, unit_price: 25, status: 2)
    transaction4 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice4.id)
## Day 4 (Monday) / Revenue = 5000 / Tied for Best & the most recent! - THE WINNER!!!!!!!!!!!
    invoice5 = customer4.invoices.create!(status: 0, created_at: "2012-03-12 20:54:52")
    invoice_item3 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: item3.id, quantity: 5, unit_price: 100, status: 0)
    invoice_item8 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: item2.id, quantity: 1, unit_price: 4500, status: 1)
    transaction5 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice5.id)

    expect(merchant1.best_day).to eq("Monday, March 12, 2012")
  end

  it 'tests the top five merchants model' do
    merchant1 = Merchant.create!(name: "The Tornado", status: 1)
    merchant3 = Merchant.create!(name: "The Mornado", status: 1)
    merchant2 = Merchant.create!(name: "The Vornado", status: 0)
    merchant4 = Merchant.create!(name: "The Lornado", status: 0)
    merchant5 = Merchant.create!(name: "The Sornado", status: 0)
    merchant6 = Merchant.create!(name: "The Wornado", status: 0)
    item1 = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    item2 = merchant2.items.create!(name: "FunPants", description: "Cha + 20", unit_price: 2000)
    item3 = merchant3.items.create!(name: "FitPants", description: "Con + 20", unit_price: 150)
    item4 = merchant4.items.create!(name: "VeinyShorts", description: "Str + 20", unit_price: 1400)
    item5 = merchant5.items.create!(name: "SpringSocks", description: "DX + 20", unit_price: 375)
    item6 = merchant6.items.create!(name: "UnderRoos", description: "SNUG!", unit_price: 25)
    item7 = merchant1.items.create!(name: "SunStoppers", description: "Eclipse ready!", unit_price: 50)
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    customer2 = Customer.create!(first_name: "Larky", last_name: "Lark" )
    customer3 = Customer.create!(first_name: "Sparky", last_name: "Spark" )
    customer4 = Customer.create!(first_name: "Farky", last_name: "Fark" )
    invoice1 = customer1.invoices.create!(status: 0)
    invoice2 = customer2.invoices.create!(status: 0)
    invoice3 = customer3.invoices.create!(status: 0)
    invoice4 = customer4.invoices.create!(status: 0)
    invoice5 = customer4.invoices.create!(status: 0)

    invoice_item2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    invoice_item4 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 120, status: 1)
    invoice_item7 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item7.id, quantity: 15, unit_price: 50, status: 2)
    invoice_item3 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: item3.id, quantity: 5, unit_price: 125, status: 0)
    invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 2, unit_price: 125, status: 0)
    invoice_item6 = InvoiceItem.create!(invoice_id: invoice4.id, item_id: item6.id, quantity: 20, unit_price: 25, status: 2)
    invoice_item5 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 1)
    invoice_item8 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: item2.id, quantity: 1, unit_price: 2000, status: 1)
    invoice_item9 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item4.id, quantity: 3, unit_price: 1400, status: 2)

    transaction1 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    transaction2 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    transaction3 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)
    transaction4 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice4.id)
    transaction5 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice5.id)

    expect(Merchant.top_merchant).to eq([merchant2,  merchant1, merchant4, merchant3, merchant6])
    expect(Merchant.top_merchant).to_not include([merchant5])
  end

  it 'favorite_customers' do
    ## merchant 1 is the protagonist of the test! Death to all other merchants!!!!!!!!!!!
    merchant1 = Merchant.create!(name: "The Tornado", status: 1)
    item1 = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    ## 1 Transaction - should not rank
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    invoice1 = customer1.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    ## 7 Transactions on 1 invoice // The #1 favorite
    customer2 = Customer.create!(first_name: "Narky", last_name: "Nark" )
    invoice1 = customer2.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    ## 2 Transactions over 2 invoices // The #5 favorite
    customer3 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    invoice1 = customer3.invoices.create!(status: 0)
    invoice2 = customer3.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    ## 6 Transactions over 2 invoices, plus a bunch of transactions with another merchant // The #2 favorite
    customer4 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    invoice1 = customer4.invoices.create!(status: 0)
    invoice2 = customer4.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    merchant2 = Merchant.create!(name: "The Tornado", status: 1)
    item2 = merchant2.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    invoice1 = customer4.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 7894542, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 3456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 34563456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 3645, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 345634566, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 65433333, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 9872334, result: 0, invoice_id: invoice1.id)
    ## 8 Transactions on 5 invoices, but 4 transactions fail /4 total/ The #3 favorite
    customer5 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    invoice1 = customer5.invoices.create!(status: 0)
    invoice2 = customer5.invoices.create!(status: 0)
    invoice3 = customer5.invoices.create!(status: 0)
    invoice4 = customer5.invoices.create!(status: 0)
    invoice5 = customer5.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice3.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice4.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice5.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice2.id)
    Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice2.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)
    Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice4.id)
    Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice4.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice5.id)
    ## 1 Transaction for the merchant, 1 for another merchant (doesn't count), 2 transactions on a shared invoice between them (should count) /3 total/ The #4 favorite
    customer6 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    merchant2 = Merchant.create!(name: "The Tornado", status: 1)
    item2 = merchant2.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    invoice1 = customer6.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    invoice2 = customer6.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    invoice3 = customer6.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice3.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice3.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)

    expected_rank = [customer2.id, customer4.id, customer5.id, customer6.id, customer3.id]
    actual_rank = merchant1.favorite_customers.map { |customer| customer.id }
    expect(expected_rank).to eq(actual_rank)

    expected_transaction_counts = [7, 6, 4, 3, 2]
    actual_transaction_counts = merchant1.favorite_customers.map { |customer| customer.transaction_count }
    expect(expected_transaction_counts).to eq(actual_transaction_counts)
  end
end
