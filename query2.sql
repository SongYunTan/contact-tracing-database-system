CREATE VIEW dataused AS
(SELECT A.company_id, C.cmt_timestamp
FROM Comment C, Message M, Associate A
WHERE M.msg_id = C.msg_id AND A.location_id = M.location_id
)
GO

CREATE VIEW eachWeek AS
(
SELECT
 ((DATEPART(week, cmt_timestamp) + @@DATEFIRST - 1 - 2) % 7) - 1 AS week, company_id, 
  COUNT(*) AS NoComments
FROM dataused
WHERE '20210302' <= cmt_timestamp
  AND cmt_timestamp < '20210330'
GROUP BY DATEPART(week, cmt_timestamp), company_id
)
GO

SELECT A.week, A.company_id, A.noComments
FROM eachWeek A, (SELECT week, MAX(noComments) AS maxNoComments
                    FROM eachWeek 
                    GROUP BY week
                    ) B
WHERE A.noComments = B.maxNoComments AND A.week = B.week
ORDER BY week 

DROP VIEW dataused;
DROP VIEW eachWeek;
GO