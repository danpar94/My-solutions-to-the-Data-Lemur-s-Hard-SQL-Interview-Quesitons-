/*
Interview question here: https://datalemur.com/questions/marketing-touch-streak
*/

CREATE TABLE marketing_touches (
    event_id INT PRIMARY KEY,
    contact_id INT,
    event_type VARCHAR(100),
    event_date TIMESTAMP
);

INSERT INTO marketing_touches (event_id, contact_id, event_type, event_date) VALUES
(1, 101, 'page view', '2026-06-01 09:15:00'),
(2, 101, 'email click', '2026-06-03 14:20:00'),
(3, 101, 'trial request', '2026-06-04 11:05:00'),
(4, 102, 'page view', '2026-06-02 10:00:00'),
(5, 102, 'trial request', '2026-06-02 16:45:00'),
(6, 103, 'webinar sign-up', '2026-06-05 08:30:00'),
(7, 103, 'page view', '2026-06-06 13:10:00'),
(8, 104, 'trial request', '2026-06-07 15:50:00'),
(9, 105, 'email open', '2026-05-30 09:00:00'),
(10, 105, 'trial request', '2026-06-02 12:25:00'),
(11, 105, 'trial request', '2026-06-09 12:25:00');


CREATE TABLE crm_contacts (
    contact_id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL
);


INSERT INTO crm_contacts (contact_id, email) VALUES
(101, 'alex.smith@example.com'),
(102, 'sarah.jones@company.org'),
(103, 'liam.brown@startup.io'),
(104, 'emily.davis@business.net'),
(105, 'michael.wilson@enterprise.com');

WITH cte AS(
SELECT marketing_touches.contact_id AS contact_id,
email,
EXTRACT(WEEK FROM event_date) AS cur_week,
LAG(EXTRACT(WEEK FROM event_date)) OVER(PARTITION BY marketing_touches.contact_id ORDER BY EXTRACT(WEEK FROM event_date) ASC) AS lag_week,
LEAD(EXTRACT(WEEK FROM event_date)) OVER(PARTITION BY marketing_touches.contact_id ORDER BY EXTRACT(WEEK FROM event_date) ASC) AS lead_week
FROM marketing_touches
JOIN crm_contacts
  ON marketing_touches.contact_id = crm_contacts.contact_id
WHERE marketing_touches.contact_id IN (SELECT contact_id FROM marketing_touches WHERE event_type LIKE '%trial_request%') 
)
SELECT DISTINCT(contact_id),
email
FROM cte 
WHERE cur_week - 1 = lag_week 
AND lead_week - 1 = cur_week
;
