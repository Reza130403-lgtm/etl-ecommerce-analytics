-- =========================================================
-- File: dm_tx_user_per_hour.sql
-- Layer: Datamart - KPI
-- Purpose:
--   Hourly transactions and unique users
-- =========================================================

CREATE TABLE IF NOT EXISTS dm.dm_tx_user_per_hour (
    transaction_date   DATE,
    transaction_hour   INT,
    total_transactions INT,
    total_users        INT,
    last_update        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (transaction_date, transaction_hour)
);

TRUNCATE TABLE dm.dm_tx_user_per_hour;

INSERT INTO dm.dm_tx_user_per_hour
    (transaction_date, transaction_hour,
     total_transactions, total_users, last_update)
SELECT
    transaction_date,
    EXTRACT(HOUR FROM transaction_time)::INT AS transaction_hour,
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT user_id) AS total_users,
    CURRENT_TIMESTAMP
FROM dm.dm_cube_ecommerce_transaction
GROUP BY
    transaction_date,
    EXTRACT(HOUR FROM transaction_time)
ORDER BY
    transaction_date,
    transaction_hour;

SELECT *
FROM dm.dm_tx_user_per_hour
ORDER BY transaction_date DESC, transaction_hour DESC
LIMIT 24;
