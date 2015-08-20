class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, only: :index
  respond_to :html

  def index
      @button_name = button_name
    @plans = Plan.all.order(:id)
    respond_with(@plans)
  end

  def button_name
    if user_signed_in?
        "Get Plan"
    else
        "Sign up"
    end
  end
end