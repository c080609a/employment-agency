class SkillsEmployee < ApplicationRecord
  belongs_to :skill
  belongs_to :employee
end