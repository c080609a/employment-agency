class Vacancy < ApplicationRecord
  has_many :skills_vacancies

  # Validation
  validates_associated :skills
  validates :title, presence: true
  validates :salary, presence: true, numericality: true
  validates :expiry_date, date: true

end
