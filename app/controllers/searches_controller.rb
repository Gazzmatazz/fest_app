class SearchesController < ApplicationController

	def new
    	@search = Search.new
  	end

	# This will create a new Search record, then redirect to its show page(action) to show the results
	def create
	    @search = Search.create!(params[:search])
	    redirect_to @search
  	end
  
  	# Shows Search results, passed in from Create action, then search values passed to Show view file
	def show
	    @search = Search.find(params[:id])
	end

end
