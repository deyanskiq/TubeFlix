class Upload < ApplicationRecord

  belongs_to :user
  has_many :comments

  # before_validation(on: [:create, :save]) do
  #   if self.video_processing
  #     Delayed::Worker.new.run(Delayed::Job.last)
  #   end
  #   end

  validates :video, presence: true
  has_attached_file :video, :styles => {
      :medium => {:geometry => "640x480#", :format => 'mp4'}, :thumb => ["300x300#", :jpg]},
                    :processors => [:transcoder],
                    :preview => {
                        :format => :jpg,
                        :geometry => "1200x675#",
                        :convert_options => {
                            :output => {
                                :vframes => 1,
                                :s => "1200x675",
                                :ss => '00:00:02'
                            }
                        }
                    },
                    :thumb => {
                        :format => :jpg,
                        :geometry => "300x169#",
                        :convert_options => {
                            :output => {
                                :vframes => 1,
                                :s => '300x169',
                                :ss => '00:00:02'
                            }
                        }
                    }

  #
  # There are two options for validation:
  # explicitly add validation options and explicitly do not validate
  #
  validates_attachment_size :video, less_than: 1.gigabytes
  validates_attachment_content_type :video, :content_type => ["video/mp4", "video/quicktime", "video/x-flv", "video/x-msvideo", "video/x-ms-wmv", "video/webm"]
  process_in_background :video

  # validates :video, attachment_presence: true
  # validates_with AttachmentPresenceValidator, attributes: :video
  # validates_with AttachmentSizeValidator, attributes: :video, less_than: 800.megabytes

  # Validate content type
  #validates_attachment_content_type :video, content_type: /\video/
  # Validate filename
  #validates_attachment_file_name :video, matches: [/flv\z/, /mp4?g\z/]
  #
  #
  # Explicitly do not validate
  # do_not_validate_attachment_file_type :video

end
