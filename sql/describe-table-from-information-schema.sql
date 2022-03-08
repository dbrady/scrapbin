-- describe-table-from-information-schema.sql

-- This will be psql-centric since mysql server literally lets you run the query
-- "DESCRIBE TABLE <table>", where psql's \d and \d+ are built into the client,
-- but postgresql is really good about compliance with the SQL standard, so this
-- may work wherever fine database products are sold:

SELECT
        table_name,
        column_name,
        data_type
FROM
        information_schema.columns
WHERE
        table_name = 'merchants'; -- or whatever
