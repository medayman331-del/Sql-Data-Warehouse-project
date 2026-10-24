# Data Catalog: Sales Data Mart (Gold Layer)

## Overview

The **Gold Layer** is the business-level data representation, structured as a **Star Schema** to support analytics and reporting. It consists of **two dimension tables** and **one fact table**.

| Table | Type | Purpose |
|---|---|---|
| `gold.dim_customers` | Dimension | Customer details enriched with demographic and geographic data |
| `gold.dim_products` | Dimension | Product details, categories, and cost information |
| `gold.fact_sales` | Fact | Transactional sales data used for analytics |

### Relationships

```
gold.dim_customers (1) ────< (many) gold.fact_sales (many) >──── (1) gold.dim_products
        customer_key                                                     product_key
```

- `gold.fact_sales.customer_key` → `gold.dim_customers.customer_key`
- `gold.fact_sales.product_key` → `gold.dim_products.product_key`

Surrogate keys (`customer_key`, `product_key`) are generated in the Data Warehouse and are independent of the source system identifiers.

---

## 1. `gold.dim_customers`

**Purpose:** Stores customer details enriched with demographic and geographic data. One row per customer.

**Grain:** One row per customer.

| Column | Data Type | Description |
|---|---|---|
| `customer_key` | INT | **Primary Key.** Surrogate key generated in the Data Warehouse, used to join with `fact_sales`. |
| `customer_id` | INT | Unique numerical identifier assigned to each customer in the source system. |
| `customer_number` | NVARCHAR(50) | Alphanumeric identifier of the customer, used for tracking and referencing. |
| `first_name` | NVARCHAR(50) | The customer's first name. |
| `last_name` | NVARCHAR(50) | The customer's last name or family name. |
| `country` | NVARCHAR(50) | The customer's country of residence (e.g., `Australia`). |
| `marital_status` | NVARCHAR(50) | The marital status of the customer (e.g., `Married`, `Single`). |
| `gender` | NVARCHAR(50) | The gender of the customer (e.g., `Male`, `Female`, `n/a`). |
| `birthdate` | DATE | The customer's date of birth, formatted as `YYYY-MM-DD`. |

**Sources:** `crm_cust_info` (customer information), `erp_cust_az12` (birthdate), `erp_loc_a101` (country).

---

## 2. `gold.dim_products`

**Purpose:** Provides information about products and their attributes. One row per product.

**Grain:** One row per product (current and historical versions are tracked by `start_date`).

| Column | Data Type | Description |
|---|---|---|
| `product_key` | INT | **Primary Key.** Surrogate key generated in the Data Warehouse, used to join with `fact_sales`. |
| `product_id` | INT | Unique identifier assigned to the product in the source system. |
| `product_number` | NVARCHAR(50) | Structured alphanumeric code of the product, used for categorization and inventory. |
| `product_name` | NVARCHAR(50) | Descriptive name of the product, including details such as type, color, and size. |
| `category_id` | NVARCHAR(50) | Identifier linking the product to its high-level category. |
| `category` | NVARCHAR(50) | Broader classification of the product (e.g., `Bikes`, `Components`). |
| `subcategory` | NVARCHAR(50) | More detailed classification of the product within its category. |
| `maintenance` | NVARCHAR(50) | Indicates whether the product requires maintenance (e.g., `Yes`, `No`). |
| `cost` | INT | The cost or base price of the product. Used to calculate profit. |
| `product_line` | NVARCHAR(50) | The product line or series the product belongs to (e.g., `Road`, `Mountain`). |
| `start_date` | DATE | The date the product became available for sale. |

**Sources:** `crm_prd_info` (current and historical product information), `erp_px_cat_g1v2` (category data).

---

## 3. `gold.fact_sales`

**Purpose:** Stores transactional sales data for analytical purposes.

**Grain:** One row per product per sales order line.

| Column | Data Type | Description |
|---|---|---|
| `order_number` | NVARCHAR(50) | Unique alphanumeric identifier for each sales order (e.g., `SO54496`). Degenerate dimension. |
| `product_key` | INT | **Foreign Key (FK1).** Links the order line to `gold.dim_products`. |
| `customer_key` | INT | **Foreign Key (FK2).** Links the order line to `gold.dim_customers`. |
| `order_date` | DATE | The date the order was placed. |
| `shipping_date` | DATE | The date the order was shipped to the customer. |
| `due_date` | DATE | The date the order payment was due. |
| `sales_amount` | INT | Total monetary value of the line item (e.g., `25`). |
| `quantity` | INT | Number of units of the product ordered in the line item. |
| `price` | INT | Price per unit of the product for the line item. |

**Business rule:** `sales_amount = quantity * price`

**Source:** `crm_sales_details` (transactional records about sales and orders).

---

## Source Systems and Integration Model

The Gold Layer is built from two source systems:

| Source | Table | Description | Join Key |
|---|---|---|---|
| CRM | `crm_sales_details` | Transactional records about sales and orders | `prd_key`, `cst_id` |
| CRM | `crm_prd_info` | Current and historical product information | `prd_key` |
| CRM | `crm_cust_info` | Customer information | `cst_id`, `cst_key` |
| ERP | `erp_px_cat_g1v2` | Product category information | `id` → `crm_prd_info.prd_key` |
| ERP | `erp_cust_az12` | Extra customer information (birthdate) | `cid` → `crm_cust_info.cst_key` |
| ERP | `erp_loc_a101` | Location of customers (country) | `cid` → `crm_cust_info.cst_key` |

### How the source tables are related

- `crm_sales_details.prd_key` → `crm_prd_info.prd_key`
- `crm_sales_details.cst_id` → `crm_cust_info.cst_id`
- `erp_px_cat_g1v2.id` → `crm_prd_info.prd_key`
- `erp_cust_az12.cid` → `crm_cust_info.cst_key`
- `erp_loc_a101.cid` → `crm_cust_info.cst_key`
