# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
feed = Feedzirra::Feed.fetch_and_parse("chrisburnor.com/posts.rss")
Feed.create(feed_url: feed.feed_url, title: feed.title, author: feed.entries.first.author)