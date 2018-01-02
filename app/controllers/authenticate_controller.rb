class AuthenticateController < ApplicationController
  CALLBACK_URL = 'http://localhost:3000/callback'.freeze
  def index
  end

  def login
    my_oauth = MyOauth.new
    request_token = my_oauth.consumer.get_request_token(oauth_callback: CALLBACK_URL)
    session[:request_token] = request_token.token
    session[:request_secret] = request_token.secret
    redirect_to request_token.authorize_url(oauth_callback: CALLBACK_URL)
  end

  def callback
    if session[:request_token] && params[:oauth_verifier]
      my_oauth = MyOauth.new
      my_oauth.set_request_token(session[:request_token], session[:request_secret])
      p my_oauth

      oauth_verifier = params[:oauth_verifier]
      access_token = my_oauth.request_token.get_access_token(:oauth_verifier => oauth_verifier)
      p access_token
      session[:access_token] = access_token.token
      session[:access_secret] = access_token.secret

      user = User.new
      user.encrypt_zaim_request_token = session[:request_token]
      user.encrypt_zaim_request_token_secret = session[:request_secret]
      user.encrypt_zaim_access_token = session[:access_token]
      user.encrypt_zaim_access_token_secret = session[:access_secret]
      user.save
    end
    redirect_to complete_path
  end

  def complete

  end
end
