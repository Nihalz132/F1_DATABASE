import mysql.connector

conn = mysql.connector.connect(
    user="me",
    password="Password123",
    database="F1_21174229"
)
cursor = conn.cursor()

# Insert New Team
def insert_team():
    team_name = input("Enter team name: ")
    cursor.execute("SELECT * FROM Teams WHERE Team_Name = %s", (team_name,))
    if cursor.fetchone() is not None:
        print("Error: A team with this name already exists.")
    else:
        base = input("Enter team base: ")
        cursor.execute("INSERT INTO Teams (Team_Name, Base) VALUES (%s, %s)", (team_name, base))
        conn.commit()
        print("Team inserted successfully.")

# Insert New Driver
def insert_driver():
    driver_id = input("Enter driver ID (5 characters): ")
    cursor.execute("SELECT * FROM Drivers WHERE Driver_ID = %s", (driver_id,))
    if cursor.fetchone() is not None:
        print("Error: A driver with this ID already exists.")
    else:
        driver_number = int(input("Enter driver number: "))
        driver_name = input("Enter driver name: ")
        team_name = input("Enter team name: ")
        dob = input("Enter date of birth (YYYY-MM-DD): ")
        nationality = input("Enter nationality: ")
        cursor.execute("INSERT INTO Drivers VALUES (%s, %s, %s, %s, %s, %s)", 
                       (driver_id, driver_number, driver_name, team_name, dob, nationality))
        conn.commit()
        print("Driver inserted successfully.")

# Insert New Race Result
def insert_race_result():
    year = int(input("Enter year: "))
    circuit_id = input("Enter circuit ID (3 characters): ")
    driver_id = input("Enter driver ID: ")
    
    cursor.execute("SELECT * FROM Race_Results WHERE Year = %s AND Circuit_ID = %s AND Driver_ID = %s",
                   (year, circuit_id, driver_id))
    if cursor.fetchone() is not None:
        print("Error: A race result for this driver in this circuit and year already exists.")
    else:
        position = int(input("Enter position: "))
        team_name = input("Enter team name: ")
        starting_grid = int(input("Enter starting grid position: "))
        time_or_retired = input("Enter race time or 'Retired': ")
        points = int(input("Enter points: "))
        cursor.execute("INSERT INTO Race_Results VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", 
                       (year, circuit_id, position, driver_id, team_name, starting_grid, time_or_retired, points))
        conn.commit()
        print("Race result inserted successfully.")

# Update Team Base
def update_team_base():
    team_name = input("Enter team name to update: ")
    cursor.execute("SELECT * FROM Teams WHERE Team_Name = %s", (team_name,))
    if cursor.fetchone() is None:
        print("Error: Team not found.")
    else:
        new_base = input("Enter new base: ")
        cursor.execute("UPDATE Teams SET Base = %s WHERE Team_Name = %s", (new_base, team_name))
        conn.commit()
        print("Team updated successfully.")

# Update Driver's Team
def update_drivers_team():
    driver_id = input("Enter driver ID to update: ")
    cursor.execute("SELECT * FROM Drivers WHERE Driver_ID = %s", (driver_id,))
    if cursor.fetchone() is None:
        print("Error: Driver not found.")
    else:
        new_team = input("Enter new team name: ")
        cursor.execute("UPDATE Drivers SET Team_Name = %s WHERE Driver_ID = %s", (new_team, driver_id))
        conn.commit()
        print("Driver updated successfully.")


# Delete team
def delete_team():
    team_name = input("Enter team name to delete: ")
    cursor.execute("SELECT * FROM Teams WHERE Team_Name = %s", (team_name,))
    if cursor.fetchone() is None:
        print("Error: Team not found.")
    else:
        cursor.execute("DELETE FROM Teams WHERE Team_Name = %s", (team_name,))
        conn.commit()
        print("Team deleted successfully.")

# Delete driver
def delete_driver():
    driver_id = input("Enter driver ID to delete: ")
    cursor.execute("SELECT * FROM Drivers WHERE Driver_ID = %s", (driver_id,))
    if cursor.fetchone() is None:
        print("Error: Driver not found.")
    else:
        cursor.execute("DELETE FROM Drivers WHERE Driver_ID = %s", (driver_id,))
        conn.commit()
        print("Driver deleted successfully.")

# Menu
def menu():
    choice = ""
    while choice != "8":
        print("\nFORMULA 1 DB MANAGEMENT MENU:")
        print("1. Insert Team")
        print("2. Insert Driver")
        print("3. Insert Race Result")
        print("4. Update Team")
        print("5. Update Driver")
        print("6. Delete Team")
        print("7. Delete Driver")
        print("8. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":
            insert_team()
        elif choice == "2":
            insert_driver()
        elif choice == "3":
            insert_race_result()
        elif choice == "4":
            update_team_base()
        elif choice == "5":
            update_drivers_team()
        elif choice == "6":
            delete_team()
        elif choice == "7":
            delete_driver()
        elif choice == "8":
            print("Menu closed.")
        else:
            print("Invalid choice. Please try again.")


menu()
cursor.close()
conn.close()

