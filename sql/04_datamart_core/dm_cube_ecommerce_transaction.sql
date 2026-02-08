-- =========================================================
-- File: dm_cube_ecommerce_transaction.sql
-- Layer: Datamart - Core (Table)
-- Purpose:
--   Store a physical, partitioned datamart table
--   optimized for analytical queries
-- =========================================================

CREATE SCHEMA IF NOT EXISTS dm;

CREATE TABLE IF NOT EXISTS dm.dm_cube_ecommerce_transaction (
    sale_id            INT,
    transaction_date   DATE NOT NULL,
    transaction_time   TIME,
    store_id           INT,
    store_name         VARCHAR(255),
    store_city         VARCHAR(50),
    user_id            INT,
    user_name          VARCHAR(255),
    user_city          VARCHAR(50),
    product_id         INT,
    product_name       VARCHAR(255),
    product_category   VARCHAR(50),
    product_price      FLOAT4,
    quantity           INT,
    total_price        FLOAT,
    payment_method     VARCHAR(50),
    transaction_status VARCHAR(50),
    shipping_method    VARCHAR(50),
    last_update        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (transaction_date);

-- Accessibility check
SELECT 1
FROM dm.dm_cube_ecommerce_transaction
LIMIT 1;
