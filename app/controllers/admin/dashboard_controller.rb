class Admin::DashboardController < ApplicationController
  require 'kaminari'
  expose(:users) do
    if ['city_ids', 'country_ids'].include?(sort_column)
      to_sort = User.all.sort_by{|u| u.send(sort_column).size}
      sort_direction == 'desc' ? to_sort : (to_sort = to_sort.reverse)
      Kaminari.paginate_array(to_sort).page(params[:page]).per(30)
    else
     User.all.order_by(sort_column + " " + sort_direction).page(params[:page]).per(30)
    end
  end
  layout 'admin'
  http_basic_authenticate_with name: "admin", password: "secret"
  helper_method :sort_column, :sort_direction


  # constants
  USER_SORT_COLUMNS = ['email', 'mobile', 'created_at', 'shared_to', 'city_ids', 'country_ids']


  private

  def sort_column
    USER_SORT_COLUMNS.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
