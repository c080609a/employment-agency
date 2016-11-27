require 'rails_helper'

describe Employee do

  before(:each) do
    @employee = Employee.create(name: nil, salary: nil, contacts: nil)
  end

  it 'is invalid without a name' do
    @employee.valid?
    expect(@employee.errors).to have_key(:name)
  end

  it 'is invalid without salary' do
    @employee.valid?
    expect(@employee.errors).to have_key(:salary)
  end

  it 'is invalid without contacts' do
    @employee.valid?
    expect(@employee.errors).to have_key(:contacts)
  end

  it 'allows only numbers in salary' do
    employee = Employee.create(salary: 'Lorem')
    employee.valid?
    expect(employee.errors[:salary]).to include('is not a number')
  end

  it 'allows only valid phone number or email in contacts' do
    employee = Employee.create(contacts: '8988')
    employee.valid?
    expect(employee.errors[:contacts]).to include('Поле должно содержать корректный E-mail или номер телефона')
  end

  it 'allows only cyrillic letters in name' do
    employee = Employee.create(name: 'Name Name Name')
    employee.valid?
    expect(employee.errors[:name]).to include('Поле может содержать только буквы кириллицы')
  end

  it 'requires exactly 3 words in name' do
    employee = Employee.create(name: 'Иван Иванов')
    employee.valid?
    expect(employee.errors[:name]).to include('Поле должно содержать 3 слова')
  end

end