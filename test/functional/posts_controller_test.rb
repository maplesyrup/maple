require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  def setup
    @user = users(:one)
  end

#TODO Fix this test!
#  test "uploads image as post" do
#    image = ActionDispatch::Http::UploadedFile.new({
#      :filename => 'written.jpg',
#      :content_type => 'image/jpeg',
#      :tempfile => File.new("#{Rails.root}/test/fixtures/written.jpg")
#    })
#    post :create, {
#      :user_id => @user.id,
#      :image => image
#    }
#  end
end
