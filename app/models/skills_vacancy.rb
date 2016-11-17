class SkillsVacancy < ApplicationRecord
  belongs_to :skill
  belongs_to :vacancy
end