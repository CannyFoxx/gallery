class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authenticate_admin!, except: [:index, :show, :map]

  # GET /posts
  def index
    @title = "Gallery - Los Angeles"

    @posts = Post.order(date: :desc).where(hidden: admin_signed_in? ? [true, false] : false ).page(params[:page]).per(30)
    @post = Post.new
  end

  # GET /map
  def map
    @title = "Map - Los Angeles"

    @posts = Post.order(date: :desc).where(gps: true, hidden: admin_signed_in? ? [true, false] : false)
    @hash = Gmaps4rails.build_markers(@posts) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow "<center><p><a href=\"#{post_url(post)}\"><img src=\"#{post.media.url(:thumb)}\" class=\"img-thumbnail\"></a></p><p><b><em>#{post.address}</em><b></p></center>"
    end
  end

  # GET /:id
  def show
    @title = "Record #{@post.date.strftime("%d.%m.%Y")} - Los Angeles"
  end

  # POST /new
  def create
    post_params[:media].each do |m| # Media Array
      mn = "tmp/files/#{Random.rand(9000000000)}_#{m.original_filename}"
      FileUtils.cp(m.tempfile, mn)
      ImageWorkerJob.perform_later(mn)
    end

    redirect_to root_path, notice: "#{post_params[:media].count} files added it queue for convertion!"
  end

  # PATCH /posts/1
  def update
    @post.update(post_params)
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    def set_post
      @post = Post.where(hidden: admin_signed_in? ? [true, false] : false).find(params[:id])
    end

    def post_params
      params.require(:post).permit(:hidden, media: [])
    end
end
