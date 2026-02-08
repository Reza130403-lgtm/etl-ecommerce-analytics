-- =========================================================
-- File: fact_ecommerce_transaction.sql
-- Layer: Data Warehouse - Fact
-- Purpose:
--   Store atomic ecommerce transactions as the single
--   source of truth for analytical metrics
-- =========================================================

-- Ensure schema exists
CREATE SCHEMA IF NOT EXISTS dwh;

-- Create fact table if it does not exist
CREATE TABLE IF NOT EXISTS dwh.fact_ecommerce_transaction (
    sale_id            INT PRIMARY KEY,
    transaction_date   DATE,
    transaction_time   TIME,
    store_id           INT,
    user_id            INT,
    product_id         INT,
    quantity           INT,
    total_price        FLOAT,
    payment_method     VARCHAR(50),
    transaction_status VARCHAR(50),
    shipping_method    VARCHAR(50),
    last_update        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert new transactions only (insert-only strategy)
INSERT INTO dwh.fact_ecommerce_transaction
    (sale_id,
     transaction_date,
     transaction_time,
     store_id,
     user_id,
     product_id,
     quantity,
     total_price,
     payment_method,
     transaction_status,
     shipping_method,
     last_update)
SELECT
    src.transaction_id             AS sale_id,
    src.transaction_time::DATE     AS transaction_date,
    src.transaction_time::TIME     AS transaction_time,
    src.store_id,
    src.user_id,
    src.product_id,
    src.quantity,
    src.total_price,
    src.payment_method,
    src.transaction_status,
    src.shipping_method,
    CURRENT_TIMESTAMP              AS last_update
FROM stg.stg_ecommerce_transaction AS src
WHERE NOT EXISTS (
    SELECT 1
    FROM dwh.fact_ecommerce_transaction f
    WHERE f.sale_id = src.transaction_id
);

-- =========================================================
-- Validation Checks
-- =========================================================

-- Total number of fact rows
SELECT COUNT(*) AS fact_row_count
FROM dwh.fact_ecommerce_transaction;

-- Ensure no duplicate sale_id exists
SELECT COUNT(*) - COUNT(DISTINCT sale_id) AS duplicate_count
FROM dwh.fact_ecommerce_transaction;
