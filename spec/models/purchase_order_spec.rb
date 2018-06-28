require 'rails_helper'

RSpec.describe PurchaseOrder, type: :model do
    it "has a valid factory" do
        purchase_order = FactoryGirl.create(:purchase_order)
        expect(purchase_order).to be_valid
    end
end

describe PurchaseOrder do
    it { is_expected.to validate_presence_of(:po_number) }
    it { is_expected.to validate_presence_of(:so_number) }
    it { is_expected.to validate_presence_of(:date_order) }
end
