# -- The Warehouse
# -- lINK: https://en.wikibooks.org/wiki/SQL_Exercises/The_warehouse
# --3.1 Select all warehouses.
SELECT *
from Warehouses;
# --3.2 Select all boxes with a value larger than $150.
SELECT *
FROM Boxes
WHERE Value >= 150;
# --3.3 Select all distinct contents in all the boxes.
SELECT DISTINCT (Boxes.Contents)
from Boxes;
# --3.4 Select the average value of all the boxes.
SELECT AVG(Boxes.Value)
from Boxes;
# --3.5 Select the warehouse code and the average value of the boxes in each warehouse.
SELECT AVG(Boxes.Value), Warehouse
from Boxes
GROUP BY Warehouse;
# --3.6 Same as previous exercise, but select only those warehouses where the average value of the boxes is greater than 150.
SELECT AVG(Boxes.Value) as avg_value, Warehouse
from Boxes
GROUP BY Warehouse
HAVING avg_value >= 150;
# --3.7 Select the code of each box, along with the name of the city the box is located in.
SELECT B.Code, W.Location
from Boxes B
         left join sql_exercise.Warehouses W on W.Code = B.Warehouse;
# --3.8 Select the warehouse codes, along with the number of boxes in each warehouse.
#     -- Optionally, take into account that some warehouses are empty (i.e., the box count should show up as zero, instead of omitting the warehouse from the result).
SELECT W.Code, count(B.Code)
from Warehouses W
         left join Boxes B on W.Code = B.Warehouse
GROUP BY W.Code;
# --3.9 Select the codes of all warehouses that are saturated (a warehouse is saturated if the number of boxes in it is larger than the warehouse's capacity).
SELECT *
from Warehouses W1
         LEFT JOIN (SELECT W.Code, count(B.Code) as count_boxes
                    from Warehouses W
                             left join Boxes B on W.Code = B.Warehouse
                    GROUP BY W.Code) t on W1.Code = t.Code
WHERE t.count_boxes > W1.Capacity;

SELECT DISTINCT (t.Code), t.*
FROM (SELECT W.Code, W.Capacity, W.Location, COUNT(B.Code) over (partition by W.Code) as count_boxes
      from Warehouses W
               left join Boxes B on W.Code = B.Warehouse) t
WHERE t.count_boxes > t.Capacity;
# --3.10 Select the codes of all the boxes located in Chicago.
SELECT B.Code
FROM Boxes B
         left join sql_exercise.Warehouses W on W.Code = B.Warehouse
WHERE W.Location = 'Chicago';
# --3.11 Create a new warehouse in New York with a capacity for 3 boxes.
INSERT INTO Warehouses (Code, Location, Capacity)
VALUES (7, 'New York', 3);
# --3.12 Create a new box, with code "H5RT", containing "Papers" with a value of $200, and located in warehouse 2.
INSERT INTO Boxes (Code, Contents, Value, Warehouse)
VALUES ('H5RT', 'Paper', 200, 2);
# --3.13 Reduce the value of all boxes by 15%.
UPDATE Boxes
SET Value = Value * 0.85
WHERE TRUE;
# --3.14 Remove all boxes with a value lower than $100.
DELETE
FROM Boxes
WHERE Value < 100;
# -- 3.15 Remove all boxes from saturated warehouses.
DELETE
FROM Boxes
WHERE Boxes.Warehouse IN (SELECT W1.CODE
                          from Warehouses W1
                                   LEFT JOIN (SELECT W.Code, count(B.Code) as count_boxes
                                              from Warehouses W
                                                       left join Boxes B on W.Code = B.Warehouse
                                              GROUP BY W.Code) t on W1.Code = t.Code
                          WHERE t.count_boxes > W1.Capacity);
# -- 3.16 Add Index for column "Warehouse" in table "boxes"
#     -- !!!NOTE!!!: index should NOT be used on small tables in practice
CREATE INDEX Warehouse_Index ON Boxes (Warehouse);
# -- 3.17 Print all the existing indexes
#     -- !!!NOTE!!!: index should NOT be used on small tables in practice
select table_name,
       index_name,
       seq_in_index,
       column_name,
       non_unique,
       index_type,
       comment
from information_schema.statistics
where TRUE
  and table_schema = 'sql_exercise'
order by 1, 2, 3, 4, 5, 6;
# -- 3.18 Remove (drop) the index you added just
#     -- !!!NOTE!!!: index should NOT be used on small tables in practice
ALTER TABLE Boxes
    DROP FOREIGN KEY Boxes_ibfk_1;
ALTER TABLE Boxes
    DROP INDEX Warehouse_Index;