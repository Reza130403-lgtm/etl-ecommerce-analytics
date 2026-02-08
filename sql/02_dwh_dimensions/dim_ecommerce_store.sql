-- =========================================================
-- File: dim_ecommerce_store.sql
-- Layer: Data Warehouse - Dimension
-- Purpose:
--   Build store dimension table
--   One row per store_id (SCD Type 1)
-- =========================================================

CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_ecommerce_store (
    store_id    INT PRIMARY KEY,
    store_name  VARCHAR(255),
    store_phone VARCHAR(50),
    store_city  VARCHAR(50),
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE dwh.dim_ecommerce_store;

INSERT INTO dwh.dim_ecommerce_store
    (store_id, store_name, store_phone, store_city, last_update)
SELECT
    store_id,
    store_name,
    store_phone,
    store_city,
    CURRENT_TIMESTAMP
FROM (
    SELECT
        src.store_id,
        src.store_name,
        src.store_phone,
        src.store_city,
        ROW_NUMBER() OVER (
            PARTITION BY src.store_id
            ORDER BY src.last_update DESC
        ) AS rn
    FROM stg.stg_ecommerce_transaction src
    WHERE src.store_id IS NOT NULL
) x
WHERE rn = 1;

-- Validation
SELECT
    COUNT(*) AS dim_rows,
    COUNT(DISTINCT store_id) AS distinct_store_id
FROM dwh.dim_ecommerce_store;
