# Raise prices on all non-purchased tickets for future flights by 5%
# (Turn off Safe Updates in Preferences > SQL Editor)
UPDATE Ticket 
INNER JOIN Flight ON Ticket.flightID = Flight.flightID
SET basePrice = basePrice * 1.05
WHERE Flight.DepartureDateTimeUTC > NOW() && ISNULL(Ticket.passengerID);

# Fire Leonardo Di Caprio
DELETE FROM Crew
WHERE crewID = 1