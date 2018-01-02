class Api::ZaimApiController < ApiApplicationController
  def index
    user = User.last
    access_token = MyOauth.new.set_access_token(user.encrypt_zaim_access_token, user.encrypt_zaim_access_token_secret)
    zaim_api = ZaimApi.new(access_token)
    options = { start_date: Date.yesterday.strftime('%Y-%m-%d'), end_date: Date.today.strftime('%Y-%m-%d') }
    results = zaim_api.home_money(options)
    # results = Rails.cache.fetch("zaim_api/home/money/#{user.id}", expired_in: 1.hour) do
    #   zaim_api.home_money(options)
    # end
    sum = 0
    results['money'].each do |money|
      sum += money['amount'].to_i
    end
    @message = "昨日は#{sum}円使いました"
  end
end