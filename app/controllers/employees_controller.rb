class EmployeesController < ApplicationController

  before_action :find_employee, only: [:show, :update, :destroy]
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

  # delete item
  def destroy
    @employee.delete
    render json: { success: @employee.destroyed? }
  end

  # create item
  def create
    @employee = Employee.create(employee_data)
    if @employee.valid?
      result = { success: true }
    else
      result = { success: false, errors: @employee.errors }
    end
    render json: result
  end

  # update item
  def update
    if @employee.update_attributes(employee_data)
      result = { success: true }
    else
      result = { success: false, errors: @employee.errors }
    end
    render json: result
  end


  # show single item
  def show
    render json: { data: @employee, skills: @skills }
  end

  def find_employee
    @employee = Employee.find params[:id]
    @skills = @employee.skills
  end

  private

  def employee_data
    params.require(:employee).permit(:name, :is_active, :salary,
                                     :contacts)
  end
end
