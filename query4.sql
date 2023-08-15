SELECT F.user1_id, F.user2_id
FROM be_family F 
WHERE F.relationship = 'Couple' 
AND EXISTS (
            SELECT C.user_id, D.user_id, COUNT(*) AS commonLocations
            FROM Check_in_out C, Check_in_out D
            WHERE F.User1_id = C.user_id 
            AND F.User2_id = D.user_id 
            AND CAST(C.check_in_time AS DATE) = '20210101' 
            AND CAST(D.check_in_time AS DATE) = '20210101'
            AND C.location_id = D.location_id 
            AND C.user_id <> D.user_id 
            GROUP BY C.user_id, D.user_id
            HAVING COUNT(*) >= 2)
