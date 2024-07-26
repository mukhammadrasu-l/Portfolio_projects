/* 
  Analysis of students' test scores in math, reading, and writing.
  Objectives:
  1) Compare male and female test scores.
  2) Examine the impact of parental education on performance.
  3) Investigate the effect of lunch type on performance.
  4) Assess the impact of test preparation courses.
  5) Compare performance across different races/ethnicities.
  6) Analyze the educational level of parents across races.
  7) Determine average and maximum scores for each race.
*/

-- Gender distribution
SELECT 
    gender, 
    COUNT(gender) AS count,
    ROUND(COUNT(gender) / (SELECT COUNT(*) FROM students_performance.studentsperformance), 2) AS percent 
FROM 
    students_performance.studentsperformance
GROUP BY 
    gender;

-- Math score distribution by gender
SELECT 
    gender, 
    COUNT(CASE WHEN `math score` > (SELECT AVG(`math score`) FROM students_performance.studentsperformance) THEN 1 ELSE NULL END) AS above_average,
    COUNT(CASE WHEN `math score` <= (SELECT AVG(`math score`) FROM students_performance.studentsperformance) THEN 1 ELSE NULL END) AS below_average
FROM 
    students_performance.studentsperformance
GROUP BY 
    gender;

-- Average math score by gender
SELECT gender, ROUND(AVG(`math score`), 1) AS math_average FROM  students_performance.studentsperformance GROUP BY 1 ORDER BY 2 DESC;

-- Average scores in math, reading, and writing by gender
WITH average_scores AS(
	SELECT 
        gender, 
        ROUND(AVG(`math score`), 1) AS math_average,
        ROUND(AVG(`reading score`), 1) AS reading_average,
        ROUND(AVG(`writing score`), 1) AS writing_average
    FROM  
        students_performance.studentsperformance
    GROUP BY 1
)
SELECT 
    gender, math_average, reading_average, writing_average
FROM
    average_scores
GROUP BY 1
ORDER BY 3 DESC;

-- Number of maximum scores by gender
WITH max_scores AS (
	SELECT 
        gender,
        COUNT(CASE WHEN `math score` = (SELECT MAX(`math score`) FROM students_performance.studentsperformance) THEN 1 END) AS total_math,
        COUNT(CASE WHEN `reading score` = (SELECT MAX(`reading score`) FROM students_performance.studentsperformance) THEN 1 END) AS total_reading,
        COUNT(CASE WHEN `writing score` = (SELECT MAX(`writing score`) FROM students_performance.studentsperformance) THEN 1 END) AS total_writing
	FROM 
	    students_performance.studentsperformance 
    GROUP BY 1
)
SELECT 
	gender, total_math, total_reading, total_writing, 
    total_math + total_reading + total_writing AS total_scores
FROM 
	max_scores 
GROUP BY 1 
ORDER BY total_scores DESC;

-- Average scores by parental education level
SELECT  
    `parental level of education`, 
    ROUND(AVG(`math score`), 1) AS math_average, 
    ROUND(AVG(`reading score`), 1) AS reading_average, 
    ROUND(AVG(`writing score`), 1) AS writing_average 
FROM 
    students_performance.studentsperformance
GROUP BY 
    `parental level of education`
ORDER BY 
    math_average DESC;

-- Number of maximum scores by parental education level
WITH top_scores AS (
	SELECT 
        `parental level of education`,
        COUNT(CASE WHEN `math score` = (SELECT MAX(`math score`) FROM students_performance.studentsperformance) THEN 1 END) AS total_math,
        COUNT(CASE WHEN `reading score` = (SELECT MAX(`reading score`) FROM students_performance.studentsperformance) THEN 1 END) AS total_reading,
        COUNT(CASE WHEN `writing score` = (SELECT MAX(`writing score`) FROM students_performance.studentsperformance) THEN 1 END) AS total_writing,
        COUNT(`gender`) AS total
	FROM 
	    students_performance.studentsperformance 
    GROUP BY 1
)
SELECT 
    `parental level of education`, total_math, total_reading, total_writing, 
    total_math + total_reading + total_writing AS total_scores, total
FROM 
	top_scores
GROUP BY 1 
ORDER BY total_scores DESC;

