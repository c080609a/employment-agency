class EmployeesController < ApplicationController

  # before_action :find_employee

  def index
    employees = Employee.all
    render json: employees
  end

  def find_employee
    @employee = Employee.find params[:id]
  end
end
