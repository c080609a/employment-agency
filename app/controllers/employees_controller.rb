class EmployeesController < ApplicationController

  before_action :find_item, only: [:show, :update, :destroy, :get_matches]
  skip_before_action :verify_authenticity_token
  attr_accessor :skills

  # get all items with sorting & pagination
  def index
    ord = params[:order] ? params[:order] : 'id'
    limit = params[:limit].to_i
    page = params[:page].to_i
    offset = (page - 1) * limit

    if ord.to_s.start_with?('-')
      dir = 'desc'
      ord.gsub!(/\A\-/, '')
    else
      dir = 'asc'
    end

    employees = Employee.order("#{ord} #{dir}")

    if limit
      employees = employees.limit(limit).offset(offset)
      total = employees.except(:limit, :offset).count
    else
      total = employees.count
    end

    render json: { rows: employees, total: total }
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

  # show single item
  def show
    render json: { data: @employee, skills: @skills }
  end

  # delete item
  def destroy
    @employee.delete
    render json: { success: @employee.destroyed? }
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
