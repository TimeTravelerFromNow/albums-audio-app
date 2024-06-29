

class ActionDispatch::Routing::Mapper

  def draw(resource)
    resources resource, only: [:show, :index]
  end
  # writing an "except: :new syntax" like draw(resource) doesnt really work,
  # I had to write it out in module admin scope
end

Rails.application.routes.draw do

  resources :albums, only: [:show, :index], param: :name do
    draw :musics

    draw :elements
  end

  draw :blog_posts do
    draw :elements
  end

  draw :categories do
    draw :blog_posts
  end

  scope module: "admin" do
    resources :albums, except: :new, param: :name do
      resources :musics do
        get 'swap_up', :on => :member
        get 'swap_down', :on => :member
      end
      resources :elements
    end
    # prefixed with "admin/" to stop the albums/new albums/:id conflict.
    get 'admin/albums/new' => 'albums#new', as: :new_album

    resources :blog_posts, except: :new do
      resources :elements do
        get 'swap_up', :on => :member
        get 'swap_down', :on => :member
      end
    end
    # same comment as for albums
    get 'admin/blog_posts/new' => 'blog_posts#new', as: :new_blog_post

    resources :categories, except: :new do
      resources :blog_posts
    end
    get 'admin/categories/new' => 'categories#new', as: :new_category

    get 'dashboard/index'

    get 'musics/index' => 'musics#index', as: :musics_index
    get 'albums/:id/edit' => 'albums#edit', as: :album_edit
  end # admin

  get 'home_page/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home_page#index"
end
