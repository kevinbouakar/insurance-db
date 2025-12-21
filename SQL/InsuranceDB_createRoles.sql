USE `InsuranceDB`;

-- Create Users
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER IF NOT EXISTS 'agent_user'@'localhost' IDENTIFIED BY 'Agent@123';
CREATE USER IF NOT EXISTS 'readonly_user'@'localhost' IDENTIFIED BY 'Read@123';

-- Admin Role: Full access
GRANT ALL PRIVILEGES ON InsuranceDB.* TO 'admin_user'@'localhost';

-- Agent Role: Can view and insert customers, policies, payments, claims
GRANT SELECT, INSERT, UPDATE ON InsuranceDB.Customer TO 'agent_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON InsuranceDB.CustomerPolicy TO 'agent_user'@'localhost';
GRANT SELECT, INSERT ON InsuranceDB.Payment TO 'agent_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON InsuranceDB.Claim TO 'agent_user'@'localhost';
GRANT SELECT ON InsuranceDB.Policy TO 'agent_user'@'localhost';
GRANT SELECT ON InsuranceDB.Agent TO 'agent_user'@'localhost';

-- Read-Only Role: View-only access
GRANT SELECT ON InsuranceDB.* TO 'readonly_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;
