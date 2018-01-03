class AuthenticateController < ApplicationController
  CALLBACK_URL = if Rails.env.production?
                   'https://zaim-google-home.herokuapp.com/callback'.freeze
                 else
                   'http://localhost:3000/callback'.freeze
                 end
  def index
  end

  def login
    zaim_api = ZaimApi.new
    request_token = zaim_api.consumer.get_request_token(oauth_callback: CALLBACK_URL)
    session[:request_token] = request_token.token
    session[:request_secret] = request_token.secret
    redirect_to request_token.authorize_url(oauth_callback: CALLBACK_URL)
  end

  def callback
    if session[:request_token] && params[:oauth_verifier]
      zaim_api = ZaimApi.new
      zaim_api.set_request_token(session[:request_token], session[:request_secret])
      access_token = zaim_api.request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
      session[:access_token] = access_token.token
      session[:access_secret] = access_token.secret

      @user = User.new(request_token: session[:request_token],
                       request_token_secret: session[:request_secret],
                       access_token: session[:access_token],
                       access_token_secret: session[:access_secret])
      @user.save!
    elsif session[:request_token] && session[:request_secret] && session[:access_token] && session[:access_secret]
      set_user_by_session_params
    else
      reset_session
      redirect_to root_path, alert: '不正な画面遷移です'
    end
  end

  def complete
    redirect_to root_path, alert: '不正な画面遷移です' if invalid_session?
    set_user_by_session_params
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

  def set_user_by_session_params
    @user = User.find_by!(request_token: session[:request_token],
                          request_token_secret: session[:request_secret],
                          access_token: session[:access_token],
                          access_token_secret: session[:access_secret])
  end
end
