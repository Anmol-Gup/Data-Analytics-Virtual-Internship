-- 1. What percentage of male and female Genz wants to go to office Every Day ?
SELECT 
	(SUM(CASE WHEN Gender='Male' AND PreferredWorkingEnvironment="Every Day Office Environment" THEN 1 ELSE 0 END)/SUM(1))*100    AS Percent_of_Males, 
	(SUM(CASE WHEN Gender='Female' AND PreferredWorkingEnvironment="Every Day Office Environment" THEN 1 ELSE 0 END)/SUM(1))*100  AS Percent_of_Females
FROM `learning_aspirations` la JOIN personalized_info pi
ON pi.ResponseID=la.ResponseID;

-- 2. What percentage of Genz's who have chosen their career in Business operations are most likely to be influenced  by their Parents?
SELECT 
    (SUM(CASE WHEN CareerInfluenceFactor="My Parents" AND ClosestAspirationalCareer LIKE 'Business Operations%' THEN 1 ElSE 0 END)/SUM(1))*100 AS Percent_of_GenZ 
FROM `learning_aspirations`;

-- 3. What percentage of Genz prefer opting for higher studies, give a gender wise approach?
SELECT 
    (SUM(CASE WHEN Gender='Male' AND HigherEducationAbroad="Yes, I wil" THEN 1 ELSE 0 END)/SUM(1))*100         AS Percent_of_Males,
    (SUM(CASE WHEN Gender='Female' AND HigherEducationAbroad="Yes, I wil" THEN 1 ELSE 0 END)/SUM(1))*100       AS Percent_of_Females,
    (SUM(CASE WHEN Gender='Transgender' AND HigherEducationAbroad="Yes, I wil" THEN 1 ELSE 0 END)/SUM(1))*100  AS Percent_of_Transgender 
FROM `learning_aspirations` la JOIN personalized_info pi ON la.ResponseID=pi.ResponseID;

-- 4. What percentage of Genz are willing & not willing to work for a company whose mission is misaligned with their public 
-- actions or even their products ? (give gender based split )
SELECT 
    (SUM(CASE WHEN Gender='Male' AND MisalignedMissionLikelihood="Will NOT work for them" THEN 1 ELSE 0 END)/SUM(1))*100        AS Percent_of_MalesNotWilling,
    (SUM(CASE WHEN Gender='Male' AND MisalignedMissionLikelihood="Will work for them" THEN 1 ELSE 0 END)/SUM(1))*100            AS Percent_of_MalesWilling,
    (SUM(CASE WHEN Gender='Female' AND MisalignedMissionLikelihood="Will NOT work for them" THEN 1 ELSE 0 END)/SUM(1))*100      AS Percent_of_FemalesNotWilling,
    (SUM(CASE WHEN Gender='Female' AND MisalignedMissionLikelihood="Will work for them" THEN 1 ELSE 0 END)/SUM(1))*100          AS Percent_of_FemalesWilling,
    (SUM(CASE WHEN Gender='Transgender' AND MisalignedMissionLikelihood="Will NOT work for them" THEN 1 ELSE 0 END)/SUM(1))*100 AS Percent_of_TransgenderNotWilling,
    (SUM(CASE WHEN Gender='Transgender' AND MisalignedMissionLikelihood="Will work for them" THEN 1 ELSE 0 END)/SUM(1))*100     AS Percent_of_TransgenderNotWilling 
FROM `learning_aspirations` la JOIN personalized_info pi ON la.ResponseID=pi.ResponseID
JOIN mission_aspirations ma ON ma.ResponseID=pi.ResponseID;

-- 5. What is the most suitable working environment according to female genz's?
WITH Female_Preferred_Environment_Cte AS 
( 
    SELECT PreferredWorkingEnvironment,COUNT(*) AS Most_Preferred_Environment FROM learning_aspirations la 
    JOIN personalized_info pi ON pi.ResponseID=la.ResponseID 
    WHERE Gender='Female' 
    GROUP BY PreferredWorkingEnvironment 
    ORDER BY Most_Preferred_Environment DESC 
) 
SELECT * FROM Female_Preferred_Environment_Cte LIMIT 1;

