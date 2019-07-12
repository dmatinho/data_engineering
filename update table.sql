ALTER TABLE flights.flight ADD COLUMN `flightid` INT AUTO_INCREMENT UNIQUE FIRST;
ALTER TABLE flights.Weather ADD COLUMN `airline_id` INT;
ALTER TABLE flights.flight ADD COLUMN weatherid INT(11);

UPDATE flights.Weather SET airline_id = 12892 WHERE name like 'LOS ANGELES %';
UPDATE flights.Weather SET airline_id = 11292 WHERE name like 'DENVER %';
UPDATE flights.Weather SET airline_id = 12478 WHERE name like 'JFK %';
UPDATE flights.Weather SET airline_id = 10397 WHERE name like 'ATLANTA %';
UPDATE flights.Weather SET airline_id = 11298 WHERE name like 'DALLAS %';
UPDATE flights.Weather SET airline_id = 13930 WHERE name like 'CHICAGO %';

update flights.flight t2 join
       flights.Weather t1
       on date(t2.FL_date) = date(t1.date) AND t1.airline_id = t2.ORIGIN_AIRPORT_ID
    set t2.weatherid = t1.weatherid;
