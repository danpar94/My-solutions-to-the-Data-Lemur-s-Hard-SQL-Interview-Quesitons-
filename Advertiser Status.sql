-- Interview question here: https://datalemur.com/questions/updated-status

CREATE TABLE advertiser (
    user_id VARCHAR(50),
    status VARCHAR(20)
);

INSERT INTO advertiser (user_id, status) VALUES 
('google', 'EXISTING'),
('yahoo', 'NEW'),
('spotify', 'CHURN'),
('netflix', 'RESURRECT'),
('twitch', 'NEW'),
('reddit', 'EXISTING'),
('pinterest', 'CHURN'),
('amazon', 'RESURRECT'),
('discord', 'EXISTING'),
('github', 'NEW');

CREATE TABLE daily_pay (
    user_id VARCHAR(50),
    paid DECIMAL(10, 2)
);

INSERT INTO daily_pay (user_id, paid) VALUES
('google', 45.00),
('spotify', 13.00),
('twitch', 18.00),
('amazon', 60.00),
('yahoo', 15.00)
;

SELECT advertiser.user_id,
CASE  
  WHEN (status = 'NEW' OR status = 'EXISTING' OR status = 'RESURRECT') AND paid IS NOT NULL THEN 'EXISTING'
  WHEN (status = 'NEW' OR status = 'EXISTING' OR status = 'CHURN' OR status = 'RESURRECT') 
  AND paid IS NULL THEN 'CHURN'
  WHEN status = 'CHURN' AND paid IS NOT NULL THEN 'RESURRECT'
END
new_status
FROM advertiser 
LEFT JOIN daily_pay
  ON advertiser.user_id = daily_pay.user_id;


