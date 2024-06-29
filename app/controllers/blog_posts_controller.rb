# non- Admin controller
class BlogPostsController < ApplicationController
  before_action :set_blog_post, only: %i[ show ] # only is for the before action!!!

  # GET /blog_posts or /blog_posts.json
  def index
    @blog_posts = BlogPost.all
    @categories = Category.all
  end

  # GET /blog_posts/1 or /blog_posts/1.json
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_post
      @blog_post = BlogPost.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_post_params
      params.require(:blog_post)
    end
end
