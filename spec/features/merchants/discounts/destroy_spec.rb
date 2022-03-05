require 'rails_helper'

RSpec.describe "Deleting Discounts:", type: :feature do
  before :each do
    @merchant1 = create(:merchant)
    @discount1 = @merchant1.discounts.create(name: "Just Because", percent: 10, threshold: 7)
    @discount2 = @merchant1.discounts.create(name: "For You", percent: 5, threshold: 3)
    @discount3 = @merchant1.discounts.create(name: "October Surprise", percent: 12, threshold: 7)
  end

  it "has a button to delete from the index" do
    visit "/merchants/#{@merchant1.id}/discounts"

    within("#discount-#{@discount1.id}") do
      expect(page).to have_button("delete")
    end
  end

  it "deletes the discount" do
    visit "/merchants/#{@merchant1.id}/discounts"

    within("#discount-#{@discount1.id}") do
      click_button("delete")
    end

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts")

    expect(page).to_not have_content(@discount1.name)

    expect(page).to have_content(@discount2.name)
    expect(page).to have_content(@discount3.name)
  end
end
