require 'rails_helper'

RSpec.describe Key, type: :model do
    it "has a valid factory" do
        key = FactoryGirl.create(:key)
        expect(key).to be_valid
    end 
end
