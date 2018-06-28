FactoryGirl.define do
    factory :key do
        system_name         { Faker::Name.name }
        keyway              { Faker::DragonBall.character }
        master_key          { Faker::Number.number(6) }
        control_key         { Faker::Number.number(6) }
        operating_key       { Faker::Number.number(6) }
        keycode_stamp       { Faker::StarWars.droid }
        reference_code      { Faker::Number.number(6) }
        bitting_driver      { Faker::Number.number(6) }
        bitting_control     { Faker::Number.number(6) }
        bitting_master      { Faker::Number.number(6) }
        bitting_bottom      { Faker::Number.number(6) }
        comments            { Faker::StarWars.wookie_sentence }
    end
end

