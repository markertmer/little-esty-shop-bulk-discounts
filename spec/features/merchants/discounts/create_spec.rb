require 'rails_helper'

RSpec.describe "Creating Discounts:", type: :feature do
  before :each do
    @merchant1 = create(:merchant)
    @discount1 = @merchant1.discounts.create(name: "Just Because", percent: 10, threshold: 7)
    @discount2 = @merchant1.discounts.create(name: "For You", percent: 5, threshold: 3)
    @discount3 = @merchant1.discounts.create(name: "October Surprise", percent: 12, threshold: 7)
    @merchant2 = create(:merchant)
    @discount4 = @merchant2.discounts.create(name: "Birth Of Our Savior Day", percent: 15, threshold: 20)
  end

  it 'link to update from the index page' do
    visit "/merchants/#{@merchant1.id}/discounts"
    click_button("Make a New Discount")
    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/new")
  end

  it 'happy path' do
    visit "/merchants/#{@merchant1.id}/discounts/new"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "13")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts")

    expect(page).to have_content("Baby Jesus Sale")
    expect(page).to have_content("13")
    expect(page).to have_content("666")
  end

  it 'sad path: everything blank' do
    visit "/merchants/#{@merchant1.id}/discounts/new"

    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/new")
    expect(page).to have_content("Error: XXXXXX")
  end

  it 'sad path: one thing blank' do
    visit "/merchants/#{@merchant1.id}/discounts/new"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "13")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/new")
    expect(page).to have_content("Error: XXXXXX")
  end

  it 'sad path: percent too high' do
    visit "/merchants/#{@merchant1.id}/discounts/new"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "420")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/new")
    expect(page).to have_content("Error: XXXXXX")

  end

  it 'sad paths: no negative numbers accepted' do
    visit "/merchants/#{@merchant1.id}/discounts/new"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "-20")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/new")
    expect(page).to have_content("Error: XXXXXX")

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "16")
    fill_in("Threshold", with: "-20")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/new")
    expect(page).to have_content("Error: XXXXXX")
  end

  it 'sad paths: non-numericals' do
    visit "/merchants/#{@merchant1.id}/discounts/new"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "abc")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/new")
    expect(page).to have_content("Error: XXXXXX")

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "15")
    fill_in("Threshold", with: "Jeff")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/new")
    expect(page).to have_content("Error: XXXXXX")
  end

  it 'sad path: submitting decimals for threshold' do
    visit "/merchants/#{@merchant1.id}/discounts/new"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "42")
    fill_in("Threshold", with: "66.6")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/new")
    expect(page).to have_content("Error: XXXXXX")
  end

  it 'edge case: submitting decimals for percent' do
    visit "/merchants/#{@merchant1.id}/discounts/new"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "6.66")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/new")
    expect(page).to have_content("Error: XXXXXX")
  end
end
