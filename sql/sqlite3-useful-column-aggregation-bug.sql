/*
SQLITE3 has an exploitable bug that makes for a nice feature: it can select an ungrouped column (data from a specific row) when using an aggregate function.

Let's say we have branch_history that records the path, branch, and created_at, and we want to see the most recent branch for each path.

In SQLite3 this is trivial:

We could do
*/

SELECT
    path
    , branch
    , MAX(created_at) AS newest_created_at
FROM
    branch_history
GROUP BY path

/*
This won't work on Redshift. We could do it with a subquery:
*/

SELECT
    t1.path
    , t1.branch
    , t1.created_at
FROM
    branch_history t1
JOIN (
    SELECT
        path
        , MAX(created_at) AS newest_created_at
    FROM
        branch_history
    GROUP BY path
) t2 ON t1.path = t2.path AND t1.created_at = t2.newest_created_at

/*

On the data services team we really like our window functions. We still have to
do a subquery, but it's tidier. A good example of "if you know the
harder-to-understand syntax, you can express a harder-to-understand concept in
an easier-to-read idiom, making the whole mess easier to understand.

*/

SELECT path, branch, created_at
FROM (
    SELECT
        path
        , branch
        , created_at
        , ROW_NUMBER() OVER (PARTITION BY path ORDER BY created_at DESC) AS row_num
    FROM
        branch_history
) t
WHERE
    row_num = 1
