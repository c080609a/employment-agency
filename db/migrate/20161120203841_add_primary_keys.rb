class AddPrimaryKeys < ActiveRecord::Migration[5.0]
  def change
    execute('ALTER TABLE skills_employees ADD PRIMARY KEY (employee_id, skill);')
    execute('ALTER TABLE skills_vacancies ADD PRIMARY KEY (vacancy_id, skill);')
  end
end
