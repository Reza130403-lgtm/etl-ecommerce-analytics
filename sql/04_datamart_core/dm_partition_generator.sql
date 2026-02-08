-- =========================================================
-- File: dm_partition_generator.sql
-- Layer: Datamart - Core (Partition Management)
-- Purpose:
--   Automatically create daily partitions for the
--   ecommerce datamart table
-- =========================================================

DO $$
DECLARE
    d DATE := DATE '2025-01-01';
    end_date DATE := DATE '2025-03-28';
BEGIN
    WHILE d <= end_date LOOP
        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS dm.dm_cube_ecommerce_transaction_%s
             PARTITION OF dm.dm_cube_ecommerce_transaction
             FOR VALUES FROM (%L) TO (%L);',
            to_char(d, 'YYYYMMDD'),
            d,
            d + 1
        );
        d := d + 1;
    END LOOP;
END $$;

-- Validation: list created partitions
SELECT
    child.relname AS partition_name
FROM pg_inherits
JOIN pg_class parent ON pg_inherits.inhparent = parent.oid
JOIN pg_class child  ON pg_inherits.inhrelid  = child.oid
JOIN pg_namespace nsp ON nsp.oid = parent.relnamespace
WHERE nsp.nspname = 'dm'
  AND parent.relname = 'dm_cube_ecommerce_transaction'
ORDER BY child.relname;
