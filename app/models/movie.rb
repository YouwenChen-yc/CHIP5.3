class Movie < ApplicationRecord
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list)
    if ratings_list.blank?
      Movie.all
    else
      formatted_ratings = Array(ratings_list).map { |r| r.to_s.upcase }
      Movie.where(rating: formatted_ratings)
    end
  end
end