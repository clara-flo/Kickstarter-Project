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

### 📊  Answer 

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


### 📊  Answer: Three most successful 

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

### 📊  Answer 


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


### 📊 Answer

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

### 📊 **Answer**
| launch\_year | total\_projects | successful\_projects | success\_rate\_percent |
| ------------ | --------------- | -------------------- | ---------------------- |
| 2018         | 241             | 0                    | 0.00                   |
| 2017         | 96,483          | 34,027               | 35.27                  |
| 2016         | 106,607         | 35,035               | 32.86                  |
| 2015         | 143,393         | 39,160               | 27.31                  |
| 2014         | 126,146         | 39,348               | 31.19                  |
| 2013         | 83,912          | 36,362               | 43.33                  |
| 2012         | 76,969          | 33,661               | 43.73                  |
| 2011         | 49,058          | 22,639               | 46.15                  |
| 2010         | 19,312          | 8,466                | 43.84                  |
| 2009         | 2,447           | 1,067                | 43.60                  |
| 1970         | 17              | 0                    | 0.00                   |



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

---
## 🧿   Seasonal trends
```sql
SELECT 
    MONTH(col8) AS launch_month, 
    COUNT(*) AS total_projects, 
    SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    ROUND(
    SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END)/COUNT(*) *100,
    2
    ) AS success_rate_percent
FROM
  projects
GROUP BY
  launch_month
ORDER BY
    success_rate_percent DESC;
```

### 📊 Answer

| launch\_month | total\_projects | successful\_projects | success\_rate\_percent |
| ------------- | --------------- | -------------------- | ---------------------- |
| 3 (March)     | 63,192          | 23,694               | 37.50%                 |
| 4 (April)     | 59,659          | 22,325               | 37.42%                 |
| 10 (October)  | 61,812          | 22,977               | 37.17%                 |
| 5 (May)       | 61,760          | 22,804               | 36.92%                 |
| 2 (Feb)       | 55,175          | 20,242               | 36.69%                 |
| 9 (Sept)      | 57,956          | 21,082               | 36.38%                 |
| 11 (Nov)      | 61,116          | 22,044               | 36.07%                 |
| 6 (June)      | 61,041          | 21,967               | 35.99%                 |
| 1 (Jan)       | 51,508          | 17,565               | 34.10%                 |
| 8 (Aug)       | 60,523          | 20,399               | 33.70%                 |
| 7 (July)      | 67,558          | 21,893               | 32.41%                 |
| 12 (Dec)      | 43,285          | 12,773               | 29.51%                 |


### 💡  What we learn 

* The **range is about 8%** (37.5% → 29.5%).
* So seasonality exists, but it’s moderate. Good timing helps — but strong ideas & marketing matter more.
* If you want to **maximize success odds**, launching in **spring or early fall** is statistically slightly better.
* Avoid **late summer** & **December** if you can — backers are distracted.

---
## 🧿   Duration of the campaign
```sql
SELECT 
    CASE 
        WHEN DATEDIFF(col6, col8) <= 14 THEN 'Short (<=2 weeks)'
        WHEN DATEDIFF(col6, col8) <= 30 THEN 'Medium (15–30 days)'
        WHEN DATEDIFF(col6, col8) <= 60 THEN 'Long (31–60 days)'
        WHEN DATEDIFF(col6, col8) <= 90 THEN 'Very Long (61–90 days)'
        ELSE 'Ultra Long (>90 days)'
      END AS duration_group,
      COUNT(*) AS total_projects,
     ROUND(
        SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END) / COUNT(*) * 100,
         2
     ) AS success_rate_percent
FROM
    projects
GROUP BY
    duration_group
ORDER BY
    success_rate_percent DESC;
```
### 📊 Answer

| duration\_group        | total\_projects | success\_rate\_percent |
| ---------------------- | --------------- | ---------------------- |
| Short (<=2 weeks)      | 25,430          | 48.35%                 |
| Medium (15–30 days)    | 418,544         | 35.59%                 |
| Long (31–60 days)      | 250,474         | 33.97%                 |
| Very Long (61–90 days) | 9,198           | 34.45%                 |
| Ultra Long (>90 days)  | 939             | 28.22%                 |

### 💡  What we learn 

✅ **1️⃣ Short campaigns succeed *much more often***

* Projects with a **duration of 2 weeks or less** have a **48% success rate** — far above the dataset average.
* Why? Short campaigns create *urgency*: backers feel they must pledge now or miss out.
* Also, short campaigns often have strong pre-launch promotion — they know their audience.

✅ **2️⃣ The standard 15–30 day range still works well**

* The biggest bucket by far — **418k projects** — shows a healthy **35.6% success rate**.
* This aligns with Kickstarter’s recommended \~30-day run time: enough time to gather momentum without losing urgency.


✅ **3️⃣ Longer campaigns don’t help — they *hurt***

* **31–60 days**: success rate drops to **33.9%**.
* **61–90 days**: about the same (34.4%).
* **Over 90 days**: success rate falls to **28%**.
* Longer campaigns lose steam — backers get bored, promotion costs go up, momentum fades.

---
# 💸 **3. Fundraising Goals & Pledges**

## 🧿 Goal ranges for successful vs. failed projects?
```sql
SELECT 
  CASE
    WHEN col7 <= 1000 THEN 'Under $1,000'
    WHEN col7 <= 5000 THEN '$1,001–$5,000'
    WHEN col7 <= 10000 THEN '$5,001–$10,000'
    WHEN col7 <= 50000 THEN '$10,001–$50,000'
    WHEN col7 <= 100000 THEN '$50,001–$100,000'
    ELSE 'Over $100,000'
  END AS goal_range,
  ROUND(
        SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END)/COUNT(*)*100,
        2
        ) AS success_rate_percent
FROM 
  projects

GROUP BY goal_range
ORDER BY success_rate_percent DESC;
```

