############## SQL Programming ##############

# Function


# Age function - Calculate the age of a person given their birth date (returns difference in years between current date and input date)
CREATE FUNCTION Age(mDate DATE) RETURNS INTEGER
RETURN TIMESTAMPDIFF(YEAR, mDate, CURDATE());

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
    
	SELECT arrivalDateTimeUTC INTO arrivalTimeUTC FROM Flight WHERE Flight.flightID = mFlightID;
    SELECT arrivalGateAirport INTO arrivalAirportICAO FROM Flight WHERE Flight.flightID = mFlightID;
	SELECT cityName INTO arrivalCity FROM Airport WHERE Airport.ICAO = arrivalAirportICAO;
	SELECT timeZoneID INTO arrivalTimeZone FROM City WHERE City.cityName = arrivalCity;
    
    RETURN DATE_ADD(arrivalTimeUTC, INTERVAL arrivalTimeZone HOUR);
END//
DELIMITER ;

# Procedures
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

# Events
