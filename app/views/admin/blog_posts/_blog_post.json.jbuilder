json.extract! blog_post, :id, :title, :description, :status, :created_at, :updated_at, :elements
json.url blog_post_url(blog_post, format: :json)
