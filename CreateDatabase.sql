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
	(timeZoneID	VARCHAR(4),
    timeOffset	DECIMAL(2,0),
    PRIMARY KEY(timeZoneID)
    );

# City
# Longest city name Taumatawhakatangihangakoauauotamateapokaiwhenuakitanatahu
# Country er vel bare 1 ord? The United Kingdom of Great Britain and Northern Ireland er officielt det længste navn for et land
DROP TABLE IF EXISTS City;
CREATE TABLE City
	(cityName	VARCHAR(85),
    country		VARCHAR(60) NOT NULL,
    timeZoneID	VARCHAR(4) NOT NULL,
    PRIMARY KEY(cityName),
    FOREIGN KEY(timeZoneID) REFERENCES TimeZone(timeZoneID) ON DELETE CASCADE
    );
	
# Airport
# Longest airport name (that's not a helipad) Sheikh Sultan Bin Khalifa bin Zayed Al Nahyan palace Complex
DROP TABLE IF EXISTS Airport;
CREATE TABLE Airport
	(ICAO		VARCHAR(4),
    airportName	VARCHAR(60) NOT NULL,
    cityName	VARCHAR(85)	NOT NULL,
    PRIMARY KEY(ICAO),
    FOREIGN KEY(cityName) REFERENCES City(cityName) ON DELETE CASCADE
    );

# Gate
DROP TABLE IF EXISTS Gate;
CREATE TABLE Gate
	(gateID	VARCHAR(4),
    ICAO	VARCHAR(4),
    PRIMARY KEY(gateID, ICAO),
    FOREIGN KEY(ICAO) REFERENCES Airport(ICAO) ON DELETE CASCADE
	);

# Aircraft Model
DROP TABLE IF EXISTS AircraftModel;
CREATE TABLE AircraftModel
	(modelName			VARCHAR(50),
    manufacturer		VARCHAR(50),
    seats				INT NOT NULL,
    licenseDurationDays	INT NOT NULL,
    PRIMARY KEY(modelName)
    );

# Aircraft Instance
DROP TABLE IF EXISTS AircraftInstance;
CREATE TABLE AircraftInstance
	(aircraftReg	VARCHAR(10),
    productionYear	YEAR NOT NULL,
    modelName		VARCHAR(50) NOT NULL,
    PRIMARY KEY(aircraftReg),
    FOREIGN KEY(modelName) REFERENCES AircraftModel(modelName) ON DELETE CASCADE
    );
    
# Flight
DROP TABLE IF EXISTS Flight;
CREATE TABLE Flight
	(flightID 				INT AUTO_INCREMENT,
    arrivalDateTimeUTC 		DATETIME NOT NULL,
    departureDateTimeUTC 	DATETIME NOT NULL,
    aircraftReg 			VARCHAR(8) NOT NULL,
    arrivalGateID 			VARCHAR(5) NOT NULL,
    departureGateID			VARCHAR(5) NOT NULL,
    arrivalGateAirport		VARCHAR(5) NOT NULL,
    departureGateAirport	VARCHAR(5) NOT NULL,
    PRIMARY KEY(flightID),
    FOREIGN KEY(aircraftReg) REFERENCES AircraftInstance(aircraftReg) ON DELETE CASCADE,
    FOREIGN KEY(arrivalGateID) REFERENCES Gate(gateID) ON DELETE CASCADE,
    FOREIGN KEY(departureGateID) REFERENCES Gate(gateID) ON DELETE CASCADE,
    FOREIGN KEY(arrivalGateAirport) REFERENCES Gate(ICAO) ON DELETE CASCADE,
    FOREIGN KEY(departureGateAirport) REFERENCES Gate(ICAO) ON DELETE CASCADE
    );

# Pilot
DROP TABLE IF EXISTS Pilot;
CREATE TABLE Pilot
	(pilotID	INT AUTO_INCREMENT,
    firstName 	VARCHAR(50) NOT NULL,
    middleName 	VARCHAR(100),
    lastName 	VARCHAR(50) NOT NULL,
    birthDate 	DATE NOT NULL,
    PRIMARY KEY(pilotID)
    );

