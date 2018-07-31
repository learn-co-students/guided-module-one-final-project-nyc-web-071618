class AddCostToBilling < ActiveRecord::Migration[5.0]
  def change
    add_column :billings, :cost, :integer
  end
end
