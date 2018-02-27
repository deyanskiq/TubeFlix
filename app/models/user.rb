class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
  has_many :uploads, dependent: :destroy
  has_many :subordinates, class_name: 'User', foreign_key: :reseller_id
  
  def self.get_users_by_reseller(user)
    where(reseller_id: user.id)
  end

end
