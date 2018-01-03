class Api::ZaimApiController < ApiApplicationController
  def index
    logger.info params
    logger.info params[:result]
    logger.info params[:result][:parameters][:uid]
    if invalid_params?
      @message = 'ログインに失敗しました'
    else
      user = User.find_by(uid: params[:result][:parameters][:uid].downcase, password: params[:result][:parameters][:password])
      if user
        access_token = MyOauth.new.set_access_token(user.access_token, user.access_token_secret)
        zaim_api = ZaimApi.new(access_token)
        options = { start_date: Date.yesterday.strftime('%Y-%m-%d'), end_date: Date.today.strftime('%Y-%m-%d') }
        results = zaim_api.home_money(options)
        sum = 0
        results['money'].each do |money|
          sum += money['amount'].to_i
        end
        @message = "昨日は#{sum}円使いました"
      else
        @message = 'ユーザーが見つかりませんでした'
      end
    end
  end

  private

  def invalid_params?
    !params[:result] || !params[:result][:parameters] ||
        !params[:result][:parameters][:uid] || !params[:result][:parameters][:password]
  end
end