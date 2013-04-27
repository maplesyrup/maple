require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "verify basic commenting" do
    assert_equal users(:commenter).comments.length, 2, "User doesn't have the correct number of comments"


    assert_equal comments(:one).comments.length, 1, "Comment doesn't have the correct number of nested comments"
    assert_equal posts(:commentable).comments.length, 1, "Post doesn't have the correct number of comments" 
    
    users(:commenter).comments.each do |comment|
      assert_equal comment.commenter_id, users(:commenter).id, "wrong user"
    end

    assert_equal comments(:one).comments[0].commenter_id, users(:commenter).id
    assert_equal posts(:commentable).comments[0].commenter_id, users(:commenter).id 
  end 
  
  test "validations" do
    test = users(:one).comments.new(:content => "Hello, world", :commentable_type => 'Post')
    assert !test.save, "Able to save a comment without commentable_id"

    test = users(:one).comments.new(:content => "Hello, world", :commentable_id => 1)
    assert !test.save, "Able to save a comment without commentable_type"

    test = users(:one).comments.new(:commentable_type => 'Post', :commentable_id => 1)
    assert !test.save, "Able to save a comment without content"
  end
end
