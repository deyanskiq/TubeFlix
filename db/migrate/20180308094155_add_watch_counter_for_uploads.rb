class AddWatchCounterForUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :hit_counter, :bigint

  end
end
