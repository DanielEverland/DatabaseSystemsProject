# Data queries for different scenarios
USE airport;

# Query 1: Find all passengers for a specific flight
SELECT passengerID, firstName, lastName
FROM Passenger NATURAL JOIN Ticket
WHERE flightID = 1
ORDER BY firstName;

# Query 2: Find the number of different meals on a specific flight
SELECT Meal, COUNT(*) AS Meals
FROM Ticket
WHERE flightID = 1
AND meal IS NOT NULL
GROUP BY meal;

# Query 3: Find all pilots with an active (not expired) license for a certain AircraftModel
SELECT pilotID, firstName, lastName, (licenseDurationDays - DATEDIFF(CURRENT_DATE, lastRenewal)) AS 'Days to expiration'
FROM AircraftModel NATURAL JOIN License NATURAL JOIN Pilot
WHERE modelName = 'A330'
AND licenseDurationDays > DATEDIFF(CURRENT_DATE, lastRenewal);
