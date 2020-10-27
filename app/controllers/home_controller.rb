class HomeController < ApplicationController
  def index
    render json: "Hello, World!"
  end
end
