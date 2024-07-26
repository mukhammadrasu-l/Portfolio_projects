   Unveiling Insights from Students' Performance Data 📚✨
   
   Project Objective 🎯

In the Students Performance Analysis project, we're on a mission to answer some burning questions that might just change how we see education forever! 🚀✨

  **Gender Matters**: How does gender impact performance in math, reading, and writing? Are boys really better at math, or is it just a myth? 🤔
 
  **Parental Influence**: What's the correlation between students' test scores and their parents' educational levels? Does having a mom with a PhD make you a genius by default? 🧠🏆
  
  **Lunchbox Chronicles**: How does the type of lunch a student receives affect their academic performance? Is there magic in a well-balanced meal? 🍎🥪
    
 ** Prep Course Power**: Does completing a test preparation course significantly boost students' scores? Is cramming really the secret sauce to acing exams? 📚💡
  
**Cultural Context**: How do different racial and ethnic groups compare in terms of academic achievement? Are there hidden stories in the statistics? 🌍📊
  
  **Top Scorers' Secrets**: Which factors contribute most to students achieving the highest scores? What's the secret recipe for academic excellence? 🏅🎓

By diving into these questions, we're not just crunching numbers; we're uncovering the real stories that can help educators, policymakers, and anyone who cares about education make better decisions. 🎉💪
The Dataset: Our Starting Point

The Dataset: Our Starting Point 🗂️🔍

