-- =========================================================
-- File: dm_most_transaction_date.sql
-- Layer: Datamart - KPI
-- Purpose:
--   Daily transaction volume summary
-- =========================================================

CREATE TABLE IF NOT EXISTS dm.dm_most_transaction_date (
    transaction_date   DATE PRIMARY KEY,
    total_transactions INT,
    last_update        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE dm.dm_most_transaction_date;

INSERT INTO dm.dm_most_transaction_date
    (transaction_date, total_transactions, last_update)
SELECT
    transaction_date,
    COUNT(*) AS total_transactions,
    CURRENT_TIMESTAMP
FROM dm.dm_cube_ecommerce_transaction
GROUP BY transaction_date
ORDER BY total_transactions DESC;

SELECT *
FROM dm.dm_most_transaction_date
ORDER BY total_transactions DESC
LIMIT 10;
