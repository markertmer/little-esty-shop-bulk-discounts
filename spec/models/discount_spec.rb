require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant) }
  end

  describe "attributes" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:percent) }
    it { should validate_presence_of(:threshold) }

    it { should validate_numericality_of(:percent).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:percent).is_less_than_or_equal_to(100) }
    it { should validate_numericality_of(:threshold).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:threshold).only_integer }
  end
end
