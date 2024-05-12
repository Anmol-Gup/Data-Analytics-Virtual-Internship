-- Question 1 : How many Male have responded to the survey from India
SELECT COUNT(*) AS No_of_Males FROM `personalized_info` WHERE Gender="Male" AND CurrentCountry="India";

-- Question 2: How many Male have responded to the survey from India 
SELECT COUNT(*) AS No_of_Females FROM `personalized_info` WHERE Gender="Female" AND CurrentCountry="India";

-- Question 3 : How many of the Gen-Z are influenced by their parents in regards to their career choices from India
SELECT COUNT(*) AS No_of_GenZ FROM `learning_aspirations` la JOIN personalized_info pi
ON pi.ZipCode=la.ZipCode WHERE CareerInfluenceFactor="My Parents" AND CurrentCountry='India';

-- Question 4 : How many of the Female Gen-Z are influenced by their parents in regards to their career choices from India
SELECT COUNT(*) AS No_of_Female_GenZ FROM `learning_aspirations` la JOIN personalized_info pi ON pi.ZipCode=la.ZipCode 
WHERE CareerInfluenceFactor="My Parents" AND CurrentCountry='India' AND Gender="Female";

-- Question 5 : How many of the Male Gen-Z are influenced by their parents in regards to their career choices from India
SELECT COUNT(*) AS No_of_Female_GenZ FROM `learning_aspirations` la JOIN personalized_info pi ON pi.ZipCode=la.ZipCode 
WHERE CareerInfluenceFactor="My Parents" AND CurrentCountry='India' AND Gender="Male";

-- Question 6 : How many of the Male and Female (individually display in 2 different columns, but as part of the same query) 
-- Gen-Z are influenced by their parents in regards to their career choices from India
SELECT SUM(CASE WHEN Gender="Male" THEN 1 ELSE 0 END) AS No_of_Male_GenZ, SUM(CASE WHEN Gender="Female" THEN 1 ELSE 0 END) AS 
No_of_Female_GenZ FROM `learning_aspirations` la JOIN personalized_info pi ON pi.ZipCode=la.ZipCode 
WHERE CareerInfluenceFactor="My Parents" AND CurrentCountry='India';

-- Question 7 : How many Gen-Z are influenced by Media and Influencers together from India
SELECT COUNT(*) AS No_of_GenZ FROM `learning_aspirations` la JOIN personalized_info pi
ON pi.ZipCode=la.ZipCode WHERE (CareerInfluenceFactor LIKE "%Influencers%" OR CareerInfluenceFactor LIKE '%Media%') 
AND CurrentCountry='India';

-- Question 8 : How many Gen-Z are influenced by Social Media and Influencers together, display for Male and Female seperately 
-- from India
SELECT SUM(CASE WHEN Gender="Male" THEN 1 ELSE 0 END) AS No_of_Male_GenZ, SUM(CASE WHEN Gender="Female" THEN 1 ELSE 0 END) AS 
No_of_Female_GenZ FROM `learning_aspirations` la JOIN personalized_info pi
ON pi.ZipCode=la.ZipCode WHERE (CareerInfluenceFactor LIKE "%Influencers%" OR CareerInfluenceFactor LIKE '%Media%') 
AND CurrentCountry='India';

-- Question 9 : How many of the Gen-Z who are influenced by the social media for their career aspiration are looking to go 
-- abroad
SELECT COUNT(*) AS No_of_GenZ FROM `learning_aspirations` WHERE CareerInfluenceFactor LIKE '%Media%' 
AND HigherEducationAbroad LIKE 'Yes%';

-- Question 10 : How many of the Gen-Z who are influenced by "people in their circle" for career aspiration are looking to 
-- go abroad
SELECT COUNT(*) AS No_of_GenZ FROM `learning_aspirations` WHERE CareerInfluenceFactor LIKE 'People%circle%'
AND HigherEducationAbroad LIKE 'Yes%';

SELECT COUNT(*) AS No_of_GenZ FROM `learning_aspirations` 
WHERE CareerInfluenceFactor='People from my circle, but not family members' AND HigherEducationAbroad LIKE 'Yes%';