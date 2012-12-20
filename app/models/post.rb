class Post < ActiveRecord::Base
  attr_accessible :author, :content, :feed_id, :rank, :summary, :title, :published_at, :guid, :url
  
  belongs_to :feed
  #has_many :votes, as: :votable, dependent: :destroy
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :supercategories
  
  default_scope order('published_at desc')
  
  serialize :summary
  serialize :content
  
  def self.parse_from_feed(feed_id)
    feed = Feed.find(feed_id)
    Feedzirra::Feed.fetch_and_parse(feed.feed_url).entries.each do |entry|
      unless exists? guid: entry.id
        
        p = create!(
          title: entry.title,
          summary: entry.summary,
          content: entry.content,
          author: entry.author,
          feed_id: feed_id,
          published_at: entry.published,
          url: entry.url,
          guid: entry.id
        )
        p.supercategories = feed.supercategories
        entry.categories.each do |cat|
          if(cat = Category.parse(cat, feed.supercategories))
            p.categories << cat
          end
        end
      end
    end
  end
  
  # Return posts associated with specified feed, page is 0-based
  def self.load_entries_from_feed(feed_id, page = -1)
    if(page < 0)
      self.find_all_by_feed_id(feed_id)
    else
      self.find_all_by_feed_id(feed_id)[page*5..(page+1)*5-1]
    end
  end
  
=begin
  #deprecated, feed_data is no longer stored in feeds table.
  def self.update_from_feed(feed_id)
    #The following line is here because I want to move away from storing bulky feeds in the Feed model
    #feed = Feedzirra::Feed.fetch_and_parse(Feed.find(feed_id).feed_url)
    feed = Feed.find(feed_id).feed_data
    feed.entries.each do |entry|
      unless exists? guid: entry.id
        create!(
          title: entry.title,
          summary: entry.summary,
          content: entry.content,
          author: entry.author,
          feed_id: feed_id,
          published_at: entry.published,
          guid: entry.id
        )
      end
    end
  end
=end
end
