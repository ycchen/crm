class HomeController < ApplicationController

  before_action :authenticate_user!, except: [:logout]

  def index
    redirect_to contacts_path
  end

  def logout
    reset_session
    redirect_to Figaro.env.www_url
  end
end
