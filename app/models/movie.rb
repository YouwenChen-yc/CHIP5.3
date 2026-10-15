class Movie < ApplicationRecord
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list)
    # If ratings_list is nil or empty, return all movies
    if ratings_list.nil? || ratings_list.empty?
      Movie.all
    else
      # Perform case-insensitive search or array match on rating column
      Movie.where(rating: ratings_list.map(&:upcase))
    end
  end
end