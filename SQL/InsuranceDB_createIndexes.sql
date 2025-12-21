USE `InsuranceDB`;

CREATE INDEX `fk_Customer_Agent_idx` ON `Customer` (`Agent_agent_id` ASC) VISIBLE;
SHOW WARNINGS;

CREATE INDEX `fk_CustomerPolicy_Customer1_idx` ON `CustomerPolicy` (`Customer_customer_id` ASC) VISIBLE;
SHOW WARNINGS;

CREATE INDEX `fk_CustomerPolicy_Policy1_idx` ON `CustomerPolicy` (`Policy_policy_id` ASC) VISIBLE;
SHOW WARNINGS;

CREATE INDEX `fk_Payment_CustomerPolicy1_idx` ON `Payment` (`CustomerPolicy_customerpolicy_id` ASC) VISIBLE;
SHOW WARNINGS;

CREATE INDEX `fk_Claim_CustomerPolicy1_idx` ON `Claim` (`CustomerPolicy_customerpolicy_id` ASC) VISIBLE;
SHOW WARNINGS;
