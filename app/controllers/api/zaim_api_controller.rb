class Api::ZaimApiController < ApiApplicationController
  def index
    if invalid_params?
      @message = 'ログインに失敗しました'
    else
      user = User.find_by(uid: params[:uid].downcase, password: params[:password])
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
    !params[:uid] || !params[:password]
  end
end