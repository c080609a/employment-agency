class CreateEmployees < ActiveRecord::Migration[5.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :contacts
      t.boolean :is_active, default: false
      t.integer :salary

      t.timestamps null: false
    end
  end
end
