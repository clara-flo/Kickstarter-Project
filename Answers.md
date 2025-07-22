## 🧿 Calculate the overall success rate

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


### 📌  Explanation 

* `COUNT(*)` → total number of projects in the dataset.
* `SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END)` → counts only projects where the  state  is `'successful'` (in your table, that’s `col10`).
* `ROUND(..., 2)` → gives you the percentage success rate with 2 decimals.


### ✅  Answer 

| total\_projects | successful\_projects | success\_rate\_percent |
| --------------- | -------------------- | ---------------------- |
| 704585          | 249765                | 35.45                  |



---

## 🧿   Success rate by main category and category 

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


### 📌  What this does 

* Groups projects by `main_category` and `category`
* Counts total projects for each pair
* Counts how many were successful
* Calculates success rate (%) per pair
* Orders results by success rate (highest first)


### ✅  Answer: Three most successful 

| main\_category | category       | total\_projects | successful\_projects | success\_rate\_percent |
| -------------- | -------------- | --------------- | -------------------- | ---------------------- |
| Music          | Chiptune | 57            | 43                 | 75.44                  |
| Comics            | Anthologies    | 761            | 568                  | 74.64                  |
| Dance     | Residencies      | 98             | 67                  | 68.37                  |

---

## 🧿   Average amount pledged by project state 

```sql
SELECT
  col10 AS project_state,
  COUNT(*) AS total_projects,
  ROUND(
    AVG(col9),
    2) AS avg_pledged
FROM
  projects
GROUP BY
  col10
ORDER BY
  total_projects DESC;
```

---

### 📌  What this does 

* Groups all rows by the `state` column (`successful`, `failed`, maybe `canceled` or `undefined` if they exist in your data).
* Counts how many projects in each state.
* Computes the  average pledged amount  for each group.
* Orders them from highest number of projects to lowest.

---

### ✅  Answer 


| project\_state | total\_projects | avg\_pledged |
| -------------- | --------------- | ------------ |
| failed         | 367,629         | 1,409.64     |
| successful     | 249,765         | 24,349.05    |
| canceled       | 71,830          | 2,513.16     |
| live           | 5,320           | 9,539.46     |
| suspended      | 3,378           | 9,386.40     |


### 💡  What we learn 
Great — let’s interpret this  step by step .
Your output:

#### 1️⃣  Successful vs. Failed: Huge difference 

*  Successful projects  raise  \~24,000 USD  on average.
*  Failed projects  raise only  \~1,400 USD  on average.
* → Clear evidence that there’s a big gap: projects that get traction often get *much* more than the minimum goal, while most failed projects struggle to get off the ground.

#### 2️⃣  Canceled projects: Mid-range 

* Average for  canceled  projects is  \~2,500 USD  — higher than failed ones but way below successful ones.
*  Possible reasons: 

  * Creators often  cancel their own projects  if they see they’re unlikely to succeed.
  * Sometimes they relaunch with better strategy/goal.

#### 3️⃣  Live projects: promising but incomplete 

*  Live  projects are still raising money → they average  \~9,500 USD  so far.
* Some will likely succeed, others might fail.
* So their average sits between failed and successful: *in progress*.


#### 4️⃣  Suspended projects: unusual 

* Suspended means Kickstarter  stopped the project  — e.g. policy violations, fraud, or errors.
* Their average pledged is  \~9,300 USD  — often suspicious because suspicious projects sometimes raise a surprising amount before being flagged.

### 🔑  Key takeaway 

This pattern is typical of crowdfunding:

* There’s a clear  threshold effect : once a project reaches a certain momentum, backers pile on → large pledges.
*  Failed and canceled projects  often stay small → they don’t build trust or attract enough backers.
* It is important to  Advice for creators  since realistic goals and good promotion are key to crossing the funding line.

