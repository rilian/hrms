class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, ActionPoint
    can :manage, Attachment
    if user.has_access_to_dayoffs?
      can :manage, Dayoff
    else
      can [:read, :employees], Dayoff
    end

    can :manage, Event if user.has_access_to_events?

    if user.has_access_to_expenses?
      can :manage, Expense
    else
      can :read, Expense
    end

    can :manage, Note
    can :manage, Person
    can :manage, Project
    can :manage, ProjectNote
    can :manage, Vacancy
    can :manage, User if user.has_access_to_users?
  end
end
