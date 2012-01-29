class FilmsController < ApplicationController
  
  
  def index
    @films = Film.all
    #@films = [Film.find_by_name("Anonymous")]
    #render :json => @films
    respond_to do |format|
      format.html # index.html.erb
      format.js # { render :json => @users}
      format.json { render :json => @films}
    end
  end
  
end
