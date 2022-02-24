require 'rails_helper'

RSpec.describe 'merchant item index', type: :feature do
  it 'displays all items' do
    merchant = create(:merchant)

    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)

    visit "/merchants/#{merchant.id}/items"

    expect(page).to have_content(item1.name)
    expect(page).to have_content(item2.name)
    expect(page).to have_content(item3.name)
  end

  it 'can toggle the status from the index page' do
    merchant = create(:merchant)

    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)

    visit "/merchants/#{merchant.id}/items"

    expect(item1.status).to eq("disabled")

    within "#item-#{item1.id}" do

      click_button "enable"

      expect(item1.status).to eq("enabled")
    end
    
    expect(page).to have_content("Item status updated!")
  end
end
