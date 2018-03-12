class Upload < ApplicationRecord

  belongs_to :user
  has_many :comments, dependent: :destroy

  # Unless we do not use delegate option we access name of the upload owner this way: upload.user.name
  # This exposes the user object even if we don't really need it, so we could do the following:
  delegate :name, to: :user, prefix: true

  before_validation(on: [:create, :save]) do
    if self.video_processing
      Delayed::Worker.new.run(Delayed::Job.last)
    end
  end

  validates :video, attachment_presence: true
  validates :name, presence: true, uniqueness: true, length: {minimum: 2}

  has_attached_file :video, :styles => {
      :medium => {:geometry => '640x480#', :format => 'mp4'}, :thumb => ['300x300#', :jpg]},
                    :processors => [:transcoder],
                    :preview => {
                        :format => :jpg,
                        :geometry => '1200x675#',
                        :convert_options => {
                            :output => {
                                :vframes => 1,
                                :s => '1200x675',
                                :ss => '00:00:02'
                            }
                        }
                    },
                    :thumb => {
                        :format => :jpg,
                        :geometry => '300x169#',
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
  validates_attachment_content_type :video, :content_type => ['video/mp4', 'video/quicktime', 'video/x-flv', 'video/x-msvideo', 'video/x-ms-wmv', 'video/webm']
  process_in_background :video


  # Validate filename
  #validates_attachment_file_name :video, matches: [/flv\z/, /mp4?g\z/]

  # Explicitly do not validate
  # do_not_validate_attachment_file_type :video

  scope :visible_by, ->(current_user) {
    if current_user.role == 'Reseller'
      where(user_id: current_user.subordinates.map(&:id).push(current_user.id))
    elsif current_user.role == 'User'
      reseller = User.find_by(id: current_user.owner_id)
      where(user_id: reseller.subordinates.map(&:id).push(reseller.id))
    end
  }

  scope :custom_sort, ->(attribute) {
    if attribute == 'name'
      order(:name)
    elsif attribute == 'views'
      order(hit_counter: :desc)
    elsif attribute == 'user'
      Upload.joins(:user).order('users.name')
    elsif attribute == 'newest'
      order(created_at: :desc)
    else
      order(:created_at)
    end
  }

  scope :filter_by_user, ->(filter_user) {
    where(user_id: filter_user)
  }
end
