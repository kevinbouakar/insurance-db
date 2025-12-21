USE `InsuranceDB`;

-- View: Active Policies with Customer Details
CREATE VIEW vw_ActivePolicies AS
SELECT 
    cp.customerpolicy_id,
    c.customer_name,
    c.customer_email,
    p.policy_type,
    p.policy_cost,
    cp.customerpolicy_startDate,
    cp.customerpolicy_endDate,
    a.agent_name
FROM CustomerPolicy cp
JOIN Customer c ON cp.Customer_customer_id = c.customer_id
JOIN Policy p ON cp.Policy_policy_id = p.policy_id
JOIN Agent a ON c.Agent_agent_id = a.agent_id
WHERE cp.customerpolicy_status = 'Active';

-- View: Payment History Summary
CREATE VIEW vw_PaymentHistory AS
SELECT 
    c.customer_name,
    p.policy_type,
    pay.payment_date,
    pay.payment_amount,
    pay.payment_method
FROM Payment pay
JOIN CustomerPolicy cp ON pay.CustomerPolicy_customerpolicy_id = cp.customerpolicy_id
JOIN Customer c ON cp.Customer_customer_id = c.customer_id
JOIN Policy p ON cp.Policy_policy_id = p.policy_id
ORDER BY pay.payment_date DESC;

-- View: Claims Status Report
CREATE VIEW vw_ClaimsReport AS
SELECT 
    c.customer_name,
    cl.claim_date,
    cl.claim_amount,
    cl.claim_status,
    cl.claim_description,
    p.policy_type
FROM Claim cl
JOIN CustomerPolicy cp ON cl.CustomerPolicy_customerpolicy_id = cp.customerpolicy_id
JOIN Customer c ON cp.Customer_customer_id = c.customer_id
JOIN Policy p ON cp.Policy_policy_id = p.policy_id;

-- View: Agent Performance
CREATE VIEW vw_AgentPerformance AS
SELECT 
    a.agent_name,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT cp.customerpolicy_id) AS total_policies
FROM Agent a
LEFT JOIN Customer c ON a.agent_id = c.Agent_agent_id
LEFT JOIN CustomerPolicy cp ON c.customer_id = cp.Customer_customer_id
GROUP BY a.agent_id, a.agent_name;
