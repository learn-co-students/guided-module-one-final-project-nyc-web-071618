class DropBillings < ActiveRecord::Migration[5.2]
  def change
    drop_table :billings
  end
end
