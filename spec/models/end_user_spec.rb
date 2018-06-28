require 'rails_helper'

RSpec.describe EndUser, type: :model do
    it "has a valid factory" do
        end_user = FactoryGirl.create(:end_user)
        expect(end_user).to be_valid
    end
end

describe EndUser do
    it { is_expected.to validate_presence_of(:name) }
end
