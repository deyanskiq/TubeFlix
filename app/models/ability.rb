class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    
       user ||= User.new # guest user (not logged in)
        can :manage, :all if user.role == "Admin"
        can :manage, User, :reseller_id => user.id if user.role == "Reseller"
        if user.present?  # additional permissions for logged in users (they can manage their posts)   
         can [:manage], [Upload, Comment], user_id: user.id
       else
         can :read, Upload
       end
  end

 end