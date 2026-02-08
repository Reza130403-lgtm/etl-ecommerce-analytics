# End-to-End ETL Pipeline for E-Commerce Analytics

This repository contains an **end-to-end automated ETL pipeline** designed to transform raw e-commerce transactional data (OLTP) into **analytics-ready datamarts** using SQL.

The project focuses on building a **reliable analytical data foundation** through proper data layering, dimensional modeling, automation, performance optimization, and data validation — enabling consistent reporting and scalable analytics.

---

## 🧩 Business Problem

Transactional databases are optimized for operational workloads, not analytics.  
Running analytical queries directly on OLTP systems often leads to:

- Slow query performance  
- Inconsistent metrics across reports  
- Difficult-to-scale dashboards  
- High operational risk as data volume grows  

This project addresses those challenges by designing a **structured ETL pipeline** that separates transactional and analytical workloads.

---

## 🏗️ Architecture Overview

### Data Flow
OLTP Source (ecommerce_transaction)
↓
Staging Layer (Snapshot)
↓
Data Warehouse (Dimensions & Fact)
↓
Datamart (Partitioned & Aggregated Tables)

### Data Layers

- **Staging (stg)**  
  Full snapshot of raw transactional data with a `last_update` timestamp for auditability and refresh tracking.

- **Data Warehouse (dwh)**  
  Dimensional data model consisting of fact and dimension tables to ensure data consistency and reusability.

- **Datamart (dm)**  
  Analytics-optimized tables and KPI datasets designed for high-performance analytical queries and dashboards.

---

## 🧱 Data Modeling

### Dimension Tables
- `dim_ecommerce_product`
- `dim_ecommerce_store`
- `dim_ecommerce_user`

Characteristics:
- One row per business entity  
- Deduplicated using window functions  
- SCD Type 1 (latest attribute values retained)

### Fact Table
- `fact_ecommerce_transaction`

Characteristics:
- Transactional grain (one row per transaction)
- Insert-only loading strategy to preserve history
- Duplicate prevention using primary keys

---

## ⚙️ ETL Automation Strategy

- The ETL process is designed to be **rerunnable and idempotent**
- Clear execution order:
  1. Refresh staging snapshot  
  2. Rebuild dimension tables  
  3. Load fact table with duplicate protection  
  4. Refresh datamart tables and KPI aggregations  

This design allows the pipeline to be executed on-demand or scheduled via database jobs or external orchestrators.

---

## 🚀 Performance Optimization

- Core datamart tables are **range-partitioned by `transaction_date`**
- Daily partitions are created to support scalable data growth
- Partition pruning enables:
  - Faster query execution  
  - Reduced disk I/O  
  - Stable performance over time  

---

## ✅ Data Quality & Validation

Built-in validation checks include:
- Row count consistency across layers (source → staging → warehouse → datamart)
- Uniqueness validation for business keys
- Duplicate detection in fact and datamart tables
- Data freshness tracking using `last_update` timestamps

These checks ensure analytical datasets are **accurate, consistent, and trustworthy**.

---

## 📊 Analytical Datamarts & KPIs

This project produces multiple analytics-ready tables, including:

- Daily total transactions  
- Hourly total transactions and unique users  
- Total quantity sold by product  
- Total quantity sold by store  
- Revenue by product category  

These datasets are designed to directly support BI dashboards and business reporting.

---

## 🛠️ Tech Stack

- SQL (PostgreSQL)
- Stored Procedures
- Window Functions
- Dimensional Data Modeling (Fact & Dimension)
- Table Partitioning
- Analytical Datamarts

---

## 📂 Repository Structure
sql/
├── staging/
├── dwh/
│ ├── dimensions/
│ └── facts/
├── datamart/
│ ├── core/
│ └── kpi/
└── validation/


---

## 🎯 Key Takeaways

- Clear separation between OLTP and analytical workloads  
- Reliable and reusable analytical datasets  
- Production-oriented ETL design with automation and validation  
- Scalable datamart architecture optimized for performance  

---

## ▶️ Execution Order

1. Seed data
2. Staging layer
3. Dimension tables
4. Fact table
5. Datamart core (view & partitions)
6. Datamart cube refresh
7. KPI tables

---

## ✅ Data Quality Checks
- Row count consistency across layers
- Uniqueness validation for dimension keys
- Duplicate prevention in fact and datamart tables
- Freshness tracking via last_update timestamps


## 📌 Notes

This project focuses on **data engineering and analytical data foundations**, rather than visualization.  
The resulting datamarts are ready to be consumed by BI tools or downstream analytical workflows.

