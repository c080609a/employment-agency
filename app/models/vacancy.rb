class Vacancy < ApplicationRecord
  has_many :skills_vacancies

  # Validation
  validates_associated :skills_vacancies
  validates :title, presence: true
  validates :salary, presence: true, numericality: true
  validates :expiry_date, date: true



  def update_skills(id, skills)
    all_skills = Skill.all.pluck(:title)
    SkillsVacancy.delete_all(vacancy_id: id)
    skills.each do |skill|
      if (all_skills.exclude? skill) then
        Skill.create(:title => skill)
      end
      SkillsVacancy.create(:vacancy_id => id, :skill => skill)
    end
  end

end
