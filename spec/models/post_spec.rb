require 'spec_helper'

describe Post do
  it "has a valid factory" do
    FactoryGirl.create(:post).should be_valid
  end

  it "is invalid without a title" do
    FactoryGirl.build(:post, title: nil).should_not be_valid
  end

  it "is invalid without a picture" do
    FactoryGirl.build(:post, image: nil).should_not be_valid
  end

  it "is invalid without a company" do
    FactoryGirl.build(:post, company_id: nil).should_not be_valid
  end

  it "is invalid without an author" do
    FactoryGirl.build(:post, user_id: nil).should_not be_valid
  end
end