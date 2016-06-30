class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    case user.role
    when 'admin'
      can :manage, :all
    when 'manager'
      can :manage, ActionPoint
      can :manage, Attachment
      can :manage, Dayoff
      can :manage, Note, type: user.accessible_note_types
      can :manage, Person
    end
  end
end
