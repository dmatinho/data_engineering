-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema flights_snowflake
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema flights_snowflake
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `flights_snowflake` DEFAULT CHARACTER SET latin1 ;
USE `flights_snowflake` ;

-- -----------------------------------------------------
-- Table `flights_snowflake`.`dim_airline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights_snowflake`.`dim_airline` ;

CREATE TABLE IF NOT EXISTS `flights_snowflake`.`dim_airline` (
  `airline_key` INT(11) NOT NULL AUTO_INCREMENT,
  `airline_id` VARCHAR(45) NOT NULL,
  `description` LONGTEXT NOT NULL,
  PRIMARY KEY (`airline_key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights_snowflake`.`dim_state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights_snowflake`.`dim_state` ;

CREATE TABLE IF NOT EXISTS `flights_snowflake`.`dim_state` (
  `state_key` INT(11) NOT NULL AUTO_INCREMENT,
  `state` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`state_key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights_snowflake`.`dim_city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights_snowflake`.`dim_city` ;

CREATE TABLE IF NOT EXISTS `flights_snowflake`.`dim_city` (
  `city_key` INT(11) NOT NULL AUTO_INCREMENT,
  `citystate_id` INT(11) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state_key` INT(11) NOT NULL,
  PRIMARY KEY (`city_key`),
  INDEX `fk_City_State_idx` (`state_key` ASC),
  CONSTRAINT `fk_City_State`
    FOREIGN KEY (`state_key`)
    REFERENCES `flights_snowflake`.`dim_state` (`state_key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights_snowflake`.`dim_airport`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights_snowflake`.`dim_airport` ;

CREATE TABLE IF NOT EXISTS `flights_snowflake`.`dim_airport` (
  `airport_key` INT(11) NOT NULL AUTO_INCREMENT,
  `airport_id` INT(11) NOT NULL,
  `description` LONGTEXT NOT NULL,
  `city_key` INT(11) NOT NULL,
  PRIMARY KEY (`airport_key`),
  INDEX `fk_dim_airport_dim_city1_idx` (`city_key` ASC),
  CONSTRAINT `fk_dim_airport_dim_city1`
    FOREIGN KEY (`city_key`)
    REFERENCES `flights_snowflake`.`dim_city` (`city_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights_snowflake`.`dim_cancellation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights_snowflake`.`dim_cancellation` ;

CREATE TABLE IF NOT EXISTS `flights_snowflake`.`dim_cancellation` (
  `cancel_key` INT(11) NOT NULL AUTO_INCREMENT,
  `cancel_id` VARCHAR(1) NOT NULL,
  `description` LONGTEXT NOT NULL,
  PRIMARY KEY (`cancel_key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights_snowflake`.`dim_date`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights_snowflake`.`dim_date` ;

CREATE TABLE IF NOT EXISTS `flights_snowflake`.`dim_date` (
  `date_key` INT(11) NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `day` INT NULL,
  `month` INT NULL,
  `year` INT NULL,
  `dayofweek` VARCHAR(45) NULL,
  `monthname` VARCHAR(45) NULL,
  `weekend_flag` CHAR(1) DEFAULT 'f' CHECK (weekday_flag in ('t', 'f')),
  PRIMARY KEY (`date_key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights_snowflake`.`dim_weather`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights_snowflake`.`dim_weather` ;

CREATE TABLE IF NOT EXISTS `flights_snowflake`.`dim_weather` (
  `weather_key` INT(11) NOT NULL AUTO_INCREMENT,
  `weatherid` VARCHAR(45) NOT NULL,
  `wind` FLOAT NOT NULL,
  `prcp` FLOAT NOT NULL,
  `snow` FLOAT NOT NULL,
  `snwd` FLOAT NOT NULL,
  `tmax` FLOAT NOT NULL,
  `tmin` FLOAT NOT NULL,
  PRIMARY KEY (`weather_key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights_snowflake`.`dim_flight`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights_snowflake`.`dim_flight` ;

CREATE TABLE IF NOT EXISTS `flights_snowflake`.`dim_flight` (
   `flight_key` INT(11) NOT NULL AUTO_INCREMENT,
  `flight_id` INT(11) NULL DEFAULT NULL,
  `CRSDepTime` TIME NOT NULL,
  `DepTime` TIME NOT NULL,
  `TaxiOut` INT(11) NOT NULL,
  `WheelsOff` TIME NOT NULL,
  `WheelsOn` TIME NOT NULL,
  `CRSArrTime` TIME NOT NULL,
  `ArrTime` TIME NOT NULL,
  `CRSElapsedTime` INT(11) NOT NULL,
  `ElapsedTime` INT(11) NOT NULL,
  `TaxiIn` INT(11) NOT NULL,
  `AirTime` INT(11) NOT NULL,
  `date_key` INT(11) NOT NULL,
  PRIMARY KEY (`flight_key`),
  INDEX `fk_dim_flight_dim_date1_idx` (`date_key` ASC),
  CONSTRAINT `fk_dim_flight_dim_date1`
    FOREIGN KEY (`date_key`)
    REFERENCES `flights_snowflake`.`dim_date` (`date_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `flights_snowflake`.`fact_delay`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights_snowflake`.`fact_delay` ;

CREATE TABLE IF NOT EXISTS `flights_snowflake`.`fact_delay` (
  `Flight_delay_ID` INT(11) NOT NULL,
  `cancel_key` INT(11) NOT NULL,
  `airline_key` INT(11) NOT NULL,
  `origin_airport_key` INT(11) NOT NULL,
  `dep_delay` INT(11) NULL DEFAULT NULL,
  `destination_airport_key` INT(11) NOT NULL,
  `arr_dealy` INT(11) NULL DEFAULT NULL,
  `carrier_delay` INT(11) NULL DEFAULT NULL,
  `weather_delay` INT(11) NULL DEFAULT NULL,
  `NAS_delay` INT(11) NULL DEFAULT NULL,
  `security_delay` INT(11) NULL DEFAULT NULL,
  `late_aircraft_delay` INT(11) NULL DEFAULT NULL,
  `weather_key` INT(11) NOT NULL,
  `flight_key` INT NOT NULL,
  PRIMARY KEY (`Flight_delay_ID`),
  INDEX `fk_fact_flight_dim_cancellation1_idx` (`cancel_key` ASC),
  INDEX `fk_fact_flight_dim_airline1_idx` (`airline_key` ASC),
  INDEX `fk_fact_flight_dim_airport1_idx` (`origin_airport_key` ASC),
  INDEX `fk_fact_flight_dim_airport2_idx` (`destination_airport_key` ASC),
  INDEX `fk_fact_flight_table11_idx` (`weather_key` ASC),
  INDEX `fk_fact_delay_dim_flight1_idx` (`flight_key` ASC),
  CONSTRAINT `fk_fact_flight_dim_airline1`
    FOREIGN KEY (`airline_key`)
    REFERENCES `flights_snowflake`.`dim_airline` (`airline_key`),
  CONSTRAINT `fk_fact_flight_dim_airport1`
    FOREIGN KEY (`origin_airport_key`)
    REFERENCES `flights_snowflake`.`dim_airport` (`airport_key`),
  CONSTRAINT `fk_fact_flight_dim_airport2`
    FOREIGN KEY (`destination_airport_key`)
    REFERENCES `flights_snowflake`.`dim_airport` (`airport_key`),
  CONSTRAINT `fk_fact_flight_dim_cancellation1`
    FOREIGN KEY (`cancel_key`)
    REFERENCES `flights_snowflake`.`dim_cancellation` (`cancel_key`),
  CONSTRAINT `fk_fact_flight_table11`
    FOREIGN KEY (`weather_key`)
    REFERENCES `flights_snowflake`.`dim_weather` (`weather_key`),
  CONSTRAINT `fk_fact_delay_dim_flight1`
    FOREIGN KEY (`flight_key`)
    REFERENCES `flights_snowflake`.`dim_flight` (`flight_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

create unique index flight_id_idx on flights_snowflake.dim_flight(flight_id);
create unique index fk_cancelid_indx on flights_snowflake.dim_cancellation(cancel_id);
create unique index fk_weather_id_indx on flights_snowflake.dim_weather(weatherid);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
