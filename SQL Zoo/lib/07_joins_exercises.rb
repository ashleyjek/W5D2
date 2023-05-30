# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery';
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT
    title
  FROM
    movies
  WHERE
    id IN
  (
  SELECT
    movie_id
  FROM
    castings
  WHERE
    actor_id IN (
  SELECT
    id
  FROM
    actors
  WHERE
     name = 'Harrison Ford'
  )
  );
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the starring
  # role. [Note: The ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role.]
  execute(<<-SQL)
  SELECT
    title
  FROM
    movies
  WHERE
    id IN
  (
  SELECT
    movie_id
  FROM
    castings
  WHERE
    actor_id IN (
  SELECT
    id
  FROM
    actors
  WHERE
     name = 'Harrison Ford'
  ) AND ord != 1
  );
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT
    title, name
  FROM
    movies
  INNER JOIN
    castings
  ON
    movies.id = castings.movie_id
  INNER JOIN
    actors
  ON
    actors.id = castings.actor_id
  WHERE
    yr = 1962 and ord = 1;

  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT
    yr, COUNT(title)
  FROM
    movies
  WHERE
    id IN
    (
    SELECT
      movie_id
    FROM
      castings
    WHERE
      actor_id IN (
      SELECT
        id
      FROM
        actors
      WHERE
        name = 'John Travolta'
    )
    )
  GROUP BY
    yr
  HAVING
    COUNT(title) >= 2;
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  SELECT
    title, name
  FROM
    movies
  INNER JOIN
    castings
  ON 
    movies.id = castings.movie_id
  INNER JOIN
    actors
  ON 
    actors.id = castings.actor_id
  WHERE 
    ord = 1 AND movies.id IN (
              SELECT
                movie_id
              FROM
                castings
              WHERE
                actor_id IN (
              SELECT
                id
              FROM
                actors
              WHERE
                name = 'Julie Andrews'
    ));
  
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
  SELECT
    DISTINCT name
  FROM 
    actors
  WHERE
    id IN
  (SELECT
    actor_id
  FROM
    castings
  GROUP BY
    actor_id
  HAVING
    COUNT(ord = 1) >= 15);

  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
  SQL
end