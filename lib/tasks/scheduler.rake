desc "This task is called by the Heroku scheduler add-on"
task :update_feeds => :environment do
    puts "Updating feeds...\n"
    Feed.all.each do |f|
      f.update_attribute 'feed_data', Feedzirra::Feed.fetch_and_parse(f.feed_url)
      puts "updated blog id: #{f.id} title: #{f.title}"
    end
    puts "\ndone."
end