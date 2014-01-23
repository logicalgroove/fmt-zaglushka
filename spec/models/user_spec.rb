require 'spec_helper'

describe User do

  let(:user) {User.new(email: "user@mail.com")}
  subject { user }
  it { should respond_to(:email) }
  it { should be_valid}

  describe "when email is not present" do
    before { user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        user.email = invalid_address
        user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        user.should be_valid
      end
    end
  end

  describe "when user add city" do
    let(:country) { FactoryGirl.create(:country) }
    let(:city) { FactoryGirl.create(:city, country: country) }
    it "create a jpeg" do
      user.cities << city
      user.save_mini_map(city)
      File.exist?("public/world_map_#{user.id.to_s}.jpg").should be_true 
      File.delete("public/world_map_#{user.id.to_s}.jpg")
    end
    it "should contain the right amount of cities and countries" do
      some_city  = FactoryGirl.create(:city, country: country, name: 'Barcelona')
      some_country = FactoryGirl.create(:country, name: 'Cuba')
      some_other_city = FactoryGirl.create(:city, country: some_country, name: 'Matanzas')
      user.cities << city
      user.cities << some_city
      user.cities << some_other_city
      user.save
      user.cities.count.should == 3
      user.countries_count.to_i.should == 2
    end
  end

end
