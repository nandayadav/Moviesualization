class StoriesController < ApplicationController
  
  def index
    @stories = Story.where.order(:name).all
    respond_to do |format|
      format.json { render :json => @stories}
    end
  end
  
  
end