-- 6. Calculate the total number of Female who aspire to work in their Closest Aspirational Career and have a 
-- No Social Impact Likelihood of "1 to 5"
SELECT COUNT(*) AS TotalAspiringFemales FROM learning_aspirations la 
JOIN personalized_info pi ON pi.ResponseID=la.ResponseID 
JOIN mission_aspirations ma ON ma.ResponseID=pi.ResponseID 
WHERE Gender="Female" AND ClosestAspirationalCareer IS NOT NULL AND NoSocialImpactLikelihood BETWEEN 1 AND 5;

-- 7. Retrieve the Male who are interested in Higher Education Abroad and have a Career Influence Factor of "My Parents."
SELECT * FROM learning_aspirations la JOIN personalized_info pi ON pi.ResponseID=la.ResponseID 
WHERE Gender='Male' AND HigherEducationAbroad='Yes, I wil' AND CareerInfluenceFactor="My Parents";

-- 8. Determine the percentage of gender who have a No Social Impact Likelihood of "8 to 10" among those who are interested in Higher Education Abroad.
SELECT 
    (SUM(CASE WHEN (NoSocialImpactLikelihood BETWEEN 8 AND 10) THEN 1 ELSE 0 END)/SUM(1))*100 AS Percentage_Of_Gender 
FROM learning_aspirations la 
JOIN personalized_info pi ON pi.ResponseID=la.ResponseID 
JOIN mission_aspirations ma ON ma.ResponseID=pi.ResponseID;
WHERE HigherEducationAbroad='Yes, I wil'

-- 9. Give a detailed split of the GenZ preferences to work with Teams, Data should include Male, Female and Overall in counts and also the overall in %.
SELECT PreferredWorkSetup, Gender, COUNT(*) AS OverallCount, (COUNT(*)/SUM(COUNT(*)) OVER(PARTITION BY PreferredWorkSetup))*100 AS OverallCountPercent
FROM `manager_aspirations` ma JOIN personalized_info pi
ON ma.ResponseID=pi.ResponseID
GROUP BY PreferredWorkSetup, Gender;

-- 10. Give a detailed breakdown of "WorkLikelihood3Years" for each gender
SELECT WorkLikelihood3Years,Gender,COUNT(*) AS Count, COUNT(*)/SUM(COUNT(*)) OVER(PARTITION BY WorkLikelihood3Years)*100 AS OverallCountPercent 
FROM `manager_aspirations` ma JOIN personalized_info pi ON pi.ResponseID=ma.ResponseID 
GROUP BY WorkLikelihood3Years,Gender ORDER BY Count DESC;

-- 11. Give a detailed breakdown of "WorkLikelihood3Years" for each states
SELECT WorkLikelihood3Years,State,COUNT(*) AS Count FROM `manager_aspirations` ma 
JOIN personalized_info pi ON pi.ResponseID=ma.ResponseID 
JOIN india_pincode ip ON ip.pincode=pi.ZipCode
GROUP BY WorkLikelihood3Years,State;

-- 12. What is the Average Starting salary expectations at 3 year mark for each gender
SELECT 
	Gender,
    AVG(
    	CASE 
            WHEN ExpectedSalary3Years='31k to 40k' THEN 31
            WHEN ExpectedSalary3Years='21k to 25k' THEN 21
            WHEN ExpectedSalary3Years='26k to 30k' THEN 26
            WHEN ExpectedSalary3Years='16k to 20k' THEN 16
            WHEN ExpectedSalary3Years='41k to 50k' THEN 41
            WHEN ExpectedSalary3Years='11k to 15k' THEN 11
            WHEN ExpectedSalary3Years='5k to 10k' THEN 5
            WHEN ExpectedSalary3Years='>50k' THEN 50
            ELSE 0
        END
    ) AS Avg_Salary
