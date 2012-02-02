class FilmsController < ApplicationController
  
  
  def index
    year = params[:year] || 2011
    if year
      @films = Film.where(:year => year.to_i).all
    else
      @films = Film.all
    end
    @stories = Story.limit(10).all
    respond_to do |format|
      format.html # index.html.erb
      format.js # { render :json => @users}
      format.json { render :json => @films, :methods => [:r, :g, :b, :story_name]}
    end
  end
  
end
