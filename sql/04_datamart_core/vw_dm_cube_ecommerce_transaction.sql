-- =========================================================
-- File: vw_dm_cube_ecommerce_transaction.sql
-- Layer: Datamart - Core (View)
-- Purpose:
--   Provide a denormalized analytical view by joining
--   fact and dimension tables
-- =========================================================

CREATE SCHEMA IF NOT EXISTS dm;

CREATE OR REPLACE VIEW dm.vw_dm_cube_ecommerce_transaction AS
SELECT
    -- Fact attributes
    fs.sale_id,
    fs.transaction_date,
    fs.transaction_time,
    fs.store_id,
    fs.user_id,
    fs.product_id,
    fs.quantity,
    fs.total_price,
    fs.payment_method,
    fs.transaction_status,
    fs.shipping_method,
    fs.last_update,

    -- Store dimension
    ds.store_name,
    ds.store_city,

    -- User dimension
    du.user_name,
    du.user_city,

    -- Product dimension
    dp.product_name,
    dp.product_category,
    dp.product_price

FROM dwh.fact_ecommerce_transaction AS fs
LEFT JOIN dwh.dim_ecommerce_store   AS ds ON fs.store_id   = ds.store_id
LEFT JOIN dwh.dim_ecommerce_user    AS du ON fs.user_id    = du.user_id
LEFT JOIN dwh.dim_ecommerce_product AS dp ON fs.product_id = dp.product_id;

-- Validation
SELECT
  (SELECT COUNT(*) FROM dwh.fact_ecommerce_transaction) AS fact_rows,
  (SELECT COUNT(*) FROM dm.vw_dm_cube_ecommerce_transaction) AS view_rows;
