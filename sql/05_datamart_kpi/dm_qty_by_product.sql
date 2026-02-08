-- =========================================================
-- File: dm_qty_by_product.sql
-- Layer: Datamart - KPI
-- Purpose:
--   Total quantity sold per product
-- =========================================================

CREATE TABLE IF NOT EXISTS dm.dm_qty_by_product (
    product_id  INT PRIMARY KEY,
    total_qty   BIGINT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE dm.dm_qty_by_product;

INSERT INTO dm.dm_qty_by_product
    (product_id, total_qty, last_update)
SELECT
    product_id,
    SUM(quantity)::BIGINT AS total_qty,
    CURRENT_TIMESTAMP
FROM dm.dm_cube_ecommerce_transaction
GROUP BY product_id
ORDER BY total_qty DESC;

SELECT *
FROM dm.dm_qty_by_product
ORDER BY total_qty DESC
LIMIT 10;
