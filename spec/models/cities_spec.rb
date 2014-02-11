require 'spec_helper'

describe City do
  describe "when user add a city" do
    let(:country) { FactoryGirl.create(:country) }
    let(:city) { FactoryGirl.create(:city, country: country) }
    it "should count properly user percentage" do
    end
  end
end
