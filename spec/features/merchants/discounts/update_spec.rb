require 'rails_helper'

RSpec.describe "Updating Discounts:", type: :feature do
  before :each do
    @merchant1 = create(:merchant)
    @discount1 = @merchant1.discounts.create(name: "Just Because", percent: 10, threshold: 7)
  end

  it 'has a link to edit from the show page' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}"

    click_on("edit discount")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit")
  end

  it 'happy path: updates all three attributes' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "13")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}")

    expect(page).to have_content("Baby Jesus Sale")
    expect(page).to have_content("13%")
    expect(page).to have_content("666")

    expect(page).to_not have_content("Just Because")
    expect(page).to_not have_content("10%")
    expect(page).to_not have_content("7")
  end

  it 'happy path: updates two attributes' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}")

    expect(page).to have_content("Baby Jesus Sale")
    expect(page).to have_content("666")

    expect(page).to_not have_content("Just Because")
    expect(page).to have_content("10%")
    expect(page).to_not have_content("7")
  end

  it 'happy path: updates one attribute' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}")

    expect(page).to have_content("666")

    expect(page).to have_content("Just Because")
    expect(page).to have_content("10%")
    expect(page).to_not have_content("7")
  end

  it 'sad path: everything blank' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    fill_in("Name", with: "")
    fill_in("Percent", with: "")
    fill_in("Threshold", with: "")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit")
    expect(page).to have_content("Error: Name can't be blank, Percent can't be blank, Percent is not a number, Threshold can't be blank, Threshold is not a number")
  end

  it 'sad path: one thing blank' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Threshold", with: "")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit")
    expect(page).to have_content("Error: Threshold can't be blank, Threshold is not a number")
  end

  it 'sad path: percent too high' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "420")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit")
    expect(page).to have_content("Error: Percent must be less than or equal to 100")
  end

  it 'sad paths: no negative numbers accepted' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    fill_in("Percent", with: "-20")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit")
    expect(page).to have_content("Error: Percent must be greater than or equal to 0")

    fill_in("Threshold", with: "-20")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit")
    expect(page).to have_content("Error: Threshold must be greater than 0")
  end

  it 'sad paths: non-numericals' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "abc")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit")
    expect(page).to have_content("Error: Percent is not a number")

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "15")
    fill_in("Threshold", with: "Jeff")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit")
    expect(page).to have_content("Error: Threshold is not a number")
  end

  it 'sad path: submitting decimals for threshold' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "42")
    fill_in("Threshold", with: "66.6")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit")
    expect(page).to have_content("Error: Threshold must be an integer")
  end

  it 'edge case: decimals not accepted for percent' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    fill_in("Name", with: "Baby Jesus Sale")
    fill_in("Percent", with: "6.5")
    fill_in("Threshold", with: "666")
    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}")
    expect(page).to_not have_content("6.5%")
    expect(page).to have_content("6%")
  end

  it 'edge case: making no changes' do
    visit "/merchants/#{@merchant1.id}/discounts/#{@discount1.id}/edit"

    click_button("Submit")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}")

    expect(page).to have_content("Just Because")
    expect(page).to have_content("10%")
    expect(page).to have_content("7")
  end
end
