class ChangeDoctorsCostToInteger < ActiveRecord::Migration[5.0]
  def change
    change_column :doctors, :cost, :integer
  end
end
