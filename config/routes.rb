Randomjunk::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  root :to => 'stuffs#index'

  get '/minesweeper' => 'stuffs#minesweeper'
  get '/scattergories' => 'stuffs#scattergories'
  get '/whatis' => 'stuffs#whatis'
  post '/notes/update_positions' => 'notes#update_positions'
  get '/cards_against/single' => 'cards#single'
  # get '/cards_against/single/get_cards' => 'cards#get_cards'

  get '/thoughts/get_all' => 'thoughts#get_all'
  get '/thoughts/supersecretthoughtroute' => 'thoughts#secret_page'
  post '/thoughts/approve/:id' => 'thoughts#approve_thought'

  get '/thoughts/comments/get_comments_for/:id' => 'comments#get_comments_for'

  get '/records/query_records' => 'minesweeper_records#query_records'

  resources :notes
  resources :thoughts
  resources :comments
  resources :minesweeper_records

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
