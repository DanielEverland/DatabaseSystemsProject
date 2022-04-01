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
    manufacturer		VARCHAR(50) NOT NULL,
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
    arrivalGateID 			VARCHAR(4) NOT NULL,
    departureGateID			VARCHAR(4) NOT NULL,
    arrivalGateAirport		VARCHAR(4) NOT NULL,
    departureGateAirport	VARCHAR(4) NOT NULL,
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
    seatNo		VARCHAR(4),
    passengerID	INT,
    basePrice	DECIMAL(8,2) NOT NULL,
    luggage		DECIMAL(4,2) NOT NULL,
    meal		ENUM('Beef', 'Chicken', 'Pork', 'Vegan', 'Vegetarian'),
    PRIMARY KEY(flightID, seatNo),
    FOREIGN KEY(flightID) REFERENCES Flight(flightID) ON DELETE CASCADE,
    FOREIGN KEY(passengerID) REFERENCES Passenger(passengerID) ON DELETE SET NULL
	);

# =======================================================
# ============== Populate Relation Schemas ==============
# =======================================================
# TimeZone
INSERT TimeZone (timeZoneID, timeOffset) VALUES
('-04', -4), ('-03', -3), ('-02', -2), ('-01', -1),
('UTC', 0),
('+01', 1), ('+02', 2), ('+03', 3), ('+04', 4), ('+05', 5),
('+06', 6), ('+07', 7), ('+08', 8), ('+09', 9);
SELECT * FROM TimeZone;

# City
INSERT City (cityName, country, timeZoneID) VALUES
('Copenhagen', 'Denmark', '+01'),
('London', 'England', 'UTC'),
('New York City', 'United States', '-04'),
('Tokyo', 'Japan', '+09');
SELECT * FROM City;

# Airport
INSERT Airport (ICAO, airportName, cityName) VALUES
('EKCH', 'Copenhagen Airport, Kastrup', 'Copenhagen'),
('EGLL', 'Heathrow Airport', 'London'),
('KJFK', 'John F. Kennedy International Airport', 'New York City'),
('RJAA', 'Narita International Airport', 'Tokyo');
SELECT * FROM Airport;

# Gate
INSERT Gate (gateID, ICAO) VALUES
('D2', 'EKCH'), ('T3', 'EKCH'), ('A17', 'EKCH'),
('T2', 'EGLL'), ('T5', 'EGLL'), ('T3', 'EGLL'),
('12', 'KJFK'), ('B30', 'KJFK'), ('22', 'KJFK'),
('171', 'RJAA'), ('E', 'RJAA'), ('150D', 'RJAA');
SELECT * FROM Gate;

# Passenger
INSERT Passenger (firstName, middleName, lastName, birthDate) VALUES
('Daniel', 'Emil', 'Everland', '1997-04-13'),
('Thorbjørn', 'Thanner', 'Den Store', '1997-09-13'),
('Mark', 'Richard', 'Hamill', '1951-09-25'),
('Gabe', 'Logan', 'Newell', '1962-11-03'),
('Elizabeth', 'Alexandra', 'Mary', '1926-04-21'),
('X AE A-XII', NULL,'Musk', '2020-05-04'), 
('Lewis', NULL, 'Hamilton', '1974-11-11');
SELECT * FROM Passenger;

# Crew
INSERT Crew (firstName, middleName, lastName, birthDate, crewRole) VALUES
('Leonardo', 'Wilhelm', 'DiCaprio', '1974-11-11', 'Purser'), 
('Betty', 'Marion White', 'Ludden', '1922-01-17', 'Loadmaster'),
('Robin', 'McLaurin', 'Williams', '1951-07-21', 'Flight Attendant'),
('Sandra', 'Annette', 'Bullock', '1964-07-26', 'Purser');
SELECT * FROM Crew;

# Aircraft Model
INSERT AircraftModel (modelName, manufacturer, seats, licenseDurationDays) VALUES
('747', 'Boeing', 416, 365),
('A330', 'Airbus', 293 , 548);
SELECT * FROM AircraftModel;

