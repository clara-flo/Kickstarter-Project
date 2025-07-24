#  Why convert all amounts to USD?

Kickstarter is an international platform, so projects are created in dozens of currencies.  
When comparing **fundraising goals**, **pledged amounts**, and **success rates**, it is impossible to compare meaningfully if one project’s goal is in Yen and another’s in US Dollars.

Without currency normalization:
- A project goal of **1,000 JPY (~$7 USD)** looks much larger than it really is.
- Average or total pledges would be misleading.
- Statistical trends across categories, countries, and years would be distorted.

By converting all monetary columns (**goal**, **pledged**, **usd_pledged**) to the **same unit (USD)**, we make sure:
- Comparisons are consistent and fair.
- Group averages and totals have real meaning.
- Insights are not biased by currency differences.

## What this code does

This project includes a simple Python script:
- It reads the raw CSV.
- Uses approximate exchange rates to convert all monetary fields to USD.
- Writes a new CSV with exactly the same structure — ready for import to MySQL.

**The result:**  
All future SQL queries and analyses now operate on values in the same currency.  
This is a crucial step for any serious **data analysis**, **financial trend**, or **success rate study**.

 **Clear. Comparable. Reliable.**

---
