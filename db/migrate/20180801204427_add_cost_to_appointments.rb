class AddCostToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :cost, :integer
  end
end
