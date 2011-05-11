class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new(:role => 'guest') # guest user
    
    if user.role? :admin
      can :manage, :all
      can :index, :all
    elsif user.role? :user
      can [:index, :show, :latest, :voting], Proposition
      can :create, Proposition
      can :create, Comment
      can :show, [Page, User, Announcement]
      can [:create,:index, :show], Vote
      can :create, Rating 
      can :update, User do |u|
        u && u == user
      end
    else
      can [:index, :show, :latest, :voting], [Proposition]
      can :show, User
      can :index, Vote
      can :create, User
      can :create, UserSession
      can :show, Page
      can :show, User
      can :show, Announcement
    end
  end
end