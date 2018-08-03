class ChangeColumnDatetimeAppointments < ActiveRecord::Migration[5.0]
  def change
    change_column :appointments, :date_and_time, :date
  end
end
