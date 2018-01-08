require 'rails_helper'

RSpec.describe 'POST /api/index.json', type: :request do
  let(:request_url) { '/api/index.json' }
  before do
    allow_any_instance_of(ZaimApi).to receive(:set_access_token).and_return(true)
  end

  describe '正常系' do
    let(:params) { { result: { parameters:{ uid: 'てすと', password: '1111' } } } }

    before do
      create(:user, uid: 'てすと', password: '1111')
      allow_any_instance_of(ZaimApi).to receive(:home_money).and_return({'money' => [{'amount' => 100}, {'amount' => 200}]})
    end

    it '値が取得できる' do
      post request_url, params: params
      expect(response.status).to eq 200
      json = JSON.parse(response.body)
      expect(json['speech']).to eq '昨日は300円使いました'
      expect(json['displayText']).to eq '昨日は300円使いました'
    end
  end

  describe '異常系' do
    before do
      create(:user, uid: 'てすと', password: '1111')
    end

    it 'パラメータが不適当な場合はエラーメッセージが返る' do
      params = {}
      post request_url, params: params
      expect(response.status).to eq 200
      json = JSON.parse(response.body)
      expect(json['speech']).to eq 'ログインに失敗しました'
      expect(json['displayText']).to eq 'ログインに失敗しました'

      params = { result: { parameters:{ password: '1111' } } }
      post request_url, params: params
      expect(response.status).to eq 200
      json = JSON.parse(response.body)
      expect(json['speech']).to eq 'ログインに失敗しました'
      expect(json['displayText']).to eq 'ログインに失敗しました'
    end

    it '存在しないユーザーのパラメータだった場合エラーメッセージが返る' do
      params = { result: { parameters:{ uid: 'ほげほげ', password: '1111' } } }
      post request_url, params: params
      expect(response.status).to eq 200
      json = JSON.parse(response.body)
      expect(json['speech']).to eq 'ユーザーが見つかりませんでした'
      expect(json['displayText']).to eq 'ユーザーが見つかりませんでした'
    end

    it 'APIの返却値が空だった場合、値がないメッセージが返る' do
      allow_any_instance_of(ZaimApi).to receive(:home_money).and_return({})
      params = { result: { parameters:{ uid: 'てすと', password: '1111' } } }
      post request_url, params: params
      expect(response.status).to eq 200
      json = JSON.parse(response.body)
      expect(json['speech']).to eq '結果が取得できませんでした'
      expect(json['displayText']).to eq '結果が取得できませんでした'
    end
  end
end