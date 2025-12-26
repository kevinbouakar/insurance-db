USE `InsuranceDB`;

DELIMITER $$

-- ==================== STORED PROCEDURES ====================

-- 1. Search customers by filters (phone, email, name)
CREATE PROCEDURE sp_SearchCustomers(
    IN p_search_term VARCHAR(100)
)
BEGIN
    SELECT 
        c.customer_id,
        c.customer_name,
        c.customer_email,
        c.customer_phone,
        c.customer_address,
        a.agent_name
    FROM Customer c
    JOIN Agent a ON c.Agent_agent_id = a.agent_id
    WHERE c.customer_name LIKE CONCAT('%', p_search_term, '%')
       OR c.customer_email LIKE CONCAT('%', p_search_term, '%')
       OR c.customer_phone LIKE CONCAT('%', p_search_term, '%');
END$$

-- 2. Get policies by type with customer count
CREATE PROCEDURE sp_GetPoliciesByType(
    IN p_policy_type VARCHAR(50)
)
BEGIN
    SELECT 
        p.policy_id,
        p.policy_type,
        p.policy_cost,
        p.policy_durationMonths,
        COUNT(cp.customerpolicy_id) as total_customers
    FROM Policy p
    LEFT JOIN CustomerPolicy cp ON p.policy_id = cp.Policy_policy_id
    WHERE p.policy_type LIKE CONCAT('%', p_policy_type, '%')
    GROUP BY p.policy_id;
END$$

-- 3. Get customer's full policy details with payments and claims
CREATE PROCEDURE sp_GetCustomerPolicyDetails(
    IN p_customer_id INT
)
BEGIN
    SELECT 
        c.customer_name,
        p.policy_type,
        cp.customerpolicy_status,
        cp.customerpolicy_startDate,
        cp.customerpolicy_endDate,
        COALESCE(SUM(pay.payment_amount), 0) as total_paid,
        COALESCE(SUM(cl.claim_amount), 0) as total_claimed,
        COUNT(DISTINCT pay.payment_id) as payment_count,
        COUNT(DISTINCT cl.claim_id) as claim_count
    FROM Customer c
    JOIN CustomerPolicy cp ON c.customer_id = cp.Customer_customer_id
    JOIN Policy p ON cp.Policy_policy_id = p.policy_id
    LEFT JOIN Payment pay ON cp.customerpolicy_id = pay.CustomerPolicy_customerpolicy_id
    LEFT JOIN Claim cl ON cp.customerpolicy_id = cl.CustomerPolicy_customerpolicy_id
    WHERE c.customer_id = p_customer_id
    GROUP BY cp.customerpolicy_id;
END$$

-- 4. Filter claims by status
CREATE PROCEDURE sp_GetClaimsByStatus(
    IN p_status VARCHAR(20)
)
BEGIN
    SELECT 
        cl.claim_id,
        c.customer_name,
        c.customer_phone,
        p.policy_type,
        cl.claim_date,
        cl.claim_amount,
        cl.claim_status,
        cl.claim_description
    FROM Claim cl
    JOIN CustomerPolicy cp ON cl.CustomerPolicy_customerpolicy_id = cp.customerpolicy_id
    JOIN Customer c ON cp.Customer_customer_id = c.customer_id
    JOIN Policy p ON cp.Policy_policy_id = p.policy_id
    WHERE cl.claim_status = p_status
    ORDER BY cl.claim_date DESC;
END$$

