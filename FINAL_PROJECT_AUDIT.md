# Final Project QA Audit

Date: 23 August 2026

## Checks performed

| Area | Check | Result |
|---|---|---|
| Raw data | 100,000 rows / 26 columns | PASS |
| Missing values | 0 | PASS |
| Duplicate rows | 0 | PASS |
| Duplicate student IDs | 0 | PASS |
| Placement count | 54,459 placed / 45,541 not placed | PASS |
| Placement rate | 54.46% | PASS |
| Processed data | 100,000 rows / 27 columns | PASS |
| Salary leakage | 0 salary for every non-placed; >0 for every placed | PASS / DOCUMENTED |
| EDA script | Original script failed under current Seaborn due to implicit color handling | FIXED |
| EDA outputs | Six figures are present | PASS |
| SQL | Syntax/logic reviewed statically; MySQL execution not available in this environment | REVIEWED |
| Power BI structure | PBIX opens as a ZIP package with report layout/model resources | PASS (structural) |
| Power BI page count | Supplied PBIX has 2 pages | CLARIFIED |
| Documentation consistency | README/deck/report references to 4 pages corrected | FIXED |

## Important clarification

The original project materials were inconsistent about Power BI page count. The actual supplied PBIX has **2 pages** (`Executive Overview` and `Insight`). References to “4 pages” were documentation errors and have been corrected in the final package.

## Data-quality clarification

The raw dataset is already structurally clean: there are no missing values, duplicate rows or duplicate IDs. The cleaning script is still appropriate because it demonstrates a reproducible cleaning pipeline and derives the analysis-ready `placement_flag`.

## Modelling warning

`salary_package_lpa` is target leakage. It must be excluded from any model predicting placement. It can remain in downstream salary/outcome analysis for already-placed students.

## Final status

**READY FOR STUDENT SUBMISSION**, provided the presenter describes the Power BI asset accurately as a **2-page dashboard** and does not claim causal conclusions or a trained prediction model that is not included.
