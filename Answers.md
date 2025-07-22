# 📊 1. Overall Performance & Success Rates

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

### ✅  Answer 


| project\_state | total\_projects | avg\_pledged |
| -------------- | --------------- | ------------ |
| failed         | 367,629         | 1,409.64     |
| successful     | 249,765         | 24,349.05    |
| canceled       | 71,830          | 2,513.16     |
| live           | 5,320           | 9,539.46     |
| suspended      | 3,378           | 9,386.40     |


### 💡  What we learn 

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

---
## 🧿   Proportion of projects exceeding their fundraising goal, and by how much


```sql
SELECT
  COUNT(*) AS total_projects, 
  SUM(CASE WHEN col9 >= col7 THEN 1 ELSE 0 END) AS projects_exceeded_goal,
  ROUND(
    SUM(CASE WHEN col9 >= col7 THEN 1 ELSE 0 END) / COUNT(*) * 100,
    2) AS percent_exceeded_goal,

  ROUND(
    AVG(CASE WHEN col9 >= col7 THEN (col9- col7)/col7 * 100 ELSE NULL END) ,
    2
  ) AS avg_percent_over_goal
FROM
  projects; 
```


### ✅ Answer

| total\_projects | projects\_exceeded\_goal | percent\_exceeded\_goal |
| --------------- | ------------------------ | ----------------------- |
| 704,585         | 255,539                  | 36.27%                  |

| avg\_percent\_over\_goal |
| ------------------------ |
| 769.20%                  |

### 💡  What we learn 
* Success takes work, but once momentum builds, it often **exceeds expectations**.

* The **average percent over goal** is \~**770%**. This means that on average, these over-goal projects raise **8.7×** their original target. This is because many creators set *low, reachable goals* to guarantee they get funded — once backers pile in, total funding often grows far beyond the original goal.

---
# 📅 2. Time-based Trends

## 🧿   Success rate by year
```sql
SELECT
  YEAR(col8) AS launch_year,
  COUNT(*) AS total_projects,
  SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
  ROUND(
    SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END) / COUNT(*) * 100,
    2
  ) AS success_rate_percent
FROM
  projects
GROUP BY
  launch_year
ORDER BY
  launch_year DESC;
```

### ✅ **Answer**

| launch\_year | total\_projects | successful\_projects | success\_rate\_percent |
| ------------ | --------------- | -------------------- | ---------------------- |

| 2017         | 96,483          | 34,027               | 35.27                  |
| 2016         | 106,607         | 35,035               | 32.86                  |
| 2015         | 143,393         | 39,160               | 27.31                  |
| 2014         | 126,146         | 39,348               | 31.19                  |
| 2013         | 83,912          | 36,362               | 43.33                  |
| 2012         | 76,969          | 33,661               | 43.73                  |
| 2011         | 49,058          | 22,639               | 46.15                  |
| 2010         | 19,312          | 8,466                | 43.84                  |
| 2009         | 2,447           | 1,067                | 43.60                  |


---

### 💡  What we learn 

✅ **1️⃣ Early years → high success rates**

* From 2009 to 2012, the success rate hovered around **43–46%**, meaning nearly **half** of projects reached their goal.
* Why? Kickstarter was newer, fewer projects, more “early adopters” who were deeply supportive.
* There was *less competition*, and backers trusted the novelty.

✅ **2️⃣ Massive growth → lower success rates**

* By 2013–2014, the number of projects exploded (83k → 126k → 143k in 2015).
* But success rate **dropped** from \~43% to \~27% by 2015.
* More creators launched projects, but audience attention didn’t scale linearly → competition for backers increased.


✅ **3️⃣ Recent years stay lower**

* After the big peak in 2015, volume slightly shrank (106k in 2016, 96k in 2017).
* The success rate stabilized around **32–35%**, lower than the early years but not falling off a cliff.
* By 2017, about 1 in 3 projects succeeded — not bad, but much tougher than Kickstarter’s early “gold rush.”

#### 🔑 Key takeaway 

* Kickstarter’s early years had **fewer but more successful projects** — novelty, loyal backers, less noise.
* As the platform scaled, **competition increased**, and creators needed better marketing, planning, and community.
* The success rate leveling off around 30–35% shows the platform *matured* into a competitive crowdfunding marketplace.

