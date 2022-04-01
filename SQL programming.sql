############## SQL Programming ##############
# Function
# Age function - Calculate the age of a person given their birth date (returns difference in years between current date and input date)
DROP FUNCTION IF EXISTS Age;
CREATE FUNCTION Age(mDate DATE) RETURNS INTEGER
RETURN TIMESTAMPDIFF(YEAR, mDate, CURDATE());

DROP FUNCTION IF EXISTS getFlightDuration;
CREATE FUNCTION getFlightDuration(departureTime DATETIME, arrivalTime DATETIME) RETURNS INT
RETURN TIMESTAMPDIFF(MINUTE, departureTime, arrivalTime);

DROP FUNCTION IF EXISTS LocalArrivalTime;
# Function for calculating the local time zone when a flight arrives at the destination airport.
DELIMITER //
CREATE FUNCTION LocalArrivalTime(mFlightID INT) RETURNS DATETIME
BEGIN
	DECLARE arrivalTimeUTC DATETIME;
    DECLARE arrivalAirportICAO VARCHAR(4);
    DECLARE arrivalCity VARCHAR(85);
    DECLARE arrivalTimeZone VARCHAR(4);
    DECLARE timeZoneOffset DECIMAL(2,0);
    
	SELECT arrivalDateTimeUTC INTO arrivalTimeUTC FROM Flight WHERE Flight.flightID = mFlightID;
    SELECT arrivalGateAirport INTO arrivalAirportICAO FROM Flight WHERE Flight.flightID = mFlightID;
	SELECT cityName INTO arrivalCity FROM Airport WHERE Airport.ICAO = arrivalAirportICAO;
	SELECT timeZoneID INTO arrivalTimeZone FROM City WHERE City.cityName = arrivalCity;
    SELECT timeOffset INTO timeZoneOffset FROM TimeZone WHERE TimeZone.timeZoneID = arrivalTimeZone;
    
    RETURN DATE_ADD(arrivalTimeUTC, INTERVAL timeZoneOffset HOUR);
END//
DELIMITER ;

#SELECT LocalArrivalTime(1);

# Procedures
DROP PROCEDURE IF EXISTS AddFlight;
DELIMITER //
CREATE PROCEDURE AddFlight (IN inAircraftReg VARCHAR(8), IN inArrivalDateTimeUTC DATETIME, IN inDepartureDateTimeUTC DATETIME,
IN inArrivalGateID VARCHAR(5), IN inArrivalGateAirport VARCHAR(5), IN inDepartureGateID VARCHAR(5), IN inDepartureGateAirport VARCHAR(5))
BEGIN
	DECLARE newFlightID INT;
    
	INSERT Flight (arrivalDateTimeUTC, departureDateTimeUTC, aircraftReg, arrivalGateID, departureGateID, arrivalGateAirport, departureGateAirport)
    VALUES (inArrivalDateTimeUTC, inDepartureDateTimeUTC, inAircraftReg, inArrivalGateID, inDepartureGateID, inArrivalGateAirport, inDepartureGateAirport);    
    
    SELECT flightID INTO newFlightID FROM Flight WHERE flightID = (SELECT MAX(flightID) FROM Flight);
    
    INSERT Ticket (flightID, seatNo, basePrice, luggage) VALUES
    (newFlightID, 101, 500, 0),
    (newFlightID, 102, 500, 0),
    (newFlightID, 501, 250, 0),
    (newFlightID, 601, 250, 0);
END //
DELIMITER ;

# Test run:
# SELECT * FROM Flight;
# CALL AddFlight ('N405DX', '2038-01-19 06:14:07', '2038-01-18 06:14:07', '12', 'KJFK', '171', 'RJAA');
# SELECT * FROM Flight;
# SELECT * FROM Ticket;

# Triggers
# Check if a crew member is already scheduled for at flight at a given time
DROP TRIGGER IF EXISTS ensure_valid_flight_time;
DELIMITER //
CREATE TRIGGER ensure_valid_flight_time
BEFORE INSERT ON Flight FOR EACH ROW
BEGIN
	IF (NEW.arrivalDateTimeUTC <= NEW.departureDateTimeUTC) THEN SIGNAL SQLSTATE 'HY000'
            SET MYSQL_ERRNO = 1525, MESSAGE_TEXT = 'Flight must arrive after departure';
	END IF;
END//
DELIMITER ;

# Test
#INSERT Flight (arrivalDateTimeUTC, departureDateTimeUTC, aircraftReg, arrivalGateID,
#	departureGateID, arrivalGateAirport, departureGateAirport) 
#    VALUES('2021-01-19 03:00:00', '2021-01-19 03:00:00', 'N405DX', 'D2', '150D', 'EKCH', 'RJAA');

# Events
SET GLOBAL event_scheduler = 1;
# Removes all unsold tickets from flights that have started
DROP EVENT IF EXISTS RemoveUnsoldTickets;
CREATE EVENT RemoveUnsoldTickets
ON SCHEDULE EVERY 1 DAY
DO DELETE FROM Ticket WHERE passengerID IS NULL AND flightID IN (SELECT flightID FROM Flight WHERE departureDateTimeUTC < NOW());

SELECT timeOffset FROM TimeZone WHERE timeZoneID IN (SELECT timeZoneID FROM City WHERE cityName IN (SELECT cityName FROM Airport WHERE 'EKCH' = Airport.ICAO));

# Views
DROP VIEW IF EXISTS AllFlights;
CREATE VIEW AllFlights AS
SELECT flightID AS Flight,
DATE_ADD(Flight.departureDateTimeUTC,
INTERVAL 	(SELECT timeOffset FROM TimeZone WHERE timeZoneID IN
			(SELECT timeZoneID FROM City WHERE cityName IN
			(SELECT cityName FROM Airport WHERE Flight.departureGateAirport = Airport.ICAO) ) ) HOUR)
    AS LocalDepartureTime,
LocalArrivalTime(flightID) AS LocalArrivalTime,
(SELECT cityName FROM Airport WHERE Flight.departureGateAirport = Airport.ICAO) AS DepartureCity,
(SELECT cityName FROM Airport WHERE Flight.arrivalGateAirport = Airport.ICAO) AS ArrivalCity
FROM Flight ORDER BY Flight;
SELECT * FROM AllFlights;