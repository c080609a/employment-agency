class Employee < ApplicationRecord
  has_many :skills_employees

  # Validation
  validates_associated :skills_employees
  validates :name, presence: true, length: {
      is: 3,
      tokenizer: lambda { |str| str.split },
      wrong_length: "must have %{count} words",
  }, format: {
      with: /\A[а-яА-Я\s]+\z/,
      message: "must contain cyrillic letters and spaces only"
  }
  validates :contacts, presence: true, contacts: true
  validates :salary, presence: true, numericality: true



  def update_skills(id, skills)
    all_skills = Skill.all.pluck(:title)
    SkillsEmployee.delete_all(employee_id: id)
    skills.each do |skill|
      if (all_skills.exclude? skill) then
        Skill.create(:title => skill)
      end
      SkillsEmployee.create(:employee_id => id, :skill => skill)
    end
  end


end
