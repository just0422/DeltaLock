class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new
      if user.admin?
          can :manage, :all
      elsif user.editor?
          actions = [:read, :result, :create, :new, :search, :update_map, :assignment, :edit, :update, :upload, :download]
          can actions, [Key, EndUser, Purchaser, PurchaseOrder, Relationship]
          can :read, User
      elsif user.viewer?
          can :read, [Key, EndUser, Purchaser, PurchaseOrder, Relationship]
      else
          cannot :manage
      end
  end
end
