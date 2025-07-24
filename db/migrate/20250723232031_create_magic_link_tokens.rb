class CreateMagicLinkTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :magic_link_tokens do |t|
      t.string :email
      t.string :token
      t.datetime :expires_at
      t.boolean :used

      t.timestamps
    end
  end
end
