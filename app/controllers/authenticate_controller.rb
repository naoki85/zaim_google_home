class AuthenticateController < ApplicationController
  CALLBACK_URL = if Rails.env.production?
                   'https://zaim-google-home.herokuapp.com/callback'.freeze
                 else
                   'http://localhost:3000/callback'.freeze
                 end
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

      oauth_verifier = params[:oauth_verifier]
      access_token = my_oauth.request_token.get_access_token(:oauth_verifier => oauth_verifier)
      session[:access_token] = access_token.token
      session[:access_secret] = access_token.secret

      @user = User.new
      @user.request_token = session[:request_token]
      @user.request_token_secret = session[:request_secret]
      @user.access_token = session[:access_token]
      @user.access_token_secret = session[:access_secret]
      @user.save!
    else
      redirect_to root_path, alert: '不正な画面遷移です'
    end
  end

  def complete
    redirect_to root_path, alert: '不正な画面遷移です' if invalid_session?
    @user = User.find_by!(request_token: session[:request_token],
                          request_token_secret: session[:request_secret],
                          access_token: session[:access_token],
                          access_token_secret: session[:access_secret])
    if @user.update(user_params)
      reset_session
      render :complete
    else
      render :callback
    end
  end

  private

  def user_params
    params.require(:user).permit(:uid, :password)
  end

  def invalid_session?
    !session[:request_token] || !session[:request_secret] || !session[:access_token] || !session[:access_secret]
  end
end
