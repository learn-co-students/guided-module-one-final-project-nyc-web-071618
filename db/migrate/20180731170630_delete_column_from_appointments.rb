class DeleteColumnFromAppointments < ActiveRecord::Migration[5.0]
  def change
    remove_column :appointments, :paid?
  end
end
