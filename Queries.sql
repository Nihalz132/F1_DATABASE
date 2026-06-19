/* 1. Select all circuits which has the name of the track start with B */
SELECT Track, Location  
FROM Circuits  
WHERE Track LIKE 'B%';

/* 2. Select all races that were held in 2023 */
SELECT DISTINCT Year, Circuit_ID  
FROM Race_Results  
WHERE Year = 2023;

/* 3. Select the top 3 drivers for every year */
SELECT ds.Year, ds.Final_Position, ds.Driver_ID, d.Driver_Name 
FROM Driver_Standings ds
JOIN Drivers d ON ds.Driver_ID = d.Driver_ID
WHERE ds.Final_Position IN (1, 2, 3) 
ORDER BY ds.Year, ds.Final_Position;

/* 4. Select all drivers that are younger than 30 years old */
SELECT Driver_ID, Driver_Name, DOB, TIMESTAMPDIFF(YEAR, DOB, CURDATE()) AS Age  
FROM Drivers  
WHERE TIMESTAMPDIFF(YEAR, DOB, CURDATE()) < 30;

/* 5. Select all drivers that were disqualified */
SELECT Year, Driver_ID
FROM Race_Results   
WHERE Time_or_Retired = 'DSQ';

/* 6. Count the number of times each driver has won a race */
SELECT r.Driver_ID, d.Driver_Name, COUNT(*) AS Wins 
FROM Race_Results r  
JOIN Drivers d ON r.Driver_ID = d.Driver_ID  
WHERE r.Position = 1  
GROUP BY r.Driver_ID, d.Driver_Name 
ORDER BY Wins DESC;

/* 7. Select all drivers who have raced for a team that won the championship from 2022-2024 */
SELECT DISTINCT d.Driver_Name
FROM Race_Results rr
JOIN Drivers d ON rr.Driver_ID = d.Driver_ID 
JOIN Team_Standings ts ON rr.Team_Name = ts.Team_Name
WHERE ts.Final_Position = 1
AND ts.Year BETWEEN 2022 AND 2024;

/* 8. Select all teams and the drivers they have had */
SELECT t.Team_Name, COUNT(d.Driver_Name) AS NumberOfDrivers, 
	GROUP_CONCAT(SUBSTRING_INDEX(d.Driver_Name, ' ', 1) SEPARATOR ', ') AS Driver
FROM Teams t
JOIN Drivers d ON t.Team_Name = d.Team_Name
GROUP BY t.Team_Name
ORDER BY t.Team_Name;


