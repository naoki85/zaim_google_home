Rails.application.routes.draw do
  root to: 'authenticate#index'
  get 'login'    => 'authenticate#login'
  get 'callback' => 'authenticate#callback'
  get 'complete' => 'authenticate#complete'

  namespace :api, format: 'json' do
    get 'index' => 'zaim_api#index'
  end
end
