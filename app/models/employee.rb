class Employee < ApplicationRecord
  has_many :skills_employees

  # Validation
  validates_associated :skills_employees
  validates :name, presence: true, length: {
      is: 3,
      tokenizer: lambda { |str| str.split },
      wrong_length: "Поле должно содержать %{count} слова",
  }, format: {
      with: /\A[а-яА-Я\s]+\z/,
      message: "Поле может содержать только буквы кириллицы"
  }
  validates :contacts, presence: true, contacts: true
  validates :salary, presence: true, numericality: true

  # Common method for matching
  def self.get_matches
    where(is_active: true)
        .joins(:skills_employees)
        .group('employees.id')
  end

  # Find fully matching employees
  def self.get_full_matches(skills)
    self.get_matches.having("array_agg(text(skills_employees.skill)) @> ARRAY[?]", skills)
        .order(:salary)
  end

  # Find partially matching employees
  def self.get_partial_matches(skills)
    self.get_matches.having("array_agg(text(skills_employees.skill)) && ARRAY[?]", skills)
        .having("NOT array_agg(text(skills_employees.skill)) @> ARRAY[?]", skills)
        .order(:salary)
  end

  # Update skills list
  def update_skills(id, skills)
    all_skills = Skill.all.pluck(:title)
    # delete previous values for excluding duplicates
    SkillsEmployee.delete_all(employee_id: id)
    skills.each do |skill|
      if (all_skills.exclude? skill) then
        # create new skill if such skill title is missing
        Skill.create(:title => skill)
      end
      # create skills-to-employee relation
      SkillsEmployee.create(:employee_id => id, :skill => skill)
    end
  end


end
