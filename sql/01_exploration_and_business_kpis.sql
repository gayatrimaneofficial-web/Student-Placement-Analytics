-- ============================================================
-- STUDENT PLACEMENT ANALYTICS
-- MySQL 8.0+
--
-- This file consolidates the project's two original SQL scripts
-- (SQL_SCRIPT1.sql, SQL_SCRIPT2.sql) into one ordered analysis.
-- SQL_SCRIPT2.sql was a redundant subset of these queries and has
-- been removed from the repo to avoid duplication.
--
-- FIX APPLIED: the original script 1 opened with an unbounded
-- `SELECT * FROM student_placement;` (no LIMIT) against a
-- 100,000-row table. Removed — query #1 below (with LIMIT 10)
-- already covers row-level inspection safely.
-- ============================================================

USE student_placement_analytics;

-- ============================================================
-- 1. ROW COUNT + PREVIEW
-- ============================================================

SELECT COUNT(*) AS total_students
FROM student_placement;

SELECT *
FROM student_placement
LIMIT 10;


-- ============================================================
-- 6. CHECK DUPLICATE STUDENT IDs
-- ============================================================

SELECT
    student_id,
    COUNT(*) AS occurrences
FROM student_placement
GROUP BY student_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 7. CHECK MISSING VALUES
-- ============================================================

SELECT

    COUNT(*) AS total_rows,

    SUM(student_id IS NULL) AS missing_student_id,

    SUM(age IS NULL) AS missing_age,

    SUM(gender IS NULL) AS missing_gender,
    
    
  

    SUM(cgpa IS NULL) AS missing_cgpa,

    SUM(branch IS NULL) AS missing_branch,

    SUM(college_tier IS NULL) AS missing_college_tier,

    SUM(internships_count IS NULL) AS missing_internships,

    SUM(projects_count IS NULL) AS missing_projects,

    SUM(certifications_count IS NULL) AS missing_certifications,

    SUM(coding_skill_score IS NULL) AS missing_coding_score,

    SUM(aptitude_score IS NULL) AS missing_aptitude_score,

    SUM(communication_skill_score IS NULL) AS missing_communication_score,

    SUM(logical_reasoning_score IS NULL) AS missing_logical_score,

    SUM(mock_interview_score IS NULL) AS missing_mock_interview,

    SUM(attendance_percentage IS NULL) AS missing_attendance,

    SUM(placement_status IS NULL) AS missing_placement_status,

    SUM(salary_package_lpa IS NULL) AS missing_salary

FROM student_placement;


-- ============================================================
-- 8. PLACEMENT DISTRIBUTION
-- ============================================================

SELECT
    placement_status,
    COUNT(*) AS students
FROM student_placement
GROUP BY placement_status
ORDER BY students DESC;


-- ============================================================
-- 9. PLACEMENT FLAG VALIDATION
-- ============================================================

SELECT
    placement_status,
    placement_flag,
    COUNT(*) AS students
FROM student_placement
GROUP BY
    placement_status,
    placement_flag
ORDER BY
    placement_status,
    placement_flag;


-- ============================================================
-- 10. OVERALL PLACEMENT RATE
-- ============================================================

SELECT

    COUNT(*) AS total_students,

    SUM(placement_flag) AS placed_students,

    COUNT(*) - SUM(placement_flag) AS not_placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement;


-- ============================================================
-- 11. PLACEMENT RATE BY GENDER
-- ============================================================

SELECT

    gender,

    COUNT(*) AS total_students,

    SUM(placement_flag) AS placed_students,

    COUNT(*) - SUM(placement_flag) AS not_placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY gender

ORDER BY placement_rate_percentage DESC;


-- ============================================================
-- 12. PLACEMENT RATE BY BRANCH
-- ============================================================

SELECT

    branch,

    COUNT(*) AS total_students,

    SUM(placement_flag) AS placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY branch

ORDER BY placement_rate_percentage DESC;


-- ============================================================
-- 13. PLACEMENT RATE BY COLLEGE TIER
-- ============================================================

SELECT

    college_tier,

    COUNT(*) AS total_students,

    SUM(placement_flag) AS placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY college_tier

