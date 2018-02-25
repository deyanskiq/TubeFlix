class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
  has_many :uploads, dependent: :destroy

  before_validation(on: [:create, :save]) do
    if self.video_processing
      Delayed::Worker.new.run(Delayed::Job.last)
    end
  end

end