Our dataset is a treasure trove of information, including:

    Gender 👩‍🎓👨‍🎓
    Race/Ethnicity 🎨
    Parental Level of Education 🎓
    Lunch Type 🍴
    Test Preparation Course Completion 📘
    Math Score ➕
    Reading Score 📖
    Writing Score ✍️

  ![Screenshot 2024-07-26 151106](https://github.com/user-attachments/assets/9e8f6d71-b27c-447c-b088-2d4fb74e205d)

  Setting the Scene: Gender and Performance 👧👦

Exploring Gender Distribution

We kick off our journey by looking at the gender distribution. Understanding who our students are is the first step in appreciating their unique paths to success.

    SELECT 
      gender, 
      COUNT(gender) AS count,
      ROUND(COUNT(gender) / (SELECT COUNT(*) FROM students_performance.studentsperformance), 2) AS percent 
    FROM 
      students_performance.studentsperformance
    GROUP BY 
       gender;


![Screenshot 2024-07-26 152526](https://github.com/user-attachments/assets/0eeaad78-f538-4b4f-b5e3-efe3da052818)

Unearthing Math Score Patterns

Next, we dive into the math score distribution by gender. Are boys really better at math, or do girls hold the secret to numerical prowess? 🧮✨

    SELECT 
        gender, 
        COUNT(CASE WHEN `math score` > (SELECT AVG(`math score`) FROM students_performance.studentsperformance) THEN 1 ELSE NULL END) AS above_average,
        COUNT(CASE WHEN `math score` <= (SELECT AVG(`math score`) FROM students_performance.studentsperformance) THEN 1 ELSE NULL END) AS below_average
    FROM 
        students_performance.studentsperformance
    GROUP BY 
        gender;
![image](https://github.com/user-attachments/assets/235899fa-d4c5-42d3-a689-6842b14dee3e)

Comparing Averages

By comparing the average math scores by gender, we identify trends and deviations. This comparison highlights the strengths and weaknesses of each group, providing a foundation for targeted interventions.

    SELECT 
      gender, 
      ROUND(AVG(`math score`), 1) AS math_average 
    FROM  
      students_performance.studentsperformance 
    GROUP BY 1 
    ORDER BY 2 DESC;

![image](https://github.com/user-attachments/assets/17caefbe-40ec-4483-85f5-e03eff0bffbb)

Diving Deeper: Holistic Academic Performance 🧠🌟

Comprehensive Score Analysis

Next, we analyze the average scores in math, reading, and writing by gender. This holistic view allows us to appreciate the multifaceted nature of academic performance.

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

![image](https://github.com/user-attachments/assets/2193b86f-7ded-4f2e-b4c0-009796d514b8)

Recognizing Top Performers

We celebrate excellence by identifying the number of maximum scores by gender. Highlighting top performers showcases the potential within each group and sets benchmarks for success.

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

  ![image](https://github.com/user-attachments/assets/536d0fb9-6c4c-4f7d-926a-b3a058960229)

Influences from Home: Parental Education 🏠🎓

Impact of Parental Education

We explore the average scores by parental education level to understand how the educational background of parents influences student performance. This analysis provides insights into the advantages and challenges faced by students from different backgrounds.

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

  ![image](https://github.com/user-attachments/assets/b55c0b47-f7cc-4d3d-a459-e403a2a84256)

  Celebrating Educational Legacy

By counting the number of maximum scores by parental education level, we recognize the legacy of educational attainment and its impact on student success.

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

![image](https://github.com/user-attachments/assets/57dc0c0a-725a-475f-85ad-0f8506f61f32)

Nutritional Influence: Lunch Type 🍏🍱

Examining Lunch Type

We analyze the average scores by lunch type to uncover the impact of nutrition on academic performance. This step highlights the importance of adequate nourishment for optimal learning.

    SELECT 
        lunch, 
        ROUND(AVG(`math score`), 1) AS math_average, 
        ROUND(AVG(`reading score`), 1) AS reading_average, 
        ROUND(AVG(`writing score`), 1) AS writing_average 
    FROM 
        students_performance.studentsperformance
    GROUP BY 
        lunch;

![image](https://github.com/user-attachments/assets/3a525900-12d4-4452-822b-34b49bd6c16d)

Extra Efforts: Test Preparation 📖🏆

Effectiveness of Test Preparation

We evaluate the average scores by test preparation course completion to assess the effectiveness of additional preparation. This analysis provides valuable insights for students and educators alike.

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

Cultural Context: Race/Ethnicity 🌍📚

Performance by Race/Ethnicity

We delve into the average scores by race/ethnicity to explore cultural influences on academic performance. Understanding these differences is key to promoting educational equity.

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

  ![image](https://github.com/user-attachments/assets/be8aa668-7593-4755-a815-f5dd832e27fa)

  Recognizing Diverse Excellence

By identifying the number of maximum scores by race/ethnicity, we celebrate academic excellence across diverse groups, emphasizing the value of diversity in education.

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

![image](https://github.com/user-attachments/assets/e8017a60-75d7-4345-b8ec-bfb8b916eddb)

Socio-Educational Dynamics 📊👩‍🏫

Parental Education and Race/Ethnicity

We investigate the parental education level by race/ethnicity to understand the socio-educational dynamics at play. This analysis sheds light on the broader context of student performance.

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
    
![image](https://github.com/user-attachments/assets/8fe29c95-1169-4d8a-9223-d28b15ac5e06)

Highlighting Unsung Achievements 🌟👏

The Second Highest Scores

Finally, we seek out the second highest score in each race/ethnicity, giving recognition to those who excel just behind the top performers. This step emphasizes the breadth of talent within each group.

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

![image](https://github.com/user-attachments/assets/b4b84e34-d14f-4d4a-83a5-0bff280002a7)

Conclusions 🎓📊

    Gender Insights: Females excel in reading and writing, while males perform better in math. 👩‍🎓📚👨‍🎓🔢
    Parental Influence: Higher parental education levels positively impact students' average performance. 🧑‍🏫📈
    Nutritional Impact: Standard lunch leads to better performance. 🍎📈
    Preparation Pays Off: Completing test preparation courses improves test results. 📘🎯
    Cultural Excellence: Group E consistently outperforms other races/ethnicities. 🎨🏆



This dataset downloaded from Kaggle. 

Link for the data: https://www.kaggle.com/datasets/spscientist/students-performance-in-exams/data



