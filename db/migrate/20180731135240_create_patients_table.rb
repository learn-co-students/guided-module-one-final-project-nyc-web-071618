class CreatePatientsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :patients do |t|
      t.string :name
      t.integer :age
      t.string :sex
    end
  end
end
