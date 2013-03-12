def profile_image(post)
  if post.user
    if post.user.uid
      "http://graph.facebook.com/" + post.user.uid + "/picture"
    else
      post.user.avatar.url(:thumb)
    end
  else
    nil
  end
end

def time_since(created_at)
  distance_of_time_in_words_to_now(created_at)
end

# Return code for whether user
# has voted on Post
# 0 - Logged in User, has not voted
# 1 - Logged in User, has voted
# 2 - Not logged in user
def user_has_voted(post)
  if (current_user)
    if (post.voted_by?(current_user))
      1
    else
      0
    end
  else
    2
  end
end

def check_for_nil(parent, val)
  if parent.nil?
    nil
  else
    val
  end
end

json.array!(@posts) do |post|
  json.id post.id

  json.company do
    json.id check_for_nil(post.company, post.company.id)
    json.name check_for_nil(post.company, post.company.name)
  end

  json.content post.content
  json.created_at post.created_at
  json.thumbnail post.image.url(:thumb)
  json.image_url post.image.url(:medium)
  json.full_image_url post.image.url
  json.title post.title
  json.total_votes post.votes_for

  json.user do
    json.id check_for_nil(post.user, post.user.id)
    json.name check_for_nil(post.user, post.user.name)
    json.uid check_for_nil(post.user, post.user.uid)
    json.profile_image profile_image(post)
  end

  json.time_since time_since(post.created_at)
  json.voted_on user_has_voted(post)

end
