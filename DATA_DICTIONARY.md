# Data Dictionary — `student_placement`

100,000 rows · 26 raw columns (27 in the processed file, after
`placement_flag` is engineered). One row = one student.

| Column | Type | Range / Values | Description |
|---|---|---|---|
| `student_id` | int | 1–100,000 | Unique row identifier. No predictive meaning — exclude from modeling/correlation. |
| `age` | int | 18–24 | Student age in years. |
| `gender` | text | Male, Female | Self-reported gender. |
| `cgpa` | float | 4.5–10.0 | Cumulative GPA (10-point scale). |
| `branch` | text | CSE, IT, ECE, EEE, Mechanical, Civil | Engineering branch. |
| `college_tier` | text | Tier 1, Tier 2, Tier 3 | Institution tier. |
| `internships_count` | int | 0–8 | Number of internships completed. |
| `projects_count` | int | 0–13 | Number of academic/personal projects. |
| `certifications_count` | int | 0–11 | Number of professional certifications. |
| `coding_skill_score` | float | 20–100 | Internal coding assessment score. |
| `aptitude_score` | float | 20–100 | Aptitude test score. |
| `communication_skill_score` | float | 20–100 | Communication assessment score. |
| `logical_reasoning_score` | float | 20–100 | Logical reasoning test score. |
| `hackathons_participated` | int | 0–8 | Number of hackathons participated in. |
| `github_repos` | int | 0–16 | Public GitHub repository count. |
| `linkedin_connections` | int | 50–999 | LinkedIn connection count. |
| `mock_interview_score` | float | 20–100 | Average mock interview score. |
| `attendance_percentage` | float | 50–100 | Overall class attendance %. |
| `backlogs` | int | 0–6 | Number of academic backlogs (failed/pending courses). |
| `extracurricular_score` | float | 0–100 | Extracurricular activity score. |
| `leadership_score` | float | 0–100 | Leadership assessment score. |
| `volunteer_experience` | text | Yes, No | Whether the student has volunteering experience. |
| `sleep_hours` | float | 3–10 | Average daily sleep hours. |
| `study_hours_per_day` | float | 0.5–10 | Average daily study hours. |
| `placement_status` | text | Placed, Not Placed | Placement outcome — the target variable. |
| `salary_package_lpa` | float | 0–20.44 | Annual salary in lakhs per annum. **0 iff `placement_status = "Not Placed"`; always > 0 iff `"Placed"` — a perfect proxy for the target. Do not use as a model feature (see README § Data Leakage).** |
| `placement_flag` *(engineered)* | int | 0, 1 | `1` if `placement_status = "Placed"`, else `0`. Created in `python/03_data_cleaning.py`. |

## Known data characteristics

- **No missing values, no duplicate rows, no duplicate `student_id`s** in
  the raw file — the dataset arrives already structurally clean. The
  cleaning script's null/duplicate handling exists as defensive best
  practice, not because this run needed it.
- **Class balance:** 54,459 Placed (54.46%) vs. 45,541 Not Placed (45.54%)
  — close enough to balanced that accuracy alone would be a reasonable
  (though not the only) metric if this becomes a classification project.
- **Weak individual correlations with `placement_flag`** for every
  feature except `salary_package_lpa` (max |r| ≈ 0.08, `backlogs`). This
  is consistent with data generated with mostly-random feature/outcome
  relationships. `internships_count`, `projects_count`, and `backlogs`
  show the clearest — if still modest — directional patterns; see the
  README's Key Findings section.
