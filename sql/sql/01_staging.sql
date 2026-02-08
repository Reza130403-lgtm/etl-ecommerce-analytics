-- =========================================================
-- 01_staging.sql
-- STEP 1: Load data into STAGING (stg)
-- Goal: Keep a stable snapshot of source data for downstream ETL
-- =========================================================

-- Ensure schema exists (safe to rerun)
CREATE SCHEMA IF NOT EXISTS stg;

-- Create staging table (structure based on source) if it does not exist
-- NOTE: WITH NO DATA creates structure only (no initial load)
CREATE TABLE IF NOT EXISTS stg.stg_ecommerce_transaction AS
SELECT
    src.*,
    CURRENT_TIMESTAMP AS last_update
FROM public.ecommerce_transaction AS src
WITH NO DATA;

-- Full refresh: remove old snapshot to avoid duplicates
TRUNCATE TABLE stg.stg_ecommerce_transaction;

-- Reload the latest snapshot from source
INSERT INTO stg.stg_ecommerce_transaction
SELECT
    src.*,
    CURRENT_TIMESTAMP AS last_update
FROM public.ecommerce_transaction AS src;

-- Optional: update stats for better downstream performance (PostgreSQL)
ANALYZE stg.stg_ecommerce_transaction;
