class VacanciesController < ApplicationController

  before_action :find_item, only: [:show, :update, :destroy]
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
    vacancies = Vacancy.order("#{ord} #{dir}").all
    render json: vacancies
  end

  # create item
  def create
    @vacancy = Vacancy.create(vacancy_data)
    render json: { success: @vacancy.valid? }
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

  # updte item
  def update
    result = @vacancy.update_attributes(vacancy_data)
    render json: { success: result }
  end

  # filter items by id
  def find_item
    @vacancy = Vacancy.find params[:id]
    @skills = @vacancy.skills
  end

  private

   def vacancy_data
     params.require(:vacancy).permit(:title, :expiry_date, :salary,
                                  :contacts)
   end
end
