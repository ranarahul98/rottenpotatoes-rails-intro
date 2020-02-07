class MoviesController < ApplicationController
 #Help received: Piazza and Stackoverflow articles about Ruby/Rails
 -# http://haml.info/tutorial.html
 -# https://stackoverflow.com/questions/23908507/conditional-class-in-haml/23908682
 -# https://apidock.com/rails/ActionView/Helpers/FormTagHelper/form_tag
 -# https://guides.rubyonrails.org/action_controller_overview.html#session

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  # For part 3: need to redesign code outline
  def index
    ##-------DEFINE-------##
    @all_ratings = Movie.get_ratings()
    @movies = Movie.all
    redirect = false
    @filtered_movies = @all_ratings

    ##-------FILTER RATINGS-------##
    if params[:ratings] #get from selection
      @filtered_movies = params[:ratings].keys
      session[:ratings] = params[:ratings] # store it in cookies
    elsif session[:ratings] #existing cookies
      redirect = true
      @filtered_movies = session[:ratings].keys
    end

    ##-------SORT SELECTION-------##
    if params[:sort] #get from selection
      @sort = params[:sort]
      session[:sort] = @sort
    else
      @sort = session[:sort] #existing cookies
    end
   
    ##-------@SORT?-------##
    #executed depending on if title or release_date clicked
    @sort ? @movies = Movie.where(:rating => @filtered_movies).order(@sort) : @movies = Movie.where(:rating => @filtered_movies)

    ##-------TO BE RESTFUL-------##
    if redirect
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
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
