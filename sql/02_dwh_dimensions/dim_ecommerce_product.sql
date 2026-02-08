-- =========================================================
-- File: dim_ecommerce_product.sql
-- Layer: Data Warehouse - Dimension
-- Purpose:
--   Build product dimension table
--   One row per product_id (SCD Type 1)
-- =========================================================

CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_ecommerce_product (
    product_id       INT PRIMARY KEY,
    product_name     VARCHAR(255),
    product_category VARCHAR(50),
    product_price    FLOAT4,
    last_update      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Full refresh (assignment-friendly, SCD Type 1)
TRUNCATE TABLE dwh.dim_ecommerce_product;

INSERT INTO dwh.dim_ecommerce_product
    (product_id, product_name, product_category, product_price, last_update)
SELECT
    product_id,
    product_name,
    product_category,
    product_price,
    CURRENT_TIMESTAMP
FROM (
    SELECT
        src.product_id,
        src.product_name,
        src.product_category,
        src.product_price,
        ROW_NUMBER() OVER (
            PARTITION BY src.product_id
            ORDER BY src.last_update DESC
        ) AS rn
    FROM stg.stg_ecommerce_transaction src
    WHERE src.product_id IS NOT NULL
) x
WHERE rn = 1;

-- Validation
SELECT
    COUNT(*) AS dim_rows,
    COUNT(DISTINCT product_id) AS distinct_product_id
FROM dwh.dim_ecommerce_product;