ORDER BY college_tier;


-- ============================================================
-- 14. CGPA VS PLACEMENT
-- ============================================================

SELECT

    placement_status,

    COUNT(*) AS students,

    ROUND(
        AVG(cgpa),
        2
    ) AS average_cgpa,

    ROUND(
        MIN(cgpa),
        2
    ) AS minimum_cgpa,

    ROUND(
        MAX(cgpa),
        2
    ) AS maximum_cgpa

FROM student_placement

GROUP BY placement_status;


-- ============================================================
-- 15. CGPA BAND ANALYSIS
-- ============================================================

SELECT

    CASE

        WHEN cgpa < 6 THEN 'Below 6'

        WHEN cgpa < 7 THEN '6-7'

        WHEN cgpa < 8 THEN '7-8'

        WHEN cgpa < 9 THEN '8-9'

        ELSE '9+'

    END AS cgpa_band,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY cgpa_band

ORDER BY cgpa_band;


-- ============================================================
-- 16. INTERNSHIPS VS PLACEMENT
-- ============================================================

SELECT

    internships_count,

    COUNT(*) AS students,

    SUM(placement_flag) AS placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY internships_count

ORDER BY internships_count;


-- ============================================================
-- 17. PROJECTS VS PLACEMENT
-- ============================================================

SELECT

    projects_count,

    COUNT(*) AS students,

    SUM(placement_flag) AS placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY projects_count

ORDER BY projects_count;


-- ============================================================
-- 18. CERTIFICATIONS VS PLACEMENT
-- ============================================================

SELECT

    certifications_count,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY certifications_count

ORDER BY certifications_count;


-- ============================================================
-- 19. HACKATHONS VS PLACEMENT
-- ============================================================

SELECT

    hackathons_participated,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY hackathons_participated

ORDER BY hackathons_participated;


-- ============================================================
-- 20. AVERAGE SKILLS: PLACED VS NOT PLACED
-- ============================================================

SELECT

    placement_status,

    ROUND(
        AVG(coding_skill_score),
        2
    ) AS avg_coding_score,

    ROUND(
        AVG(aptitude_score),
        2
    ) AS avg_aptitude_score,

    ROUND(
        AVG(communication_skill_score),
        2
    ) AS avg_communication_score,

    ROUND(
        AVG(logical_reasoning_score),
        2
    ) AS avg_logical_reasoning_score,

    ROUND(
        AVG(mock_interview_score),
        2
    ) AS avg_mock_interview_score

FROM student_placement

GROUP BY placement_status;


-- ============================================================
-- 21. ATTENDANCE VS PLACEMENT
-- ============================================================

SELECT

    placement_status,

    COUNT(*) AS students,

    ROUND(
        AVG(attendance_percentage),
        2
    ) AS average_attendance

FROM student_placement

GROUP BY placement_status;


-- ============================================================
-- 22. BACKLOGS VS PLACEMENT
-- ============================================================

SELECT

    backlogs,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY backlogs

ORDER BY backlogs;


-- ============================================================
-- 23. STUDY HOURS VS PLACEMENT
-- ============================================================

SELECT

    ROUND(study_hours_per_day, 1) AS study_hours,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY ROUND(study_hours_per_day, 1)

ORDER BY study_hours;


-- ============================================================
-- 24. SLEEP HOURS VS PLACEMENT
-- ============================================================

SELECT

    ROUND(sleep_hours, 1) AS sleep_hours,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY ROUND(sleep_hours, 1)

ORDER BY sleep_hours;


-- ============================================================
-- 25. GITHUB REPOSITORIES VS PLACEMENT
-- ============================================================

SELECT

    github_repos,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY github_repos

ORDER BY github_repos;


-- ============================================================
-- 26. LINKEDIN CONNECTIONS VS PLACEMENT
-- ============================================================

SELECT

    CASE

        WHEN linkedin_connections < 100
            THEN 'Below 100'

        WHEN linkedin_connections < 250
            THEN '100-249'

        WHEN linkedin_connections < 500
            THEN '250-499'

        ELSE '500+'

    END AS linkedin_band,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY linkedin_band;


