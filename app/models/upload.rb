class Upload < ApplicationRecord

  belongs_to :user
  has_many :comments

  before_validation(on: [:create, :save]) do
    if self.video_processing
      Delayed::Worker.new.run(Delayed::Job.last)
    end
  end

  validates :video, attachment_presence: true
  validates :name, presence: true, uniqueness: true, length: {minimum: 2}

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


  # Validate filename
  #validates_attachment_file_name :video, matches: [/flv\z/, /mp4?g\z/]

  # Explicitly do not validate
  # do_not_validate_attachment_file_type :video
  
  def self.scope_admin
    all
  end

  def self.scope_reseller(reseller)
    where(user_id: reseller.subordinates.map(&:id).push(reseller.id))
  end

  def self.scope_user(user)
    reseller = User.find_by(id: user.reseller_id)
    where(user_id: reseller.subordinates.map(&:id).push(reseller.id))
  end

end
