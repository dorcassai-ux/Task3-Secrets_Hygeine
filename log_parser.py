import os

api_key = os.environ.get("API_KEY")
if not api_key:
    raise SystemExit("API_KEY not set in environment")

count = 0
try:
    with open("app.log", "r") as f:
        for line in f:
            if "ERROR" in line:
                count += 1
    print(f"Total ERRORs found: {count}")
except FileNotFoundError:
    print("app.log not found")
