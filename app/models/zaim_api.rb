require 'json'
require 'oauth'

class ZaimApi
  API_BASE_URL = 'https://api.zaim.net/v2'.freeze

  # @param [Object] oauth_access_token OAuth::AccessToken
  def initialize(oauth_access_token)
    @oauth_by_access_token = oauth_access_token
  end

  # GET /home/money
  # List user input
  # @param  [Hash]
  # @return [JSON]
  def home_money(params)
    money = @oauth_by_access_token.get("#{API_BASE_URL}/home/money#{get_parameters_home_money(params)}")
    JSON.parse(money.body)
  end

  # GET /Category
  # @return [JSON]
  def category
    categories = @oauth_by_access_token.get("#{API_BASE_URL}/category")
    JSON.parse(categories.body)
  end

  def refresh()
    oauth_verifier = params[:oauth_verifier]
    access_token = my_oauth.request_token.get_access_token(:oauth_verifier => oauth_verifier)
    session[:access_token] = access_token.token
    session[:access_secret] = access_token.secret

    user = User.new
    user.encrypt_zaim_request_token = session[:request_token]
    user.encrypt_zaim_request_token_secret = session[:request_secret]
    user.encrypt_zaim_access_token = session[:access_token]
    user.encrypt_zaim_access_token_secret = session[:access_secret]
    user.save
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