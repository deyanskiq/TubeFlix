class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.bigint :user_id
      t.bigint :upload_id

      t.timestamps
    end
  end
end
