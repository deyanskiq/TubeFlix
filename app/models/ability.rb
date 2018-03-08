class Ability
  include CanCan::Ability

  def initialize(user)
    # Admin
    if user && user.role == 'Admin'
      can :manage, :all

      # Reseller
      # can :manage, User, :owner_id => user.id if user && user.role == "Reseller"
      # can [:manage], [Upload, Comment], :user_id => user.id if user && user.role == "Reseller"
      #
      # can :manage, User, id: user.id if user && user.role == "Reseller"
      #
      # binding.pry
    elsif user && user.role == 'Reseller'
      # binding.pry
      can :manage, User, :owner_id => user.id
      can :manage, User, id: user.id
      can [:manage], [Upload, Comment], :user_id => user.id

      can :manage, Upload do |upload|
        upload.user.owner_id == user.id
      end


      # User
      # can [:update, :destroy], User if user && user.role == "User"
    elsif user
      # binding.pry
      can [:update, :destroy], User, id: user.id
      can [:manage], [Upload, Comment], user_id: user.id
      can :show, Upload do |upload|
        upload.user.id == user.owner_id || upload.user.owner_id == user.owner_id
      end
    end
  end

  # Logged User
  # elsif user.present? # additional permissions for logged in users
  #   can [:manage], [Upload, Comment], user_id: user.id

  # else
  #   can :read, Page


  #   if admin(user)
  #     can :manage, :all
  #   elsif reseller(user)
  #     can :manage, User, :owner_id => user.id
  #     # can :manage, Upload do |upload|
  #     #   upload.user.owner_id == user.id or upload.user_id == user.id
  #     # end
  #   else
  #     can :manage, User, :id => user.id
  #   end
  #   can :manage, Upload, :user_id => user.id
  # end
  #
  # def admin(user)
  #   user.role == 'Admin'
  # end
  #
  # def reseller(user)
  #   user.role == 'Reseller'
  # end

end