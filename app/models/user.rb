class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable, :timeoutable

  validates :name, presence: true, uniqueness:  {message: 'has already been taken'}, length: {minimum: 2}

  has_many :uploads, dependent: :destroy
  has_many :subordinates, class_name: 'User', foreign_key: :owner_id, dependent: :destroy

  scope :get_users_by_reseller, -> (user) {where(owner_id: user.id)}

end

