-- =========================================================
-- File: dm_qty_by_store.sql
-- Layer: Datamart - KPI
-- Purpose:
--   Total quantity sold per store
-- =========================================================

CREATE TABLE IF NOT EXISTS dm.dm_qty_by_store (
    store_id    INT PRIMARY KEY,
    total_qty   BIGINT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE dm.dm_qty_by_store;

INSERT INTO dm.dm_qty_by_store
    (store_id, total_qty, last_update)
SELECT
    store_id,
    SUM(quantity)::BIGINT AS total_qty,
    CURRENT_TIMESTAMP
FROM dm.dm_cube_ecommerce_transaction
GROUP BY store_id
ORDER BY total_qty DESC;

SELECT *
FROM dm.dm_qty_by_store
ORDER BY total_qty DESC
LIMIT 10;
