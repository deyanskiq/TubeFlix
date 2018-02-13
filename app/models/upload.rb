class Upload < ApplicationRecord
  belongs_to :user
  has_many :comments
  
  #validates :title, presence: true
  #has_attached_file :avatar, :styles => {
   # :medium => { :geometry => "640x480", :format => 'flv' },
   # :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
  #}, :processors => [:transcoder]

end
