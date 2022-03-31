DROP FUNCTION IF EXISTS TicketFullPrice;

DELIMITER //
CREATE FUNCTION TicketFullPrice(vFlightID INT, vSeatNo VARCHAR(4)) RETURNS DECIMAL(9,2)
BEGIN
	DECLARE vBasePrice DECIMAL(8,2);
	DECLARE vLuggagePrice DECIMAL(5,2);
	DECLARE vMealPrice DECIMAL(4,2);
    
	SELECT basePrice, 
    CASE
		WHEN luggage > 79.99 THEN 100.00
		WHEN luggage > 49.99 THEN 75.00
		WHEN luggage > 29.99 THEN 50.00
		WHEN luggage > 9.99 THEN 25.00
        ELSE 0.00
	END,
    CASE
		WHEN meal = 'Beef' THEN 30.00
		WHEN meal = 'Chicken' THEN 20.00
		WHEN meal = 'Pork' THEN 25.00
		WHEN meal = 'Vegan' THEN 20.00
		WHEN meal = 'Vegetarian' THEN 20.00
        ELSE 0.00
	END
    INTO vBasePrice, vLuggagePrice, vMealPrice FROM Ticket
	WHERE flightID = vFlightID AND seatNo = vSeatNo;
    
    RETURN vBasePrice + vLuggagePrice + vMealPrice;
END//
DELIMITER ;

SELECT TicketFullPrice(1, '666');