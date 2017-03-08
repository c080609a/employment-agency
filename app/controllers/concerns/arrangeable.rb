module Arrangeable
  include ActiveSupport::Concern

  def get_params
    page = params[:page] ? params[:page].to_i : 1
    limit = params[:limit] ? params[:limit].to_i : 10
    ord = params[:order] ? params[:order] : 'id'

    if ord.to_s.start_with?('-')
      dir = 'desc'
      ord.gsub!(/\A\-/, '')
    else
      dir = 'asc'
    end

    { page: page, limit: limit, ord: ord, dir: dir }
  end

end
