class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, ActionPoint
    can :manage, Attachment
    can :manage, Dayoff
    can :manage, Event if user.has_access_to_events?
    can :manage, Note
    can :manage, Person
    can :manage, Project
    can :manage, ProjectNote
    can :manage, Vacancy
    can :manage, User if user.has_access_to_users?
  end
end
