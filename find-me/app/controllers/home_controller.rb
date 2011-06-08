class HomeController < ApplicationController
  def index
    redirect_to tamapi_path + '/authorize'
  end
  
  def find_me
  end
  
  def denied
  end

end
