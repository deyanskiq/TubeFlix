class RenameAttribute < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :owner_id, :bigint

  end
end