# Aircraft Instance
INSERT AircraftInstance (aircraftReg, productionYear, modelName) VALUES
('JA14KZ', 2013, '747'),
('N405DX', 2019, 'A330');
SELECT * FROM AircraftInstance;

# Flight
INSERT Flight (arrivalDateTimeUTC, departureDateTimeUTC, aircraftReg, arrivalGateID,
	departureGateID, arrivalGateAirport, departureGateAirport) VALUES
('2038-01-19 03:14:07', '2038-01-18 03:14:07', 'JA14KZ', 'T2', '171', 'EGLL', 'RJAA'),
('2021-01-19 03:14:07', '2021-01-18 03:14:07', 'N405DX', 'B30', 'E', 'KJFK', 'RJAA'),
('2021-03-28 22:00:00', '2021-03-28 12:00:00', 'N405DX', '150D', 'D2', 'RJAA', 'EKCH'),
('2021-03-28 22:00:00', '2021-03-28 12:00:00', 'N405DX', 'D2', '150D', 'EKCH', 'RJAA'),
('2021-01-19 04:00:00', '2021-01-19 03:00:00', 'N405DX', 'D2', '150D', 'EKCH', 'RJAA');
SELECT * FROM Flight;

# CrewFlight
INSERT CrewFlight (crewID, flightID) VALUES
(1, 1), (1, 2),
(2, 1), (2, 2);
SELECT * FROM CrewFlight;

# Pilot
INSERT Pilot (firstName, middleName, lastName, birthDate) VALUES
('Alan', 'Mathison', 'Turing', '1912-06-23'),
('Stephen', 'William', 'Hawking', '1942-01-08');
SELECT * FROM Pilot;

# Pilot Flight
INSERT PilotFlight VALUES
(1, 1), (1, 2),
(2, 1), (2, 2);
SELECT * FROM PilotFlight;

# License
INSERT License (pilotID, modelName, dateOfAcquisition, lastRenewal) VALUES
(1, '747', '1962-02-21', '2020-08-24'),
(2, 'A330', '1982-10-02', '2022-01-24');
SELECT * FROM License;

# Ticket
INSERT Ticket (flightID, seatNo, passengerID, basePrice, luggage, meal) VALUES
(1, '666', 1, 6000.00, 20.00, 'Vegan'),
(2, '420', 2, 243.30, 44.21, 'Chicken'),
(1, '69', 3, 199.95, 00.00, NULL),
(1, 'A10', NULL, 500.00, 00.00, NULL),
(2, 'B12', NULL, 299.95, 00.00, NULL);
SELECT * FROM Ticket;

# =======================================================
# ======================== Views ========================
# =======================================================
DROP VIEW IF EXISTS AllFlights;
CREATE VIEW AllFlights AS
SELECT flightID AS Flight,
DATE_ADD(Flight.departureDateTimeUTC,
INTERVAL 	(SELECT timeOffset FROM TimeZone WHERE timeZoneID IN
			(SELECT timeZoneID FROM City WHERE cityName IN
			(SELECT cityName FROM Airport WHERE Flight.departureGateAirport = Airport.ICAO) ) ) HOUR)
    AS LocalDepartureTime,
DATE_ADD(Flight.arrivalDateTimeUTC,
INTERVAL 	(SELECT timeOffset FROM TimeZone WHERE timeZoneID IN
			(SELECT timeZoneID FROM City WHERE cityName IN
			(SELECT cityName FROM Airport WHERE Flight.arrivalGateAirport = Airport.ICAO) ) ) HOUR)
    AS LocalArrivalTime,
(SELECT airportName FROM Airport WHERE Flight.departureGateAirport = Airport.ICAO) AS DepartureAirport,
(SELECT airportName FROM Airport WHERE Flight.arrivalGateAirport = Airport.ICAO) AS ArrivalAirport
FROM Flight ORDER BY Flight;
SELECT * FROM AllFlights;