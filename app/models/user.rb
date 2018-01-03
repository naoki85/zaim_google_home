class User < ApplicationRecord
  # TODO: 保存する前にハッシュ化する
  # include Encryptor
  VALID_UID_REGEX = /\A[a-zA-Z]+\z/
  VALID_PASSWORD_REGEX = /\A[0-9]+\z/

  validates :uid, format: { with: VALID_UID_REGEX }, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :password, format: { with: VALID_PASSWORD_REGEX }, allow_nil: true
  before_save :uid_downcase

  private

  def uid_downcase
    unless uid.nil?
      uid.downcase!
    else
      true
    end
  end
end