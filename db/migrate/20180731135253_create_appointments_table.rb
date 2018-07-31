class CreateAppointmentsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.datetime
      t.string :condition
      t.decimal :price
      t.boolean :paid?
      t.integer :doctor_id
      t.integer :patient_id
    end
  end
end
