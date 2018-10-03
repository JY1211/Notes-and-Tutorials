--1. List each country name where the population is larger than 'Russia'.

SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia');

--2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
 
 SELECT name 
 FROM world 
 WHERE continent = 'Europe' AND gdp/population > (
      SELECT gdp/population 
      FROM world 
      WHERE name = 'United Kingdom');

--3. List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.

SELECT name, continent FROM world WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina', 'Australia')) ORDER BY name;

--4. Which country has a population that is more than Canada but less than Poland? Show the name and the population.
 
SELECT name, population FROM world WHERE population > (SELECT population FROM world WHERE name = 'Canada') AND population < (SELECT population FROM world WHERE name = 'Poland');

--*5*. Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
-- Should put *100 inside ROUND(), otherwise ROUND() on 0.xxxx will all produce number 0!!!
SELECT name, CONCAT(ROUND(population/(SELECT population 
                                      FROM world 
                                      WHERE name ='Germany')*100 ),'%')
FROM world 
WHERE continent = 'Europe'

--*6*. Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
-- Don't forget gdp > 0
SELECT name 
FROM world 
WHERE gdp > ALL(SELECT gdp 
                FROM world 
                WHERE gdp > 0 AND continent = 'Europe');

--*7*. Find the largest country (by area) in each continent, show the continent, the name and the area:
-- The usage of 'world x' and 'world y'. Inside the ALL function, it's the list to be looped on. 
SELECT continent, name, area 
FROM world x
WHERE area >= ALL(SELECT area
                  FROM world y
                  WHERE y.continent=x.continent AND area>0)

--*8*. List each continent and the name of the country that comes first alphabetically.
-- WHERE name <= ALL(), should not be name < ALL()
SELECT continent, name 
FROM world x
WHERE name <= ALL(SELECT name 
                  FROM world y
                  WHERE x.continent = y.continent)

--*9*. Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
-- Be aware that 25000000 should be placed before ALL()
SELECT name, continent, population
FROM world
WHERE continent IN (SELECT continent
                    FROM world x
                    WHERE 25000000 >= ALL(SELECT population
                                          FROM world y 
                                          WHERE x.continent = y.continent)
                   )
                   
--*10*. Some countries have populations more than three times that of any of their neighbors (in the same continent). Give the countries and continents.                                                           
-- Be aware the use of a.name!= y.name
SELECT name, continent 
FROM world x
WHERE population >= ALL(SELECT population*3 
                        FROM world y
                        WHERE x.continent=y.continent AND x.name != y.name)

