class VacanciesController < ApplicationController

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
    vacancies = Vacancy.order("#{ord} #{dir}").limit(limit).offset(offset)
    total = vacancies.except(:limit, :offset).count
    render json: { rows: vacancies, total: total }
  end

  # create item
  def create
    @vacancy = Vacancy.create(vacancy_data)
    if @vacancy.valid?
      result = { success: true }
    else
      result = { success: false, errors: @vacancy.errors }
    end
    render json: result
  end

  # show single item
  def show
    render json: { data: @vacancy, skills: @skills }
  end

  # delete item
  def destroy
    @vacancy.delete
    render json: { success: @vacancy.destroyed? }
  end

  # update item
  def update
    @vacancy.update_skills(params[:id], params[:skills])
    if @vacancy.update_attributes(vacancy_data)
      result = { success: true }
    else
      result = { success: false, errors: @vacancy.errors }
    end
    render json: result
  end

  # filter items by id
  def find_item
    @vacancy = Vacancy.find params[:id]
    @skills = @vacancy.skills_vacancies.pluck(:skill)
  end

  # get matching employees
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
