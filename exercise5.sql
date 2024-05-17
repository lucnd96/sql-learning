-- https://en.wikibooks.org/wiki/SQL_Exercises/Pieces_and_providers
-- 5.1 Select the name of all the pieces.
SELECT *
FROM Pieces;
-- 5.2  Select all the providers' data.
SELECT *
FROM Providers;
SELECT *
from Provides;
-- 5.3 Obtain the average price of each piece (show only the piece code and the average price).
SELECT AVG(Provides.Price), Piece
from Provides
GROUP BY Piece;
-- 5.4  Obtain the names of all providers who supply piece 1.
SELECT Providers.Name
FROM Provides
         LEFT JOIN Providers ON Provides.Provider = Providers.Code
WHERE Piece = 1;
-- 5.5 Select the name of pieces provided by provider with code "HAL".
SELECT *
FROM Pieces
         LEFT JOIN Provides on Pieces.Code = Provides.Piece
         LEFT JOIN Providers ON Provides.Provider = Providers.Code
WHERE Providers.Code = 'HAL';
-- 5.6
-- ---------------------------------------------
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- Interesting and important one.
-- For each piece, find the most expensive offering of that piece and include the piece name, provider name, and price
-- (note that there could be two providers who supply the same piece at the most expensive price).
EXPLAIN ANALYZE
SELECT *
FROM (SELECT Pieces.Code,
             Pieces.Name                                                 as Pieces_Name,
             Providers.Name                                              as Provider_Name,
             Provides.Price,
             rank() over (partition by Pieces.Code order by Price desc ) as rank_price
      FROM Pieces
               INNER JOIN Provides on Pieces.Code = Provides.Piece
               INNER JOIN Providers ON Provides.Provider = Providers.Code
      ORDER BY Pieces.Code) t
WHERE t.rank_price = 1;

EXPLAIN ANALYZE
SELECT Pieces.Name, Providers.Name, Price
FROM Pieces
         INNER JOIN Provides ON Pieces.Code = Piece
         INNER JOIN Providers ON Providers.Code = Provider
WHERE Price =
      (SELECT MAX(Price)
       FROM Provides
       WHERE Piece = Pieces.Code)
ORDER BY Pieces.Code;
-- ---------------------------------------------
-- 5.7 Add an entry to the database to indicate that "Skellington Supplies" (code "TNBC") will provide sprockets (code "1") for 7 cents each.
-- 5.8 Increase all prices by one cent.
-- 5.9 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply bolts (code 4).
-- 5.10 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply any pieces
-- (the provider should still remain in the database).