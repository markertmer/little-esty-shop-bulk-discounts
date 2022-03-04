require 'rails_helper'

RSpec.describe "merchant discounts index page:", type: :feature do
  before :each do
    @merchant1 = create!(:merchant)
    @discount1 = @merchant1.create!(name: "Just Because", percent: 10, threshold: 7)
    @discount2 = @merchant1.create!(name: "For You", percent: 5, threshold: 3)
    @discount3 = @merchant1.create!(name: "October Surprise", percent: 12, threshold: 7)
    @merchant2 = create!(:merchant)
    @discount4 = @merchant2.create!(name: "Birth Of Our Savior Day", percent: 15, threshold: 20)
  end

  it "link to discounts index from merchant dashboard" do
    visit "/merchants/#{@merchant1.id}"
    click_on("View My Bulk Discounts")
    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts")
  end

  it "lists the discounts and their attributes" do
    visit "/merchants/#{@merchant1.id}/discounts"

    within("discount-#{@discount1.id}") do
      expect(page).to have_content(@discount1.name)
      expect(page).to have_content(@discount1.percent)
      expect(page).to have_content(@discount1.threshold)
    end

    within("discount-#{@discount2.id}") do
      expect(page).to have_content(@discount2.name)
      expect(page).to have_content(@discount2.percent)
      expect(page).to have_content(@discount2.threshold)
    end

    within("discount-#{@discount3.id}") do
      expect(page).to have_content(@discount3.name)
      expect(page).to have_content(@discount3.percent)
      expect(page).to have_content(@discount3.threshold)
    end

    expect(page).to_not have_content(@discount4.name)
    expect(page).to_not have_content(@discount4.percent)
    expect(page).to_not have_content(@discount4.threshold)
  end

  it "links to each discount's show page" do
    visit "/merchants/#{@merchant1.id}/discounts"

    within("discount-#{@discount1.id}") do
      expect(page).to have_link(@discount1.name)
      click_on(@discount1.name)
      expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}")
    end
  end
  end
