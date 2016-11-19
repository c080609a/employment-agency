class Employee < ApplicationRecord
  has_many :skills_employees

  # Validation
  validates_associated :skills
  validates :name, presence: true, length: {
      is: 3,
      tokenizer: lambda { |str| str.split },
      wrong_length: "must have %{count} words",
  }, format: {
      with: /\A[а-яА-Я\s]+\z/,
      message: "must contain cyrillic letters and spaces only"
  }
  validates :contacts, presence: true, contacts: true
  validates :salary, presence: true, numericality: true

  def get_full_match
    where(status: true).order(:salary)
  end

  def get_partial_match
    where(status: true).order(:salary)
  end

end
