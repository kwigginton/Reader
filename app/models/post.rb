class Post < ActiveRecord::Base
  attr_accessible :author, :content, :feed_id, :rank, :summary, :title, :published_at, :guid, :url
  
  belongs_to :feed
  has_many :votes, as: :votable, dependent: :destroy
  has_and_belongs_to_many :categories
  
  default_scope order('published_at desc')
  
  serialize :summary
  serialize :content
  
  def self.parse_from_feed(feed_id)
    Feedzirra::Feed.fetch_and_parse(Feed.find(feed_id).feed_url).entries.each do |entry|
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
        entry.categories.each do |cat|
          if(cat = Category.parse(cat))
            p.categories << cat
          end
        end
      end
    end
  end
  
  # Return posts associated with specified feed, count is 1-based
  def self.load_entries_from_feed(feed_id, count = 0)
    if(count < 1)
      self.find_all_by_feed_id(feed_id)
    else
      self.find_all_by_feed_id(feed_id)[0..count-1]
    end
  end
  
=begin
  #deprecated, feed_data is no longer stored in feeds.
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
