class Employee < ApplicationRecord
  has_many :skills

  # Validation
  validates_associated :skills
  validates :name, presence: true, length: {
      is: 3,
      tokenizer: lambda { |str| str.scan(/\w+/) },
      wrong_length: "must have %{count} words",
  },
      format: {
      with: /\A[а-яА-Я\s]+\z/,
      message: "must contain cyrillic letters and spaces only"
  }
  validates :contacts, presence: true, contacts: true
  validates :salary, presence: true, numericality: true




end