-- ============================================================
-- 27. MOCK INTERVIEW VS PLACEMENT
-- ============================================================

SELECT

    placement_status,

    ROUND(
        AVG(mock_interview_score),
        2
    ) AS average_mock_interview_score

FROM student_placement

GROUP BY placement_status;


-- ============================================================
-- 28. LEADERSHIP VS PLACEMENT
-- ============================================================

SELECT

    leadership_score,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY leadership_score

ORDER BY leadership_score;


-- ============================================================
-- 29. EXTRACURRICULAR SCORE VS PLACEMENT
-- ============================================================

SELECT

    extracurricular_score,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY extracurricular_score

ORDER BY extracurricular_score;


-- ============================================================
-- 30. VOLUNTEER EXPERIENCE VS PLACEMENT
-- ============================================================

SELECT

    volunteer_experience,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY volunteer_experience

ORDER BY volunteer_experience;


-- ============================================================
-- 31. SALARY ANALYSIS
-- ============================================================

SELECT

    COUNT(*) AS placed_students,

    ROUND(
        AVG(salary_package_lpa),
        2
    ) AS average_salary_lpa,

    ROUND(
        MIN(salary_package_lpa),
        2
    ) AS minimum_salary_lpa,

    ROUND(
        MAX(salary_package_lpa),
        2
    ) AS maximum_salary_lpa

FROM student_placement

WHERE placement_flag = 1;


-- ============================================================
-- 32. SALARY BY BRANCH
-- ============================================================

SELECT

    branch,

    COUNT(*) AS placed_students,

    ROUND(
        AVG(salary_package_lpa),
        2
    ) AS average_salary_lpa,

    ROUND(
        MAX(salary_package_lpa),
        2
    ) AS highest_salary_lpa,

    ROUND(
        MIN(salary_package_lpa),
        2
    ) AS lowest_salary_lpa

FROM student_placement

WHERE placement_flag = 1

GROUP BY branch

ORDER BY average_salary_lpa DESC;


-- ============================================================
-- 33. SALARY BY COLLEGE TIER
-- ============================================================

SELECT

    college_tier,

    COUNT(*) AS placed_students,

    ROUND(
        AVG(salary_package_lpa),
        2
    ) AS average_salary_lpa

FROM student_placement

WHERE placement_flag = 1

GROUP BY college_tier

ORDER BY college_tier;


-- ============================================================
-- 34. SALARY BY CGPA BAND
-- ============================================================

SELECT

    CASE

        WHEN cgpa < 6 THEN 'Below 6'

        WHEN cgpa < 7 THEN '6-7'

        WHEN cgpa < 8 THEN '7-8'

        WHEN cgpa < 9 THEN '8-9'

        ELSE '9+'

    END AS cgpa_band,

    COUNT(*) AS placed_students,

    ROUND(
        AVG(salary_package_lpa),
        2
    ) AS average_salary_lpa

FROM student_placement

WHERE placement_flag = 1

GROUP BY cgpa_band

ORDER BY cgpa_band;


-- ============================================================
-- 35. TOP 20 HIGHEST SALARY STUDENTS
-- ============================================================

SELECT

    student_id,

    branch,

    college_tier,

    cgpa,

    internships_count,

    projects_count,

    coding_skill_score,

    aptitude_score,

    communication_skill_score,

    mock_interview_score,

    salary_package_lpa

FROM student_placement

WHERE placement_flag = 1

ORDER BY salary_package_lpa DESC

LIMIT 20;


-- ============================================================
-- 36. TOP STUDENTS BY OVERALL PROFILE
-- ============================================================

SELECT

    student_id,

    cgpa,

    internships_count,

    projects_count,

    certifications_count,

    coding_skill_score,

    aptitude_score,

    communication_skill_score,

    logical_reasoning_score,

    mock_interview_score,

    placement_status,

    salary_package_lpa

FROM student_placement

ORDER BY

    cgpa DESC,

    coding_skill_score DESC,

    aptitude_score DESC,

    mock_interview_score DESC

LIMIT 20;


-- ============================================================
-- 37. PLACEMENT RATE BY COMBINED EXPERIENCE
-- ============================================================

SELECT

    internships_count,

    projects_count,

    COUNT(*) AS students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY

    internships_count,

    projects_count

