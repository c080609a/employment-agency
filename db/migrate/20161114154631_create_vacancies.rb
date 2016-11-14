class CreateVacancies < ActiveRecord::Migration[5.0]
  def change
    create_table :vacancies do |t|
      t.string :title
      t.date :expiry_date
      t.integer :salary
      t.string :contacts

      t.timestamps null: false
    end
  end
end
