SELECT L.location_id, L.name
FROM Location L, 
        (SELECT TOP 5 C.Location_id, COUNT(*) AS Visits
        FROM Check_in_out C
        WHERE CAST(C.check_in_time AS DATE) >= '20210320' 
        AND CAST(C.check_in_time AS DATE) <= '20210330'  
        GROUP BY C.Location_id
        ORDER BY Visits DESC
        ) X
WHERE L.location_id = X.location_id


