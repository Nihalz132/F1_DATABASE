/* Procedure to insert driver details if the team exists  */
DELIMITER //
DROP PROCEDURE IF EXISTS Add_Driver;

CREATE PROCEDURE Add_Driver (
    IN p_Driver_ID CHAR(5),
    IN p_Driver_Number INT, 
    IN p_Driver_Name VARCHAR(100), 
    IN p_Team_Name VARCHAR(100), 
    IN p_DOB DATE, 
    IN p_Nationality VARCHAR(50)
)
BEGIN
    DECLARE team_exists INT;

    SELECT COUNT(*) INTO team_exists FROM Teams WHERE Team_Name = p_Team_Name;

    IF team_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Provided Team_Name does not exist in Teams table';
    ELSE
        INSERT INTO Drivers (Driver_ID, Driver_Number, Driver_Name, Team_Name, DOB, Nationality) 
        VALUES (p_Driver_ID, p_Driver_Number, p_Driver_Name, p_Team_Name, p_DOB, p_Nationality);
    END IF;
END //

DELIMITER ;


/* Sample input: CALL Add_Driver('F1031', 33, 'Max Verstappen', 'Red Bull Racing', '1997-09-30', 'Dutch'); */


/* Procedure to count the total number of races a driver has participated in */
DELIMITER //  

DROP PROCEDURE IF EXISTS Get_Driver_Race_Count;

CREATE PROCEDURE Get_Driver_Race_Count(IN p_Driver_ID CHAR(5), OUT Race_Count INT)  
BEGIN  
    SELECT COUNT(*) INTO Race_Count  
    FROM Race_Results  
    WHERE Driver_ID = p_Driver_ID;  
END //

DELIMITER ;  

/* Sample input: CALL Get_Driver_Race_Count('F1001', @Race_Count);
   SELECT @Race_Count; */


/* Procedure to get the list of all race winners in a particular year  */
DELIMITER //  

DROP PROCEDURE IF EXISTS Get_Race_Winners_By_Year;

CREATE PROCEDURE Get_Race_Winners_By_Year(IN p_Year INT)  
BEGIN  
    SELECT r.Track, d.Driver_Name  
    FROM Race_Results rr  
    JOIN Circuits r ON rr.Circuit_ID = r.Circuit_ID  
    JOIN Drivers d ON rr.Driver_ID = d.Driver_ID  
    WHERE rr.Position = 1 AND rr.Year = p_Year;  
END //

DELIMITER ;  

/* Sample input: CALL Get_Race_Winners_By_Year(2023); */

/* View to get the top 10 drivers with most points across 3 years */
DROP VIEW IF EXISTS Most_Points_Top10;
CREATE VIEW Most_Points_Top10 AS  
SELECT  
    DENSE_RANK() OVER (ORDER BY SUM(rr.Points) DESC) AS Position, 
    d.Driver_Name,  
    SUM(rr.Points) AS Total_Points  
FROM Drivers d  
JOIN Race_Results rr ON d.Driver_ID = rr.Driver_ID  
GROUP BY d.Driver_Name  
ORDER BY Total_Points DESC  
LIMIT 10;

/* Sample input: SELECT * FROM Most_Points_Top10; */

/* View to get the drivers with the most race wins across 3 years  */
DROP VIEW IF EXISTS Most_Wins;
CREATE VIEW Most_Wins AS  
SELECT d.Driver_ID, d.Driver_Name, COUNT(rr.Position) AS Total_Wins  
FROM Drivers d  
JOIN Race_Results rr ON d.Driver_ID = rr.Driver_ID  
WHERE rr.Position = 1  
GROUP BY d.Driver_ID, d.Driver_Name  
ORDER BY Total_Wins DESC;

/* Sample input: SELECT * FROM Most_Wins; */

/* Trigger to update the total points in the standings after inserting a new result  */
DELIMITER //

DROP TRIGGER IF EXISTS After_Insert_Race_Result;

CREATE TRIGGER After_Insert_Race_Result
AFTER INSERT ON Race_Results
FOR EACH ROW
BEGIN
    UPDATE Driver_Standings
    SET Total_Points = Total_Points + NEW.Points
    WHERE Driver_ID = NEW.Driver_ID;
END //

DELIMITER ;

/* Trigger to restrict deletion of a result with points as it affects the standings  */
DELIMITER //

DROP TRIGGER IF EXISTS Prevent_Delete_Race_Result;

CREATE TRIGGER Prevent_Delete_Race_Result
BEFORE DELETE ON Race_Results
FOR EACH ROW
BEGIN
    IF OLD.Points > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete race result with points';
    END IF;
END //

DELIMITER ;


