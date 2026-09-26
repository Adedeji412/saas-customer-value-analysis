SELECT COUNT(*) FROM feature_usage;
SELECT COUNT(*) FROM support_tickets;
SELECT COUNT(*) FROM subscriptions;
SELECT * FROM support_tickets;
SELECT * FROM churn_events;
SELECT * FROM accounts;
SELECT * FROM feature_usage;
SELECT * FROM subscriptions;

CREATE TABLE feature_usage (
usage_id VARCHAR(50),
subscription_id VARCHAR(50),
usage_date DATE,
feature_name VARCHAR(50),
usage_count INT,
usage_duration_secs INT,
error_count INT,
is_beta_feature VARCHAR(50)
);

CREATE TABLE subscriptions (
subscription_id VARCHAR(50) PRIMARY KEY,
account_id VARCHAR(50),
start_date DATE,
end_date DATE,
plan_tier VARCHAR(50),
seats INT,
mrr_amount DECIMAL(10,2),
arr_amount DECIMAL(10,2),
is_trial VARCHAR(10),
upgrade_flag VARCHAR(10),
downgrade_flag VARCHAR(10),
churn_flag VARCHAR(10),
billing_frequency VARCHAR(20),
auto_renew_flag VARCHAR(10),
tenure_months INT
);

CREATE TABLE support_tickets (
ticket_id VARCHAR(50),
account_id VARCHAR(50),
submitted_at DATE,
closed_at DATE,
resolution_time_hours INT,
priority VARCHAR(50),
first_response_time_minutes INT,
satisfaction_score INT,
escalation_flag VARCHAR(50)
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/hp/Documents/acquisition_analytics/cleaned_1/subscriptions.csv'
INTO TABLE subscriptions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 

SET SQL_SAFE_UPDATES = 0;
SET SESSION sql_mode = '';
UPDATE subscriptions
SET end_date = NULL
WHERE end_date = '0000-00-00' 
OR end_date = '0000-00-00 00:00:00'
OR CAST(end_date AS CHAR) = '0000-00-00';
SET SESSION sql_mode = DEFAULT;
SET SQL_SAFE_UPDATES = 1;

-- Total Currents Monthly Ocurring Revenue (MRR)
SELECT SUM(mrr_amount) AS active_mrr
FROM subscriptions
WHERE end_date IS NULL OR end_date > CURDATE();

SELECT COUNT(*) AS total_churns 
FROM churn_events;

-- Overall Churn Rate
SELECT 
(SELECT COUNT(DISTINCT account_id) FROM churn_events) AS churned_customers,
(SELECT COUNT(DISTINCT account_id) FROM accounts) AS total_customers,
ROUND((SELECT COUNT(DISTINCT account_id) FROM churn_events) / 
(SELECT COUNT(DISTINCT account_id) FROM accounts) * 100, 2) AS churn_rate_percentage;
 
WITH Churn_Metrics AS (
SELECT 
(SELECT COUNT(DISTINCT account_id) FROM churn_events) /
(SELECT COUNT(DISTINCT account_id) FROM accounts) AS overall_churn_rate),
Revenue_Metrics AS (
SELECT 
AVG(mrr_amount) AS ARPA
FROM subscriptions
WHERE mrr_amount > 0)
SELECT 
ROUND(r.ARPA, 2) AS Average_Revenue_Per_Account,
ROUND(c.overall_churn_rate * 100, 2) AS Churn_Rate_Pct,
ROUND(r.ARPA / c.overall_churn_rate, 2) AS Customer_Lifetime_Value
FROM Revenue_Metrics r
CROSS JOIN Churn_Metrics c;

SELECT 
s.plan_tier,
COUNT(DISTINCT s.account_id) AS total_cutomers,
ROUND(AVG(s.mrr_amount), 2) AS ARPA,
ROUND(COUNT(DISTINCT c.account_id) / COUNT(DISTINCT s.account_id), 4) AS tier_churn_rate,
ROUND(AVG(s.mrr_amount) / NULLIF((COUNT(DISTINCT c.account_id) / COUNT(DISTINCT s.account_id)), 0), 2) AS Tier_LTV
FROM subscriptions s
LEFT JOIN churn_events c ON s.account_id = c.account_id
WHERE s.mrr_amount > 0
GROUP BY s.plan_tier
ORDER BY Tier_LTV DESC;

CREATE TABLE marketing_spend (
campaign_month DATE,
channel VARCHAR(50),
spend DECIMAL(10,2),
new_customers_acquired INT);

INSERT INTO marketing_spend (campaign_month, channel, spend, new_customers_acquired)
VALUES
('2024-01-01', 'Google Ads', 45000.00, 120),
('2024-01-01', 'LinkedIn Ads', 35000.00, 45),
('2024-01-01', 'Organic Search', 8000.00, 210),
('2024-02-01', 'Google Ads', 52000.00, 135),
('2024-02-01', 'LinkedIn Ads', 38000.00, 50),
('2024-02-01', 'Organic Search', 8500.00, 225);

SELECT * FROM marketing_spend;

SELECT channel, 
SUM(spend) AS total_spend,
SUM(new_customers_acquired) AS total_acquired,
ROUND(SUM(spend) / SUM(new_customers_acquired), 2) AS CAC,
3814.82 AS baseline_LTV,
ROUND(3814.82 / (SUM(spend) / SUM(new_customers_acquired)), 2) AS LTV_to_CAC_Ratio
FROM marketing_spend
GROUP BY channel
ORDER BY LTV_to_CAC_Ratio DESC;





 









