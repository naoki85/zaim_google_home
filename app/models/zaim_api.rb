require 'json'
require 'oauth'

class ZaimApi
  API_BASE_URL = 'https://api.zaim.net/v2'.freeze
  CONSUMER_KEY = ENV['CONSUMER_KEY']
  CONSUMER_SECRET = ENV['CONSUMER_SECRET']

  attr_accessor :consumer, :request_token, :access_token

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

  # @param [String] access_token
  # @param [String] access_token_secret
  def set_access_token(access_token, access_token_secret)
    self.access_token = OAuth::AccessToken.new(
        self.consumer,
        access_token,
        access_token_secret
    )
  end

  # GET /home/money
  # List user input
  # @param  [Hash]
  # @return [JSON]
  def home_money(params)
    money = self.access_token.get("#{API_BASE_URL}/home/money#{get_parameters_home_money(params)}")
    JSON.parse(money.body)
  end

  # GET /Category
  # @return [JSON]
  def category
    categories = self.access_token.get("#{API_BASE_URL}/category")
    JSON.parse(categories.body)
  end

  private

  # GET parameters for API /home/money
  # params [Hash] params
  #   mapping: set 1
  #   category_id: narrow down by category_id
  #   genre_id: narrow down by genre_id
  #   mode: narrow down by type (payment or income or transfer)
  #   order: sort by id or date (default : date)
  #   start_date: the first date (Y-m-d format)
  #   end_date: the last date (Y-m-d format)
  #   page: number of current page (default 1)
  #   limit: number of items per page (default 20, max 100)
  #   group_by: if you set as "receipt_id", Zaim makes the response group by the receipt_id (option)
  # @return [String]
  def get_parameters_home_money(params)
    query_params = ''
    query_params << '?mapping=1'

    params.each do |key, param|
      if param.present?
        query_params << "&#{key}=#{param}"
      end
    end
    query_params
  end
end