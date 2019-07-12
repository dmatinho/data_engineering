-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema flights
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `flights` DEFAULT CHARACTER SET latin1 ;
USE `flights` ;

-- -----------------------------------------------------
-- Table `flights`.`airline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights`.`airline` ;

CREATE TABLE IF NOT EXISTS `flights`.`airline` (
  `Airline_id` VARCHAR(45) NOT NULL,
  `Description` LONGTEXT NOT NULL,
  PRIMARY KEY (`Airline_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights`.`airport`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights`.`airport` ;

CREATE TABLE IF NOT EXISTS `flights`.`airport` (
  `airport_id` INT(11) NOT NULL,
  `Description` LONGTEXT NOT NULL,
  PRIMARY KEY (`airport_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights`.`cancellation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights`.`cancellation` ;

CREATE TABLE IF NOT EXISTS `flights`.`cancellation` (
  `Cancel_id` VARCHAR(45) NOT NULL,
  `Description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Cancel_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights`.`city_state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights`.`city_state` ;

CREATE TABLE IF NOT EXISTS `flights`.`city_state` (
  `CityState_id` INT(11) NOT NULL,
  `Description` LONGTEXT NOT NULL,
  PRIMARY KEY (`CityState_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `flights`.`flight`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights`.`flight` ;

CREATE TABLE IF NOT EXISTS `flights`.`flight` (
  `FL_date` DATE NULL DEFAULT NULL,
  `ACTUAL_ELAPSED_TIME` INT(11) NULL DEFAULT NULL,
  `AIR_TIME` INT(11) NULL DEFAULT NULL,
  `ARR_DELAY` INT(11) NULL DEFAULT NULL,
  `ARR_TIME` TIME NULL DEFAULT NULL,
  `CANCELLATION_CODE` VARCHAR(45) NOT NULL,
  `CANCELLED` INT(11) NULL DEFAULT NULL,
  `CARRIER_DELAY` INT(11) NULL DEFAULT NULL,
  `CRS_ARR_TIME` TIME NULL DEFAULT NULL,
  `CRS_DEP_TIME` TIME NULL DEFAULT NULL,
  `CRS_ELAPSED_TIME` INT(11) NULL DEFAULT NULL,
  `DEP_DELAY` INT(11) NULL DEFAULT NULL,
  `DEP_TIME` TIME NULL DEFAULT NULL,
  `DEST_AIRPORT_ID` INT(11) NOT NULL,
  `DEST_CITY_MARKET_ID` INT(11) NOT NULL,
  `DIVERTED` INT(11) NULL DEFAULT NULL,
  `LATE_AIRCRAFT_DELAY` INT(11) NULL DEFAULT NULL,
  `NAS_DELAY` INT(11) NULL DEFAULT NULL,
  `OP_UNIQUE_CARRIER` VARCHAR(45) NOT NULL,
  `ORIGIN_AIRPORT_ID` INT(11) NOT NULL,
  `ORIGIN_CITY_MARKET_ID` INT(11) NOT NULL,
  `SECURITY_DELAY` INT(11) NULL DEFAULT NULL,
  `TAXI_IN` INT(11) NULL DEFAULT NULL,
  `TAXI_OUT` INT(11) NULL DEFAULT NULL,
  `WEATHER_DELAY` INT(11) NULL DEFAULT NULL,
  `WHEELS_OFF` TIME NULL DEFAULT NULL,
  `WHEELS_ON` TIME NULL DEFAULT NULL,
  INDEX `fk_flight_airline_idx` (`OP_UNIQUE_CARRIER` ASC),
  INDEX `fk_flight_airport1_idx` (`ORIGIN_AIRPORT_ID` ASC),
  INDEX `fk_flight_city_state1_idx` (`ORIGIN_CITY_MARKET_ID` ASC),
  INDEX `fk_flight_airport2_idx` (`DEST_AIRPORT_ID` ASC),
  INDEX `fk_flight_city_state2_idx` (`DEST_CITY_MARKET_ID` ASC),
  INDEX `fk_flight_cancellation1_idx` (`CANCELLATION_CODE` ASC),
  CONSTRAINT `fk_flight_airline`
    FOREIGN KEY (`OP_UNIQUE_CARRIER`)
    REFERENCES `flights`.`airline` (`Airline_id`),
  CONSTRAINT `fk_flight_airport1`
    FOREIGN KEY (`ORIGIN_AIRPORT_ID`)
    REFERENCES `flights`.`airport` (`airport_id`),
  CONSTRAINT `fk_flight_airport2`
    FOREIGN KEY (`DEST_AIRPORT_ID`)
    REFERENCES `flights`.`airport` (`airport_id`),
  CONSTRAINT `fk_flight_cancellation1`
    FOREIGN KEY (`CANCELLATION_CODE`)
    REFERENCES `flights`.`cancellation` (`Cancel_id`),
  CONSTRAINT `fk_flight_city_state1`
    FOREIGN KEY (`ORIGIN_CITY_MARKET_ID`)
    REFERENCES `flights`.`city_state` (`CityState_id`),
  CONSTRAINT `fk_flight_city_state2`
    FOREIGN KEY (`DEST_CITY_MARKET_ID`)
    REFERENCES `flights`.`city_state` (`CityState_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `flights`.`Weather`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flights`.`Weather` ;

CREATE TABLE IF NOT EXISTS `flights`.`Weather` (
  `weatherid` INT(11) NOT NULL AUTO_INCREMENT,
  `station` VARCHAR(45) NOT NULL,
  `name` VARCHAR(70) NOT NULL,
  `DATE` DATETIME NOT NULL,
  `AWND` FLOAT NULL DEFAULT NULL,
  `PRCP` FLOAT NULL DEFAULT NULL,
  `SNOW` FLOAT NULL DEFAULT NULL,
  `SNWD` FLOAT NULL DEFAULT NULL,
  `TMAX` FLOAT NULL DEFAULT NULL,
  `TMIN` FLOAT NULL DEFAULT NULL,
  `TAVG` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`weatherid`))
ENGINE = InnoDB
AUTO_INCREMENT = 487
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
