class FilmsController < ApplicationController
  
  
  def index
    @films = Film.all
    @stories = Story.all
    respond_to do |format|
      format.html # index.html.erb
      format.js # { render :json => @users}
      format.json { render :json => @films, :methods => [:r, :g, :b, :story_name]}
    end
  end
  
end
