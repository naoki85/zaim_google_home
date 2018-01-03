Rails.application.routes.draw do
  root to: 'authenticate#index'
  get   'login'    => 'authenticate#login'
  get   'callback' => 'authenticate#callback'
  patch 'complete' => 'authenticate#complete'

  namespace :api, format: 'json' do
    post 'index' => 'zaim_api#index'
  end

  # ルーティングエラー
  match '*path' => 'application#render_404', via: :all
end
