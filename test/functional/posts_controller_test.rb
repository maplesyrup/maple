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
  
end
