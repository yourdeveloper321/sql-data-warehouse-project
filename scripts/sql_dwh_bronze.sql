-- Overview
-- This SQL script creates a stored procedure named bronze.load_data() in MySQL. The procedure is responsible for dropping and recreating six tables inside the bronze schema. It ensures data consistency by using transactions and includes error handling to prevent execution failures from leaving the database in an inconsistent state.

-- Functionality
-- Error Handling

-- The procedure declares an exit handler that catches any SQL exceptions (SQLEXCEPTION).
-- If an error occurs, it rolls back the transaction and displays an error message.
-- Transaction Control

-- A transaction (START TRANSACTION) is initiated to ensure that all table creations are executed as a single atomic operation.
-- If any step fails, a rollback (ROLLBACK) occurs, undoing any changes.
-- If all steps succeed, the commit (COMMIT) ensures changes are permanently saved.
-- Table Creation Process

-- Each table is dropped (DROP TABLE IF EXISTS) before being recreated (CREATE TABLE) to avoid conflicts.
-- Status messages (SELECT 'message' AS message;) are included at each step to indicate progress.


CALL bronze.load_data();

DELIMITER $$

CREATE PROCEDURE bronze.load_data()
BEGIN
    DECLARE exit handler FOR SQLEXCEPTION 
    BEGIN
        -- Capture the error and display message
        SELECT 'An error occurred. Rolling back changes...' AS message;
        ROLLBACK;
    END;

    -- Start transaction to ensure rollback on failure
    START TRANSACTION;

    -- Step 1: Drop and Create Table crm_prd_info
    SELECT 'Starting table creation process...' AS message;
    SELECT 'Dropping table: bronze.crm_prd_info...' AS message;
    DROP TABLE IF EXISTS bronze.crm_prd_info;
    SELECT 'Creating table: bronze.crm_prd_info...' AS message;
    CREATE TABLE bronze.crm_prd_info (
        prd_id INT DEFAULT NULL, 
        prd_key VARCHAR(255) DEFAULT NULL,
        prd_nm VARCHAR(100) DEFAULT NULL,
        prd_cost DECIMAL(10,2) DEFAULT NULL,
        prd_line VARCHAR(50) DEFAULT NULL,
        prd_start_dt VARCHAR(10) DEFAULT NULL,
        prd_end_dt VARCHAR(10) DEFAULT NULL
    );
    SELECT 'Table bronze.crm_prd_info created successfully.' AS message;

    -- Step 2: Drop and Create Table crm_cust_info
    SELECT 'Dropping table: bronze.crm_cust_info...' AS message;
    DROP TABLE IF EXISTS bronze.crm_cust_info;
    SELECT 'Creating table: bronze.crm_cust_info...' AS message;
    CREATE TABLE bronze.crm_cust_info (
        cst_id INT DEFAULT NULL, 
        cst_key VARCHAR(255) DEFAULT NULL,
        cst_fnm VARCHAR(100) DEFAULT NULL,
        cst_lsn VARCHAR(100) DEFAULT NULL,
        cst_marital_status VARCHAR(50) DEFAULT NULL,
        cst_gndr VARCHAR(10) DEFAULT NULL,
        cst_create_date VARCHAR(10) DEFAULT NULL
    );
    SELECT 'Table bronze.crm_cust_info created successfully.' AS message;

    -- Step 3: Drop and Create Table bronze.sales_details
    SELECT 'Dropping table: bronze.crm_sales_details...' AS message;
    DROP TABLE IF EXISTS bronze.crm_sales_details;
    SELECT 'Creating table: bronze.crm_sales_details...' AS message;
    CREATE TABLE bronze.crm_sales_details (
        sls_ord_num VARCHAR(100) DEFAULT NULL,
        sls_prd_key VARCHAR(100) DEFAULT NULL,
        sls_cust_id INT DEFAULT NULL,
        sls_order_dt VARCHAR(100) DEFAULT NULL,
        sls_ship_dt VARCHAR(100) DEFAULT NULL,
        sls_due_dt VARCHAR(100) DEFAULT NULL,
        sls_sales INT DEFAULT NULL,
        sls_quantity INT DEFAULT NULL,
        sls_price INT DEFAULT NULL
    );
    SELECT 'Table bronze.crm_sales_details created successfully.' AS message;

    -- Step 4: Drop and Create Table bronze.customers
    SELECT 'Dropping table: bronze.erp_cust_az12...' AS message;
    DROP TABLE IF EXISTS bronze.erp_cust_az12;
    SELECT 'Creating table: bronze.erp_cust_az12...' AS message;
    CREATE TABLE bronze.erp_cust_az12 (
        CID VARCHAR(255) DEFAULT NULL,
        BDATE VARCHAR(255) DEFAULT NULL,
        GEN VARCHAR(255) DEFAULT NULL
    );
    SELECT 'Table bronze.erp_cust_az12 created successfully.' AS message;

    -- Step 5: Drop and Create Table bronze.erp_loc_a101
    SELECT 'Dropping table: bronze.erp_loc_a101...' AS message;
    DROP TABLE IF EXISTS bronze.erp_loc_a101;
    SELECT 'Creating table: bronze.erp_loc_a101...' AS message;
    CREATE TABLE bronze.erp_loc_a101 (
        CID VARCHAR(50) DEFAULT NULL,
        CNTRY VARCHAR(50) DEFAULT NULL
    );
    SELECT 'Table bronze.erp_loc_a101 created successfully.' AS message;

    -- Step 6: Drop and Create Table bronze.erp_px_cat_g1v2
    SELECT 'Dropping table: bronze.erp_px_cat_g1v2...' AS message;
    DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
    SELECT 'Creating table: bronze.erp_px_cat_g1v2...' AS message;
    CREATE TABLE bronze.erp_px_cat_g1v2 (             
        ID VARCHAR(50) DEFAULT NULL,
        CAT VARCHAR(50) DEFAULT NULL,
        SUBCAT VARCHAR(50) DEFAULT NULL,
        MAINTENANCE VARCHAR(50) DEFAULT NULL
    );
    SELECT 'Table bronze.erp_px_cat_g1v2 created successfully.' AS message;

    -- Commit Transaction if no error occurs
    COMMIT;
    SELECT 'All tables have been created successfully.' AS message;
END $$

DELIMITER ;

SELECT 'All tables have been created successfully.' AS message;

-- Step 5: Verify Data
-- SELECT * FROM bronze.crm_cust_info;
-- SELECT * FROM bronze.crm_prd_info;
-- SELECT * FROM bronze.crm_sales_details;
-- SELECT * FROM bronze.erp_cust_az12;
-- SELECT * FROM bronze.erp_loc_a101;
-- SELECT * FROM bronze.erp_px_cat_g1v2;