FROM `mission_aspirations` ma JOIN personalized_info pi ON ma.ResponseID=pi.ResponseID
WHERE Gender IS NOT NULL
GROUP BY Gender;

-- 13. What is the Average Starting salary expectations at 5 year mark for each gender
SELECT 
	Gender,
    AVG(
    	CASE 
            WHEN ExpectedSalary5Years='91k to 110k' THEN 91
            WHEN ExpectedSalary5Years='50k to 70k' THEN 50
            WHEN ExpectedSalary5Years='71k to 90k' THEN 71
            WHEN ExpectedSalary5Years='111k to 130k' THEN 111
            WHEN ExpectedSalary5Years='131k to 150k' THEN 131
            WHEN ExpectedSalary5Years='30k to 50k' THEN 30
            WHEN ExpectedSalary5Years='>151k' THEN 151
            ELSE 0
        END
    ) AS Avg_Salary
FROM `mission_aspirations` ma JOIN personalized_info pi ON ma.ResponseID=pi.ResponseID
WHERE Gender IS NOT NULL
GROUP BY Gender;

-- 14. What is the Average Higher Bar salary expectations at 3 year mark for each gender
SELECT 
	Gender,
    AVG(
    	CASE 
            WHEN ExpectedSalary3Years='31k to 40k' THEN 40
            WHEN ExpectedSalary3Years='21k to 25k' THEN 25
            WHEN ExpectedSalary3Years='26k to 30k' THEN 30
            WHEN ExpectedSalary3Years='16k to 20k' THEN 20
            WHEN ExpectedSalary3Years='41k to 50k' THEN 50
            WHEN ExpectedSalary3Years='11k to 15k' THEN 15
            WHEN ExpectedSalary3Years='5k to 10k' THEN 10
            WHEN ExpectedSalary3Years='>50k' THEN 50
            ELSE 0
        END
    ) AS Avg_Salary
FROM `mission_aspirations` ma JOIN personalized_info pi ON ma.ResponseID=pi.ResponseID
WHERE Gender IS NOT NULL
GROUP BY Gender;

-- 15. What is the Average Higher Bar salary expectations at 5 year mark for each gender
SELECT 
	Gender,
    AVG(
    	CASE 
            WHEN ExpectedSalary5Years='91k to 110k' THEN 110
            WHEN ExpectedSalary5Years='50k to 70k' THEN 170
            WHEN ExpectedSalary5Years='71k to 90k' THEN 90
            WHEN ExpectedSalary5Years='111k to 130k' THEN 130
            WHEN ExpectedSalary5Years='131k to 150k' THEN 150
            WHEN ExpectedSalary5Years='30k to 50k' THEN 50
            WHEN ExpectedSalary5Years='>151k' THEN 151
            ELSE 0
        END
    ) AS Avg_Salary
FROM `mission_aspirations` ma JOIN personalized_info pi ON ma.ResponseID=pi.ResponseID
WHERE Gender IS NOT NULL
GROUP BY Gender;

-- 16. What is the Average Starting salary expectations at 3 year mark for each gender and each state in India
SELECT 
	Gender,State,
    AVG(
    	CASE 
            WHEN ExpectedSalary3Years='31k to 40k' THEN 30
            WHEN ExpectedSalary3Years='21k to 25k' THEN 21
            WHEN ExpectedSalary3Years='26k to 30k' THEN 26
            WHEN ExpectedSalary3Years='16k to 20k' THEN 16
            WHEN ExpectedSalary3Years='41k to 50k' THEN 41
            WHEN ExpectedSalary3Years='11k to 15k' THEN 11
            WHEN ExpectedSalary3Years='5k to 10k' THEN 5
            WHEN ExpectedSalary3Years='>50k' THEN 50
            ELSE 0
        END
    ) AS Avg_Salary
