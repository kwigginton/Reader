class SupercategoriesController < ApplicationController
  skip_before_filter :authorize_admin, :authorize_reader, only: [:show]
  # GET /supercategories
  # GET /supercategories.json
  def index
    @supercategories = Supercategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @supercategories }
    end
  end

  # GET /supercategories/1
  # GET /supercategories/1.json
  def show
    @supercategory = Supercategory.find(params[:id])
    if params[:view] == "feed"
      @feeds = Feed.find(:all, include: :supercategories, conditions: ['supercategories.id in (?)',["#{@supercategory.id}"]])
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @supercategory }
    end
  end

  # GET /supercategories/new
  # GET /supercategories/new.json
  def new
    @supercategory = Supercategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @supercategory }
    end
  end

  # GET /supercategories/1/edit
  def edit
    @supercategory = Supercategory.find(params[:id])
  end

  # POST /supercategories
  # POST /supercategories.json
  def create
    @supercategory = Supercategory.new(params[:supercategory])

    respond_to do |format|
      if @supercategory.save
        format.html { redirect_to @supercategory, notice: 'Supercategory was successfully created.' }
        format.json { render json: @supercategory, status: :created, location: @supercategory }
      else
        format.html { render action: "new" }
        format.json { render json: @supercategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /supercategories/1
  # PUT /supercategories/1.json
  def update
    @supercategory = Supercategory.find(params[:id])

    respond_to do |format|
      if @supercategory.update_attributes(params[:supercategory])
        format.html { redirect_to @supercategory, notice: 'Supercategory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @supercategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supercategories/1
  # DELETE /supercategories/1.json
  def destroy
    @supercategory = Supercategory.find(params[:id])
    @supercategory.destroy

    respond_to do |format|
      format.html { redirect_to supercategories_url }
      format.json { head :no_content }
    end
  end
end
