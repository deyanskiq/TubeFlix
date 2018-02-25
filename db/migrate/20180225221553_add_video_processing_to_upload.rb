class AddVideoProcessingToUpload < ActiveRecord::Migration[5.1]
  def self.up
    add_column :uploads, :video_processing, :boolean
  end

  def self.down
    remove_column :uploads, :video_processing
  end
end
