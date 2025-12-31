USE `InsuranceDB`;

-- Create Users
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER IF NOT EXISTS 'staff_user'@'localhost' IDENTIFIED BY 'Staff@123';

-- Admin Role: Full access
GRANT ALL PRIVILEGES ON InsuranceDB.* TO 'admin_user'@'localhost';

-- Staff Role: Can view and modify customers, policies, payments, claims
GRANT SELECT, INSERT, UPDATE ON InsuranceDB.Customer TO 'staff_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON InsuranceDB.CustomerPolicy TO 'staff_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON InsuranceDB.Payment TO 'staff_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON InsuranceDB.Claim TO 'staff_user'@'localhost';
GRANT SELECT ON InsuranceDB.Policy TO 'staff_user'@'localhost';
GRANT SELECT ON InsuranceDB.Agent TO 'staff_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;