class EmployeesController < ApplicationController

  include Arrangeable

  before_action :find_item, only: [:show, :update, :destroy, :get_matches]
  skip_before_action :verify_authenticity_token
  attr_accessor :skills

  def index
    query_params = get_params
    employees = Employee.order("#{query_params[:ord]} #{query_params[:dir]}")
                        .paginate(:page => query_params[:page], :per_page => query_params[:limit])

    render json: { rows: employees, total: employees.total_entries }
  end

  def create
    @employee = Employee.create(employee_data)
    if @employee.valid?
      result = { success: true }
    else
      result = { success: false, errors: @employee.errors }
    end
    render json: result
  end

  def show
    render json: { data: @employee, skills: @skills }
  end

  def destroy
    @employee.delete
    render json: { success: @employee.destroyed? }
  end

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

  def find_item
    @employee = Employee.find params[:id]
    @skills = @employee.skills_employees.pluck(:skill)
  end

  private

  def employee_data
    params.permit(:name, :is_active, :salary, :contacts)
  end
end
