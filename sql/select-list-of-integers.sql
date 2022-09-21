-- generate a list of integers up to a set value.

-- Taken from the SQL Cookbook 10.5

-- This solution works in DB2 and SQL Server without the RECURSIVE keyword; psql
-- and snowflake require the RECURSIVE keyword. However, both of those databases
-- have a generate_series() function (see next query) so I'm saving this off as
-- more of a note on how to write a recursive CTE.
WITH RECURSIVE x (id)
AS (
    SELECT 1
        UNION ALL
    SELECT id+1
        FROM x
    WHERE id+1 <=10
)
SELECT * FROM x

-- Mind you the cookbook DOES point out that in PSQL you can do this instead:
SELECT id FROM generate_series(1, 10) x(id)
