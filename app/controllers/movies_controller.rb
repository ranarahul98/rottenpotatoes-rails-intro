class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort] # need to define sort here to use in view
    #@movies = Movie.order(params[:sort])
    @all_ratings = ['G','PG','PG-13','R'] # to support checkboxes
    @filtered_movies = params[:ratings]
    # create hash to store filtered ratings and populate it based on 
    # selected filters, 
    @checked_boxes = {} 
    if params.has_key?(:ratings)
      @all_ratings.each do |rating|
        if params[:ratings].keys.include?(rating)
          @checked_boxes[rating] = true
        end
      end
      @movies = Movie.where(rating: params[:ratings].keys) #return filtered movies
    else
      #@movies = Movie.all
      @movies = Movie.order(params[:sort])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
