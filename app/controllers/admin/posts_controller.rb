class Admin::PostsController < ApplicationController
  
  before_filter :check_login
  before_filter :load_website
  
  def load_website
    if current_user.admin?
      @website = current_website
    else
      @website = current_user.websites.find(current_website.id)
    end
  end
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = @website.posts    

    respond_to do |format|
      format.html { render :layout => request.xhr? ? false : 'application' } 
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html { render :layout => request.xhr? ? false : 'application' } 
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new(:website_id => @website.id)

    respond_to do |format|
      format.html { render :layout => request.xhr? ? false : 'application' } 
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = @website.posts.find(params[:id])
    respond_to do |format|
      format.html { render :layout => request.xhr? ? false : 'application' } 
      format.xml  { render :xml => @post }
    end
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to [:admin, :posts] }
        format.xml  { render :xml => @post, :status => :created, :location => [@website, @post] }
        format.js { render :text => "Post created." }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = @website.posts.find(params[:id])

    respond_to do |format|
      if @post.update(post_params)
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to [:admin, :posts] }
        format.xml  { head :ok }
        format.js { render :text => "Post updated." }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = @website.posts.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.js { render :text => "The post was removed." }
      format.html { redirect_to [:admin, :posts] }
      format.xml  { head :ok }
    end
  end

  private

  def post_params
    params.require(:post).permit %i(
      title
      blog_category_id
      content
      allow_comments
      language
      slug
    )
  end
end
