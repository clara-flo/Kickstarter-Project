### 🧿 ** Calculate the overall success rate**

```sql
-- Calculate the overall success rate
SELECT
  COUNT(*) AS total_projects,
  SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
  ROUND(
    SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END) / COUNT(*) * 100, 
    2
  ) AS success_rate_percent
FROM
  projects;
```


### 📌 **Explanation**

* `COUNT(*)` → total number of projects in the dataset.
* `SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END)` → counts only projects where the **state** is `'successful'` (in your table, that’s `col10`).
* `ROUND(..., 2)` → gives you the percentage success rate with 2 decimals.


### ✅ **Answer**

| total\_projects | successful\_projects | success\_rate\_percent |
| --------------- | -------------------- | ---------------------- |
| 704585          | 249765                | 35.45                  |



---

### 🧿 ** Success rate by main category and category**

```sql
SELECT
  col4 AS main_category,
  col3 AS category,
  COUNT(*) AS total_projects,
  SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
  ROUND(
    SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END) / COUNT(*) * 100, 
    2
  ) AS success_rate_percent
FROM
  projects
GROUP BY
  col4, col3
ORDER BY
  success_rate_percent DESC;
```


### 📌 **What this does**

* Groups projects by `main_category` and `category`
* Counts total projects for each pair
* Counts how many were successful
* Calculates success rate (%) per pair
* Orders results by success rate (highest first)


### ✅ **Answer: Three most successful**

| main\_category | category       | total\_projects | successful\_projects | success\_rate\_percent |
| -------------- | -------------- | --------------- | -------------------- | ---------------------- |
| Music          | Chiptune | 57            | 43                 | 75.44                  |
| Comics            | Anthologies    | 761            | 568                  | 74.64                  |
| Dance     | Residencies      | 98             | 67                  | 68.37                  |
