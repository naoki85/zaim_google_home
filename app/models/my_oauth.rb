require 'json'
require 'oauth'

class MyOauth
  CONSUMER_KEY     = '50b7b2fdf0e288825064defa3a4fdd0592a6c153'
  CONSUMER_SECRET  = '12e8c2ffef89fd4fc13d7717edf02de378a09f93'

  attr_accessor :consumer, :request_token

  def initialize
    self.consumer = OAuth::Consumer.new(
        CONSUMER_KEY,
        CONSUMER_SECRET,
        site: 'https://api.zaim.net',
        request_token_path: '/v2/auth/request',
        authorize_url: 'https://auth.zaim.net/users/auth',
        access_token_path: '/v2/auth/access'
    )
  end

  # @param [String] request_token
  # @param [String] request_secret
  def set_request_token(request_token, request_secret)
    self.request_token = OAuth::RequestToken.new(
        self.consumer,
        request_token,
        request_secret
    )
  end

  # @param [Object] consumer
  # @param [String] access_token
  # @param [String] access_token_secret
  def set_access_token(access_token, access_token_secret)
    OAuth::AccessToken.new(
        self.consumer,
        access_token,
        access_token_secret
    )
  end
end