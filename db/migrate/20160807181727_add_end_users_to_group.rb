class AddEndUsersToGroup < ActiveRecord::Migration
  def change
      remove_foreign_key :groups, :end_user
      remove_reference :groups, :end_user, index: true
      add_reference :end_users, :group, index: true, foreign_key: true
  end
end
