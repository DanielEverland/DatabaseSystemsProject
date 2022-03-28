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
# INSERT new flight = new tickets with empty passengers

# Triggers

# Events