# License
DROP TABLE IF EXISTS License;
CREATE TABLE License
	(pilotID			INT,
    modelName			VARCHAR(50),
    dateOfAcquisition 	DATE NOT NULL,
    lastRenewal			DATE NOT NULL,
    PRIMARY KEY(pilotID, modelName),
    FOREIGN KEY(pilotID) REFERENCES Pilot(pilotID) ON DELETE CASCADE,
    FOREIGN KEY(modelName) REFERENCES AircraftModel(modelName) ON DELETE CASCADE
    );

# Pilot Flight
DROP TABLE IF EXISTS PilotFlight;
CREATE TABLE PilotFlight
	(pilotID	INT,
    flightID	INT,
    PRIMARY KEY(pilotID, flightID),
    FOREIGN KEY(pilotID) REFERENCES Pilot(pilotID) ON DELETE CASCADE,
    FOREIGN KEY(flightID) REFERENCES Flight(flightID) ON DELETE CASCADE
    );

# Crew
DROP TABLE IF EXISTS Crew;
CREATE TABLE Crew 
	(crewID 	INT AUTO_INCREMENT,
    firstName 	VARCHAR(50),
    middleName 	VARCHAR(100),
    lastName 	VARCHAR(50),
    birthDate 	DATE,
    crewRole 	ENUM('Flight Attendant', 'Flight Medic', 'Loadmaster', 'Purser'),
    PRIMARY KEY(crewID)
    );

# CrewFlight
DROP TABLE IF EXISTS CrewFlight;
CREATE TABLE CrewFlight
	(crewID INT,
    flightID INT,
    PRIMARY KEY(crewID, flightID),
    FOREIGN KEY(crewID) REFERENCES Crew(crewID) ON DELETE CASCADE,
    FOREIGN KEY(flightID) REFERENCES Flight(flightID) ON DELETE CASCADE
    );
    
# Passenger
DROP TABLE IF EXISTS Passenger;
CREATE TABLE Passenger
	(passengerID	INT AUTO_INCREMENT,
    firstName 		VARCHAR(50) NOT NULL,
    middleName 		VARCHAR(100),
    lastName 		VARCHAR(50) NOT NULL,
    birthDate 		DATE NOT NULL,
    PRIMARY KEY(passengerID)
    );
    
# Ticket
DROP TABLE IF EXISTS Ticket;
CREATE TABLE Ticket
	(flightID	INT,
    passengerID	INT,
    luggage		DECIMAL(4,2) NOT NULL,
    seatNo		VARCHAR(4) NOT NULL,
    meal		ENUM('None', 'Beef', 'Chicken', 'Pork', 'Vegan', 'Vegetarian'),
    PRIMARY KEY(flightID, passengerID),
    FOREIGN KEY(flightID) REFERENCES Flight(flightID) ON DELETE CASCADE,
    FOREIGN KEY(passengerID) REFERENCES Passenger(passengerID) ON DELETE CASCADE
	);

# FK constraints need an index, which must be manually created for non-PKs
CREATE INDEX ix_luggage ON Ticket(luggage);
CREATE INDEX ix_seatNo ON Ticket(seatNo);
CREATE INDEX ix_meal ON Ticket(meal);
    
# Ticket Price
DROP TABLE IF EXISTS TicketPrice;
CREATE TABLE TicketPrice
	(flightID	INT,
    luggage 	DECIMAL(4,2) NOT NULL,
    seatNo 		VARCHAR(4) NOT NULL,
    meal		ENUM('None', 'Beef', 'Chicken', 'Pork', 'Vegan', 'Vegetarian'),
    price 		DECIMAL(8,2) NOT NULL,
    PRIMARY KEY(flightID, luggage, seatNo, meal),
    FOREIGN KEY(flightID) REFERENCES Ticket(flightID) ON DELETE CASCADE,
    FOREIGN KEY(luggage) REFERENCES Ticket(luggage) ON DELETE CASCADE,
    FOREIGN KEY(seatNo) REFERENCES Ticket(seatNo) ON DELETE CASCADE,
    FOREIGN KEY(meal) REFERENCES Ticket(meal) ON DELETE CASCADE
	);