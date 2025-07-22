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

---

### 📌 **Explanation**

* `COUNT(*)` → total number of projects in the dataset.
* `SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END)` → counts only projects where the **state** is `'successful'` (in your table, that’s `col10`).
* `ROUND(..., 2)` → gives you the percentage success rate with 2 decimals.

---

### ✅ **Answer**

| total\_projects | successful\_projects | success\_rate\_percent |
| --------------- | -------------------- | ---------------------- |
| 704585          | 249765                | 35.45                  |

