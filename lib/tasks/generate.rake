require 'rake'

namespace :generate do

  desc 'Load a variable number of posts for either a specific user or random ones'
  task :posts => :environment do
    uid = ENV['uid']
    cid = ENV['cid']
    n_posts = ENV['n'].to_i

    Post.index_name(Post.model_name.plural)
    Post.index.delete
    Post.create_elasticsearch_index

    users = Array(uid ? User.find(uid) : User.limit(10))
    companies = Array(cid ? Company.find(cid) : Company.limit(10))

    (0..n_posts).each do
      p = Post.create({
        :title => /[:word:]-[:word:]-\d{1,5}/.gen.titlecase,
        :content => /[:sentence:]. [:sentence:]./.gen
      })
      p.user = users[rand(0..users.length - 1)]
      p.company = companies[rand(0..companies.length - 1)]

      p.save
      p.user.save
      p.company.save
    end

    Post.index.refresh
  end

end



