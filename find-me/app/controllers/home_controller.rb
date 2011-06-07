class HomeController < ApplicationController
  def index
    redirect_to '/tamapi/authorize'
  end
  
  def find_me
  end
  
  def denied
  end

end
