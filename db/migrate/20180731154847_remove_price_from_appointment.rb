class RemovePriceFromAppointment < ActiveRecord::Migration[5.0]
  def change
    remove_column :appointments, :price
  end
end
