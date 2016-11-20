class SkillsController < ApplicationController
  skip_before_action :verify_authenticity_token

   # get all skils (via AJAX)
  def index

    if (params[:query]) then
        query = params[:query].downcase
        skills = Skill.where('lower(title) LIKE ?', "%#{query}%").pluck(:title)
    else
        skills = Skill.pluck(:title)
    end

    render json: skills
  end

  def create
  end
end
