USE `InsuranceDB`;

DELIMITER $$

-- 1. Trigger: Prevent deleting Agent if they have Customers
CREATE TRIGGER trg_prevent_agent_delete
BEFORE DELETE ON Agent
FOR EACH ROW
	BEGIN
		    DECLARE customer_count INT;
		    SELECT COUNT(*) INTO customer_count FROM Customer WHERE Agent_agent_id = OLD.agent_id;
		    IF customer_count > 0 THEN
			        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete Agent with existing Customers';
				    END IF;
			END$$

-- 2. Trigger: Prevent deleting Customer if they have active policies
CREATE TRIGGER trg_prevent_customer_delete
BEFORE DELETE ON Customer
FOR EACH ROW
	BEGIN
		    DECLARE policy_count INT;
		    SELECT COUNT(*) INTO policy_count FROM CustomerPolicy WHERE Customer_customer_id = OLD.customer_id;
		    IF policy_count > 0 THEN
			        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete Customer with existing policies';
		 END IF;
	END$$

-- 3. Trigger: Validate payment amount is positive
CREATE TRIGGER trg_validate_payment
BEFORE INSERT ON Payment
FOR EACH ROW
	BEGIN
		    IF NEW.payment_amount <= 0 THEN
		    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment amount must be positive';
				    END IF;
			END$$

-- 4. Trigger: Validate claim amount is positive
CREATE TRIGGER trg_validate_claim
BEFORE INSERT ON Claim
FOR EACH ROW
	BEGIN
		    IF NEW.claim_amount <= 0 THEN
			        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Claim amount must be positive';
				    END IF;
			END$$

			DELIMITER ;
