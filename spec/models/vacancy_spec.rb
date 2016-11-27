require 'rails_helper'

describe Vacancy do

  before(:each) do
    @vacancy = Vacancy.create(title: nil, salary: nil, expiry_date: nil)
  end

  it 'is invalid without a title' do
    expect(@vacancy.errors).to have_key(:title)
  end

  it 'is invalid without salary' do
    expect(@vacancy.errors).to have_key(:salary)
  end

  it 'is invalid without an expiry date' do
    expect(@vacancy.errors).to have_key(:expiry_date)
  end

  it 'allows only numbers in salary' do
    vacancy = Vacancy.create(salary: 'Lorem')
    expect(vacancy.errors[:salary]).to include('is not a number')
  end

  it 'allows only valid date in expiry date' do
    vacancy = Vacancy.create(expiry_date: 'Lorem')
    expect(vacancy.errors[:expiry_date]).to include('is not a date')
  end

end