# 🎯 Kickstarter Data Analysis

Welcome to a comprehensive analysis of Kickstarter projects based on a large public dataset. This project explores what makes crowdfunding campaigns succeed or fail using structured SQL queries and statistical exploration.

## 📌 Project Overview

The goal of this project is to uncover patterns in Kickstarter campaigns to answer practical questions such as:
- What goals are realistic for project creators?
- Which categories are overcrowded or underserved?
- What are the best times to launch a campaign?
- Are there common naming patterns among successful projects?

This analysis involved:
- **Extensive data cleaning**
- **SQL-based querying and aggregation**
- **Insight generation and visual summarization**
- **Packaging into presentation-ready formats**

---

## 📁 Repository Contents

### 🧹 `data_cleaning.sql`
A detailed SQL script used to prepare and clean the raw Kickstarter dataset. Covers:
- Handling missing or corrupted fields
- Standardizing formats
- Creating derived columns (e.g., duration, goal buckets)

This step was critical to ensuring valid and accurate insights.

---

### 🧠 `analysis_kickstarter.sql`
A clean, fully-commented SQL script containing **all analytical queries** used throughout the project. Includes:
- Success rates
- Category comparisons
- Time trends
- Goal and pledge analysis
- Text-based naming patterns
- And more

You can run this script to reproduce or adapt the analysis for your own purposes.

---

### 📊 `detailed_analysis.md`
A thorough, question-by-question walkthrough of the entire analysis. For each question, it includes:
- The reasoning
- The relevant SQL queries
- The interpretation of results

This is the best place to explore the full depth of the work.

---

### 📎 `kickstarter_insights.pdf`
A polished PowerPoint-style summary of the main takeaways. Ideal for readers who want the **key insights** without diving into all the technical details.

---


## 📦 Dataset

The original dataset used for this project is the well-known **Kickstarter Projects** dataset from Kaggle, covering over 300,000 projects from the platform’s early years to recent history.

> ⚠️ The raw dataset is not included in the repo due to size and licensing. You can download it [here](https://www.kaggle.com/datasets/kemical/kickstarter-projects).

---

## 💡 Highlights

Some interesting insights discovered:
- Projects with moderate fundraising goals (especially $1,000–$10,000) succeed more often.
- Categories like **Theater** and **Comics** have disproportionately high success rates.
- Campaigns launched in **spring and early summer** tend to perform best.
- Shorter and cleaner project titles (30–40 characters) correlate with higher success.

---

## 🛠️ How to Use

1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/kickstarter-analysis.git
