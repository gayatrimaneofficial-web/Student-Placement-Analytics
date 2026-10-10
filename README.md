# Student Placement Analytics | Python, SQL & Power BI

An end-to-end analytics project exploring student placement outcomes across 100,000 student records. The workflow includes data-quality checks, data cleaning, exploratory data analysis (EDA), SQL-based KPI analysis, and a two-page Power BI dashboard.

## Business Problem

Placement teams need evidence to understand how student attributes relate to placement outcomes and where additional support may be useful. This project explores placement patterns across academic performance, internships, projects, skills, and student segments.

## Tools Used

- **Python:** pandas, NumPy, Matplotlib, Seaborn
- **SQL:** MySQL-oriented business and KPI queries
- **Power BI:** Interactive dashboard and KPI reporting
- **Excel/CSV:** Dataset inspection and data handling

## Dataset Summary

| Metric | Value |
|---|---:|
| Student records | 100,000 |
| Raw columns | 26 |
| Processed columns | 27 |
| Placed students | 54,459 |
| Students not placed | 45,541 |
| Placement rate | 54.46% |

These values are documented in the project QA audit and should be treated as dataset-specific, not as real-world estimates. The dataset appears synthetic/generated; conclusions should not be generalized to a real institution without validation.

## Workflow

1. Load and inspect the raw dataset.
2. Check missing values, duplicate rows, identifiers, and value consistency.
3. Clean data and derive `placement_flag`.
4. Explore placement outcomes with Python visualizations.
5. Query business KPIs and student segments using SQL.
6. Present metrics and patterns in Power BI.

## Questions Explored

- What is the overall placement rate?
- How do placement rates vary by branch and college tier?
- How are internships, projects, backlogs, CGPA, and attendance associated with placement outcomes?
- What data-quality risks should be considered before predictive modelling?

## Key Findings

- The dataset's overall placement rate is **54.46%**.
- Individual relationships between many student attributes and placement are weak in this dataset.
- Internship and project counts show positive directional associations with placement, while backlogs show a negative association.
- These patterns are associations, not evidence that a factor causes placement success.

## Important: Target Leakage

`salary_package_lpa` is a post-placement outcome. In this dataset, students marked as not placed have salary values of zero while placed students have positive salary values. This makes salary a proxy for the target.

**Do not use `salary_package_lpa` as an input feature in a model predicting placement.** It can be analyzed separately for salary-related questions after placement.

## Power BI Dashboard

The supplied Power BI file contains two pages: **Executive Overview** and **Insight**.

File: [`dashboard/dashboard_final.pbix`](dashboard/dashboard_final.pbix)
<img width="1391" height="777" alt="dashboard_preview" src="https://github.com/user-attachments/assets/3e7cc435-60a7-48bb-9ab5-5636b45730d7" />



Open it with Power BI Desktop to explore the report. A preview image is not included because the source package did not provide a verified dashboard screenshot in this project folder.

## Repository Structure

```text
student-placement-analytics/
├── README.md
├── PROBLEM STATEMENT.md
├── FINAL_PROJECT_AUDIT.md
├── LICENSE
├── requirements.txt
├── data/
│   ├── raw/
│   ├── processed/
│   └── DATA_DICTIONARY.md
├── python/
│   ├── 01_load_data.py
│   ├── 02_data_quality.py
│   ├── 03_data_cleaning.py
│   └── 04_eda.py
├── sql/
│   └── 01_exploration_and_business_kpis.sql
├── reports/figures/
├── dashboard/dashboard_final.pbix
└── presentation/Student_Placement_Analytics_Deck.pptx
```

## Run the Python Scripts

Python 3 is recommended. Install the dependencies from the repository root:

```bash
pip install -r requirements.txt
```

Then run the scripts from the `python` directory, in order:

```bash
cd python
python 01_load_data.py
python 02_data_quality.py
python 03_data_cleaning.py
python 04_eda.py
```

The scripts expect the folder structure shown above. The EDA script writes chart outputs to `reports/figures/`.

## SQL

Open `sql/01_exploration_and_business_kpis.sql` in MySQL Workbench or another compatible SQL editor. Review the database/table names in the script and update them to match your local setup before execution.

## Limitations

- The dataset appears synthetic/generated and is not evidence of actual placement outcomes at a specific college.
- Group comparisons and correlations do not establish causation.
- No trained predictive model is included in this project.
- `salary_package_lpa` must be excluded from any future placement-prediction model due to target leakage.
- SQL was reviewed as part of the project audit, but execution against a live MySQL database was not confirmed in that audit.

## Future Improvements

- Add automated data-quality tests.
- Create a reproducible SQL setup script.
- Build a baseline predictive model with leakage-safe features and proper train/test validation.
- Add a dashboard preview and document the measures used.

## Author

**Gayatri Mane**  
Aspiring Data Analyst | Python | SQL | Power BI | Excel

- GitHub: 
- Project: Student Placement Analytics
