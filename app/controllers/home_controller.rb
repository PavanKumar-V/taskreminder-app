class HomeController < ApplicationController
  def index
    if current_user
      redirect_to "/tasks", notice: "Signed in success"
    end
  end
end
