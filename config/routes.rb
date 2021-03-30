Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/signup', to: 'users#signup'
      post '/signin', to: 'users#signin'
      get  '/signedin', to: 'users#signedin'
    end
  end
end
