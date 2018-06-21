class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def administrator?
      has_role?(:admin)
  end

  def editor?
      has_role?(:editor)
  end

  def viewer?
      has_role?(:viewer)
  end
end
