class Vacancy < ApplicationRecord
  has_many :skills_vacancies
  has_many :skills, :through => :skills_vacancies

  # Validation
  validates_associated :skills
  validates :title, presence: true
  validates :salary, presence: true, numericality: true

end
