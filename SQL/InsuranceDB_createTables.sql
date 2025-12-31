USE `InsuranceDB`;

CREATE TABLE IF NOT EXISTS `Agent` (
	  `agent_id` INT NOT NULL AUTO_INCREMENT,
	  `agent_name` VARCHAR(100) NOT NULL,
	  `agent_email` VARCHAR(100) NOT NULL,
	  `agent_phone` VARCHAR(45) NULL,
	  PRIMARY KEY (`agent_id`))
	ENGINE = InnoDB;
	SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS `Customer` (
		  `customer_id` INT NOT NULL AUTO_INCREMENT,
		  `customer_name` VARCHAR(100) NOT NULL,
		  `customer_email` VARCHAR(100) NOT NULL,
		  `customer_phone` VARCHAR(20) NOT NULL,
		  `customer_address` VARCHAR(255) NULL,
		  `Agent_agent_id` INT NOT NULL,
		  PRIMARY KEY (`customer_id`),
		  CONSTRAINT `fk_Customer_Agent`
		    FOREIGN KEY (`Agent_agent_id`)
		    REFERENCES `Agent` (`agent_id`)
		    ON DELETE NO ACTION
		    ON UPDATE NO ACTION)
		ENGINE = InnoDB;
		SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS `Policy` (
		  `policy_id` INT NOT NULL AUTO_INCREMENT,
		  `policy_type` VARCHAR(50) NOT NULL,
		  `policy_cost` DECIMAL(10,2) NOT NULL,
		  `policy_durationMonths` INT NOT NULL,
		PRIMARY KEY (`policy_id`))
		ENGINE = InnoDB;
		SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS `CustomerPolicy` (
  `customerpolicy_id` INT NOT NULL AUTO_INCREMENT,
  `customerpolicy_startDate` DATE NOT NULL,
  `customerpolicy_endDate` DATE NULL,
  `customerpolicy_status` VARCHAR(20) NOT NULL,
  `Customer_customer_id` INT NOT NULL,
  `Policy_policy_id` INT NOT NULL,
  PRIMARY KEY (`customerpolicy_id`),
  CONSTRAINT `fk_CustomerPolicy_Customer1`
    FOREIGN KEY (`Customer_customer_id`)
    REFERENCES `Customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CustomerPolicy_Policy1`
    FOREIGN KEY (`Policy_policy_id`)
    REFERENCES `Policy` (`policy_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS `Payment` (
	`payment_id` INT NOT NULL AUTO_INCREMENT,
	`payment_amount` DECIMAL(10,2) NOT NULL,
	`payment_date` DATE NOT NULL,
	`payment_method` VARCHAR(50) NULL,
	`CustomerPolicy_customerpolicy_id` INT NOT NULL,
	PRIMARY KEY (`payment_id`),
	CONSTRAINT `fk_Payment_CustomerPolicy1`
   FOREIGN KEY (`CustomerPolicy_customerpolicy_id`)
   REFERENCES `CustomerPolicy` (`customerpolicy_id`)
   ON DELETE NO ACTION
   ON UPDATE NO ACTION)
ENGINE = InnoDB;
SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS `Claim` (
		  `claim_id` INT NOT NULL AUTO_INCREMENT,
		  `claim_date` DATE NOT NULL,
		  `claim_amount` DECIMAL(10,2) NOT NULL,
		  `claim_status` VARCHAR(20) NOT NULL,
		  `claim_description` TEXT NULL,
		  `CustomerPolicy_customerpolicy_id` INT NOT NULL,
		PRIMARY KEY (`claim_id`),
		CONSTRAINT `fk_Claim_CustomerPolicy1`
	   	FOREIGN KEY (`CustomerPolicy_customerpolicy_id`)
	   	REFERENCES `CustomerPolicy` (`customerpolicy_id`)
	   	ON DELETE NO ACTION
	   	ON UPDATE NO ACTION)
	ENGINE = InnoDB;
	SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS staff (
    staff_email VARCHAR(100) NOT NULL UNIQUE PRIMARY KEY,
    staff_password VARCHAR(255) NOT NULL,
    staff_name VARCHAR(100) NOT NULL,
    staff_role VARCHAR(10) NOT NULL
) ENGINE=InnoDB;
SHOW WARNINGS;


