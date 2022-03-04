FactoryBot.define do
  factory :discount do
    name { "MyString" }
    percent { 1 }
    threshold { 1 }
    merchant { nil }
  end
end
