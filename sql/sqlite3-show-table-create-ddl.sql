-- Show table create DDL in sqlite3
-- in the cli you can just say .schema <table>; this is how to do it from any sql connection
SELECT sql FROM sqlite_master WHERE type='table' AND name='your_table_name';
