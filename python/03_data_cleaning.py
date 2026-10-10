"""
03_data_cleaning.py
--------------------
Cleans the raw dataset and writes student_placement_clean.csv:
standardises column names, drops empty rows/duplicates, trims text
fields, safely coerces numeric-looking text columns, and derives
placement_flag from placement_status.
Run from the /python folder: python 03_data_cleaning.py
"""

import pandas as pd
import numpy as np

RAW_DATA_PATH = "../data/raw/student_placement_prediction_raw_data.csv"
CLEAN_DATA_PATH = "../data/processed/student_placement_clean.csv"

# ============================================================
# LOAD RAW DATA
# ============================================================

df = pd.read_csv(RAW_DATA_PATH)

print("Original shape:", df.shape)


# ============================================================
# CLEAN COLUMN NAMES
# ============================================================

df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace("-", "_")
)

print("\nColumn names:")
print(df.columns.tolist())


# ============================================================
# REMOVE EMPTY ROWS
# ============================================================

df = df.dropna(how="all")


# ============================================================
# REMOVE DUPLICATES
# ============================================================

print("\nDuplicates removed:", df.duplicated().sum())

df = df.drop_duplicates()


# ============================================================
# CLEAN TEXT COLUMNS
# ============================================================

text_columns = df.select_dtypes(include="object").columns

for column in text_columns:
    df[column] = df[column].astype(str).str.strip()


# ============================================================
# CONVERT POSSIBLE NUMERIC COLUMNS
# ------------------------------------------------------------
# NOTE: this heuristic (coerce to numeric, keep the conversion if
# >=80% of values parse) is convenient but not bullet-proof — a
# genuinely categorical column whose codes happen to be mostly
# numeric-looking strings (e.g. postal/ID codes) could be silently
# converted. Verified safe for this dataset: every text column
# (gender, branch, college_tier, volunteer_experience,
# placement_status) is 0% numeric-parseable, so none are affected.
# Revisit this block first if new categorical columns are added.
# ============================================================

for column in df.columns:
    if df[column].dtype == "object":
        converted = pd.to_numeric(df[column], errors="coerce")
        if converted.notna().mean() >= 0.8:
            df[column] = converted


# ============================================================
# PLACEMENT STATUS
# ============================================================

if "placement_status" in df.columns:
    df["placement_status"] = df["placement_status"].str.strip().str.title()
    df["placement_flag"] = np.where(df["placement_status"] == "Placed", 1, 0)


# ============================================================
# SAVE CLEAN DATA
# ============================================================

df.to_csv(CLEAN_DATA_PATH, index=False)


# ============================================================
# FINAL CHECK
# ============================================================

print("\n" + "=" * 60)
print("CLEANING COMPLETED")
print("=" * 60)

print("\nFinal shape:")
print(df.shape)

print("\nRemaining missing values:")
print(df.isnull().sum())

print("\nClean file created:")
print(CLEAN_DATA_PATH)
