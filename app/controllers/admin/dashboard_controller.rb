module Admin
class DashboardController < AdminController
  def index
    @categories = Category.all
    @albums = Album.all
    @blog_posts = BlogPost.all
    @musics = Music.all
  end
end
end #module Admin
