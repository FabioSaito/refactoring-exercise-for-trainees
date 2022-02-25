require 'rails_helper'

RSpec.describe OrderInstantiator do

  context "instantiating orders" do
    let(:user) { build_stubbed(:user) }

    let!(:address_params) do {
      address_1: "Test Address 1",
      address_2: "Test Address 2",
      city: "Test City",
      state: "Test State",
      country: "Test Country",
      zip: "0000-000",
    }
    end

    subject!(:order) {
      Order.new(
        user: user,
        first_name: user.first_name,
        last_name: user.last_name,
        address_1: address_params[:address_1],
        address_2: address_params[:address_2],
        city: address_params[:city],
        state: address_params[:state],
        country: address_params[:country],
        zip: address_params[:zip],
      )
    }
    
    it "return expected order" do
      order = OrderInstantiator.new(user, address_params).call
      expect(order).to have_attributes(subject.attributes)
    end
  end
end
