def thumbnail_url(post)
  post.image.url(:medium)  
end

def image_url(post)
  post.image.url
end

def profile_image(uid)
  "http://graph.facebook.com/" + uid + "/picture"
end

def time_since(created_at)
  distance_of_time_in_words_to_now(created_at)
end

# Return code for whether user
# has voted on Post
# 0 - Logged in User, has not voted
# 1 - Logged in User, has voted
# 2 - Not logged in user
def user_has_voted(post, user)
  if (user)
    if (post.voted_by?(user))
      1
    else
      0
    end
  else
    2
  end
end

json.array!(@posts) do |post|
  json.id post.id
  
  json.company do
    json.id post.company.id
    json.name post.company.name
  end

  json.content post.content
  json.created_at post.created_at
  json.thumbnail thumbnail_url(post)
  json.image_url image_url(post)
  json.title post.title
  json.total_votes post.votes_for

  json.user do
    json.id post.user.id
    json.name post.user.name
    json.uid post.user.uid
    json.profile_image profile_image(post.user.uid)
  end

  json.time_since time_since(post.created_at)
  json.voted_on user_has_voted(post, post.user)

end