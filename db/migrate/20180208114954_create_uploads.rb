class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.string :name
      t.string :path
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
