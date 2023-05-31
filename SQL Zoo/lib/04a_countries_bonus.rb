# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# BONUS QUESTIONS: These problems require knowledge of aggregate
# functions. Attempt them after completing section 05.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values.)
  execute(<<-SQL)
  SELECT
    name
  FROM
    countries
  WHERE
    gdp IS NOT NULL AND gdp >
  (
  SELECT
    MAX(gdp)
  FROM
    countries
  WHERE
    continent = 'Europe'
  );
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
  SELECT
    continent, name, area
  FROM
    countries
  WHERE
  area IN (
  SELECT
    MAX(area)
  FROM
    countries
  GROUP BY
    continent);
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
  SELECT
    name, continent
  FROM
    countries
  WHERE
    population IN (
      SELECT
        MAX(population)
      FROM
        countries
      GROUP BY
        continent
      ) AND continent IN
  (SELECT
    highest.continent
  FROM
    (SELECT
     continent, MAX(population) AS max1
    FROM
      countries
    GROUP BY
      continent) AS highest
  JOIN 
    (SELECT
      continent, MAX(population) AS max2
    FROM
      countries
    WHERE
      population NOT in (
      SELECT
        MAX(population)
      FROM
        countries
      GROUP BY
        continent
      )
      GROUP BY
        continent) AS second_highest
  ON highest.continent = second_highest.continent
  WHERE max1 > 3 * max2); 
  SQL
end