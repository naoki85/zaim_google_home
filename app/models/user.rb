class User < ApplicationRecord
  # TODO: 保存する前にハッシュ化する
  # include Encryptor
  VALID_UID_REGEX = /\A\p{Hiragana}+\z/
  VALID_PASSWORD_REGEX = /\A[0-9]+\z/

  validates :uid, format: { with: VALID_UID_REGEX }, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :password, format: { with: VALID_PASSWORD_REGEX }, allow_nil: true
end