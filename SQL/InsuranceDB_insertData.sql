USE `InsuranceDB`;

-- Insert Agents
INSERT INTO Agent (agent_name, agent_email, agent_phone) VALUES
('John Smith', 'john.smith@insurance.com', '555-0101'),
('Sarah Johnson', 'sarah.j@insurance.com', '555-0102'),
('Mike Brown', 'mike.brown@insurance.com', '555-0103'),
('Emily Davis', 'emily.d@insurance.com', '555-0104'),
('David Wilson', 'david.w@insurance.com', '555-0105'),
('Lisa Martinez', 'lisa.m@insurance.com', '555-0106'),
('Tom Anderson', 'tom.a@insurance.com', '555-0107'),
('Rachel White', 'rachel.w@insurance.com', '555-0108'),
('Kevin Lee', 'kevin.l@insurance.com', '555-0109'),
('Nancy Taylor', 'nancy.t@insurance.com', '555-0110'),
('Paul Garcia', 'paul.g@insurance.com', '555-0111'),
('Michelle Moore', 'michelle.m@insurance.com', '555-0112'),
('Steven Clark', 'steven.c@insurance.com', '555-0113');

-- Insert Policy Types
INSERT INTO Policy (policy_type, policy_cost, policy_durationMonths) VALUES
('Car Insurance', 500.00, 12),
('Health Insurance', 1200.00, 12),
('Home Insurance', 800.00, 12),
('Life Insurance', 2000.00, 24),
('Travel Insurance', 300.00, 6),
('Motorcycle Insurance', 400.00, 12),
('Business Insurance', 1500.00, 12),
('Pet Insurance', 250.00, 12),
('Dental Insurance', 600.00, 12),
('Vision Insurance', 350.00, 12),
('Disability Insurance', 900.00, 24),
('Flood Insurance', 700.00, 12),
('Earthquake Insurance', 1100.00, 12);

-- Insert Customer Policies
INSERT INTO CustomerPolicy (customerpolicy_startDate, customerpolicy_endDate, customerpolicy_status, Customer_customer_id, Policy_policy_id) VALUES
('2024-01-15', '2025-01-15', 'Active', 1, 1),
('2024-02-01', '2025-02-01', 'Active', 2, 2),
('2024-03-10', '2025-03-10', 'Active', 3, 3),
('2024-04-05', '2026-04-05', 'Active', 4, 4),
('2024-05-20', '2024-11-20', 'Expired', 5, 5),
('2024-06-15', '2025-06-15', 'Active', 6, 1),
('2024-07-01', '2025-07-01', 'Active', 7, 2),
('2024-08-10', '2025-08-10', 'Cancelled', 8, 3),
('2024-09-05', '2025-09-05', 'Active', 9, 1),
('2024-10-20', '2025-10-20', 'Active', 10, 2),
('2024-11-01', '2025-11-01', 'Active', 11, 6),
('2024-11-15', '2025-11-15', 'Active', 12, 7),
('2024-12-01', '2025-12-01', 'Active', 13, 8),
('2024-12-10', '2025-12-10', 'Active', 14, 9),
('2024-12-15', '2025-12-15', 'Active', 15, 10),
('2024-12-18', '2026-12-18', 'Active', 16, 11),
('2024-12-20', '2025-12-20', 'Active', 17, 12),
('2024-12-21', '2025-12-21', 'Active', 18, 13);

-- Insert Payments
INSERT INTO Payment (payment_amount, payment_date, payment_method, CustomerPolicy_customerpolicy_id) VALUES
(500.00, '2024-01-15', 'Credit Card', 1),
(1200.00, '2024-02-01', 'Bank Transfer', 2),
(800.00, '2024-03-10', 'Cash', 3),
(2000.00, '2024-04-05', 'Credit Card', 4),
(300.00, '2024-05-20', 'Debit Card', 5),
(500.00, '2024-06-15', 'Credit Card', 6),
(1200.00, '2024-07-01', 'Bank Transfer', 7),
(500.00, '2024-09-05', 'Cash', 9),
(1200.00, '2024-10-20', 'Credit Card', 10),
(400.00, '2024-11-01', 'Debit Card', 11),
(1500.00, '2024-11-15', 'Bank Transfer', 12),
(250.00, '2024-12-01', 'Credit Card', 13),
(600.00, '2024-12-10', 'Cash', 14),
(350.00, '2024-12-15', 'Credit Card', 15),
(900.00, '2024-12-18', 'Bank Transfer', 16),
(700.00, '2024-12-20', 'Debit Card', 17),
(1100.00, '2024-12-21', 'Credit Card', 18);

-- Insert Claims
INSERT INTO Claim (claim_date, claim_amount, claim_status, claim_description, CustomerPolicy_customerpolicy_id) VALUES
('2024-03-20', 2500.00, 'Approved', 'Car accident damage', 1),
('2024-04-15', 5000.00, 'Pending', 'Medical surgery expenses', 2),
('2024-05-10', 15000.00, 'Approved', 'House fire damage', 3),
('2024-06-25', 1000.00, 'Rejected', 'Pre-existing condition', 4),
('2024-08-12', 3000.00, 'Approved', 'Car collision repair', 6),
('2024-09-18', 8000.00, 'Pending', 'Hospitalization costs', 7),
('2024-11-05', 1500.00, 'Approved', 'Minor car accident', 9),
('2024-11-10', 4500.00, 'Approved', 'Emergency room visit', 10),
('2024-11-20', 2000.00, 'Pending', 'Motorcycle accident', 11),
('2024-12-02', 10000.00, 'Approved', 'Business property damage', 12),
('2024-12-05', 800.00, 'Approved', 'Pet surgery', 13),
('2024-12-12', 1200.00, 'Pending', 'Dental emergency', 14),
('2024-12-16', 500.00, 'Approved', 'Eye surgery', 15),
('2024-12-19', 25000.00, 'Pending', 'Long-term disability claim', 16),
('2024-12-21', 18000.00, 'Approved', 'Earthquake damage to home', 18);