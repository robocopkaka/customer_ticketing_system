class HomeController < ApplicationController
  def index
    render json: { message: "Welcome to the ticketing app" }
  end
end