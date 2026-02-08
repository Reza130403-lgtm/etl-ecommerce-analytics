-- =========================================================
-- File: dim_ecommerce_user.sql
-- Layer: Data Warehouse - Dimension
-- Purpose:
--   Build user dimension table
--   One row per user_id (SCD Type 1)
-- =========================================================

CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_ecommerce_user (
    user_id     INT PRIMARY KEY,
    user_name   VARCHAR(255),
    user_email  VARCHAR(255),
    user_phone  VARCHAR(50),
    user_gender VARCHAR(50),
    user_age    INT,
    user_city   VARCHAR(50),
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE dwh.dim_ecommerce_user;

INSERT INTO dwh.dim_ecommerce_user
    (user_id, user_name, user_email, user_phone,
     user_gender, user_age, user_city, last_update)
SELECT
    user_id,
    user_name,
    user_email,
    user_phone,
    user_gender,
    user_age,
    user_city,
    CURRENT_TIMESTAMP
FROM (
    SELECT
        src.user_id,
        src.user_name,
        src.user_email,
        src.user_phone,
        src.user_gender,
        src.user_age,
        src.user_city,
        ROW_NUMBER() OVER (
            PARTITION BY src.user_id
            ORDER BY src.last_update DESC
        ) AS rn
    FROM stg.stg_ecommerce_transaction src
    WHERE src.user_id IS NOT NULL
) x
WHERE rn = 1;

-- Validation
SELECT
    COUNT(*) AS dim_rows,
    COUNT(DISTINCT user_id) AS distinct_user_id
FROM dwh.dim_ecommerce_user;
