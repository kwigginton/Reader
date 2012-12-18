desc "Reloads supercategories from posts into themselves and their respective feeds"
task :reload_supercategories => :environment do
    puts "reloading all supercategories from posts...\n"

    puts "1 - reassigning posts and categories to the parent feed's supercategories"
    cn = pn = 0
    Post.all.each do |p|
      p.categories.each do |c|
         c.supercategories = Feed.find(p.feed_id).supercategories
         cn += 1
      end
      p.supercategories = Feed.find(p.feed_id).supercategories
      pn += 1
    end
    puts "#{cn} categories and #{pn} posts reassigned"
    
    
    
    puts "\ndone."
end