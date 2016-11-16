class EmployeesController < ApplicationController

  before_action :find_employee, only: [:show]
  skip_before_action :verify_authenticity_token

  # get all items with sorting & pagination
  def index
    ord = params[:order]
    if ord.to_s.start_with?('-') then
      dir = 'desc'
      ord.gsub!(/\-/, '')
    else
      dir = 'asc'
    end
    employees = Employee.order("#{ord} #{dir}").all
    render json: employees
  end

  # show single item
  def show
    render json: @employee
  end

  def find_employee
    @employee = Employee.find params[:id]
  end
end
