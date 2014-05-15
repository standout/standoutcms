StandoutCms::Application.routes.draw do
 # mount Ckeditor::Engine => "/ckeditor"
  match 'ckeditor/:action', :controller => 'ckeditor', via: [:get, :post]
  match 'ckeditor/:action/:id', :controller => 'ckeditor', via: [:get, :post]

  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'users#new', :as => :signup
  get 'logout' => 'sessions#destroy', :as => :logout
  get 'login' => 'sessions#new', :as => :login
  get 'admin' => 'sessions#new', :as => :admin
  get 'reset/:id/:code' => 'users#password_reset'
  post 'send_reset_link' => "users#send_password_reset", :as => :send_password_reset
  get "/delayed_job" => DelayedJobWeb, :anchor => false

  scope module: :api do
    namespace :v1 do
      resources :custom_data_lists, only: [] do
        resources :custom_data_rows, only: [:index, :show]
      end
      get 'themes' => "themes#index"
      resources :themes

      resources :websites, only: [] do
        resources :product_categories, only: :index
        resources :carts, only: [:create]
        resources :orders, only: [:create]
        resources :products, only: [:index]
      end

      resources :product_categories, only: [:show] do
        member do
          get :parent
          get :children
        end

        resources :products, only: [:index]
      end

      resources :products, only: [:show] do
        resources :product_variants, only: [:index]
      end

      resources :product_variants, only: [:show]

      resources :carts, only: [:show, :update] do
        member do
          get :empty
        end

        resources :cart_items, only: [:index, :create]
      end

      resources :cart_items, only: [:update, :destroy]

      # JSONP fallbacks
      post 'websites/:website_id/carts/create'  => 'carts#create'
      post 'websites/:website_id/orders/create' => 'orders#create'
      put 'carts/:id/update'                   => 'carts#update'
      post 'carts/:cart_id/cart_items/create'   => 'cart_items#create'
      put 'cart_items/:id/update'              => 'cart_items#update'
      post 'cart_items/:id/destroy'             => 'cart_items#destroy'
    end
  end

  constraints(UserDomain) do
    resources :content_items, only: :show

    # First page of app
    get '/' => 'websites#show'

    # Search results
    match "search" => "search#index", via: [:get, :post]
    get "checkout" => "orders#new"
    post "checkout" => "orders#create"
    get "checkout/paypal_notification" => 'orders#paypal_notification', :as => :paypal_notification
    get "thank_you" => "orders#thank_you"
    post "dibs/accept"
    post "dibs/cancel"
    post "dibs/callback/:id/:token" => "dibs#callback", as: :dibs_callback

    # Administration
    namespace :admin do
      resources :blog_categories
      resources :custom_data_lists do
        resources :custom_data_fields
        resources :custom_data_rows do
          resources :attachment_files
        end
      end
      resources :content_items
      post 'content_items/order'
      resources :custom_data_rows
      resources :looks do
        resources :look_files
        resources :page_templates
      end
      resources :galleries
      resources :gallery_photos
      resources :orders do
        resources :payments
      end
      resources :customers
      resources :pages do
        collection do
          post :order
        end
        member do
          get :details
          get :preview
          get :menu_items
        end
        resources :content_items
      end
      resources :pictures
      resources :posts
      resources :products do
        member do
          post :duplicate
        end
        resources :product_images do
          collection do
            post :order
          end
        end
        resources :product_relations
        resources :product_variants
      end
      resources :csv_imports
      resources :product_categories do
        resources :product_images do
          collection do
            post :order
          end
        end
        resources :attachment_files, only: [:create, :destroy]
      end
      resources :files
      resources :releases
      resources :vendors
      resources :shipping_costs, except: :show
      resources :product_property_keys, except: [:index, :show]
      resources :websites, :only => [:edit, :update] do
        get :edit_webshop, on: :member
        resources :attachment_files
        resources :pictures
      end
      resources :website_memberships
    end

    # TODO: most of the ones below should probably be moved into admin namespace
    resources :sessions
    resources :url_pointers
    resources :allowed_pages
    resources :users
    resources :website_memberships
    resources :languages
    get '/websites/:website_id/pages/:div_id/menu_items/' => 'pages#menu_items'
    get '/sign_out' => 'users#logout', :as => :sign_out
    resources :extra_views do

      member do
    post :choose
    end

    end

    resources :extras do

      member do
    get :settings
    end

    end

    resources :blog_settings
    resources :posts
    resources :servers do

      member do
        get :sync
        get :force_sync
        get :reverse_sync_of_files
    end

    end

    resources :users do
      collection do
        post :login
        get :logout
        post :send_reset_email
      end



    resources :domains
    resources :look_files

    resources :pages do
      collection do
    post :order
    end
      member do
    get :details
    end

    end

    # "/websites/57/pages/1216/content_items/before_submenu"
    resources :websites do
      member do
        get :support
      end
    end

    resources :pages do
        resources :content_items
        collection do
          post :order
        end
        member do
          get :details
          get :preview
        end
      end

      resources :product_categories
      resources :addresses
      resources :extras do

      member do
        post :install
      end

      end

      resources :blog_settings
      resources :posts



      end

    resources :menu

    # Shopping cart
    post 'cart/add' => "cart#add"
    post 'cart/empty' => "cart#destroy"
    post 'cart/update' => "cart#update"
    get 'cart' => "cart#show"

    # Other
    match '*path' => 'pages#show', via: [:get, :post]
    get '*path.jpg' => 'application#image_rescue'
    get '*path.png' => 'application#image_rescue'
    get '*path.gif' => 'application#image_rescue'

    get 'menu/:action' => 'menu#index'

  end

  # Only allow login from the main domain (standoutcms.se)
  constraints(MainDomain) do
    root :to => 'websites#index'
    resources :websites
    resources :sessions
  end

end
