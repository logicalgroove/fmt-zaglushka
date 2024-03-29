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
      user.create_image_world_map
      user.cities << city
      user.add_city_to_image_world_map(city)
      File.exist?("public/maps/world_map_#{user.id.to_s}.jpg").should be_true
      File.exist?("public/maps/instagram_map_#{user.id.to_s}.jpg").should be_true
      File.delete("public/maps/world_map_#{user.id.to_s}.jpg")
      File.delete("public/maps/instagram_map_#{user.id.to_s}.jpg")
    end
    it "should contain the right amount of cities and countries" do
      some_city  = FactoryGirl.create(:city, country: country, name: 'Barcelona')
      some_country = FactoryGirl.create(:country, name: 'Cuba')
      some_other_city = FactoryGirl.create(:city, country: some_country, name: 'Matanzas')
      user.cities << city
      user.cities << some_city
      user.cities << some_other_city
      user.countries << country
      user.countries << some_country
      user.save
      user.cities.count.should == 3
      user.countries_count.to_i.should == 2
    end
  end

  describe "when user delete city" do
    let(:country) { FactoryGirl.create(:country) }
    let(:city) { FactoryGirl.create(:city, country: country) }

    context 'with one country' do
      it "should contain the right amount of cities and countries after delete" do
        user.cities << city
        user.countries << country
        user.save
        user.delete_city(city)
        user.cities.count.should == 0
        user.countries.count.should == 0
      end
    end

    context 'with many countries' do
      it "should contain the right amount of cities and countries after delete" do
        some_city  = FactoryGirl.create(:city, country: country, name: 'Barcelona')
        some_country = FactoryGirl.create(:country, name: 'Cuba')
        some_other_city = FactoryGirl.create(:city, country: some_country, name: 'Matanzas')
        some_other_city_same_country = FactoryGirl.create(:city, country: some_country, name: 'Varadero')
        user.cities << city
        user.cities << some_city
        user.cities << some_other_city
        user.cities << some_other_city_same_country
        user.countries << country
        user.countries << some_country
        user.save
        user.delete_city(some_other_city)
        user.cities.count.should == 3
        user.countries.count.should == 2
      end
    end
  end

end
