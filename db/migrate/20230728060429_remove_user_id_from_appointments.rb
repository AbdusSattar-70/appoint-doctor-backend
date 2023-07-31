class RemoveUserIdFromAppointments < ActiveRecord::Migration[7.0]
  def change
    remove_column :appointments, :user_id, :bigint
  end
end
