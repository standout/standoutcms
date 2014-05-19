class UrlPointersController < ApplicationController
  # GET /url_pointers
  # GET /url_pointers.xml
  def index
    @url_pointers = UrlPointer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @url_pointers }
    end
  end

  # GET /url_pointers/1
  # GET /url_pointers/1.xml
  def show
    @url_pointer = UrlPointer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @url_pointer }
    end
  end

  # GET /url_pointers/new
  # GET /url_pointers/new.xml
  def new
    @url_pointer = UrlPointer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @url_pointer }
    end
  end

  # GET /url_pointers/1/edit
  def edit
    @url_pointer = UrlPointer.find(params[:id])
  end

  # POST /url_pointers
  # POST /url_pointers.xml
  def create
    @url_pointer = UrlPointer.new(url_pointer_params)

    respond_to do |format|
      if @url_pointer.save
        format.html { redirect_to(@url_pointer, :notice => 'UrlPointer was successfully created.') }
        format.xml  { render :xml => @url_pointer, :status => :created, :location => @url_pointer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @url_pointer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /url_pointers/1
  # PUT /url_pointers/1.xml
  def update
    @url_pointer = UrlPointer.find(params[:id])

    respond_to do |format|
      if @url_pointer.update(url_pointer_params)
        format.html { redirect_to(@url_pointer, :notice => 'UrlPointer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @url_pointer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /url_pointers/1
  # DELETE /url_pointers/1.xml
  def destroy
    @url_pointer = UrlPointer.find(params[:id])
    @url_pointer.destroy

    respond_to do |format|
      format.html { redirect_to(url_pointers_url) }
      format.xml  { head :ok }
    end
  end

  private

  def url_pointer_params
    params.require(:url_pointer).permit %i(
      path
      website_id
      page_id
      language
      custom_data_row_id
      post_id
      product_id
      product_category_id
      vendor_id
    )
  end
end
