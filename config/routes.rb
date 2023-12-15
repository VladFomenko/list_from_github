Rails.application.routes.draw do
  root 'graphql#new'

  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?

  get '/graphql', to: 'graphql#execute'
end
