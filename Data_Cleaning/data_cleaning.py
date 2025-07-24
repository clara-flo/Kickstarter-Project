import csv 
import re
from datetime import datetime

# === FILE PATHS ===
input_file = 'ks-projects-201801.csv'
output_file = 'ks-projects-clean.csv'
EXPECTED_COLS = 17

# === HELPERS ===

def clean_quotes(value):
    """Fix repeated quotes."""
    return re.sub(r'""+', '"', value).strip()

def fix_value(value):
    """Trim, clean quotes."""
    return clean_quotes(value.strip())

def parse_bigint(value):
    try:
        return str(int(value.strip()))
    except:
        return "0"

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

def parse_decimal(value):
    try:
        return f"{float(value.strip()):.2f}"
    except:
        return "0.00"

def parse_int(value):
    try:
        return str(int(value.strip()))
    except:
        return "0"

def truncate_string(value, max_len):
    if len(value) > max_len:
        print(f"⚠️ Truncating field: '{value}' → '{value[:max_len]}'")
    return value[:max_len]

def clean_row(row):
    row = [fix_value(col) for col in row]

    if len(row) < EXPECTED_COLS:
        row.extend([''] * (EXPECTED_COLS - len(row)))
    elif len(row) > EXPECTED_COLS:
        row = row[:EXPECTED_COLS]

    # Coerce types
    row[0] = parse_bigint(row[0])   # ID
    row[5] = parse_datetime(row[5]) # deadline
    row[6] = parse_decimal(row[6])  # goal
    row[7] = parse_datetime(row[7]) # launched
    row[8] = parse_decimal(row[8])  # pledged
    row[10] = parse_int(row[10])    # backers
    row[12] = parse_decimal(row[12])# usd_pledged

    # Truncate text fields to schema safe max
    row[1] = truncate_string(row[1], 255)  # name
    row[2] = truncate_string(row[2], 100)  # category
    row[3] = truncate_string(row[3], 100)  # main_category
    row[4] = truncate_string(row[4], 10)   # currency ← YOUR COL5
    row[9] = truncate_string(row[9], 20)   # state
    row[11] = truncate_string(row[11], 10) # country
    row[13] = truncate_string(row[13], 100)
    row[14] = truncate_string(row[14], 100)
    row[15] = truncate_string(row[15], 100)
    row[16] = truncate_string(row[16], 250)

    return row

# === MAIN ===

kept = 0
skipped = 0

skip_lines = [20850, 206948]  # Lines to skip
max_rows = 372600              # Max lines total including header

with open(input_file, 'r', newline='', encoding='latin-1') as infile, \
     open(output_file, 'w', newline='', encoding='utf-8') as outfile:

    reader = csv.reader(infile)
    writer = csv.writer(outfile)

    line_num = 1  # start at header
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
