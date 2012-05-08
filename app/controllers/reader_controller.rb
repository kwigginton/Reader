class ReaderController < ApplicationController
  skip_before_filter :authorize_admin, :authorize_reader
  def index
    @feed = Feedzirra::Feed.fetch_and_parse(Feed.random.feed_url)
  end
  
end
