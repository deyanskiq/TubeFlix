class Ability
  include CanCan::Ability
  include UserHelper

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    
       user ||= User.new # guest user (not logged in)
       if admin(user)
         can :manage, :all
       elsif reseller(user)
          can :manage, User
       elsif user.present?  # additional permissions for logged in users (they can manage their posts)   
         can [:manage], [Upload, Comment]
       else
         can :read, :all
       end
  end

  def admin(user)
      user.role == "Admin"
  end

  def reseller(user)
      user.role == "Reseller"
  end

  def user(user)
      user.role == "User"    

  end
end