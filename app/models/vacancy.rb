class Vacancy < ApplicationRecord
  has_many :skills_vacancies

  # Validation
  validates_associated :skills_vacancies
  validates :title, presence: true
  validates :salary, presence: true, numericality: true
  validates :expiry_date, date: true

  # Common method for matching
  def self.get_matches
    self.where("expiry_date > ?", DateTime.now)
        .joins(:skills_vacancies)
        .group('vacancies.id')
  end

  # Find fully matching vacancies
  def self.get_full_matches(skills)
    self.get_matches.having("array_agg(text(skills_vacancies.skill)) <@ ARRAY[?]", skills)
        .order("#{:salary} DESC")
  end

  # Find partially matching vacancies
  def self.get_partial_matches(skills)
    self.get_matches.having("array_agg(text(skills_vacancies.skill)) && ARRAY[?]", skills)
        .having("NOT array_agg(text(skills_vacancies.skill)) <@ ARRAY[?]", skills)
        .order("#{:salary} DESC")
  end

  # Update skills list
  def update_skills(id, skills)
    all_skills = Skill.all.pluck(:title)
    # delete previous values for excluding duplicates
    SkillsVacancy.delete_all(vacancy_id: id)
    skills.each do |skill|
      if (all_skills.exclude? skill) then
        # create new skill if such skill title is missing
        Skill.create(:title => skill)
      end
      # create skill-to-vacancy relation
      SkillsVacancy.create(:vacancy_id => id, :skill => skill)
    end
  end

end
