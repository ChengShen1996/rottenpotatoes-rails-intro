class Movie < ActiveRecord::Base
	def self.all_ratings
        Movie.select(:rating).uniq.map { |movie| movie.rating }.sort
    end
end
