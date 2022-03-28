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
# Check if a crew member is already scheduled for at flight at a given time
DELIMITER //
CREATE TRIGGER crewAlreadyBooked
BEFORE INSERT ON CrewFlight FOR EACH ROW
BEGIN
	DECLARE newCrewArrival DATETIME;
    DECLARE newCrewDeparture DATETIME;
    DECLARE newCrewTimeDiff DATETIME;
    DECLARE newCrewFlightArrival DATETIME;
	DECLARE newCrewFlightDepature DATETIME;
    DECLARE flightArrivals DATETIME;
    DECLARE flightDepatures DATETIME;
    
    SELECT arrivalDateTimeUTC INTO newCrewFlightArrival FROM Flight WHERE flightID = NEW.flightID;
    SELECT depatureDateTimeUTC INTO newCrewFlightDepature FROM Flight WHERE flightID = NEW.flightID;
    
    # all arrival date time for crewID
    SELECT arrivalDateTimeUTC INTO flightArrivals FROM Flight WHERE flightID IN (SELECT flightID FROM CrewFlight WHERE NEW.crewID = CrewFlight.crewID);
    # all departure date time for crewID
    SELECT depatureDateTimeUTC INTO flightDepatures FROM Flight WHERE flightID IN (SELECT flightID FROM CrewFlight WHERE NEW.crewID = CrewFlight.crewID);
    
	# !!!!!! How to compare new crew flight arrival and departure to all flight arrival and departures for all existing flights for that crew member
    IF ((newCrewFlightArrival BETWEEN flightArrivals AND flightDepatures) OR (newCrewFlightDepature BETWEEN flightArrivals AND flightDepatures)) 
		THEN SIGNAL SQLSTATE 'HY000' SET MYSQL_ERRNO = 1525, MESSAGE_TEXT = 'crewmember is already booked'; 
    END IF;
    
END//
DELIMITER ;

# Events
