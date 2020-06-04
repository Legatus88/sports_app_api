Rails.application.routes.draw do
  namespace :api do
    scope module: :v1 do
      post '/add_achievement', to: 'commands#add_achievement'
      post '/check_achievement', to: 'commands#check_achievement'
      post '/get_top5', to: 'commands#get_top5'
    end
  end
end
