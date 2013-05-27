require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :all

  def setup
    @user = users(:one)
    @company = companies(:apple)
    @post = posts(:two)
    sign_in @user
  end

  test "upvote rewards" do
    @post.user = @user
    @post.save

    response = post :vote_up, :post_id => @post.id
    sign_out @user

    sign_in users(:two)
    response = post :vote_up, :post_id => @post.id
    assert_equal @post.rewards.count, 1, "Post wasn't assigned a reward"
    assert_equal @post.user.rewards.count, 1, "User wasn't assigned a reward"

    assert_equal @post.rewards[0].quantity, 0, "Reward quantity not updated"
    assert_equal @post.plusminus, @post.rewards[0].min_votes, "Post doesn't have enough votes to win this award"

    response = post :vote_up, :post_id => posts(:one).id
    assert_equal posts(:one).rewards.count, 0, "Post shoudn't be allowed to win any award as it doesn't have enough upvotes to qualify"

    sign_out users(:one)
    sign_in @user
    response = post :vote_up, :post_id => posts(:one).id

    assert_equal posts(:one).rewards.count, 0, "Post shouldn't be able to win any awards the quantity of the award is at 0"

  end

  test "uploads image as post" do
    image = ActionDispatch::Http::UploadedFile.new({
      :filename => 'written.jpg',
      :content_type => 'image/jpeg',
      :tempfile => File.new("#{Rails.root}/test/fixtures/written.jpg")
    })
    post :create, {
      :post => {
        :title => "mytitle",
        :content => "helloworld",
        :company_id => @company.id,
        :image => image
      }
    }


    post_json = JSON.parse(response.body)

    assert_equal post_json["company_id"], @company.id
    assert_equal post_json["title"], "mytitle"
    assert_equal post_json["content"], "helloworld"
    assert_equal post_json["image_file_name"], image.original_filename

  end

  test "untags company from post" do
    sign_in @company

    @company.posts.push(@post)
    @company.campaigns.clear
    @company.save
    @post.save

    assert @post.company

    put :untag, {'id' => @post.id }

    post_json = JSON.parse(response.body)

    assert !post_json["company_id"]
    assert !post_json["campaign_id"]

    p = Post.find(@post.id)

    assert p.banned_companies.select { |company| company.id == @company.id }, "Company not found in banned_companies"

    c = Company.find(@company.id)

    assert c.posts.empty?
  end

end
