-- https://en.wikibooks.org/wiki/SQL_Exercises/Movie_theatres
-- 4.1 Select the title of all movies.
SELECT Title
from Movies;
-- 4.2 Show all the distinct ratings in the database.
SELECT DISTINCT (Movies.Rating)
from Movies;
-- 4.3  Show all unrated movies.
SELECT Movies.*
from Movies
WHERE Rating IS NULL;
-- 4.4 Select all movie theaters that are not currently showing a movie.
SELECT MovieTheaters.*
from MovieTheaters
WHERE Movie IS NULL;
-- 4.5 Select all data from all movie theaters
-- and, additionally, the data from the movie that is being shown in the theater (if one is being shown).
SELECT *
from MovieTheaters MT
         left join sql_exercise.Movies M on M.Code = MT.Movie;
-- 4.6 Select all data from all movies and, if that movie is being shown in a theater, show the data from the theater.
SELECT *
FROM Movies M
         left join sql_exercise.MovieTheaters MT on M.Code = MT.Movie;
-- 4.7 Show the titles of movies not currently being shown in any theaters.
SELECT M.Title
FROM Movies M
         left join sql_exercise.MovieTheaters MT on M.Code = MT.Movie
WHERE MT.Code is NULL;
-- 4.8 Add the unrated movie "One, Two, Three".
UPDATE Movies
SET Rating = NULL
WHERE Title = 'One, Two, Three';
-- 4.9 Set the rating of all unrated movies to "G".
UPDATE Movies
SET Rating = 'G'
WHERE Rating is NULL;
-- 4.10 Remove movie theaters projecting movies rated "NC-17".
UPDATE MovieTheaters MT
SET Movie = NULL
WHERE MT.Movie IN (SELECT Code
                   FROM Movies M
                   WHERE M.Rating = 'NC-17')