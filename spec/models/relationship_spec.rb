require 'rails_helper'

RSpec.describe Relationship, type: :model do
    it "has a valid factory" do
        relationship = FactoryGirl.create(:relationship)
        expect(relationship).to be_valid
    end
end
