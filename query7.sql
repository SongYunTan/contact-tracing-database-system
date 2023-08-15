/* 
Find the locations that received the most ratings of ‘1’ and 
return the location, company and 
email of the company’s contact person within the last month. 
*/

-- count the number of 1s for each location
CREATE VIEW numberOnes AS
SELECT location_id, COUNT(*) AS number_of_ones
FROM Rating
WHERE rate = 1
AND check_in_time >= DATEADD(month, -1, '20210330')
AND check_in_time <= '20210330'
GROUP BY location_id
GO

-- find locations that return the most ratings of 1
CREATE VIEW worseLocations AS
SELECT location_id
FROM numberOnes
WHERE number_of_ones = 
    (SELECT MAX(number_of_ones) AS maxOnes
    FROM numberOnes)
GO

-- join worseLocations with Associate, Company and Person
-- find person with company at worseLocations
-- find his email
SELECT C.company_id, A.location_id, P.email
FROM Associate AS A, worseLocations AS W,
    Company AS C, Person AS P
WHERE A.location_id = W.location_id
AND C.company_id = A.company_id
AND P.company_id = C.company_id
AND P.is_contact_person = 1;

DROP VIEW numberOnes;
DROP VIEW worseLocations;


