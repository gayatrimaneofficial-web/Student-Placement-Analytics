"""
01_load_data.py
----------------
First-look load of the raw student placement dataset.
Run from the /python folder: python 01_load_data.py
"""

import pandas as pd

RAW_DATA_PATH = "../data/raw/student_placement_prediction_raw_data.csv"

df = pd.read_csv(RAW_DATA_PATH)

print("\n" + "=" * 60)
print("DATASET LOADED")
print("=" * 60)

print("\nShape:")
print(df.shape)

print("\nColumns:")
print(df.columns.tolist())

print("\nFirst 5 rows:")
print(df.head())

print("\nData types:")
print(df.dtypes)

print("\nMissing values:")
print(df.isnull().sum())

print("\nDuplicate rows:")
print(df.duplicated().sum())

print("\nSummary:")
print(df.describe(include="all").T)
