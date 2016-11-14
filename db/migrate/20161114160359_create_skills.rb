class CreateSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :skills do |t|
      t.belongs_to :vacancy, index: true
      t.belongs_to :employee, index: true
      t.string :title, unique: true
      t.timestamps
    end
  end
end
