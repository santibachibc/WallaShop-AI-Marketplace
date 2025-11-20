Rails.application.routes.draw do
  root 'anuncios#index'  # Página de inicio por defecto, puede ser otra

  resources :usuarios do
    resources :anuncios
  end
  
  # Rutas para registro y autenticación
  get '/anuncios', to: 'anuncios#index'
  get '/registro', to: 'usuarios#new', as: 'registro'  # Página de registro
  post '/registro', to: 'usuarios#create'  # Acción de registro
  get '/login', to: 'sessions#new', as: 'login'  # Página de inicio de sesión
  post '/login', to: 'sessions#create'  # Acción de inicio de sesión
  get '/logout', to: 'sessions#destroy', as: 'logout'

  # Ruta catch-all para redirigir a la ruta raíz
  #get '*path', to: redirect('/')
end
