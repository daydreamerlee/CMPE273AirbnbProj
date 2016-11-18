-- MySQL Script generated by MySQL Workbench
-- Wed Nov  9 13:58:10 2016
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema airbnb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `airbnb` ;

-- -----------------------------------------------------
-- Schema airbnb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `airbnb` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `airbnb` ;

-- -----------------------------------------------------
-- Table `airbnb`.`trip`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airbnb`.`trip` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `airbnb`.`trip` (
  `trip_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(50) NOT NULL,
  `property_id` VARCHAR(50) NOT NULL,
  `host_id` VARCHAR(50) NOT NULL,
  `billing_id` INT UNSIGNED NULL,
  `checkin_date` DATETIME NOT NULL,
  `checkout_date` DATETIME NOT NULL,
  `no_of_guests` INT NOT NULL,
  `trip_status` VARCHAR(45) NULL DEFAULT 'PENDING' COMMENT 'Values : ‘ACCEPTED’, ‘REJECTED’, ‘PENDING’',
  PRIMARY KEY (`trip_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `airbnb`.`billing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airbnb`.`billing` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `airbnb`.`billing` (
  `billing_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `trip_id` INT UNSIGNED NULL,
  PRIMARY KEY (`billing_id`),
  CONSTRAINT `billing_trip_id`
    FOREIGN KEY (`trip_id`)
    REFERENCES `airbnb`.`trip` (`trip_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `billing_trip_id_idx` ON `airbnb`.`billing` (`trip_id` ASC);

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `airbnb`.`bidding`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airbnb`.`bidding` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `airbnb`.`bidding` (
  `bid_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_time` DATETIME NULL DEFAULT now(),
  `max_bid_days` INT NULL DEFAULT 4,
  `expiry_date` DATETIME NULL,
  `host_min_amt` DOUBLE NULL,
  `max_bid_price` DOUBLE NULL,
  `max_bid_user_id` VARCHAR(50) NULL,
  `property_id` VARCHAR(50) NOT NULL,
  `prop_desc` VARCHAR(100) NULL,
  PRIMARY KEY (`bid_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `airbnb`.`bidding_dtl`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airbnb`.`bidding_dtl` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `airbnb`.`bidding_dtl` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `bid_id` INT UNSIGNED NULL,
  `bidder_id` VARCHAR(50) NULL,
  `bid_price` DOUBLE NULL,
  `bid_time` DATETIME NULL DEFAULT now(),
  PRIMARY KEY (`id`),
  CONSTRAINT `bid_id`
    FOREIGN KEY (`bid_id`)
    REFERENCES `airbnb`.`bidding` (`bid_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `bid_id_idx` ON `airbnb`.`bidding_dtl` (`bid_id` ASC);

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
