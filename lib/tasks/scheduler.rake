desc "This task is called by the Heroku scheduler add-on"
task :update_feeds => :environment do
    puts "Updating feeds...\n"
    Feed.all.each do |f|
      Post.parse_from_feed(f.id)
      puts "updated blog id: #{f.id} title: #{f.title}"
      #Post.update_from_feed(f.id)
      #puts "updated posts from feed id: #{f.id}"
      #TODO set updated flag to notify users of update
    end
    puts "\ndone."
end