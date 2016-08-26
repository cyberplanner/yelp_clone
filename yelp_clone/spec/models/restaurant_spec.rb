require 'spec_helper'
describe Restaurant, type: :model do
  it 'is not valid with a name of less that three characters' do
    restaurant = Restaurant.new(name: 'kf')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    Restaurant.create(name: "Moe's Tavren")
    restaurant = Restaurant.new(name: "Moe's Tavren")
    expect(restaurant).to have(1).error_on(:name)
  end

  it "is should have many reviews" do
    should have_many(:reviews)
  end

  it { should belong_to(:user) }


  it { should have_many(:reviews) }

end
