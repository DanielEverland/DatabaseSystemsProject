# Populates the database with values
use airport;

# =======================================================
# ============== Populate Relation Schemas ==============
# =======================================================
# TimeZone
# Really not sure what a "timeZoneID" is supposed to look like. Feel free to rename.
INSERT TimeZone (timeZoneID, timeOffset) VALUES
('-04', -4), ('-03', -3), ('-02', -2), ('-01', -1),
('UTC', 0),
('+01', 1), ('+02', 2), ('+03', 3), ('+04', 4), ('+05', 5),
('+06', 6), ('+07', 7), ('+08', 8), ('+09', 9);

# City
INSERT City (cityName, country, timeZoneID) VALUES
('Copenhagen', 'Denmark', '+01'),
('London', 'England', 'UTC'),
('New York City', 'United States', '-04'),
('Tokyo', 'Japan', '+09');

# Airport
INSERT Airport (ICAO, airportName, cityName) VALUES
('EKCH', 'Copenhagen Airport, Kastrup', 'Copenhagen'),
('EGLL', 'Heathrow Airport', 'London'),
('KJFK', 'John F. Kennedy International Airport', 'New York City'),
('RJAA', 'Narita International Airport', 'Tokyo');

# Gate
INSERT Gate (gateID, ICAO) VALUES
('D2', 'EKCH'), ('T3', 'EKCH'), ('A17', 'EKCH'),
('T2', 'EGLL'), ('T5', 'EGLL'), ('T3', 'EGLL'),
('12', 'KJFK'), ('B30', 'KJFK'), ('22', 'KJFK'),
('171', 'RJAA'), ('E', 'RJAA'), ('150D', 'RJAA');


# Passenger
INSERT Passenger (firstName, middleName, lastName, birthDate) VALUES
('Daniel', 'Emil', 'Everland', '1997-04-13'),
('Thorbjørn', 'Thanner', 'Den Store', '1997-09-13'),
('Mark', 'Richard', 'Hamill', '1951-09-25'),
('Gabe', 'Logan', 'Newell', '1962-11-03'),
('Elizabeth', 'Alexandra', 'Mary', '1926-04-21'),
('X AE A-XII', NULL,'Musk', '2020-05-04'), 
('Lewis', NULL, 'Hamilton', '1974-11-11');


# Crew
INSERT Crew (firstName, middleName, lastName, birthDate, crewRole) VALUES
('Leonardo', 'Wilhelm', 'DiCaprio', '1974-11-11', 'Purser'), 
('Betty', 'Marion White', 'Ludden', '1922-01-17', 'Loadmaster'),
('Robin', 'McLaurin', 'Williams', '1951-07-21', 'Flight Attendant'),
('Sandra', 'Annette', 'Bullock', '1964-07-26', 'Purser');


# Aircraft Model
INSERT AircraftModel (modelName, manufacturer, seats, licenseDurationDays) VALUES
('747', 'Boeing', 416, 365),
('A330', 'Airbus', 293 , 548);

# Aircraft Instance
INSERT AircraftInstance (aircraftReg, productionYear, modelName) VALUES
('JA14KZ', 2013, '747'),
('N405DX', 2019, 'A330');

# Flight
INSERT Flight (arrivalDateTimeUTC, departureDateTimeUTC, aircraftReg, arrivalGateID,
	departureGateID, arrivalGateAirport, departureGateAirport) VALUES
('2038-01-19 03:14:07', '2038-01-18 03:14:07', 'JA14KZ', 'T2', '171', 'EGLL', 'RJAA'),
('2021-01-19 03:14:07', '2021-01-18 03:14:07', 'N405DX', 'B30', 'E', 'KJFK', 'RJAA');

# CrewFlight
INSERT CrewFlight (crewID, flightID) VALUES
(1, 1), (1, 2),
(2, 1), (2, 2);

# Pilot
INSERT Pilot (firstName, middleName, lastName, birthDate) VALUES
('Alan', 'Mathison', 'Turing', '1912-06-23'),
('Stephen', 'William', 'Hawking', '1942-01-08');

# Pilot Flight
INSERT PilotFlight VALUES
(1, 1), (1, 2),
(2, 1), (2, 2);

# License
INSERT License (pilotID, modelName, dateOfAcquisition, lastRenewal) VALUES
(1, '747', '1962-02-21', '2020-08-24'),
(2, 'A330', '1982-10-02', '2022-01-24');


# Ticket
INSERT Ticket (flightID, passengerID, luggage, seatNo, meal) VALUES
(1, 1, 20.00, '666', 'Vegan'),
(2, 2, 44.21, '420', 'Chicken'),
(1, 3, 00.00, '69', NULL);

# Ticket Price
INSERT TicketPrice (flightID, luggage, seatNo, meal, price) VALUES
(1, 20.00, '666', 'Vegan', 6000.00),
(2, 44.21, '420', 'Chicken', 243.30),
(1, 00.00, '69', NULL, 00.00),

(1, 42.00, '42', 'Chicken', 199.95),
(1, 42.00, '43', NULL, 149.95);
