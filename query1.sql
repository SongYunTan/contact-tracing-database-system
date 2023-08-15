CREATE VIEW numFives AS
SELECT location_id, COUNT(IIF(rate = 5, 1, NULL)) AS num_of_fives
FROM Rating
WHERE check_in_time >= '20201201 00:00:00' 
AND check_in_time <= '20201231 23:59:59'
GROUP BY location_id
HAVING COUNT(IIF(rate = 5, 1, NULL)) >= 5
GO

SELECT R1.location_id, AVG(Cast(R1.rate as Float)) AS avg_rating
FROM Rating R1 JOIN numFives
ON R1.location_id = numFives.location_id
GROUP BY R1.location_id
ORDER BY avg_rating;

DROP VIEW numFives;