class PagesController < ApplicationController
  def index
    @users = User.first
  end
end
