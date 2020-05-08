Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :customers, only: %i[create] do
    resources :support_requests, only: %i[index] do
      get "/priorities", to: "support_requests#group_by_priority", on: :collection
    end
  end
  resources :support_agents, only: %i[create index] do
    resources :support_requests, only: %i[index]
  end
  resources :support_requests, only: %i[create show index] do
    resources :comments, only: %i[create index]
    collection do
      get "/export", to: "support_requests#export_as_csv"
      get "/priorities", to: "support_requests#group_by_priority"
    end
    member do
      patch '/assign', to: "admins#assign"
      patch 'resolve', to: "support_requests#resolve"
      # post '/comments', to: "comments#create"
    end
  end
  post "admins/login" => "admin_token#create"
  post "customers/login", to: "customer_token#create"
  post "support_agents/login" => "support_agent_token#create"
end
