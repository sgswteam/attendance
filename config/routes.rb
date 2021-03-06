Rails.application.routes.draw do
  resources :themes do
    put :update_theme
  end
  get 'users/index'
  resources :courses
  devise_for :users, :controllers => { :registrations => "registrations" }, :path_prefix => 'd'
  resources :students do
    post :print_selected, :on => :collection
    get :course_data
  end
  root 'students#index'
  match '/users',   to: 'users#index',   via: 'get'
  resources :users
  resources :student_imports

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
