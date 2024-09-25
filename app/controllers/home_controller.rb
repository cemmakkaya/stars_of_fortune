class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    # Add any necessary logic here
  end
end