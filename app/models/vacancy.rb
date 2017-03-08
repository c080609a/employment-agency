class Vacancy < ApplicationRecord
  has_many :skills_vacancies

  validates_associated :skills_vacancies
  validates :title, presence: true
  validates :salary, presence: true, numericality: true
  validates :expiry_date, presence: true, date: true

  def self.get_matches
    where('expiry_date > ?', DateTime.now).joins(:skills_vacancies).group('vacancies.id')
  end

  def self.get_full_matches(skills)
    self.get_matches.having('array_agg(text(skills_vacancies.skill)) <@ ARRAY[?]', skills)
        .order('salary DESC')
  end

  def self.get_partial_matches(skills)
    self.get_matches.having('array_agg(text(skills_vacancies.skill)) && ARRAY[?]', skills)
        .having('NOT array_agg(text(skills_vacancies.skill)) <@ ARRAY[?]', skills)
        .order('salary DESC')
  end

  def update_skills(id, skills)
    all_skills = Skill.all.pluck(:title)
    SkillsVacancy.delete_all(vacancy_id: id)
    skills.each do |skill|
      if (all_skills.exclude? skill)
        Skill.create(:title => skill)
      end
      SkillsVacancy.create(:vacancy_id => id, :skill => skill)
    end
  end

end
