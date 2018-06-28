FactoryGirl.define do
    factory :purchase_order do
        po_number       { Faker::Number.number(6) }
        so_number       { Faker::Number.number(6) }
        date_order      { Faker::Date.between(1.year.ago, 1.year.from_now) }
    end
end