### 📊 Answer
| goal\_range        | success\_rate\_percent |
| ------------------ | ---------------------- |
| Under \$1,000      | 48.89%                 |
| \$1,001–\$5,000    | 41.24%                 |
| \$5,001–\$10,000   | 34.56%                 |
| \$10,001–\$50,000  | 26.84%                 |
| \$50,001–\$100,000 | 14.36%                 |
| Over \$100,000     | 7.08%                  |

### 💡  What we learn 
* Small goals succeed far more often
Projects with modest goals under $1,000 succeed nearly half the time (48.9%).
* As soon as goals cross $5,000–$10,000, the success rate drops by about 15 percentage points.
* There’s a clear negative correlation between the size of a project’s fundraising goal and its probability of success. The smaller the ask, the higher the odds — suggesting that creators benefit from modest, achievable targets and strong pre-launch support.

## 🧿 Currency impact 
```sql
SELECT 
  col5 AS currency, 
  ROUND(AVG(col7)) AS avg_goal, 
  ROUND(AVG(col9)) AS avg_pledged, 
  ROUND(
    SUM(CASE WHEN col10 = 'successful' THEN 1 ELSE 0 END)/COUNT(*) * 100,
    2
  ) AS success_rate_percent
FROM 
  projects
GROUP BY
  col5
ORDER BY avg_goal DESC;
```

### 📊 Answer
| Currency | Avg Goal  | Approx Goal (USD) | Avg Pledged | Approx Pledged (USD) | Success % |
| -------- | --------- | ----------------- | ----------- | -------------------- | --------- |
| JPY      | 1,890,595 | \~\$12,604        | 282,448     | \~\$1,883            | 14.93%    |
| NOK      | 528,137   | \~\$52,814        | 27,797      | \~\$2,780            | 22.27%    |
| SEK      | 352,589   | \~\$35,259        | 65,427      | \~\$6,543            | 27.08%    |
| MXN      | 329,311   | \~\$19,371        | 23,829      | \~\$1,402            | 22.15%    |
| CHF      | 237,502   | \~\$263,891       | 18,781      | \~\$20,868           | 24.51%    |
| HKD      | 179,888   | \~\$23,064        | 129,179     | \~\$16,563           | 35.86%    |
| DKK      | 172,209   | \~\$25,328        | 41,156      | \~\$6,052            | 30.42%    |
| AUD      | 66,838    | \~\$44,559        | 7,043       | \~\$4,695            | 25.23%    |
| EUR      | 62,331    | \~\$67,762        | 8,504       | \~\$9,242            | 22.31%    |
| CAD      | 51,067    | \~\$37,558        | 7,277       | \~\$5,351            | 27.69%    |
| USD      | 40,297    | \~\$40,297        | 9,726       | \~\$9,726            | 37.16%    |
| NZD      | 28,332    | \~\$17,170        | 7,887       | \~\$4,778            | 29.61%    |
| GBP      | 27,749    | \~\$35,130        | 4,626       | \~\$5,857            | 35.26%    |
| SGD      | 20,769    | \~\$15,392        | 15,729      | \~\$11,652           | 33.64%    |

### 💡  What we learn 

✅ **1️⃣ USD, GBP, and HKD markets have the highest success rates.**
These are regions where Kickstarter has a strong backer base. USD campaigns are the largest portion overall.

✅ **3️⃣ Some currencies (MXN, NOK, SEK) show large *goals* but very low *average pledged*.**
* Less active backer base.
* Overambitious goals.
* Less traction or lower trust.

---
## 🧿   Top goal and pledged categories
```sql
SELECT 
    col3 AS category,
    ROUND(
        AVG(col7),
        2
    ) AS avg_goal,
    ROUND(
        AVG(col9),
        2
    ) AS avg_pledged
FROM 
    projects
GROUP BY 
    category
ORDER BY avg_goal DESC
LIMIT 3;
```

### 📊 **Top 3 average fundraising goals**

| Category       | avg\_goal (USD) | avg\_pledged (USD) |
| -------------- | --------------- | ------------------ |
| Movie Theaters | 1,595,563.44  | 9,514.06         |
| Fantasy        | 582,911.73    | 9,073.42         |
| Video          | 552,930.80    | 1,608.20         |


### 📊 **Top 3 average amount pledged**
| Category         | avg\_goal (USD) | avg\_pledged (USD) |
| ---------------- | --------------- | ------------------ |
| Camera Equipment | 38,715.42       | 80,466.82          |
| 3D Printing      | 45,150.07       | 65,399.30          |
| Sound            | 45,056.01       | 61,845.88          |

### 💡  What we learn 

1️⃣ **Ambition vs. reality**

* The *Top 3 goals* list shows **huge average goals** — but the average pledged is a tiny fraction of that.

* The *Top 3 pledged* categories have **moderate goals but high pledged averages** — they **overperform**.


2️⃣ **Backer appeal and product type**

* *Camera Equipment*, *3D Printing*, and *Sound* all relate to **hardware or tangible tools** — these tend to do well on Kickstarter.
* In contrast, *Movie Theaters* or *Fantasy* often depend on local communities or niche fanbases — and it’s much harder to gather millions in small pledges.



