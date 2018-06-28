require 'rails_helper'

RSpec.describe Purchaser, type: :model do
    it "has a valid factory" do
        purchaser = FactoryGirl.create(:purchaser)
        expect(purchaser).to be_valid
    end
end

describe Purchaser do
    it { is_expected.to validate_presence_of(:name) }
end
