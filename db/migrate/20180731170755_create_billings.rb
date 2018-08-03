class CreateBillings < ActiveRecord::Migration[5.0]
  def change
    create_table :billings do |t|
      t.integer :appointment_id
      t.boolean :paid?
    end
  end
end