FROM `mission_aspirations` ma JOIN personalized_info pi ON ma.ResponseID=pi.ResponseID
JOIN india_pincode ON Pincode=ZipCode
WHERE Gender IS NOT NULL AND CurrentCountry='India'
GROUP BY Gender, State;

-- 17. What is the Average Starting salary expectations at 5 year mark for each gender and each state in India
SELECT 
	Gender,State,
    AVG(
    	CASE 
            WHEN ExpectedSalary5Years='91k to 110k' THEN 91
            WHEN ExpectedSalary5Years='50k to 70k' THEN 50
            WHEN ExpectedSalary5Years='71k to 90k' THEN 71
            WHEN ExpectedSalary5Years='111k to 130k' THEN 111
            WHEN ExpectedSalary5Years='131k to 150k' THEN 131
            WHEN ExpectedSalary5Years='30k to 50k' THEN 30
            WHEN ExpectedSalary5Years='>151k' THEN 151
            ELSE 0
        END
    ) AS Avg_Salary
FROM `mission_aspirations` ma JOIN personalized_info pi ON ma.ResponseID=pi.ResponseID
JOIN india_pincode ON Pincode=ZipCode
WHERE Gender IS NOT NULL AND CurrentCountry='India'
GROUP BY Gender, State;

-- 18. What is the Average Higher Bar salary expectations at 3 year mark for each gender and each state in India
SELECT 
	Gender,State,
    AVG(
    	CASE 
            WHEN ExpectedSalary3Years='31k to 40k' THEN 40
            WHEN ExpectedSalary3Years='21k to 25k' THEN 25
            WHEN ExpectedSalary3Years='26k to 30k' THEN 30
            WHEN ExpectedSalary3Years='16k to 20k' THEN 20
            WHEN ExpectedSalary3Years='41k to 50k' THEN 50
            WHEN ExpectedSalary3Years='11k to 15k' THEN 15
            WHEN ExpectedSalary3Years='5k to 10k' THEN 10
            WHEN ExpectedSalary3Years='>50k' THEN 50
            ELSE 0
        END
    ) AS Avg_Salary
FROM `mission_aspirations` ma JOIN personalized_info pi ON ma.ResponseID=pi.ResponseID
JOIN india_pincode ON Pincode=ZipCode
WHERE Gender IS NOT NULL AND CurrentCountry='India'
GROUP BY Gender, State;

-- 19. What is the Average Higher Bar salary expectations at 5 year mark for each gender and each state in India
SELECT 
	Gender,State,
    AVG(
    	CASE 
            WHEN ExpectedSalary5Years='91k to 110k' THEN 110
            WHEN ExpectedSalary5Years='50k to 70k' THEN 70
            WHEN ExpectedSalary5Years='71k to 90k' THEN 90
            WHEN ExpectedSalary5Years='111k to 130k' THEN 130
            WHEN ExpectedSalary5Years='131k to 150k' THEN 150
            WHEN ExpectedSalary5Years='30k to 50k' THEN 50
            WHEN ExpectedSalary5Years='>151k' THEN 151
            ELSE 0
        END
    ) AS Avg_Salary
FROM `mission_aspirations` ma JOIN personalized_info pi ON ma.ResponseID=pi.ResponseID
JOIN india_pincode ON Pincode=ZipCode
WHERE Gender IS NOT NULL AND CurrentCountry='India'
GROUP BY Gender, State;

-- 20. Give a detailed breakdown of the possibility of GenZ working for an Org if the "Mission is misaligned" for each state in India
SELECT MisalignedMissionLikelihood, State, COUNT(*) AS Total_Genz FROM `mission_aspirations` ma 
JOIN personalized_info pi ON pi.ResponseID=ma.ResponseID
JOIN india_pincode ON Pincode=ZipCode
WHERE CurrentCountry='India'
GROUP BY MisalignedMissionLikelihood, State
ORDER BY MisalignedMissionLikelihood, State;
