class Employee < ApplicationRecord
  has_many :skills_employees

  validates_associated :skills_employees
  validates :name, presence: true, length: {
      is: 3,
      tokenizer: lambda { |str| str.split },
      wrong_length: "Поле должно содержать %{count} слова"
  }, format: {
      with: /\A[а-яА-Я\s]+\z/,
      message: 'Поле может содержать только буквы кириллицы'
  }
  validates :contacts, presence: true, contacts: true
  validates :salary, presence: true, numericality: true

  def self.get_matches
    where(is_active: true).joins(:skills_employees).group('employees.id')
  end

  def self.get_full_matches(skills)
    self.get_matches.having('array_agg(text(skills_employees.skill)) @> ARRAY[?]', skills)
        .order(:salary)
  end

  def self.get_partial_matches(skills)
    self.get_matches.having('array_agg(text(skills_employees.skill)) && ARRAY[?]', skills)
        .having('NOT array_agg(text(skills_employees.skill)) @> ARRAY[?]', skills)
        .order(:salary)
  end

  def update_skills(id, skills)
    all_skills = Skill.all.pluck(:title)
    # delete previous values to prevent creating duplicates
    SkillsEmployee.delete_all(employee_id: id)
    skills.each do |skill|
      if (all_skills.exclude? skill)
        Skill.create(:title => skill)
      end
      SkillsEmployee.create(:employee_id => id, :skill => skill)
    end
  end


end
