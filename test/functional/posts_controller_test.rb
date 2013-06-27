require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :all

  def setup
    @user = users(:one)

    @company = companies(:apple)
    @company2 = companies(:microsoft)

    @post = posts(:two)
    sign_in @user

    Post.index_name('test_' + Post.model_name.plural)
    Post.index.delete
    Post.create_elasticsearch_index

    @leader = posts(:leader)
    @leader2 = posts(:leader2)
    @leader3 = posts(:leader3)
    @endorsed = posts(:endorsed)

    Post.index.import [@leader, @leader2, @leader3, @endorsed]
    Post.index.refresh

  end 

  def upvote post, user
    user.vote_for post
    post.save
    Post.index.refresh
    sleep 1 
  end

  test "leader rewards" do
    post :vote_up, :post_id => @leader.id
    assert_equal 0, @leader.rewards.count, "doesn't have enough upvotes to lead"
    sign_out @user

    sign_in users(:two)
    post :vote_up, :post_id => @leader.id
    sign_out users(:two)

    sleep 1 # sleeping 
    
    upvote @leader2, users(:two)

    sign_in @user
    post :vote_up, :post_id => @leader2.id  

    sleep 1
  
    upvote @leader3, users(:two) 
    post :vote_up, :post_id => @leader3.id
    assert_equal 0, @leader3.rewards.count, "Leader3 shouldn't win this award. He has the same number of votes as a previous winner but post was created later"
    sign_out @user

    sign_in users(:commenter)
    post :vote_up, :post_id => @leader3.id 
    assert_equal 0, @leader2.rewards.count, "Leader2 should lose their award. They were overtaken by leader3 and they got their qualifying upvote last"
  end

  test "upvote rewards" do
    @post.user = @user
    @post.save

    response = post :vote_up, :post_id => @post.id
    sign_out @user

    sign_in users(:two)
    response = post :vote_up, :post_id => @post.id

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

    p = Post.find(@post.id)

    assert p.banned_companies.select { |company| company.id == @company.id }, "Company not found in banned_companies"

    c = Company.find(@company.id)

    assert c.posts.empty?
  end

  test "endorses post" do
    sign_in @company2
    post :endorse, {'id' => @endorsed.id} 

    post :endorse, {'id' => @endorsed.id}
    assert_equal false, Post.find(@endorsed).endorsed, "wasn't un-endorsed"
    assert_equal 0, @endorsed.rewards.count, "post didn't lose endorsement award"    
  end
end
