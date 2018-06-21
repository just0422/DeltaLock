class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new
      if user.administrator?
          can :manage, :all
      elsif user.editor?
          can [:read, :create, :update], [Key, EndUser, Purchaser, PurchaseOrder, Relationship]
      elsif user.viewer?
          can :read, [Key, EndUser, Purchaser, PurchaseOrder, Relationship]
      else
          cannot :manage
      end
  end
end
