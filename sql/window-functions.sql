/*
 * WINDOW FUNCTIONS
 *
 * Random scraps and learnings
 */

-- ROW_NUMBER() is not a column. You can't just put it anywhere you want in the
-- expression and then put OVER at the end.

-- ROW_NUMBER() OVER (...) *CAN* go anywhere a column goes.
-- So: It's not ROW_NUMBER(), it's ROW_NUMBER() OVER (...)

-- It makes sense if you think about needing more than one window. E.g. finding
-- the first and last time punch for a date, we say
--
-- SELECT
--     ROW_NUMBER() OVER (PARTITION BY date ORDER BY time ASC) first,
--     ROW_NUMBER() OVER (PARTITION BY date ORDER BY time DESC) last,
--     other_columns_here
-- FROM
--     table
-- WHERE
--     first=1
--     AND last=1

-- THIS DOES NOT WORK:
SELECT ROW_NUMBER(), d.* OVER (ORDER BY d.date) FROM days d LIMIT 10;

-- Because window functions and the window expression go together to make a
-- single column expression.

-- This one is correct:
SELECT d.*, ROW_NUMBER() OVER (ORDER BY d.date) FROM days d LIMIT 10;

-- And so is this one, note that ROW_NUMBER() OVER (...) *does* work like a column in that it can
-- Go anywhere in the column expression list
SELECT ROW_NUMBER() OVER (ORDER BY d.date), d.* FROM days d LIMIT 10;
