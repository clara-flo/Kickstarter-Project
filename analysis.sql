-- ----------------------------------
-- CREATE AND LOAD THE DATA
-- ----------------------------------

-- Create the table to save data
CREATE TABLE projects (
  col1 BIGINT,                -- ID
  col2 VARCHAR(600),          -- Name
  col3 VARCHAR(100),          -- Category
  col4 VARCHAR(100),          -- Main category
  col5 VARCHAR(10),           -- Currency
  col6 DATETIME,              -- Deadline
  col7 DECIMAL(15,2),         -- Goal
  col8 DATETIME,              -- Launched date
  col9 DECIMAL(15,2),         -- Pledged
  col10 VARCHAR(20),          -- State (e.g., failed, successful)
  col11 INT,                  -- Backers
  col12 VARCHAR(10),          -- Country
  col13 DECIMAL(15,2),        -- USD pledged (converted)
  col14 VARCHAR(100),         -- Unknown
  col15 VARCHAR(100),         -- Unknown
  col16 VARCHAR(100),         -- Unknown
  col17 VARCHAR(250)          -- Unknown
);

-- Load the datasets (adjust path as needed)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ks-projects-clean.csv'
INTO TABLE projects
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ks-projects-USD.csv'
INTO TABLE projects
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Sample read
SELECT * FROM projects LIMIT 10;

-- Drop table if needed
-- DROP TABLE projects;

-- ----------------------------------
-- EXPLORATORY ANALYSIS
-- ----------------------------------

-- Overall success rate
SELECT 
  COUNT(*) AS total_projects, 
  SUM(col10 = 'successful') AS successful_projects, 
  ROUND(SUM(col10 = 'successful') / COUNT(*) * 100, 2) AS success_rate_percent
FROM projects;

-- Success rate by category
SELECT 
  col4 AS main_category, 
  col3 AS category,
  COUNT(*) AS total_projects,
  SUM(col10 = 'successful') AS successful_projects,
  ROUND(SUM(col10 = 'successful') / COUNT(*) * 100, 2) AS success_rate_percent
FROM projects
GROUP BY col4, col3
ORDER BY success_rate_percent DESC;

-- Average pledged by state
SELECT
  col10 AS project_state,
  COUNT(*) AS total_projects,
  ROUND(AVG(col9), 2) AS avg_pledged
FROM projects
GROUP BY col10
ORDER BY total_projects DESC;

-- Projects that exceeded their goal
SELECT
  COUNT(*) AS total_projects, 
  SUM(col9 >= col7) AS projects_exceeded_goal,
  ROUND(SUM(col9 >= col7) / COUNT(*) * 100, 2) AS percent_exceeded_goal,
  ROUND(AVG(CASE WHEN col9 >= col7 THEN (col9 - col7) / col7 * 100 END), 2) AS avg_percent_over_goal
FROM projects;

-- Success rate by launch month
SELECT 
  MONTH(col8) AS launch_month, 
  COUNT(*) AS total_projects, 
  SUM(col10 = 'successful') AS successful_projects,
  ROUND(SUM(col10 = 'successful') / COUNT(*) * 100, 2) AS success_rate_percent
FROM projects
GROUP BY launch_month
ORDER BY success_rate_percent DESC;

-- Success rate by launch duration
SELECT 
  CASE 
    WHEN DATEDIFF(col6, col8) <= 14 THEN 'Short (<=2 weeks)'
    WHEN DATEDIFF(col6, col8) <= 30 THEN 'Medium (15–30 days)'
    WHEN DATEDIFF(col6, col8) <= 60 THEN 'Long (31–60 days)'
    WHEN DATEDIFF(col6, col8) <= 90 THEN 'Very Long (61–90 days)'
    ELSE 'Ultra Long (>90 days)'
  END AS duration_group,
  COUNT(*) AS total_projects,
  ROUND(SUM(col10 = 'successful') / COUNT(*) * 100, 2) AS success_rate_percent
FROM projects
GROUP BY duration_group
ORDER BY success_rate_percent DESC;

-- Fundraising goal ranges and success
SELECT 
  CASE
    WHEN col7 <= 1000 THEN 'Under $1,000'
    WHEN col7 <= 5000 THEN '$1,001–$5,000'
    WHEN col7 <= 10000 THEN '$5,001–$10,000'
    WHEN col7 <= 50000 THEN '$10,001–$50,000'
    WHEN col7 <= 100000 THEN '$50,001–$100,000'
    ELSE 'Over $100,000'
  END AS goal_range,
  ROUND(SUM(col10 = 'successful') / COUNT(*) * 100, 2) AS success_rate_percent
FROM projects
GROUP BY goal_range
ORDER BY success_rate_percent DESC;

-- Currency analysis: avg goal & pledged
SELECT 
  col5 AS currency, 
  ROUND(AVG(col7)) AS avg_goal, 
  ROUND(AVG(col9)) AS avg_pledged, 
  ROUND(SUM(col10 = 'successful') / COUNT(*) * 100, 2) AS success_rate_percent
FROM projects
GROUP BY col5
ORDER BY avg_goal DESC;

-- Top 3 categories with highest avg pledged
SELECT 
  col3 AS category,
  ROUND(AVG(col7), 2) AS avg_goal,
  ROUND(AVG(col9), 2) AS avg_pledged
FROM projects
GROUP BY category
ORDER BY avg_pledged DESC
LIMIT 3;

-- Music & Narrative Film success by currency
SELECT 
  col5 AS currency,
  col3 AS category,
  COUNT(*) AS total_projects,
  SUM(col10 = 'successful') AS successful_projects,
  ROUND(SUM(col10 = 'successful') / COUNT(*) * 100, 2) AS success_rate_percent
FROM projects
WHERE col3 IN ('Music', 'Narrative Film')
GROUP BY col5, col3
ORDER BY category, success_rate_percent DESC;

-- Project title length by state
SELECT 
  col10 AS state, 
  COUNT(*) AS total_projects,
  AVG(CHAR_LENGTH(col2)) AS avg_name_length
FROM projects
GROUP BY state;

-- Common words in successful project titles
SELECT
  LOWER(SUBSTRING_INDEX(SUBSTRING_INDEX(col2, ' ', numbers.n), ' ', -1)) AS word,
  COUNT(*) AS word_count
FROM projects
JOIN (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL 
           SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL 
           SELECT 9 UNION ALL SELECT 10) numbers
  ON CHAR_LENGTH(col2) - CHAR_LENGTH(REPLACE(col2, ' ', '')) >= numbers.n - 1
WHERE col10 = 'successful'
GROUP BY word
HAVING LENGTH(word) >= 3
ORDER BY word_count DESC
LIMIT 20;
