class Upload < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments
  
  validates :video, presence: true
  has_attached_file :video, :styles => {
    :medium => { :geometry => "200x200!", :format => 'mp4' },
    :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
}, :processors => [:transcoder]
#:processors => [:ffmpeg]
 # validates :video, attachment_presence: true
 # validates_with AttachmentPresenceValidator, attributes: :video
 # validates_with AttachmentSizeValidator, attributes: :video, less_than: 800.megabytes

  # Validate content type
  #validates_attachment_content_type :video, content_type: /\video/
  # Validate filename
  #validates_attachment_file_name :video, matches: [/flv\z/, /mp4?g\z/]
  # Explicitly do not validate
  do_not_validate_attachment_file_type :video

  #has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  #validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
end
