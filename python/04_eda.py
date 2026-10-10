"""
04_eda.py
---------
Exploratory data analysis on the cleaned dataset: placement
distribution, CGPA/attendance vs placement, internships/projects
vs placement rate, and a correlation matrix.

FIXES vs the original script:
  1. Paths corrected to the repo's /data folder structure.
  2. Every chart is now saved to ../reports/figures/ via
     plt.savefig() instead of relying only on plt.show(), so the
     script is reproducible headlessly (CI, servers, no display).
  3. student_id is dropped before computing the correlation matrix
     — an identifier column has no real correlation meaning and
     just adds noise to the heatmap.
  4. Explicit console warning about salary_package_lpa leakage
     printed right after the correlation matrix is computed.

Run from the /python folder: python 04_eda.py
"""

import os

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

CLEAN_DATA_PATH = "../data/processed/student_placement_clean.csv"
FIGURES_DIR = "../reports/figures"

os.makedirs(FIGURES_DIR, exist_ok=True)

# Load cleaned data
df = pd.read_csv(CLEAN_DATA_PATH)

print("Dataset shape:")
print(df.shape)


# ============================================================
# SEABORN STYLE
# ============================================================

sns.set_theme(style="whitegrid")


def save_and_close(filename):
    """Save the current figure to FIGURES_DIR and close it."""
    path = os.path.join(FIGURES_DIR, filename)
    plt.savefig(path, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"Saved: {path}")


# ============================================================
# 1. PLACEMENT DISTRIBUTION
# ============================================================

if "placement_status" in df.columns:

    print("\nPlacement Status:")
    print(df["placement_status"].value_counts())

    plt.figure(figsize=(8, 5))
    sns.countplot(data=df, x="placement_status", hue="placement_status", legend=False)
    plt.title("Student Placement Status")
    plt.xlabel("Placement Status")
    plt.ylabel("Number of Students")
    plt.tight_layout()
    save_and_close("01_placement_status_distribution.png")


# ============================================================
# 2. CGPA VS PLACEMENT
# ============================================================

if "cgpa" in df.columns and "placement_status" in df.columns:

    plt.figure(figsize=(8, 5))
    sns.boxplot(data=df, x="placement_status", y="cgpa")
    plt.title("CGPA by Placement Status")
    plt.xlabel("Placement Status")
    plt.ylabel("CGPA")
    plt.tight_layout()
    save_and_close("02_cgpa_by_placement_status.png")


# ============================================================
# 3. ATTENDANCE VS PLACEMENT
# ============================================================

if "attendance_percentage" in df.columns and "placement_status" in df.columns:

    attendance = df.groupby("placement_status")["attendance_percentage"].mean()

    print("\nAverage Attendance:")
    print(attendance)

    plt.figure(figsize=(8, 5))
    sns.barplot(x=attendance.index, y=attendance.values, hue=attendance.index, legend=False)
    plt.title("Average Attendance by Placement Status")
    plt.xlabel("Placement Status")
    plt.ylabel("Average Attendance (%)")
    plt.tight_layout()
    save_and_close("03_avg_attendance_by_placement_status.png")


# ============================================================
# 4. INTERNSHIPS VS PLACEMENT
# ============================================================

if "internships_count" in df.columns and "placement_flag" in df.columns:

    internship_analysis = df.groupby("internships_count")["placement_flag"].mean() * 100

    print("\nPlacement Rate by Internships:")
    print(internship_analysis)

    plt.figure(figsize=(10, 5))
    sns.barplot(x=internship_analysis.index, y=internship_analysis.values, hue=internship_analysis.index, legend=False)
    plt.title("Placement Rate by Number of Internships")
    plt.xlabel("Number of Internships")
    plt.ylabel("Placement Rate (%)")
    plt.tight_layout()
    save_and_close("04_placement_rate_by_internships.png")


# ============================================================
# 5. PROJECTS VS PLACEMENT
# ============================================================

if "projects_count" in df.columns and "placement_flag" in df.columns:

    project_analysis = df.groupby("projects_count")["placement_flag"].mean() * 100

    print("\nPlacement Rate by Projects:")
    print(project_analysis)

    plt.figure(figsize=(10, 5))
    sns.barplot(x=project_analysis.index, y=project_analysis.values, hue=project_analysis.index, legend=False)
    plt.title("Placement Rate by Number of Projects")
    plt.xlabel("Number of Projects")
    plt.ylabel("Placement Rate (%)")
    plt.tight_layout()
    save_and_close("05_placement_rate_by_projects.png")


# ============================================================
# 6. CORRELATION HEATMAP
# ============================================================

numeric_columns = df.select_dtypes(include=np.number).columns.drop(
    "student_id", errors="ignore"
)

correlation = df[numeric_columns].corr()

plt.figure(figsize=(14, 10))
sns.heatmap(correlation, annot=True, fmt=".2f", cmap="coolwarm")
plt.title("Correlation Matrix")
plt.tight_layout()
save_and_close("06_correlation_matrix.png")

# ------------------------------------------------------------
# TARGET LEAKAGE WARNING
# salary_package_lpa correlates ~0.98 with placement_flag because
# it is 0 for every non-placed student and non-zero for every
# placed student — it is derived FROM the outcome, not a genuine
# predictor. Any downstream model must drop this column from the
# feature set. See sql/01_exploration_and_business_kpis.sql
# (query 44) for the row-level proof.
# ------------------------------------------------------------
if "placement_flag" in correlation.columns:
    target_corr = correlation["placement_flag"].drop("placement_flag").sort_values(
        ascending=False
    )
    print("\n" + "=" * 60)
    print("CORRELATION WITH placement_flag (excluding itself)")
    print("=" * 60)
    print(target_corr)

    if "salary_package_lpa" in target_corr.index and target_corr["salary_package_lpa"] > 0.9:
        print(
            "\n[WARNING] salary_package_lpa correlates "
            f"{target_corr['salary_package_lpa']:.2f} with placement_flag. "
            "This is target leakage (salary is only known AFTER placement) "
            "— exclude it from any predictive model's feature set."
        )


# ============================================================
# FINAL SUMMARY
# ============================================================

print("\n" + "=" * 60)
print("EDA COMPLETED")
print("=" * 60)

print("\nTotal students:", len(df))

if "placement_flag" in df.columns:
    print("Placement rate:", round(df["placement_flag"].mean() * 100, 2), "%")

if "cgpa" in df.columns:
    print("Average CGPA:", round(df["cgpa"].mean(), 2))
