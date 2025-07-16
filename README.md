## 🚩 **WHY this cleaning code is necessary**

**Problem:**

* Your Kickstarter CSV is **real-world messy**:

  * Extra commas → wrong column counts
  * Weird quotes → `"The ""Great"" Book"`
  * Bad numeric values → `N/A`, empty, `"?"`
  * Inconsistent dates → `2016/12/01`, `12/01/2016`
  * Some rows break your table schema → cause `ER_DATA_TOO_LONG` or `ER_TRUNCATED_WRONG_VALUE_FOR_FIELD` when you `LOAD DATA`.

**Without cleaning:**

* `LOAD DATA` stops on *any* bad row.
* You get partial data → or no data at all.
* You waste time fighting the same syntax errors.

**Goal:**

* Get a **clean, reliable CSV** matching your **SQL table schema**, with:

  * Always 17 columns
  * No rogue quotes
  * Correct data types (INT, DECIMAL, DATETIME)
  * Truncated text so it fits column sizes
  * Skips known bad rows
  * Stops at a manageable chunk (e.g. 30,000 rows) for testing.

**Result:**

* You run `LOAD DATA` once → ✅ Works
* The SQL table loads cleanly → now you can:

  * **Query trends:** `SELECT COUNT(*) WHERE state='failed'`
  * **Visualize:** success by category, average pledged, etc.
  * **Analyze:** correlations, time trends, currency patterns.

---

## 🔍 **So this code is your “pre-flight check”**

Think of it as the **bouncer** at the door of your database — bad data is refused entry.

---

## ✅ **Line-by-line EXPLANATION**

Below is the final version you asked for, with **skipping lines** and **row limit**:

---

### 🟢 **1️⃣ Imports and config**

```python
import csv 
import re
from datetime import datetime

input_file = 'ks-projects-201801.csv'
output_file = 'ks-projects-clean.csv'
EXPECTED_COLS = 17
```

**What it does:**

* `csv` = reads & writes CSV rows.
* `re` = regex to fix multiple quotes.
* `datetime` = parse dates.
* `EXPECTED_COLS` = enforce exactly 17 columns, same as your SQL table.

---

### 🟢 **2️⃣ Helper: `clean_quotes()`**

```python
def clean_quotes(value):
    """Fix repeated quotes."""
    return re.sub(r'""+', '"', value).strip()
```

**Purpose:**

* Some fields like `"EOD ""F"" Coin"` → `"EOD "F" Coin"` → removes redundant `""`.

---

### 🟢 **3️⃣ Helper: `fix_value()`**

```python
def fix_value(value):
    """Trim, clean quotes."""
    return clean_quotes(value.strip())
```

**Purpose:**

* Removes leading/trailing spaces + fixes quotes in one step.

---

### 🟢 **4️⃣ Helpers: type converters**

```python
def parse_bigint(value):
    try:
        return str(int(value.strip()))
    except:
        return "0"
```

* Enforces **ID** must be `BIGINT` — if broken, uses `0` → avoids SQL cast errors.

```python
def parse_datetime(value):
    value = value.strip()
    if value == '':
        return ''
    for fmt in (
        '%Y-%m-%d %H:%M:%S',
        '%Y-%m-%d',
        '%m/%d/%Y',
        '%Y/%m/%d',
    ):
        try:
            dt = datetime.strptime(value, fmt)
            return dt.strftime('%Y-%m-%d %H:%M:%S')
        except:
            continue
    return ''  # fallback
```

* Handles **all weird date formats**.
* Always outputs a **MySQL-friendly DATETIME** or empty string → no `STR_TO_DATE` crash later.

```python
def parse_decimal(value):
    try:
        return f"{float(value.strip()):.2f}"
    except:
        return "0.00"
```

* Forces `goal`, `pledged`, `usd_pledged` → valid decimals.

```python
def parse_int(value):
    try:
        return str(int(value.strip()))
    except:
        return "0"
```

* Forces `backers` → valid integer.

---

### 🟢 **5️⃣ Truncate long text**

```python
def truncate_string(value, max_len):
    if len(value) > max_len:
        print(f"⚠️ Truncating field: '{value}' → '{value[:max_len]}'")
    return value[:max_len]
```

**Purpose:**

* If `name` or `currency` is too long → chop to fit column.
* Otherwise `LOAD DATA` hits `ER_DATA_TOO_LONG`.

---

### 🟢 **6️⃣ Master cleaner**

```python
def clean_row(row):
    row = [fix_value(col) for col in row]

    if len(row) < EXPECTED_COLS:
        row.extend([''] * (EXPECTED_COLS - len(row)))
    elif len(row) > EXPECTED_COLS:
        row = row[:EXPECTED_COLS]

    row[0] = parse_bigint(row[0])
    row[5] = parse_datetime(row[5])
    row[6] = parse_decimal(row[6])
    row[7] = parse_datetime(row[7])
    row[8] = parse_decimal(row[8])
    row[10] = parse_int(row[10])
    row[12] = parse_decimal(row[12])

    row[1] = truncate_string(row[1], 255)
    row[2] = truncate_string(row[2], 100)
    row[3] = truncate_string(row[3], 100)
    row[4] = truncate_string(row[4], 10)
    row[9] = truncate_string(row[9], 20)
    row[11] = truncate_string(row[11], 10)
    row[13] = truncate_string(row[13], 100)
    row[14] = truncate_string(row[14], 100)
    row[15] = truncate_string(row[15], 100)
    row[16] = truncate_string(row[16], 250)

    return row
```

**Purpose:**

* Fix quotes/spaces.
* Coerce columns to right type.
* Add missing columns or trim extras.
* Enforce all text fits SQL schema.

---

### 🟢 **7️⃣ Main loop**

```python
kept = 0
skipped = 0

skip_lines = [20849, 310001]
max_rows = 30000
```

* You skip **known bad lines**.
* You limit to **30,000** for manageable test loads.

```python
with open(input_file, 'r', newline='', encoding='latin-1') as infile, \
     open(output_file, 'w', newline='', encoding='utf-8') as outfile:

    reader = csv.reader(infile)
    writer = csv.writer(outfile)

    line_num = 1
    header = next(reader, None)
    writer.writerow(header)

    for row in reader:
        line_num += 1

        if line_num > max_rows:
            print(f"🛑 Reached row limit: {max_rows}")
            break

        if line_num in skip_lines:
            print(f"⏭️  Skipping line {line_num}")
            skipped += 1
            continue

        cleaned = clean_row(row)
        writer.writerow(cleaned)
        kept += 1

print(f"✅ Clean CSV written: {output_file}")
print(f"✅ Rows kept: {kept} | Rows skipped: {skipped} | Stopped at line: {line_num}")
```

**Purpose:**

* Reads input line by line.
* Skips problem rows.
* Stops at 30,000 lines.
* Runs the cleaner for each row.
* Writes a safe output CSV.
* Final `LOAD DATA` will succeed!

---

## 🟢 ✅ **End result: Ready for SQL analysis**

1️⃣ You run `LOAD DATA` → **no schema errors**
2️⃣ Your `projects` table is **correct shape**
3️⃣ Now you can run:

* `SELECT COUNT(*)`
* `AVG(goal)`
* `GROUP BY category`
* `WHERE currency = 'USD'`
* Time trends, states, success rates.

---

## ✔️ **So the Python cleaner is your “data firewall”**

Without it → your SQL stops on bad rows.
With it → **fast, repeatable, robust data ingestion**.

If you want, I can wrap this all in a `.py` file with **log output** too — just say **"Yes, package it up!"** 🚀
