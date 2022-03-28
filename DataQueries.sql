# Data queries for different 
USE airport;

# Query 1: Find all flight times for a specific passenger
SELECT flightID, departureDateTimeUTC, arrivalDateTimeUTC
FROM Passenger NATURAL JOIN Flight
WHERE passengerID = 3;

# Query 2: Find the number of different meals for a specific flight
SELECT Meal, COUNT(*) AS Meals
FROM Ticket
WHERE flightID = 1
AND meal != 'None'
GROUP BY meal;

# Query 3: Find all pilots with an active (not expired) license for a certain AircraftModel
SELECT pilotID, firstName, lastName, (licenseDurationDays - DATEDIFF(CURRENT_DATE, lastRenewal)) AS 'Days to expiration'
FROM AircraftModel NATURAL JOIN License NATURAL JOIN Pilot
WHERE modelName = 'A330'
AND licenseDurationDays >= DATEDIFF(CURRENT_DATE, lastRenewal);
