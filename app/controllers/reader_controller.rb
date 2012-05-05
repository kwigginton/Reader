class ReaderController < ApplicationController
  skip_before_filter :authorize_admin
  def index
    @feed = Feedzirra::Feed.fetch_and_parse("chrisburnor.com/posts.rss")
    @entries = @feed.entries
  end
  
end
