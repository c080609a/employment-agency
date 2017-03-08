class VacanciesController < ApplicationController

  include Arrangeable

  before_action :find_item, only: [:show, :update, :destroy, :get_matches]
  skip_before_action :verify_authenticity_token
  attr_accessor :skills

  def index
    query_params = get_params
    vacancies = Vacancy.order("#{query_params[:ord]} #{query_params[:dir]}")
                       .paginate(:page => query_params[:page], :per_page => query_params[:limit])

    render json: { rows: vacancies, total: vacancies.total_entries }
  end

  def create
    @vacancy = Vacancy.create(vacancy_data)
    if @vacancy.valid?
      result = { success: true }
    else
      result = { success: false, errors: @vacancy.errors }
    end
    render json: result
  end

  def show
    render json: { data: @vacancy, skills: @skills }
  end

  def destroy
    @vacancy.delete
    render json: { success: @vacancy.destroyed? }
  end

  def update
    @vacancy.update_skills(params[:id], params[:skills])
    if @vacancy.update_attributes(vacancy_data) && @vacancy.valid?
      result = { success: true }
    else
      result = { success: false, errors: @vacancy.errors }
    end
    render json: result
  end

  def find_item
    @vacancy = Vacancy.find params[:id]
    @skills = @vacancy.skills_vacancies.pluck(:skill)
  end

  def get_matches
    full_match = Employee.get_full_matches(@skills)
    partial_match = Employee.get_partial_matches(@skills)
    render json: { full: full_match, partial: partial_match }
  end

  private

  def vacancy_data
    params.permit(:title, :expiry_date, :salary, :contacts)
  end
end
