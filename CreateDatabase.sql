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
# Longest city name Taumatawhakatangihangakoauauotamateapokaiwhenuakitanatahu
# Country er vel bare 1 ord? The United Kingdom of Great Britain and Northern Ireland er officielt det længste navn for et land
DROP TABLE IF EXISTS City;
CREATE TABLE City
	(cityName	VARCHAR(85) PRIMARY KEY,
    country		VARCHAR(20) NOT NULL,
    timeZoneID	VARCHAR(4) NOT NULL,
    FOREIGN KEY(timeZoneID) REFERENCES TimeZone(timeZoneID) ON DELETE CASCADE
    );
	
# Airport
# Hvorfor har vi name attribute i airport? Er det CPH for københavns lufthavn? I så fald er det også en standard, den hedder IATA.
# name er et keyword så jeg kalder det IATA :)
DROP TABLE IF EXISTS Airport;
CREATE TABLE Airport
	(ICAO		VARCHAR(4) PRIMARY KEY,
    IATA		VARCHAR(3) NOT NULL,
    cityName	VARCHAR(85)	NOT NULL,
    FOREIGN KEY(cityName) REFERENCES City(cityName) ON DELETE CASCADE
    );

# Gate
DROP TABLE IF EXISTS Gate;
CREATE TABLE Gate
	(gateID	VARCHAR(3) PRIMARY KEY,
    ICAO	VARCHAR(4) PRIMARY KEY,
    FOREIGN KEY(ICAO) REFERENCES Airport(ICAO) ON DELETE CASCADE
	);
    
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
    FOREIGN KEY(passengerID) REFERENCES Passenger(passengerID) ON DELETE CASCADE
	);
    
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
    FOREIGN KEY(meal) REFERENCES Ticket(meal) ON DELETE CASCADE    
	);
    
# Passenger
DROP TABLE IF EXISTS Passenger;
CREATE TABLE Passenger
	(passengerID	INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(50) NOT NULL,
    middleName VARCHAR(100),
    lastName VARCHAR(50) NOT NULL,
    birthDate DATE NOT NULL
    );

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
CREATE TABLE CrewFlight
	(crewID INT PRIMARY KEY,
    flightID INT PRIMARY KEY,
    FOREIGN KEY(crewID) REFERENCES Crew(crewID) ON DELETE CASCADE
    );
    
# Flight
DROP TABLE IF EXISTS Flight;
# CREATE TABLE
CREATE TABLE Flight
	(flightID INT PRIMARY KEY AUTO_INCREMENT,
    arrivalDateTimeUTC DATETIME,
    departureDateTimeUTC DATETIME,
    aircraftReg VARCHAR(8),
    arrivalGateID VARCHAR(5),
    departureGateID VARCHAR(5),
    arrivalGateAirport VARCHAR(5),
    departureGateAirport VARCHAR(5));

# Aircraft Model
DROP TABLE IF EXISTS AircraftModel;
CREATE TABLE AircraftModel
	(modelName			VARCHAR(50) PRIMARY KEY,
    manufacturer		VARCHAR(50),
    seats				INT NOT NULL,
    licenseExpiration	TIME NOT NULL
    );

# Aircraft Instance
DROP TABLE IF EXISTS AircraftInstance;
CREATE TABLE AircraftInstance
	(aircraftReg	VARCHAR(10) PRIMARY KEY,
    productionYear	YEAR NOT NULL,
    modelName		VARCHAR(50) NOT NULL,
    FOREIGN KEY(modelName) REFERENCES AircraftModel(modelName) ON DELETE CASCADE
    );

# License
DROP TABLE IF EXISTS License;
CREATE TABLE License
	(pilotID			INT PRIMARY KEY,
    modelName			VARCHAR(50) PRIMARY KEY,
    dateOfAcquisition 	DATE NOT NULL,
    lastRenewal			DATE NOT NULL,
    FOREIGN KEY(modelName) REFERENCES AircraftModel(modelName) ON DELETE CASCADE
    );

# Pilot
DROP TABLE IF EXISTS Pilot;
CREATE TABLE Pilot
	(pilotID	INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(50) NOT NULL,
    middleName VARCHAR(100),
    lastName VARCHAR(50) NOT NULL,
    birthDate DATE NOT NULL
    );

# Pilot Flight
DROP TABLE IF EXISTS PilotFlight;
CREATE TABLE PilotFlight
	(pilotID	INT PRIMARY KEY,
    flightID	INT PRIMARY KEY,
    FOREIGN KEY(pilotID) REFERENCES Pilot(pilotID) ON DELETE CASCADE,
    FOREIGN KEY(flightID) REFERENCES Flight(flightID) ON DELETE CASCADE
    );