-- 5. Get payment history by date range
CREATE PROCEDURE sp_GetPaymentsByDateRange(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT 
        pay.payment_id,
        c.customer_name,
        c.customer_email,
        c.customer_phone,
        p.policy_type,
        pay.payment_amount,
        pay.payment_date,
        pay.payment_method
    FROM Payment pay
    JOIN CustomerPolicy cp ON pay.CustomerPolicy_customerpolicy_id = cp.customerpolicy_id
    JOIN Customer c ON cp.Customer_customer_id = c.customer_id
    JOIN Policy p ON cp.Policy_policy_id = p.policy_id
    WHERE pay.payment_date BETWEEN p_start_date AND p_end_date
    ORDER BY pay.payment_date DESC;
END$$

-- 6. Transaction: Process new policy purchase with payment
CREATE PROCEDURE sp_PurchasePolicy(
    IN p_customer_id INT,
    IN p_policy_id INT,
    IN p_payment_amount DECIMAL(10,2),
    IN p_payment_method VARCHAR(50),
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE v_customerpolicy_id INT;
    DECLARE v_policy_cost DECIMAL(10,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'ERROR: Transaction failed';
    END;
    
    START TRANSACTION;
    
    -- Get policy cost
    SELECT policy_cost INTO v_policy_cost FROM Policy WHERE policy_id = p_policy_id;
    
    -- Validate payment amount
    IF p_payment_amount < v_policy_cost THEN
        ROLLBACK;
        SET p_result = 'ERROR: Insufficient payment amount';
    ELSE
        -- Create customer policy
        INSERT INTO CustomerPolicy (customerpolicy_startDate, customerpolicy_endDate, customerpolicy_status, Customer_customer_id, Policy_policy_id)
        VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 12 MONTH), 'Active', p_customer_id, p_policy_id);
        
        SET v_customerpolicy_id = LAST_INSERT_ID();
        
        -- Record payment
        INSERT INTO Payment (payment_amount, payment_date, payment_method, CustomerPolicy_customerpolicy_id)
        VALUES (p_payment_amount, CURDATE(), p_payment_method, v_customerpolicy_id);
        
        COMMIT;
        SET p_result = CONCAT('SUCCESS: Policy purchased with ID ', v_customerpolicy_id);
    END IF;
END$$

-- 7. Transaction: File new claim
CREATE PROCEDURE sp_FileClaim(
    IN p_customerpolicy_id INT,
    IN p_claim_amount DECIMAL(10,2),
    IN p_description TEXT,
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE v_policy_status VARCHAR(20);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'ERROR: Claim filing failed';
    END;
    
    START TRANSACTION;
    
    -- Check if policy is active
    SELECT customerpolicy_status INTO v_policy_status 
    FROM CustomerPolicy 
    WHERE customerpolicy_id = p_customerpolicy_id;
    
    IF v_policy_status != 'Active' THEN
        ROLLBACK;
        SET p_result = 'ERROR: Policy is not active';
    ELSE
        INSERT INTO Claim (claim_date, claim_amount, claim_status, claim_description, CustomerPolicy_customerpolicy_id)
        VALUES (CURDATE(), p_claim_amount, 'Pending', p_description, p_customerpolicy_id);
        
        COMMIT;
        SET p_result = CONCAT('SUCCESS: Claim filed with ID ', LAST_INSERT_ID());
    END IF;
END$$

-- ==================== FUNCTIONS ====================

-- 1. Calculate total revenue from a customer
CREATE FUNCTION fn_GetCustomerRevenue(p_customer_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_revenue DECIMAL(10,2);
    
    SELECT COALESCE(SUM(pay.payment_amount), 0) INTO total_revenue
    FROM Payment pay
    JOIN CustomerPolicy cp ON pay.CustomerPolicy_customerpolicy_id = cp.customerpolicy_id
    WHERE cp.Customer_customer_id = p_customer_id;
    
    RETURN total_revenue;
END$$

-- 2. Calculate total claims for a customer
CREATE FUNCTION fn_GetCustomerTotalClaims(p_customer_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_claims DECIMAL(10,2);
    
    SELECT COALESCE(SUM(cl.claim_amount), 0) INTO total_claims
    FROM Claim cl
    JOIN CustomerPolicy cp ON cl.CustomerPolicy_customerpolicy_id = cp.customerpolicy_id
    WHERE cp.Customer_customer_id = p_customer_id;
    
    RETURN total_claims;
END$$

-- 3. Check if customer has active policies
CREATE FUNCTION fn_HasActivePolicy(p_customer_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE has_active INT;
    
    SELECT COUNT(*) INTO has_active
    FROM CustomerPolicy
    WHERE Customer_customer_id = p_customer_id
      AND customerpolicy_status = 'Active';
    
    RETURN has_active > 0;
END$$

-- ==================== CURSOR EXAMPLE ====================

-- Generate monthly revenue report using cursor
CREATE PROCEDURE sp_GenerateMonthlyReport(
    IN p_month INT,
    IN p_year INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_policy_type VARCHAR(50);
    DECLARE v_total_revenue DECIMAL(10,2);
    DECLARE v_total_claims DECIMAL(10,2);
    
    DECLARE policy_cursor CURSOR FOR
        SELECT 
            p.policy_type,
            COALESCE(SUM(pay.payment_amount), 0) as revenue,
            COALESCE(SUM(cl.claim_amount), 0) as claims
        FROM Policy p
        LEFT JOIN CustomerPolicy cp ON p.policy_id = cp.Policy_policy_id
        LEFT JOIN Payment pay ON cp.customerpolicy_id = pay.CustomerPolicy_customerpolicy_id
            AND MONTH(pay.payment_date) = p_month 
            AND YEAR(pay.payment_date) = p_year
        LEFT JOIN Claim cl ON cp.customerpolicy_id = cl.CustomerPolicy_customerpolicy_id
            AND MONTH(cl.claim_date) = p_month 
            AND YEAR(cl.claim_date) = p_year
        GROUP BY p.policy_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Create temp table for results
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_report (
        policy_type VARCHAR(50),
        revenue DECIMAL(10,2),
        claims DECIMAL(10,2),
        profit DECIMAL(10,2)
    );
    
    OPEN policy_cursor;
    
    read_loop: LOOP
        FETCH policy_cursor INTO v_policy_type, v_total_revenue, v_total_claims;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        INSERT INTO temp_report VALUES (
            v_policy_type, 
            v_total_revenue, 
            v_total_claims, 
            v_total_revenue - v_total_claims
        );
    END LOOP;
    
    CLOSE policy_cursor;
    
    SELECT * FROM temp_report;
    DROP TEMPORARY TABLE temp_report;
END$$

DELIMITER ;