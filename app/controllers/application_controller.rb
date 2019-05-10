class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  around_action :user_time_zone, if: :current_user

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def save_sorted(query)
    position = 1
    params[:order].split('&').each do |s|
      id = s.split('=')[1].to_i
      obj = query.where(id: id).first
      next unless obj
      obj.position = position
      obj.save!
      position += 1
    end
  end

end
