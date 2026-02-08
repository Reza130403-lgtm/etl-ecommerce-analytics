-- =========================================================
-- File: dm_revenue_by_category.sql
-- Layer: Datamart - KPI
-- Purpose:
--   Revenue aggregation by product category
-- =========================================================

CREATE TABLE IF NOT EXISTS dm.dm_revenue_by_category (
    product_category VARCHAR(50) PRIMARY KEY,
    total_revenue    FLOAT,
    last_update      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE dm.dm_revenue_by_category;

INSERT INTO dm.dm_revenue_by_category
    (product_category, total_revenue, last_update)
SELECT
    product_category,
    SUM(total_price) AS total_revenue,
    CURRENT_TIMESTAMP
FROM dm.dm_cube_ecommerce_transaction
GROUP BY product_category
ORDER BY total_revenue DESC;

SELECT *
FROM dm.dm_revenue_by_category
ORDER BY total_revenue DESC
LIMIT 10;
