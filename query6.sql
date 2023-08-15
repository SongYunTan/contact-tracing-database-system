/* Given a user, find the list of users that checked in the same locations with the user within 1
hour in the last week.
*/


/* SOLUTION
Get all check ins over the last week again
Then for every check_in_time found for the user, return users that have check_in_time within 1 hour and selecteduser.locationID = otheruser.locationID (user_id diff)
*/

-- for this demonstration, choose user 2. should return user 1, 3, 4

-- get ALL user check-in entries within the last week
CREATE VIEW CheckInsLastWeek AS
SELECT user_id, location_id, check_in_time 
FROM Check_in_out
WHERE check_in_time >= DATEADD(day, -7, '20210330')
AND check_in_time <= '20210330'
GO

-- Get ALL entries corresponding to the target user and place them in a view
-- choose USER 2
CREATE VIEW SelectedUserCheckins AS
SELECT user_id, location_id, check_in_time 
FROM CheckInsLastWeek
WHERE user_id = 2
GO

-- find matching users that fulfil the condition using the two views
-- compare all user checkins against selected user checkin
SELECT DISTINCT C.user_id
FROM CheckInsLastWeek C, SelectedUserCheckIns S
WHERE C.user_id != S.user_id
AND C.location_id = S.location_id
AND C.check_in_time <=  DATEADD(HOUR, 1, S.check_in_time)
AND C.check_in_time >= DATEADD(HOUR, -1, S.check_in_time)

DROP VIEW CheckInsLastWeek;
DROP VIEW SelectedUserCheckins;
