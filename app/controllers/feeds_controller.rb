include ReaderLogic
class FeedsController < ApplicationController
  skip_before_filter :authorize_admin
  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeds }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = Feed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feed }
    end
  end

  # GET /feeds/new
  # GET /feeds/new.json
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feed }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(params[:feed])
    feed = Feedzirra::Feed.fetch_and_parse(@feed.feed_url)
    if(feed && !(feed.is_a? Fixnum))
      @feed.title = feed.title
      @feed.author = feed.entries.first.author
      @feed.feed_url = feed.feed_url
      @feed.feed_data = feed
    end
    respond_to do |format|
      if @feed.save
        session[:random_feeds] << session[:random_current] = @feed.id
        format.html { redirect_to reader_path, notice: 'Feed was successfully created.' }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feeds/1
  # PUT /feeds/1.json
  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    if(session[:read_mode] == :subscription)

      get_next_subscription if(session[:subscription_current] == @feed.id)
      
      session[:subscription_feeds].delete @feed.id
    end
    if(session[:read_mode] == :random)
      
      get_next_random if(session[:random_current] == @feed.id)
        
      session[:random_feeds].delete @feed.id
    end
    respond_to do |format|
      format.html { redirect_to feeds_url }
      format.json { head :no_content }
    end
  end
end
