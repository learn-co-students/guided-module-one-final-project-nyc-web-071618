class CreateDoctorsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :specialization
      t.decimal :cost
    end
  end
end
