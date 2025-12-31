USE `InsuranceDB`;
SET FOREIGN_KEY_CHECKS=0;

INSERT INTO Agent (agent_name, agent_email, agent_phone) VALUES
('John Smith', 'john.smith@insurance.com', '555-0101'),
('Sarah Johnson', 'sarah.j@insurance.com', '555-0102'),
('Mike Brown', 'mike.brown@insurance.com', '555-0103'),
('Emily Davis', 'emily.d@insurance.com', '555-0104'),
('David Wilson', 'david.w@insurance.com', '555-0105');

INSERT INTO Customer (customer_name, customer_email, customer_password, customer_phone, customer_address, Agent_agent_id) VALUES
('Alice Green', 'alice.g@customer.com', 'hashedpass1', '555-1001', '123 Main St', 1),
('Bob White', 'bob.w@customer.com', 'hashedpass2', '555-1002', '456 Oak Ave', 2),
('Charlie Black', 'charlie.b@customer.com', 'hashedpass3', '555-1003', '789 Pine Rd', 3),
('Diana Gray', 'diana.g@customer.com', 'hashedpass4', '555-1004', '321 Maple Ln', 4),
('Ethan Blue', 'ethan.b@customer.com', 'hashedpass5', '555-1005', '654 Elm St', 5);

INSERT INTO Policy (policy_type, policy_cost, policy_durationMonths) VALUES
('Car Insurance', 500.00, 12),
('Health Insurance', 1200.00, 12),
('Home Insurance', 800.00, 12),
('Life Insurance', 2000.00, 24),
('Travel Insurance', 300.00, 6);

INSERT INTO CustomerPolicy (customerpolicy_startDate, customerpolicy_endDate, customerpolicy_status, Customer_customer_id, Policy_policy_id) VALUES
('2024-01-15', '2025-01-15', 'Active', 1, 1),
('2024-02-01', '2025-02-01', 'Active', 2, 2),
('2024-03-10', '2025-03-10', 'Active', 3, 3),
('2024-04-05', '2026-04-05', 'Active', 4, 4),
('2024-05-20', '2024-11-20', 'Expired', 5, 5);

INSERT INTO Payment (payment_amount, payment_date, payment_method, CustomerPolicy_customerpolicy_id) VALUES
(500.00, '2024-01-15', 'Credit Card', 1),
(1200.00, '2024-02-01', 'Bank Transfer', 2),
(800.00, '2024-03-10', 'Cash', 3),
(2000.00, '2024-04-05', 'Credit Card', 4),
(300.00, '2024-05-20', 'Debit Card', 5);

INSERT INTO Claim (claim_date, claim_amount, claim_status, claim_description, CustomerPolicy_customerpolicy_id) VALUES
('2024-03-20', 2500.00, 'Approved', 'Car accident damage', 1),
('2024-04-15', 5000.00, 'Pending', 'Medical surgery expenses', 2),
('2024-05-10', 15000.00, 'Approved', 'House fire damage', 3),
('2024-06-25', 1000.00, 'Rejected', 'Pre-existing condition', 4),
('2024-08-12', 3000.00, 'Approved', 'Car collision repair', 5);

INSERT INTO Staff (staff_email, staff_password, staff_name, staff_role) VALUES
('admin@circo.com', '$2y$12$8.wyZiS21KqXXWV2DkRl6..ViBT0yaHWPp4cApBSuxmFYZHKJKKKm', 'System Admin', 'Admin'),
('staff@circo.com', '$2y$12$m6vmeKf1TRdsBsYQ6blPwubc0N.1kTSUy46GVw/GuwTU6dTkw3Mga', 'Staff', 'Staff');

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