-- Average scores by lunch type
SELECT 
    lunch, 
    ROUND(AVG(`math score`), 1) AS math_average, 
    ROUND(AVG(`reading score`), 1) AS reading_average, 
    ROUND(AVG(`writing score`), 1) AS writing_average 
FROM 
    students_performance.studentsperformance
GROUP BY 
    lunch;

-- Average scores by test preparation course completion
SELECT 
    `test preparation course`, 
    ROUND(AVG(`math score`), 1) AS math_average, 
    ROUND(AVG(`reading score`), 1) AS reading_average, 
    ROUND(AVG(`writing score`) , 1) AS writing_average 
FROM 
    students_performance.studentsperformance
GROUP BY 
    `test preparation course`
ORDER BY 
    math_average DESC;

-- Average scores by race/ethnicity
SELECT 
    `race/ethnicity`, 
    ROUND(AVG(`math score`), 1) AS math_average, 
    ROUND(AVG(`reading score`), 1) AS reading_average, 
    ROUND(AVG(`writing score`), 1) AS writing_average 
FROM 
    students_performance.studentsperformance
GROUP BY 
    `race/ethnicity`
ORDER BY 
    math_average DESC;

-- Number of maximum scores by race/ethnicity
WITH top_races AS (
	SELECT 
        `race/ethnicity`,
        COUNT(CASE WHEN `math score` = (SELECT MAX(`math score`) FROM students_performance.studentsperformance) THEN 1 END) AS total_math,
        COUNT(CASE WHEN `reading score` = (SELECT MAX(`reading score`) FROM students_performance.studentsperformance) THEN 1 END) AS total_reading,
        COUNT(CASE WHEN `writing score` = (SELECT MAX(`writing score`) FROM students_performance.studentsperformance) THEN 1 END) AS total_writing
	FROM 
	    students_performance.studentsperformance 
    GROUP BY 1
)
SELECT 
    `race/ethnicity`, total_math, total_reading, total_writing, 
    total_math + total_reading + total_writing AS total_scores
FROM 
	top_races 
GROUP BY 1 
ORDER BY total_scores DESC;

-- Parental education level by race/ethnicity
SELECT `race/ethnicity`, 
    COUNT(CASE WHEN `parental level of education` = "master's degree" THEN 1 END) AS masters,
    COUNT(CASE WHEN `parental level of education` = "bachelor's degree" THEN 1 END) AS bachelors,
    COUNT(CASE WHEN `parental level of education` = "some college" THEN 1 END) AS some_college,
    COUNT(CASE WHEN `parental level of education` = "associate's degree" THEN 1 END) AS associates,
    COUNT(CASE WHEN `parental level of education` = "high school" THEN 1 END) AS high_school,
    COUNT(CASE WHEN `parental level of education` = "some high school" THEN 1 END) AS some_high_school,
    COUNT(`gender`) AS total_people
 FROM students_performance.studentsperformance
GROUP BY 1 
ORDER BY total_people DESC;

-- Second highest score in each race/ethnicity
WITH RankedScores AS (
    SELECT 
        `race/ethnicity`, 
        `math score`, 
        `writing score`, 
        `reading score`,
        DENSE_RANK() OVER (PARTITION BY `race/ethnicity` ORDER BY `math score` DESC) AS math_rank,
        DENSE_RANK() OVER (PARTITION BY `race/ethnicity` ORDER BY `writing score` DESC) AS writing_rank,
        DENSE_RANK() OVER (PARTITION BY `race/ethnicity` ORDER BY `reading score` DESC) AS reading_rank
    FROM 
        students_performance.studentsperformance
)
SELECT 
    `race/ethnicity`,
    MAX(CASE WHEN math_rank = 2 THEN `math score` END) AS second_highest_math_score,
    MAX(CASE WHEN writing_rank = 2 THEN `writing score` END) AS second_highest_writing_score,
    MAX(CASE WHEN reading_rank = 2 THEN `reading score` END) AS second_highest_reading_score
FROM 
    RankedScores
GROUP BY 
    `race/ethnicity`
ORDER BY 1 DESC;

/* 
Conclusions: 
1) Females excel in reading and writing, while males perform better in math.
2) Higher parental education levels positively impact students' average performance.
3) Standard lunch leads to better performance.
4) Completing test preparation courses improves test results.
5) Group E consistently outperforms other races/ethnicities.
*/
