class Movie < ActiveRecord::Base
    def Movie.get_ratings()
        return ['G','PG','PG-13','R']
    end
    
    def Movie.with_ratings(ratings) # TODO: it works the other way -- not implementing this function
        if ratings.any? #ratings keys will be names of the checked boxes
            #not empty
        else
            return Movie.all
        end
    end

end
