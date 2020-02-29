Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :customers, only: %i[create]
  resources :support_agents, only: %i[create]
  post 'admins/login' => 'admin_token#create'
  post 'customers/login', to: 'customer_token#create'
  post 'support_agents/login' => 'support_agent_token#create'
end
