# Enterprise Data Warehouse Analysis & Modeling

> A comprehensive repository focused on data quality analysis, transformations, and Star Schema modeling across Data Warehouse layers (Bronze, Silver, Gold) to deliver analytics-ready data.

---

## 👨‍💻 About Me

Hi, I'm **Mohammed Al-Awadhi**! I am passionate about data analytics and data management. I focus on transforming raw, complex data into structured, actionable insights through clean analytical pipelines, rigorous data quality checks, and robust data modeling.

---

## 📌 Project Overview

This repository focuses on **Data Analytics** across every stage of the Data Warehouse lifecycle—starting from inspecting raw ERP and CRM data quality, cleaning and standardizing metrics, to building business-oriented analytical models using the **3-Tier Medallion Architecture**:
## 🔍 Analytical & Data Pipeline Breakdown

### 1. Data Ingestion & Sources Analysis
* **Sources Analyzed:** ERP and CRM operational systems[cite: 1].
* **Input Format:** Flat CSV files stored in designated folder interfaces[cite: 1].
* **Analytical Focus:** Assessing source file schemas, verifying data types, and measuring missing value rates prior to ingestion.

---

### 2. Bronze Layer Analysis (Raw Ingestion)
* **Storage Type:** Database Tables[cite: 1].
* **Ingestion Strategy:** Batch Processing via Full Load (`TRUNCATE AND INSERT` strategy)[cite: 1].
* **Data State:** Unaltered raw data preservation with zero transformations (`No Transformation`)[cite: 1].
* **Analytical Focus:** Reconciling row counts between source files and target tables, tracking raw volumes, and detecting schema drift.

---

### 3. Silver Layer Analysis (Standardization & Cleansing)
* **Storage Type:** Database Tables[cite: 1].
* **Ingestion Strategy:** Batch Processing (`TRUNCATE AND INSERT`)[cite: 1].
* **Data Quality & Transformation Pipeline:**
  * **Data Cleansing:** Deduplication, handling null values, and trimming string values[cite: 1].
  * **Standardization:** Harmonizing date/time formats, currency metrics, and lookups across disparate systems[cite: 1].
  * **Normalization:** Structuring entities to resolve redundancy[cite: 1].
  * **Derived Columns:** Feature engineering calculated fields and core business logic[cite: 1].
  * **Data Enrichment:** Joining reference tables for deeper analytical context[cite: 1].

---

### 4. Gold Layer Analytical Modeling (Business Ready)
* **Storage Type:** Database Views (`No Load` runtime execution)[cite: 1].
* **Analytical Data Modeling Techniques:**
  * **Star Schema:** Dimensional modeling with central Fact tables surrounded by conformed Dimension tables[cite: 1].
  * **Flat Tables:** Wide tables optimized for ad-hoc analytical queries[cite: 1].
  * **Aggregated Tables:** Pre-computed KPI summaries and metric rollups[cite: 1].
* **Analytical Transformations:** Cross-system data integration, aggregation rollups, and core business KPI calculations[cite: 1].

---

### 5. Consumption & BI Integration
* **Analytics Delivery:** Direct connections from Gold Layer Views to BI platforms (Power BI, Tableau) and SQL analytics interfaces.
* **Target Stakeholders:** Data Analysts, Data Scientists, and Executive Decision-Makers.
