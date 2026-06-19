import mysql.connector

# Database Connection
conn = mysql.connector.connect(
    user="me",
    password="Password123",
    database="F1_21174229"
)

# First Query: Top 10 Driver Standings 2024
cursor1 = conn.cursor()
print("\nQuery 1: Top 10 Drivers Standings 2024:")
cursor1.execute("SELECT * FROM Driver_Standings WHERE Year = 2024 ORDER BY Final_Position ASC LIMIT 10")
for row in cursor1.fetchall():
    print(row)
cursor1.close()

# Second Query: Teams with the Most Championship Points
cursor2 = conn.cursor()
print("\nQuery 2: Top 5 Teams with the Most Championship Points:")
cursor2.execute("""
    SELECT Team_Name, SUM(Total_Points) AS Total_Points 
    FROM Team_Standings 
    GROUP BY Team_Name 
    ORDER BY Total_Points DESC 
    LIMIT 5
""")
for row in cursor2.fetchall():
    team_Name, total_Points = row
    print((team_Name, int(total_Points))) 
cursor2.close()

# Third Query: Most Expensive Tickets
cursor3 = conn.cursor()
print("\nQuery 3: Top 5 Most Expensive Tickets:")
cursor3.execute("""
    SELECT Ticketing.Ticket_ID, Circuits.Track, Tickets.Type, Ticketing.Price
    FROM Ticketing
    JOIN Tickets ON Ticketing.Ticket_ID = Tickets.Ticket_ID
    JOIN Circuits ON Ticketing.Circuit_ID = Circuits.Circuit_ID
    ORDER BY Ticketing.Price DESC
    LIMIT 5
""")
for row in cursor3.fetchall():
    ticket_id, track, ticket_type, price = row
    print((ticket_id, track, ticket_type, float(price))) 
print("")
cursor3.close()


# Close connection
conn.close()

