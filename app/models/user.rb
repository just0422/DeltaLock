class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def admin?
      has_role?(:admin)
  end

  def editor?
      has_role?(:editor)
  end

  def viewer?
      has_role?(:viewer)
  end
end
