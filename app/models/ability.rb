class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    #   can :manage, :all if user.role == "Admin"
    #   can :manage, User, :reseller_id => user.id if user.role == "Reseller"
    #   can [:manage], [Upload, Comment], :user_id => user.id if user.role == "Reseller"
    #   can :manage, Upload do |upload|
    #     upload.user.reseller_id == user.id
    #   end
    #   if user.present? # additional permissions for logged in users (they can manage their posts)
    #     can [:manage], [Upload, Comment], user_id: user.id
    #   else
    #     can :read, Upload
    #   end
    #
    #   can :manage, Upload, :user_id => user.id
    #
    if admin(user)
      can :manage, :all
    elsif reseller(user)
      can :manage, User, :reseller_id => user.id
      # can :manage, Upload do |upload|
      #   upload.user.reseller_id == user.id
      # end
    else
      can :manage, User, :id => user.id
    end

    can :manage, Upload, :user_id => user.id
  end

  def admin(user)
    user.role == 'Admin'
  end

  def reseller(user)
    user.role == 'Reseller'
  end

end