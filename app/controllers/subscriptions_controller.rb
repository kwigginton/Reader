class SubscriptionsController < ApplicationController
  skip_before_filter :authorize_admin
  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def new
     @subscription = Subscription.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @subscription }
      end
  end

  # GET /subscriptions/1/edit
  def edit
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    feed_url = params[:feed_url]
    feed = Feed.find_by_feed_url(feed_url)
    @subscription = Subscription.new
    @subscription.user = current_user
    @subscription.feed = feed
    if @subscription.save
      redirect_to reader_url, notice: "You are now subscribed to: "+feed.title
    else
      # TODO
      # This should definitely be redone to properly handle errors
      notice = @subscription.errors.full_messages.first.to_s
puts notice
      redirect_to reader_url, notice: notice
      
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to subscriptions_url }
      format.json { head :no_content }
    end
  end
end
