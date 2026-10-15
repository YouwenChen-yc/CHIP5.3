class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @all_ratings = Movie.all_ratings

    # 1. Safely parse ratings parameter across Hash, ActionController::Parameters, or Array
    ratings_param = params[:ratings]

    selected_ratings = if ratings_param.present?
                         if ratings_param.respond_to?(:keys)
                           ratings_param.keys
                         elsif ratings_param.is_a?(Array)
                           ratings_param
                         elsif ratings_param.is_a?(String)
                           [ratings_param]
                         end
                       end

    # 2. Update active ratings state and session
    if selected_ratings.present?
      @ratings_to_show = selected_ratings
      session[:ratings] = Hash[selected_ratings.map { |r| [r, "1"] }]
    elsif params[:commit].present? || params[:ratings_submit].present?
      # User refreshed with no boxes checked -> reset to show all ratings
      @ratings_to_show = @all_ratings
      session[:ratings] = Hash[@all_ratings.map { |r| [r, "1"] }]
    elsif session[:ratings].present?
      s_ratings = session[:ratings]
      @ratings_to_show = s_ratings.respond_to?(:keys) ? s_ratings.keys : Array(s_ratings)
    else
      @ratings_to_show = @all_ratings
    end

    # 3. Update sorting state and session
    if params[:sort_by].present?
      session[:sort_by] = params[:sort_by]
    end
    @sort_by = session[:sort_by]

    # 4. Perform RESTful redirect if visiting without params when session state exists
    if params[:sort_by].nil? && params[:ratings].nil? && params[:commit].nil? && params[:ratings_submit].nil? && (session[:sort_by].present? || session[:ratings].present?)
      flash.keep
      redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings]) and return
    end

    # 5. Fetch filtered and sorted movies from Model
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