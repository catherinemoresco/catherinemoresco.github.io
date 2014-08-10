# ss-day.py
# Report annual Saffir-Simpson day totals for each year from NOAA data.

import csv, sys


reader = csv.reader(sys.stdin)
	for row in reader:
		print row