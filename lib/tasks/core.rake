require 'rake'

desc "Run docco"
task :docco => :environment do
  system('docco -o doc/models app/models/*.rb')
  system('docco -o doc/controllers app/controllers/*.rb')
  system('docco -o doc/javascript/models app/assets/javascripts/backbone/models/*.coffee')

  dirs = Dir.entries('app/assets/javascripts/backbone/views').select do |entry|
    File.directory?(File.join('app/assets/javascripts/backbone/views', entry)) and
        !(entry =='.' || entry == '..')
  end

  dirs.each do |dir|
    system("docco -o doc/javascript/views app/assets/javascripts/backbone/views/#{dir}/*.coffee")
  end
  system('docco -o doc/javascript app/assets/javascripts/backbone/*.coffee')
end
