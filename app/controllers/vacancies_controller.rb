class VacanciesController < ApplicationController
  # before_action :find_item

  def index
    vacancies = Vacancy.all
    render json: vacancies
  end

  def find_item
    @vacancy = Vacancy.find params[:id]
  end
end
