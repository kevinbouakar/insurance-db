USE `InsuranceDB`;

CREATE INDEX `fk_Customer_Agent_idx` ON `customer` (`Agent_agent_id` ASC) VISIBLE;
SHOW WARNINGS;
CREATE INDEX `fk_CustomerPolicy_Customer1_idx` ON `customerpolicy` (`Customer_customer_id` ASC) VISIBLE;
SHOW WARNINGS;
CREATE INDEX `fk_CustomerPolicy_Policy1_idx` ON `customerpolicy` (`Policy_policy_id` ASC) VISIBLE;
SHOW WARNINGS;
CREATE INDEX `fk_Payment_CustomerPolicy1_idx` ON `payment` (`CustomerPolicy_customerpolicy_id` ASC) VISIBLE;
SHOW WARNINGS;
CREATE INDEX `fk_Claim_CustomerPolicy1_idx` ON `claim` (`CustomerPolicy_customerpolicy_id` ASC) VISIBLE;
SHOW WARNINGS;
