-- CONVERT(VARCHAR(10), check_in_time, 111) to retrieve only date from datetime
CREATE VIEW DateCheckIn AS
SELECT user_id, location_id, CONVERT(VARCHAR(10), check_in_time, 111) AS check_in_date
FROM Check_in_out
GO

CREATE VIEW CheckInLastWeek AS
SELECT user_id, location_id, check_in_date
FROM DateCheckIn
WHERE check_in_date >= '2021/03/23'
AND check_in_date <= '2021/03/29'
GO
	
-- group entries in this check-in table by the check_in_time
CREATE VIEW CheckInByEachDay AS
SELECT user_id, COUNT(location_id) AS NumLocationsCheckedIn, check_in_date
FROM CheckInLastWeek
GROUP BY user_id, check_in_date
HAVING COUNT(location_id) > 10
GO

-- If user appears 7 times in the prev table, he has checked-in at 10 locations EVERYDAY
-- in the last week. Only return those users
CREATE VIEW UserCount AS 
SELECT user_id, COUNT(check_in_date) AS NumDaysFound
FROM CheckInByEachDay
GROUP BY user_id
HAVING COUNT(check_in_date) = 7
GO

SELECT user_id
FROM UserCount

DROP VIEW CheckInLastWeek
DROP VIEW CheckInByEachDay
DROP VIEW UserCount