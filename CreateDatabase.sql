# Main script that creates the database
DROP DATABASE IF EXISTS airport;
CREATE DATABASE airport;
use airport;

# =======================================================
# =============== Create Relation Schemas ===============
# =======================================================
# TimeZone
DROP TABLE IF EXISTS TimeZone;
CREATE TABLE TimeZone
	(timeZoneID	VARCHAR(4) PRIMARY KEY,
    timeOffset	DECIMAL(2,0)
    );

# City
DROP TABLE IF EXISTS City;
# CREATE TABLE

# Airport
DROP TABLE IF EXISTS Airport;
# CREATE TABLE

# Gate
DROP TABLE IF EXISTS Gate;
# CREATE TABLE

# Ticket
DROP TABLE IF EXISTS Ticket;
CREATE TABLE Ticket
	(flightID	INT PRIMARY KEY,
    passengerID	INT PRIMARY KEY,
    luggage		DECIMAL(2,2) NOT NULL,
    price		DECIMAL(6,2) NOT NULL,
    seatNo		INT NOT NULL,
    meal		ENUM('Vegetarian', 'Vegan', 'Chicken', 'Beef', 'Pork'),
    FOREIGN KEY(flightID) REFERENCES Flight(flightID) ON DELETE CASCADE,
    FOREIGN KEY(passengerID) REFERENCES Passenger(passengerID) ON DELETE CASCADE,

# Ticket Price
DROP TABLE IF EXISTS TicketPrice;
CREATE TABLE TicketPrice
	(flightID	INT PRIMARY KEY,
    luggage 	DECIMAL(2,2) PRIMARY KEY,
    seatNo 		INT PRIMARY KEY,
    meal 		ENUM('Vegetarian', 'Vegan', 'Chicken', 'Beef', 'Pork') PRIMARY KEY,
    price 		DECIMAL(6,2),
    FOREIGN KEY(flightID) REFERENCES Ticket(flightID) ON DELETE CASCADE,
    FOREIGN KEY(luggage) REFERENCES Ticket(luggage) ON DELETE CASCADE,
    FOREIGN KEY(seatNo) REFERENCES Ticket(seatNo) ON DELETE CASCADE,
    FOREIGN KEY(meal) REFERENCES Ticket(meal) ON DELETE CASCADE,    

# Nationality
DROP TABLE IF EXISTS Nationality;
# CREATE TABLE

# Passenger
DROP TABLE IF EXISTS Passenger;
# CREATE TABLE

# Crew
DROP TABLE IF EXISTS Crew;
# CREATE TABLE
CREATE TABLE Crew 
	(crewID INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(50),
    middleName VARCHAR(100),
    lastName VARCHAR(50),
    birthDate DATE,
    crewRole VARCHAR(50));

# CrewFlight
DROP TABLE IF EXISTS CrewFlight;
# CREATE TABLE

# Flight
DROP TABLE IF EXISTS Flight;
# CREATE TABLE

# Aircraft Model
DROP TABLE IF EXISTS AircraftModel;
# CREATE TABLE

# Aircraft Instance
DROP TABLE IF EXISTS AircraftInstance;
# CREATE TABLE

# License
DROP TABLE IF EXISTS License;
# CREATE TABLE

# Pilot
DROP TABLE IF EXISTS Pilot;
# CREATE TABLE

# Pilot Flight
DROP TABLE IF EXISTS PilotFlight
# CREATE TABLE