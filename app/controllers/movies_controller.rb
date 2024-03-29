class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    if @selectragins==nil then @selectratings = @all_ratings end
    if (params[:sort]==nil) && (session[:sort]!=nil)
      @sortby = session[:sort]
      flash.keep
      redirect_to movies_path(:sort => @sortby)
    end
    if params[:ratings]==nil && session[:ratings]!=nil
      @selectratings = session[:ratings].keys
      flash[:ratings]=@selectratings
    end
    if flash[:ratings]!=nil
      @selectratings = flash[:ratings]
      flash[:ratings]=@selectratings
    end
    if params[:ratings]!=nil
      @selectratings = params[:ratings].keys
      session[:ratings]= params[:ratings]
      flash[:ratings]=@selectratings
    end
    if params[:sort]!=nil
      @sortby = params[:sort]
      @movies = Movie.where(:rating => @selectratings).order("#{@sortby} ASC").all
      flash[:sort] = @sortby
    end
    if flash[:sort]!=nil
      @sortby = flash[:sort]
      @movies = Movie.where(:rating => @selectratings).order("#{@sortby} ASC" ).all
      flash[:sort] = @sortby
    else
      @movies = Movie.where(:rating => @selectratings).all
    end
    session[:sort] = @sortby
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