HAVING COUNT(*) >= 20

ORDER BY placement_rate_percentage DESC;


-- ============================================================
-- 38. STRONG TECHNICAL PROFILE
-- ============================================================

SELECT

    COUNT(*) AS students,

    SUM(placement_flag) AS placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

WHERE

    coding_skill_score >= 70

    AND aptitude_score >= 70

    AND logical_reasoning_score >= 70;


-- ============================================================
-- 39. STRONG ACADEMIC PROFILE
-- ============================================================

SELECT

    COUNT(*) AS students,

    SUM(placement_flag) AS placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

WHERE

    cgpa >= 8

    AND attendance_percentage >= 75

    AND backlogs = 0;


-- ============================================================
-- 40. STRONG CAREER PROFILE
-- ============================================================

SELECT

    COUNT(*) AS students,

    SUM(placement_flag) AS placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

WHERE

    internships_count >= 1

    AND projects_count >= 2

    AND certifications_count >= 2;


-- ============================================================
-- 41. PLACEMENT RATE BY BRANCH + COLLEGE TIER
-- ============================================================

SELECT

    branch,

    college_tier,

    COUNT(*) AS students,

    SUM(placement_flag) AS placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage

FROM student_placement

GROUP BY

    branch,

    college_tier

ORDER BY

    placement_rate_percentage DESC;


-- ============================================================
-- 42. PLACED VS NOT PLACED COMPLETE PROFILE
-- ============================================================

SELECT

    placement_status,

    COUNT(*) AS students,

    ROUND(AVG(cgpa), 2) AS avg_cgpa,

    ROUND(AVG(internships_count), 2) AS avg_internships,

    ROUND(AVG(projects_count), 2) AS avg_projects,

    ROUND(AVG(certifications_count), 2) AS avg_certifications,

    ROUND(AVG(coding_skill_score), 2) AS avg_coding,

    ROUND(AVG(aptitude_score), 2) AS avg_aptitude,

    ROUND(AVG(communication_skill_score), 2) AS avg_communication,

    ROUND(AVG(logical_reasoning_score), 2) AS avg_logic,

    ROUND(AVG(mock_interview_score), 2) AS avg_mock_interview,

    ROUND(AVG(attendance_percentage), 2) AS avg_attendance,

    ROUND(AVG(backlogs), 2) AS avg_backlogs,

    ROUND(AVG(study_hours_per_day), 2) AS avg_study_hours

FROM student_placement

GROUP BY placement_status;


-- ============================================================
-- 43. FINAL PROJECT SUMMARY
-- ============================================================

SELECT

    COUNT(*) AS total_students,

    SUM(placement_flag) AS placed_students,

    COUNT(*) - SUM(placement_flag) AS not_placed_students,

    ROUND(
        AVG(placement_flag) * 100,
        2
    ) AS placement_rate_percentage,

    ROUND(
        AVG(cgpa),
        2
    ) AS average_cgpa,

    ROUND(
        AVG(attendance_percentage),
        2
    ) AS average_attendance,

    ROUND(
        AVG(internships_count),
        2
    ) AS average_internships,

    ROUND(
        AVG(projects_count),
        2
    ) AS average_projects

FROM student_placement;


-- ============================================================
-- 44. DATA LEAKAGE CHECK — SALARY_PACKAGE_LPA VS PLACEMENT_FLAG
-- ============================================================
-- CRITICAL FINDING: salary_package_lpa is 0 for every single
-- "Not Placed" student and > 0 for every single "Placed" student.
-- It is a deterministic proxy for the target, not an independent
-- feature (Pearson r = 0.98 against placement_flag). If this
-- column is Placed AFTER placement is decided, it must be
-- EXCLUDED from any placement-prediction model. It should only
-- ever be used downstream of placement (e.g. salary analysis for
-- students who already got placed), never as a model input.
-- ============================================================

SELECT
    placement_status,
    COUNT(*) AS students,
    SUM(salary_package_lpa = 0) AS students_with_zero_salary,
    SUM(salary_package_lpa > 0) AS students_with_nonzero_salary
FROM student_placement
GROUP BY placement_status;
