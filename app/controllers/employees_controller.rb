class EmployeesController < ApplicationController

  before_action :find_item, only: [:show, :update, :destroy, :get_matches]
  skip_before_action :verify_authenticity_token
  attr_accessor :skills

  # get all items with sorting & pagination
  def index
    ord = params[:order]
    limit = params[:limit].to_i
    page = params[:page].to_i
    offset = (page - 1) * limit
    if ord.to_s.start_with?('-') then
      dir = 'desc'
      ord.gsub!(/\-/, '')
    else
      dir = 'asc'
    end
    employees = Employee.order("#{ord} #{dir}").limit(limit).offset(offset)
    total = employees.except(:limit, :offset).count
    render json: { rows: employees, total: total }
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
    @employee.update_skills(params[:id], params[:skills])
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

  def get_matches
    full_match = Vacancy.get_full_matches(@skills)
    partial_match = Vacancy.get_partial_matches(@skills)
    render json: { full: full_match, partial: partial_match }
  end

  # get a certain employee
  def find_item
    @employee = Employee.find params[:id]
    @skills = @employee.skills_employees.pluck(:skill)
  end

  private

  def employee_data
    params.permit(:name, :is_active, :salary, :contacts)
  end
end
