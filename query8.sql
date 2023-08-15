/*
Schedule all users who had a temperature above 37.5 in the past week and have not scheduled a screening test AND schedule it to be in the next week 
*/

CREATE TRIGGER dbo.TempTrig
ON dbo.Temperature 
AFTER INSERT
AS
IF EXISTS (SELECT user_id
    FROM inserted
    WHERE inserted.temperature > 37.5
    AND CAST(inserted.timestamp AS DATE) >= DATEADD(day, -7, '20210330')
    AND CAST(inserted.timestamp AS DATE) <= '20210330'
    -- minus the users that have already been scheduled
    EXCEPT
    SELECT DISTINCT user_id
    FROM Schedule
    WHERE CAST(time_stamp AS DATE) >= '20210330'
    AND CAST(time_stamp AS DATE) <= DATEADD(day, 7, '20210330'))
BEGIN
INSERT INTO Schedule(user_id, time_stamp, clinic_location, test_result)
-- schedule 5 days after high temperature, default at NTU
SELECT i.user_id, DATEADD(day, 5, i.timestamp),'NTU', NULL
FROM inserted i
WHERE i.temperature > 37.5

END