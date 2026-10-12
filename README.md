# Data Warehouse Pipeline & Analytics

Simple and structured Data Warehouse pipeline based on the Medallion Architecture (Bronze, Silver, Gold).

---

## 👨‍💻 About Me
Hi, I'm **Mohammed Al-Awadhi**. I'm interested in data analytics and data management, focusing on cleaning, structuring, and modeling data for better decision-making.

---

## 🏗️ Architecture Layers

### 1. Sources
* **Systems:** ERP & CRM
* **Format:** CSV files in folders

### 2. Bronze Layer (Raw Data)
* **Type:** Tables
* **Load Method:** Batch processing (Full load - Truncate and Insert)
* **Logic:** Stores raw data as-is without any transformations

### 3. Silver Layer (Cleaned & Standardized)
* **Type:** Tables
* **Load Method:** Batch processing (Full load - Truncate and Insert)
* **Logic:** 
  * Data cleansing & deduplication
  * Standardization & normalization
  * Derived columns & data enrichment

### 4. Gold Layer (Business Ready)
* **Type:** Views (No load required)
* **Logic:**
* * Data cleansing & deduplication
  * Standardization & normalization
  * Derived columns & data enrichment

### 4. Gold Layer (Business Ready)
* **Type:** Views (No load required)
* **Logic:**
  * Data integrations & aggregations
  * Business rules implementation
* **Data Models:** Star Schema, Flat Tables, Aggregated Tables
  * Data integrations & aggregations
  * Business rules implementation
* **Data Models:** Star Schema, Flat Tables, Aggregated Tables
