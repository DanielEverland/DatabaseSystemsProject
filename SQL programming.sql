############## SQL Programming ##############

# Function


# Age function - Calculate the age of a person given their birth date (returns difference in years between current date and input date)
CREATE FUNCTION Age(mDate DATE) RETURNS INTEGER
RETURN TIMESTAMPDIFF(YEAR, mDate, CURDATE());

CREATE FUNCTION getFlightDuration(departureTime DATETIME, arrivalTime DATETIME) RETURNS INT
RETURN TIMESTAMPDIFF(MINUTE, departureTime, arrivalTime);

# flightID, what local time depature -> local time at arrival

DROP FUNCTION IF EXISTS LocalArrivalTime;
DELIMITER //
CREATE FUNCTION LocalArrivalTime(mFlightID INT) RETURNS DATETIME
BEGIN
	DECLARE arrivalTimeUTC DATETIME;
    DECLARE departureTimeUTC DATETIME;
    DECLARE arrivalAirportICAO VARCHAR(4);
    DECLARE departureAirportICAO VARCHAR(4);
    DECLARE arrivalCity VARCHAR(85);
    DECLARE departureCity VARCHAR(85);
    DECLARE arrivalTimeZone VARCHAR(4);
    DECLARE departureTimeZome VARCHAR(4);
    
	SELECT arrivalDateTimeUTC INTO arrivalTimeUTC FROM Flight WHERE Flight.flightID = mFlightID;
	SELECT departureDateTimeUTC INTO departureTimeUTC FROM Flight WHERE Flight.flightID = mFlightID;
    SELECT arrivalGateAirport INTO arrivalAirportICAO FROM Flight WHERE Flight.flightID = mFlightID;
    SELECT departureGateAirport INTO departureAirportICAO FROM Flight WHERE Flight.flightID = mFlightID;
	SELECT cityName INTO arrivalCity FROM Airport WHERE Airport.ICAO = arrivalAirportICAO;
    SELECT cityName INTO departureCity FROM Airport WHERE Airport.ICAO = departureAirportICAO;
	SELECT timeZoneID INTO arrivalTimeZone FROM City WHERE City.cityName = arrivalCity;
    SELECT timeZoneID INTO departureTimeZome FROM City WHERE City.cityName = departureCity;
    
    RETURN 
    
END//
DELIMITER ;

SELECT LocalArrivalTime(1);
# Procedures
# INSERT new flight = new tickets with empty passengers

# Triggers

# Events
