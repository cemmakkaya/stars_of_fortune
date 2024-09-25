class HomeController < ApplicationController
  def index
    @groups = Group.all if user_signed_in?
  end
end