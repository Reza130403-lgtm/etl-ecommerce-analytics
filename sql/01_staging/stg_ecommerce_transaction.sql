-- =========================================================
-- File: stg_ecommerce_transaction.sql
-- Layer: Staging
-- Purpose:
--   Create a stable snapshot of raw transactional data
--   as the entry point for downstream ETL processing
-- =========================================================

-- Ensure staging schema exists (safe to rerun)
CREATE SCHEMA IF NOT EXISTS stg;

-- Create staging table structure if it does not exist
-- WITH NO DATA ensures only table structure is created
CREATE TABLE IF NOT EXISTS stg.stg_ecommerce_transaction AS
SELECT
    src.*,
    CURRENT_TIMESTAMP AS last_update
FROM public.ecommerce_transaction AS src
WITH NO DATA;

-- Full snapshot refresh
-- Old snapshot is removed to prevent duplicates
TRUNCATE TABLE stg.stg_ecommerce_transaction;

-- Load latest snapshot from source
INSERT INTO stg.stg_ecommerce_transaction
SELECT
    src.*,
    CURRENT_TIMESTAMP AS last_update
FROM public.ecommerce_transaction AS src;

-- =========================================================
-- Validation Checks
-- =========================================================

-- Row count consistency check (source vs staging)
SELECT
    (SELECT COUNT(*) FROM public.ecommerce_transaction) AS source_count,
    (SELECT COUNT(*) FROM stg.stg_ecommerce_transaction) AS staging_count;

-- Sample data check
SELECT *
FROM stg.stg_ecommerce_transaction
LIMIT 10;
