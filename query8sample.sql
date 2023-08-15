-- USERS 6 and 10 have not been scheduled in the next 1 week

SELECT user_id
FROM Temperature
WHERE Temperature.temperature > 37.5
AND CAST(Temperature.timestamp AS DATE) >= DATEADD(day, -7, '20210330')
AND CAST(Temperature.timestamp AS DATE) <= '20210330'
-- minus the users that have already been scheduled
EXCEPT
SELECT DISTINCT user_id
FROM Schedule
WHERE CAST(time_stamp AS DATE) >= '20210330'
AND CAST(time_stamp AS DATE) <= DATEADD(day, 7, '20210330')