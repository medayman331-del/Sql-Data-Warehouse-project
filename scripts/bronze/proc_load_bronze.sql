/*
===============================================================================
Stored Procedure: bronze.load_bronze
===============================================================================
Script Purpose:
    This stored procedure loads raw data into the 'bronze' schema from external 
    CSV files (CRM and ERP sources). 
    It performs a 'Truncate and Load' operation to ensure the bronze layer always 
    contains the latest snapshot of the source data.

Parameters:
    None.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    -- Declare variables for tracking execution time per table and total batch duration
    DECLARE @start_time DATETIME, @end_time DATETIME;
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        -- Mark the start of the entire batch load
        SET @batch_start_time = GETDATE();
        PRINT '==================================================';
        PRINT 'Loading Bronze Layer Started';
        PRINT '==================================================';

        ---------------------------------------------------------------------------
        -- 1. Loading CRM Customer Info
        ---------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating & Loading: bronze.crm_cust_info';
        
        -- Clear existing raw data to prevent duplication
        TRUNCATE TABLE bronze.crm_cust_info;

        -- Bulk insert fresh data from CSV source file
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------------------------------------
        -- 2. Loading CRM Products Info
        ---------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating & Loading: bronze.crm_prd_info';
        
        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------------------------------------
        -- 3. Loading CRM Sales Details
        ---------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating & Loading: bronze.crm_sales_details';
        
        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------------------------------------
        -- 4. Loading ERP Customer Demographics
        ---------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating & Loading: bronze.erp_cust_az12';
        
        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------------------------------------
        -- 5. Loading ERP Customer Locations
        ---------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating & Loading: bronze.erp_loc_a101';
        
        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ---------------------------------------------------------------------------
        -- 6. Loading ERP Product Categories
        ---------------------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating & Loading: bronze.erp_px_cat_g1v2';
        
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Mark the successful completion of the batch load
        SET @batch_end_time = GETDATE();
        PRINT '==================================================';
        PRINT 'Bronze Layer Load Completed Successfully!';
        PRINT 'Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==================================================';

    END TRY
    BEGIN CATCH
        -- Error handling block to capture and print issues if any step fails
        PRINT '==================================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LAYER LOADING!';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT '==================================================';
    END CATCH
END;
GO
