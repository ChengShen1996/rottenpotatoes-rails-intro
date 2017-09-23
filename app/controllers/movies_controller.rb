class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort_term)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    # if params[:session] =="clear"
    #   session[:sort_term]=nil
    #   session[:ratings]=nil
    # end
    if params[:ratings]
      temp = @all_ratings.select{|val| params[:ratings].key?val}
      @movies = Movie.select{|val| temp.include?val.rating}
      session[:ratings]=params[:ratings]
    end
    @val_rating=params[:ratings]||session[:ratings]||{}
    val_sort= params[:sort_term]||session[:sort_term]
    if params[:sort_term]
      session[:sort_term]=params[:sort_term]
    end
    if params[:sort_term] != session[:sort_term]
      session[:sort_term] = val_sort
      redirect_to :sort_term => val_sort, :val_rating => @val_rating and return
    end

  if params[:ratings] != session[:ratings] and @val_rating != {}
      session[:sort_term] = val_sort
      session[:ratings] = @val_rating
      redirect_to :sort_term => val_sort, :val_rating => @val_rating and return
    end



    if val_sort=='title'
      @movies = Movie.order(val_sort)
      @title_header = 'hilite'
    elsif val_sort == 'release_date'
      @movies = Movie.order(val_sort)
      @release_header='hilite'
    end
    movies_back=Array.new
    
    if @val_rating
      for i in @movies.each
        if @val_rating.include?i.rating
          movies_back.push(i)
        end
      end
      @movies=movies_back
    end
    if params[val_sort] != session[val_sort] or params[@val_rating] != session[@val_rating]
      flash.keep
      redirect_to movies_path val_sort: @val_sort, val_rating: @val_rating
    end
    

    # @movies = Movie.order('release_date ASC')
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
