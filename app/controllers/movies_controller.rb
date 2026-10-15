class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @all_ratings = Movie.all_ratings

    # 1. Parse ratings parameter (supports Hash, Array, or nil)
    ratings_param = params[:ratings]

    if ratings_param.present?
      @ratings_to_show = ratings_param.is_a?(Hash) ? ratings_param.keys : Array(ratings_param)
      session[:ratings] = Hash[@ratings_to_show.map { |r| [r, "1"] }]
    elsif params[:commit].present? || params[:ratings_submit].present?
      # If form submitted with all boxes unchecked, reset to show all ratings
      @ratings_to_show = @all_ratings
      session[:ratings] = Hash[@all_ratings.map { |r| [r, "1"] }]
    elsif session[:ratings].present?
      @ratings_to_show = session[:ratings].is_a?(Hash) ? session[:ratings].keys : Array(session[:ratings])
    else
      @ratings_to_show = @all_ratings
    end

    # 2. Parse sorting parameter
    if params[:sort_by].present?
      session[:sort_by] = params[:sort_by]
    end
    @sort_by = session[:sort_by]

    # 3. Handle session redirect if visiting index with missing params when session state exists
    if params[:sort_by].nil? && params[:ratings].nil? && (session[:sort_by].present? || session[:ratings].present?)
      flash.keep
      redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings]) and return
    end

    # 4. Fetch filtered and sorted movies
    @movies = Movie.with_ratings(@ratings_to_show)

    if %w[title release_date].include?(@sort_by)
      @movies = @movies.order(@sort_by)
    end
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end