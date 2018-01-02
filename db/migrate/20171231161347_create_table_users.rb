# This migration comes from active_storage (originally 20170806125915)
class CreateTableUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :encrypt_password
      t.string :encrypt_zaim_request_token
      t.string :encrypt_zaim_request_token_secret
      t.string :encrypt_zaim_access_token
      t.string :encrypt_zaim_access_token_secret
      t.timestamps

      t.index [ :uid ], unique: true
    end
  end
end
