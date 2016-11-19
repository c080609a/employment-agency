class ReworkSkills < ActiveRecord::Migration[5.0]
  def change
    remove_column :skills_employees, :skill_id
    remove_column :skills_vacancies, :skill_id
    add_column :skills_employees, :skill, :string
    add_column :skills_vacancies, :skill, :string
  end
end
