class RenameEmployeesSkills < ActiveRecord::Migration[5.0]
  def change
    rename_table :employees_skills, :skills_employees
  end
end
