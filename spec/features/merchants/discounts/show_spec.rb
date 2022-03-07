require 'rails_helper'

RSpec.describe "Merchant Discount Show:", type: :feature do
  before :each do
    @merchant1 = create(:merchant)
    @discount1 = @merchant1.discounts.create(name: "Just Because", percent: 10, threshold: 7)
    @discount2 = @merchant1.discounts.create(name: "For You", percent: 5, threshold: 3)
    @discount3 = @merchant1.discounts.create(name: "October Surprise", percent: 12, threshold: 27)
  end

  it 'displays the relevant discount info' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}"

    expect(page).to have_content(@discount1.name)
    expect(page).to have_content(@discount1.percent)
    expect(page).to have_content(@discount1.threshold)

    expect(page).to_not have_content(@discount2.name)
    expect(page).to_not have_content(@discount2.percent)
    expect(page).to_not have_content(@discount2.threshold)
    expect(page).to_not have_content(@discount3.name)
    expect(page).to_not have_content(@discount3.percent)
    expect(page).to_not have_content(@discount3.threshold)
  end
end
