import csv

# === Paths ===
input_file = 'ks-projects-clean.csv'
output_file = 'ks-projects-USD.csv'

EXPECTED_COLS = 17

# === Approximate FX rates ===
exchange_rates = {
    'USD': 1.0,
    'GBP': 1 / 0.79,      # ~1.27
    'EUR': 1 / 0.92,      # ~1.09
    'CAD': 1 / 1.36,      # ~0.74
    'AUD': 1 / 1.5,       # ~0.67
    'NZD': 1 / 1.65,      # ~0.61
    'SGD': 1 / 1.35,      # ~0.74
    'JPY': 1 / 150,       # ~0.0067
    'MXN': 1 / 17,        # ~0.0588
    'HKD': 1 / 7.8,       # ~0.1282
    'DKK': 1 / 6.8,       # ~0.147
    'NOK': 1 / 10,        # ~0.10
    'SEK': 1 / 10,        # ~0.10
    'CHF': 1 / 0.9,       # ~1.11
}

def parse_decimal(value):
    try:
        return float(value.strip())
    except:
        return 0.0

def convert(amount, currency):
    fx = exchange_rates.get(currency, 1.0)
    return round(amount * fx, 2)

with open(input_file, 'r', newline='', encoding='latin-1') as infile, \
     open(output_file, 'w', newline='', encoding='utf-8') as outfile:

    reader = csv.reader(infile)
    writer = csv.writer(outfile)

    header = next(reader)
    writer.writerow(header)  # Same header, unchanged

    for row in reader:
        if len(row) < EXPECTED_COLS:
            row.extend([''] * (EXPECTED_COLS - len(row)))

        currency = row[4].strip()
        goal = parse_decimal(row[6])
        pledged = parse_decimal(row[8])
        usd_pledged = parse_decimal(row[12])

        row[6] = str(convert(goal, currency))
        row[8] = str(convert(pledged, currency))
        row[12] = str(convert(usd_pledged, currency))

        writer.writerow(row)

print(f"✅ Finished. All amounts converted to USD: {output_file}")
