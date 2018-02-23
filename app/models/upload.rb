class Upload < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :video, presence: true
  has_attached_file :video, :styles => {
      :medium => {:geometry => "640x480#", :format => 'mp4'}, :thumb => ["300x300#", :jpg]},
                    :processors => [:transcoder]

  # validates :video, attachment_presence: true
  # validates_with AttachmentPresenceValidator, attributes: :video
  # validates_with AttachmentSizeValidator, attributes: :video, less_than: 800.megabytes

  # Validate content type
  #validates_attachment_content_type :video, content_type: /\video/
  # Validate filename
  #validates_attachment_file_name :video, matches: [/flv\z/, /mp4?g\z/]
  # Explicitly do not validate
  do_not_validate_attachment_file_type :video

end
