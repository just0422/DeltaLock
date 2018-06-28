FactoryGirl.define do
    factory :end_user do
        name                    { Faker::Name.name }
        phone                   { Faker::PhoneNumber.phone_number }
        fax                     { Faker::PhoneNumber.phone_number }
        department              { Faker::StarWars.planet }
        store_number            { Faker::Number.number(6) }
        address                 { Faker::Address.full_address }
        group_name              { Faker::StarWars.specie }
        primary_contact         { Faker::StarWars.character }
        primary_contact_type    { Faker::StarWars.call_squadron }
        sub_department_1        { Faker::StarWars.wookie_sentence }
        sub_department_2        { Faker::StarWars.wookie_sentence }
        sub_department_3        { Faker::StarWars.wookie_sentence }
        sub_department_4        { Faker::StarWars.wookie_sentence }
        lat                     { Faker::Address.latitude }
        lng                     { Faker::Address.longitude }
    end
end
