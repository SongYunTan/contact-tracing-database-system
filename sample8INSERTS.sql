DROP Trigger tempTrig;

/* PASS CASE 
INSERT INTO TEMPERATURE
VALUES(11, '20210330 08:00:00', 38.5);
*/

/* FAIL CASE 
INSERT INTO TEMPERATURE
VALUES(2, '20210330 08:00:00', 38.5);
*/

--SELECT * FROM Temperature;
--SELECT * FROM Schedule;