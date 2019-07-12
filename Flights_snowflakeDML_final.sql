use flights_snowflake;

-- -----------------------------------------------------
-- Copy Data from flight database 
-- -----------------------------------------------------
USE flights_snowflake;

#dim_date
DROP PROCEDURE IF EXISTS fill_date_dimension;
DELIMITER //
CREATE PROCEDURE fill_date_dimension(IN startdate DATE, IN stopdate DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO dim_date(date, 
							day, 
                            month, 
                            year, 
                            dayofweek,
                            monthname,
                            weekend_flag
							) 
			VALUES ( currentdate,
						DAY(currentdate),
                        MONTH(currentdate),
                        YEAR(currentdate),
                        DATE_FORMAT(currentdate,'%W'),
                        DATE_FORMAT(currentdate,'%M'),
                        CASE DAYOFWEEK(currentdate) WHEN 1 THEN 't' WHEN 7 then 't' ELSE 'f' END
                        );
        SET currentdate = ADDDATE(currentdate, INTERVAL 1 DAY);
    END WHILE;
END
//
DELIMITER ;

CALL fill_date_dimension('2016-01-01','2020-01-01');

#dim_weather
SELECT * FROM flights.Weather;
INSERT INTO flights_snowflake.dim_weather(weatherid, 
wind, 
prcp, 
snow, 
snwd,
tmax,
tmin)
(SELECT
weatherid, 
AWND, 
PRCP, 
SNOW, 
SNWD,
TMAX,
TMIN
FROM flights.Weather);


# dim_cancellation table 
INSERT INTO flights_snowflake.dim_cancellation (    
	cancel_id,
   description)
(

SELECT 
    cancel_id,
    description
FROM
    flights.cancellation);
    


# dim_airline
INSERT INTO flights_snowflake.dim_airline (    
	airline_id,
    description)
(SELECT 
    airline_id,
    Description
FROM
    flights.airline);
    

#dim_state
INSERT INTO flights_snowflake.dim_state (  
  state
)
(
	SELECT DISTINCT SUBSTRING_INDEX(description,',',-1)
	FROM flights.city_state);
    



# dim_city
INSERT INTO flights_snowflake.dim_city (  
  citystate_id,
  city,
  state_key
)
(
	SELECT CityState_id, SUBSTRING_INDEX(description,',',1), s.state_key
	FROM flights.city_state as cs
    JOIN dim_state as s 
    ON s.state =  SUBSTRING_INDEX(cs.description,',',-1));
    
    
# dim_airport
INSERT INTO flights_snowflake.dim_airport (  
  airport_id,
  description,
  city_key
)
(
	SELECT DISTINCT airport_id, description, ds.city_key
	FROM flights.airport as a
    JOIN flights.flight as f
    ON f.DEST_AIRPORT_ID = a.airport_id
    JOIN flights_snowflake.dim_city as ds
    ON ds.citystate_id = f.DEST_CITY_MARKET_ID);
    
    

#dim_flight
INSERT INTO flights_snowflake.dim_flight (
flight_id,
CRSDepTime,
DepTime,
TaxiOut,
WheelsOff,
WheelsOn,
CRSArrTime,
ArrTime,
CRSElapsedTime,
ElapsedTime,
TaxiIn,
AirTime,
date_key

)
(

SELECT flightid,
	CRS_DEP_TIME, 
	DEP_TIME,
    TAXI_OUT, 
    WHEELS_OFF, 
    WHEELS_ON, 
    CRS_ARR_TIME,  
    ARR_TIME,
    CRS_ELAPSED_TIME,
    ACTUAL_ELAPSED_TIME,
    TAXI_IN,
    AIR_TIME,
    d.date_key
    FROM flights.flight as f
    JOIN flights_snowflake.dim_date  as d ON 
    d.date = DATE(f.FL_date));
  
    
INSERT INTO flights_snowflake.fact_delay (
Flight_delay_ID,
dep_delay,
arr_dealy,
carrier_delay,
weather_delay,
NAS_delay,
security_delay,
late_aircraft_delay,
cancel_key,
airline_key,
origin_airport_key,
destination_airport_key,
weather_key,
flight_key
)
(
SELECT flightid,
		DEP_DELAY,
        ARR_DELAY,
        CARRIER_DELAY,
        WEATHER_DELAY,
        NAS_DELAY,
        SECURITY_DELAY,
        LATE_AIRCRAFT_DELAY,
        c.cancel_key,
        a.airline_key,
        origin.airport_key,
        dest.airport_key,
        w.weather_key,
        df.flight_key
 FROM flights.flight as f
 JOIN flights_snowflake.dim_cancellation as c
 ON c.cancel_id = f.CANCELLATION_CODE
 JOIN flights_snowflake.dim_airline as a
 ON a.airline_id = f.OP_UNIQUE_CARRIER 
 JOIN flights_snowflake.dim_airport as origin
 ON origin.airport_id = f.ORIGIN_AIRPORT_ID
 JOIN flights_snowflake.dim_airport as dest
 ON dest.airport_id = f.DEST_AIRPORT_ID
 JOIN flights_snowflake.dim_weather as w on 
 w.weatherid = f.weatherid 
JOIN flights_snowflake.dim_flight as df
ON df.flight_id = f.flightid

);
