/* ===================================================================
 * Data Quality Tests: Gold Layer (Star Schema)
 * Description: SQL script to run data quality checks on Gold layer tables 
 * (dim_customers, dim_products, fact_sales) to ensure integrity, 
 * absence of duplicates, and validity of foreign keys and business rules.
 * =================================================================== */

-- ===================================================================
-- 1. Check for Duplicate Primary Keys in gold.dim_customers
-- Expected Result: 0 rows
-- ===================================================================
SELECT 
    customer_key, 
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ===================================================================
-- 2. Check for NULL Primary Keys in gold.dim_customers
-- Expected Result: 0 rows
-- ===================================================================
SELECT *
FROM gold.dim_customers
WHERE customer_key IS NULL;

-- ===================================================================
-- 3. Check for Duplicate Primary Keys in gold.dim_products
-- Expected Result: 0 rows
-- ===================================================================
SELECT 
    product_key, 
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ===================================================================
-- 4. Check for NULL Primary Keys in gold.dim_products
-- Expected Result: 0 rows
-- ===================================================================
SELECT *
FROM gold.dim_products
WHERE product_key IS NULL;

-- ===================================================================
-- 5. Check for Orphan Records (Invalid Foreign Keys) in fact_sales for customers
-- Description: Ensures every customer_key in fact_sales exists in dim_customers[cite: 2].
-- Expected Result: 0 rows
-- ===================================================================
SELECT 
    f.customer_key
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c 
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL AND f.customer_key IS NOT NULL;

-- ===================================================================
-- 6. Check for Orphan Records (Invalid Foreign Keys) in fact_sales for products
-- Description: Ensures every product_key in fact_sales exists in dim_products[cite: 2].
-- Expected Result: 0 rows
-- ===================================================================
SELECT 
    f.product_key
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p 
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL AND f.product_key IS NOT NULL;

-- ===================================================================
-- 7. Check Business Rule Integrity: sales_amount = quantity * price
-- Description: Validates that the sales amount matches the calculated product[cite: 2].
-- Expected Result: 0 rows
-- ===================================================================
SELECT 
    order_number,
    sales_amount,
    quantity,
    price,
    (quantity * price) AS calculated_sales
FROM gold.fact_sales
WHERE sales_amount <> (quantity * price);
