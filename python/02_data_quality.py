"""
02_data_quality.py
-------------------
Structured data-quality audit of the raw dataset: shape, dtypes,
missing values, duplicates, cardinality, and per-column distributions.
Run from the /python folder: python 02_data_quality.py
"""

import pandas as pd
import numpy as np

RAW_DATA_PATH = "../data/raw/student_placement_prediction_raw_data.csv"

df = pd.read_csv(RAW_DATA_PATH)

print("\n" + "=" * 60)
print("DATA QUALITY CHECK")
print("=" * 60)

# Shape
print("\nRows:", df.shape[0])
print("Columns:", df.shape[1])

# Data types
print("\nData Types:")
print(df.dtypes)

# Missing values
print("\nMissing Values:")
print(df.isnull().sum())

# Missing percentage
print("\nMissing Percentage:")
print((df.isnull().mean() * 100).round(2))

# Duplicates
print("\nDuplicate Rows:")
print(df.duplicated().sum())

# Unique values
print("\nUnique Values:")
for column in df.columns:
    print(column, ":", df[column].nunique())

# Categorical columns
print("\nCategorical Columns:")

categorical_columns = df.select_dtypes(include="object").columns

for column in categorical_columns:
    print("\n", column)
    print(df[column].value_counts(dropna=False))

# Numeric columns
print("\nNumeric Columns:")

numeric_columns = df.select_dtypes(include=np.number).columns

for column in numeric_columns:
    print("\n", column)
    print("Minimum:", df[column].min())
    print("Maximum:", df[column].max())
    print("Mean:", df[column].mean())
    print("Median:", df[column].median())

# ============================================================
# TARGET-LEAKAGE FLAG
# ------------------------------------------------------------
# salary_package_lpa is 0 for every "Not Placed" student and > 0
# for every "Placed" student — it is a deterministic function of
# the outcome, not an independent predictor. See README /
# sql/01_exploration_and_business_kpis.sql (query 44) for proof.
# Exclude it from any placement-prediction feature set.
# ============================================================
if {"salary_package_lpa", "placement_status"}.issubset(df.columns):
    leak_check = (
        df.groupby("placement_status")["salary_package_lpa"]
        .agg(zero_salary=lambda s: (s == 0).sum(), nonzero_salary=lambda s: (s > 0).sum())
    )
    print("\n" + "=" * 60)
    print("TARGET LEAKAGE CHECK: salary_package_lpa vs placement_status")
    print("=" * 60)
    print(leak_check)
