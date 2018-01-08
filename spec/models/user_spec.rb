require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'Validation' do
    context '#uid' do
      it 'ひらがなのみ保存可能であること' do
        user = build(:user, uid: 'ひらがな')
        expect(user.valid?).to eq true

        user.uid = 'aaaa'
        expect(user.valid?).to eq false

        user.uid = 'ひらがなaaa'
        expect(user.valid?).to eq false
      end
    end

    context '#password' do
      it '数字のみ保存可能であること' do
        user = build(:user, uid: 'てすと')
        user.password = '11111'
        expect(user.valid?).to eq true

        user.password = 'aaabbbb'
        expect(user.valid?).to eq false

        user.password = 'aaa222'
        expect(user.valid?).to eq false
      end
    end
  end
end