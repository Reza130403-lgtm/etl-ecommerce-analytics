-- =========================================================
-- File: dm_refresh_cube.sql
-- Layer: Datamart - KPI
-- Purpose:
--   Refresh physical datamart cube table from analytical view
-- =========================================================

TRUNCATE TABLE dm.dm_cube_ecommerce_transaction;

INSERT INTO dm.dm_cube_ecommerce_transaction
    (sale_id, transaction_date, transaction_time,
     store_id, store_name, store_city,
     user_id, user_name, user_city,
     product_id, product_name, product_category, product_price,
     quantity, total_price,
     payment_method, transaction_status, shipping_method, last_update)
SELECT
    sale_id,
    transaction_date,
    transaction_time,
    store_id,
    store_name,
    store_city,
    user_id,
    user_name,
    user_city,
    product_id,
    product_name,
    product_category,
    product_price,
    quantity,
    total_price,
    payment_method,
    transaction_status,
    shipping_method,
    last_update
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY sale_id
            ORDER BY last_update DESC
        ) AS rn
    FROM dm.vw_dm_cube_ecommerce_transaction
) x
WHERE rn = 1;

-- Validation
SELECT COUNT(*) AS dm_cube_rows
FROM dm.dm_cube_ecommerce_transaction;
