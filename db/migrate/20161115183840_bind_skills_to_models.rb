class BindSkillsToModels < ActiveRecord::Migration[5.0]
  def change
    create_join_table :skills, :employees do |t|
      t.index :skill_id
      t.index :employee_id
    end

    create_join_table :skills, :vacancies do |t|
      t.index :skill_id
      t.index :vacancy_id
    end

    change_table :skills do |t|
      t.remove :vacancy_id, :employee_id
    end
  end
end
