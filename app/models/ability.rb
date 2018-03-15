class Ability
  include CanCan::Ability

  def initialize(user)
    # Admin
    if user && user.role == 'Admin'
      can :manage, :all
    elsif user && user.role == 'Reseller'
      can :manage, User, :owner_id => user.id
      can :manage, User, id: user.id
      can [:manage], [Upload, Comment], :user_id => user.id

      can :manage, Upload do |upload|
        upload.user.owner_id == user.id
      end

      can :manage, Comment do |comment|
        comment.upload.user.owner_id == user.id
      end


      # User
      # can [:update, :destroy], User if user && user.role == "User"
    elsif user
      can [:update, :destroy], User, id: user.id
      can [:manage], [Upload, Comment], user_id: user.id
      can :show, Upload do |upload|
        upload.user.id == user.owner_id || upload.user.owner_id == user.owner_id
      end
    end
  end


end