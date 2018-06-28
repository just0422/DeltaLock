FactoryGirl.define do
    factory :purchaser do
        name                    { Faker::Name.name }
        email                   { Faker::Internet.email }
        phone                   { Faker::PhoneNumber.phone_number }
        fax                     { Faker::PhoneNumber.phone_number }
        address                 { Faker::Address.full_address }
        group_name              { Faker::StarWars.specie }
        primary_contact         { Faker::StarWars.character }
        primary_contact_type    { Faker::StarWars.call_squadron }
    end
end
