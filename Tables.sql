DROP TABLE Race_Results;
DROP TABLE Ticketing;
DROP TABLE Team_Standings;
DROP TABLE Driver_Standings;
DROP TABLE Championships;
DROP TABLE Circuits;
DROP TABLE Tickets;
DROP TABLE Drivers;
DROP TABLE Teams;

/*Creating all tables*/
CREATE TABLE Teams (
    Team_Name VARCHAR(100) PRIMARY KEY,
    Base VARCHAR(30) NOT NULL
);

CREATE TABLE Championships (
    Year INT PRIMARY KEY, 
    Total_Races INT NOT NULL
);

CREATE TABLE Circuits (
    Circuit_ID CHAR(3) PRIMARY KEY,
    Circuit_Name VARCHAR(50),
    Track VARCHAR(20),
    Location VARCHAR(20)
);

CREATE TABLE Tickets (
    Ticket_ID INT PRIMARY KEY,
    Type VARCHAR(30)
);

CREATE TABLE Drivers (
    Driver_ID CHAR(5) PRIMARY KEY,
    Driver_Number INT NOT NULL,
    Driver_Name VARCHAR(100) NOT NULL,
    Team_Name VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Nationality VARCHAR(50) NOT NULL,
    FOREIGN KEY (Team_Name) REFERENCES Teams (Team_Name) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Driver_Standings (
    Year INT NOT NULL,
    Final_Position INT NOT NULL,
    Driver_ID CHAR(5),
    Car VARCHAR(30) NOT NULL,
    Total_Points INT NOT NULL,
    PRIMARY KEY (Year, Driver_ID),
    FOREIGN KEY (Driver_ID) REFERENCES Drivers (Driver_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Year) REFERENCES Championships (Year) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Team_Standings (
    Year INT NOT NULL,
    Final_Position INT NOT NULL,
    Team_Name VARCHAR(100) NOT NULL,
    Total_Points INT NOT NULL,
    PRIMARY KEY (Year, Team_Name),
    FOREIGN KEY (Team_Name) REFERENCES Teams (Team_Name) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Year) REFERENCES Championships (Year) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Ticketing (
    Ticket_ID INT NOT NULL,
    Circuit_ID CHAR(3) NOT NULL, 
    Price DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (Ticket_ID, Circuit_ID),
    FOREIGN KEY (Ticket_ID) REFERENCES Tickets (Ticket_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Circuit_ID) REFERENCES Circuits (Circuit_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Race_Results (
    Year INT NOT NULL,
    Circuit_ID CHAR(3) NOT NULL,     
    Position INT,
    Driver_ID CHAR(5),
    Team_Name VARCHAR(100) NOT NULL,
    Starting_Grid INT NOT NULL,
    Time_or_Retired VARCHAR(10) NOT NULL,
    Points INT NOT NULL,
    PRIMARY KEY (Year, Circuit_ID, Driver_ID),
    FOREIGN KEY (Year) REFERENCES Championships (Year) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Circuit_ID) REFERENCES Circuits (Circuit_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Driver_ID) REFERENCES Drivers (Driver_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Team_Name) REFERENCES Teams (Team_Name) ON DELETE RESTRICT ON UPDATE CASCADE
);
