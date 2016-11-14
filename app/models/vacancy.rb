class Vacancy < ApplicationRecord
  has_many :skills
  validates_associated: skills
  validates :title, presence: true
  validates :salary, presence: true, numericality: true,

end
