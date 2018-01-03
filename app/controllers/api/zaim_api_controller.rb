class Api::ZaimApiController < ApiApplicationController
  def index
    if invalid_params?
      @message = 'ログインに失敗しました'
    else
      user = User.find_by(uid: params[:result][:parameters][:uid], password: params[:result][:parameters][:password])
      if user
        access_token = MyOauth.new.set_access_token(user.access_token, user.access_token_secret)
        zaim_api = ZaimApi.new(access_token)
        options = { start_date: Date.yesterday.strftime('%Y-%m-%d'), end_date: Date.today.strftime('%Y-%m-%d') }
        results = zaim_api.home_money(options)
        if results.key?('money')
          sum = 0
          results['money'].each do |money|
            sum += money['amount'].to_i
          end
          @message = "昨日は#{sum}円使いました"
        else
          @message = '結果が取得できませんでした'
        end
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