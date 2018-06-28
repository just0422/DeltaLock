FactoryGirl.define do
    factory :relationship do
        keys                { Faker::Number.number(4) }
        endusers            { Faker::Number.number(4) }
        purchasers          { Faker::Number.number(4) }
        purchaseorders      { Faker::Number.number(4) }
    end
end
