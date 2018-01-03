# This migration comes from active_storage (originally 20170806125915)
class CreateTableUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :password
      t.string :request_token
      t.string :request_token_secret
      t.string :access_token
      t.string :access_token_secret
      t.timestamps

      t.index [ :uid ], unique: true
    end
  end
end
