# Main script that creates the database
DROP DATABASE IF EXISTS airport;
CREATE DATABASE airport;
use airport;

# =======================================================
# =============== Create Relation Schemas ===============
# =======================================================
# TimeZone
DROP TABLE IF EXISTS TimeZone;
CREATE TABLE TimeZone
	( timeZoneID	VARCHAR(4),
      timeOffset	DECIMAL(2,0),
    PRIMARY KEY (timeZoneID)
    );

# City
DROP TABLE IF EXISTS City;
# CREATE TABLE

# Airport
DROP TABLE IF EXISTS Airport;
# CREATE TABLE

# Gate
DROP TABLE IF EXISTS Gate;
# CREATE TABLE

# Ticket
DROP TABLE IF EXISTS Ticket;
# CREATE TABLE

# Ticket Price
DROP TABLE IF EXISTS TicketPrice;
# CREATE TABLE

# Nationality
DROP TABLE IF EXISTS Nationality;
# CREATE TABLE

# Passenger
DROP TABLE IF EXISTS Passenger;
# CREATE TABLE

# Crew
DROP TABLE IF EXISTS Crew;
# CREATE TABLE

# CrewFlight
DROP TABLE IF EXISTS CrewFlight;
# CREATE TABLE

# Flight
DROP TABLE IF EXISTS Flight;
# CREATE TABLE

# Aircraft Model
DROP TABLE IF EXISTS AircraftModel;
# CREATE TABLE

# Aircraft Instance
DROP TABLE IF EXISTS AircraftInstance;
# CREATE TABLE

# License
DROP TABLE IF EXISTS License;
# CREATE TABLE

# Pilot
DROP TABLE IF EXISTS Pilot;
# CREATE TABLE

# Pilot Flight
DROP TABLE IF EXISTS PilotFlight
# CREATE TABLE