require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'attributes' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  it 'exists' do
    item = create(:item)
    expect(item).to be_a(Item)
    expect(item). to be_valid
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:discounts).through(:merchant) }
  end

  it 'item toggle status' do
    merchant = create(:merchant)

    item1 = create(:item, merchant: merchant)

      expect(item1.status).to eq("disabled")

      item1.update({ status: "enabled" })
      item1.reload

      expect(item1.status).to eq("enabled")

      item1.update({ status: "disabled" })
      item1.reload

      expect(item1.status).to eq("disabled")
  end

  it 'instance methods' do
    item1 = create(:item, status: "enabled")
    item2 = create(:item, status: "disabled")

    expect(Item.enabled).to eq([item1])
    expect(Item.disabled).to eq([item2])
  end

  it '#money_made' do
    item1 = create(:item)

    ii1 = create(:invoice_item, item: item1, unit_price: 10, quantity: 1)
    ii2 = create(:invoice_item, item: item1, unit_price: 10, quantity: 1)

    expect(item1.money_made).to eq(20)
  end

    it  "best day with top five items setup" do
      merchant1 = Merchant.create!(name: "The Tornado")
      smart = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
      fun = merchant1.items.create!(name: "FunPants", description: "Cha + 20", unit_price: 2000)
      fit = merchant1.items.create!(name: "FitPants", description: "Con + 20", unit_price: 150)
      veiny = merchant1.items.create!(name: "VeinyShorts", description: "Str + 20", unit_price: 1400)
      socks = merchant1.items.create!(name: "SpringSocks", description: "DX + 20", unit_price: 375)
      under = merchant1.items.create!(name: "UnderRoos", description: "SNUG!", unit_price: 25)
      sun = merchant1.items.create!(name: "SunStoppers", description: "Eclipse ready!", unit_price: 50)

      customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
      customer2 = Customer.create!(first_name: "Larky", last_name: "Lark" )
      customer3 = Customer.create!(first_name: "Sparky", last_name: "Spark" )
      customer4 = Customer.create!(first_name: "Farky", last_name: "Fark" )

      invoice1 = customer1.invoices.create!(status: 2, created_at: "2014-05-22")
      invoice2 = customer2.invoices.create!(status: 2, created_at: "2014-05-21")
      invoice3 = customer3.invoices.create!(status: 2, created_at: "2014-05-20")
      invoice4 = customer4.invoices.create!(status: 2, created_at: "2014-05-22")
      invoice5 = customer4.invoices.create!(status: 2, created_at: "2014-05-19")


      # fun pants has 4500 revenue (500 x 5) + 1000 + 1000
      invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: fun.id, quantity: 5, unit_price: 500, status: 0)
      invoice_item5 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: fun.id, quantity: 1, unit_price: 1000, status: 1)
      invoice_item8 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: fun.id, quantity: 1, unit_price: 1000, status: 1)

      # smart pants has 4400 revenue (2000 x 2) + (100 x 4)
      invoice_item2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: smart.id, quantity: 2, unit_price: 2000, status: 0)
      invoice_item4 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: smart.id, quantity: 4, unit_price: 100, status: 1)

      # veiny shorts has 1400 revenue
      invoice_item9 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: veiny.id, quantity: 3, unit_price: 1400, status: 2)

      # sun stoppers has 700 revenue (100 x 7)
      invoice_item7 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: sun.id, quantity: 7, unit_price: 100, status: 2)

      # fit pants has 500 revenue (100 x 5)
      invoice_item3 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: fit.id, quantity: 5, unit_price: 100, status: 0)

      # under roos has 75 revenue (25 x 3)
      invoice_item6 = InvoiceItem.create!(invoice_id: invoice4.id, item_id: under.id, quantity: 3, unit_price: 25, status: 2)

      transaction1 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
      transaction2 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
      transaction3 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)
      transaction4 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice4.id)
      transaction5 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice5.id)
      expect(smart.best_day).to eq(smart.created_at.strftime("Thursday, May 22, 2014"))
      expect(fun.best_day).to eq(fun.created_at.strftime("Thursday, May 22, 2014"))
      expect(fit.best_day).to eq(fit.created_at.strftime("Monday, May 19, 2014"))
    end
end
