-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema airbnb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema airbnb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `airbnb` DEFAULT CHARACTER SET utf8 ;
USE `airbnb` ;

-- -----------------------------------------------------
-- Table `airbnb`.`bidding`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airbnb`.`bidding` (
  `bid_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `max_bid_days` INT(11) NULL DEFAULT '4',
  `expiry_date` DATETIME NULL DEFAULT NULL,
  `host_min_amt` DOUBLE NULL DEFAULT NULL,
  `max_bid_price` DOUBLE NULL DEFAULT NULL,
  `max_bid_user_id` VARCHAR(50) NULL DEFAULT NULL,
  `property_id` VARCHAR(50) NOT NULL,
  `property_name` VARCHAR(256) NULL DEFAULT NULL,
  PRIMARY KEY (`bid_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `airbnb`.`bidding_dtl`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airbnb`.`bidding_dtl` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `bid_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `bidder_id` VARCHAR(50) NULL DEFAULT NULL,
  `bid_price` DOUBLE NULL DEFAULT NULL,
  `bid_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `property_name` VARCHAR(256) NULL DEFAULT NULL,
  `property_id` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `bid_id_idx` (`bid_id` ASC),
  CONSTRAINT `bid_id`
    FOREIGN KEY (`bid_id`)
    REFERENCES `airbnb`.`bidding` (`bid_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `airbnb`.`trip`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airbnb`.`trip` (
  `trip_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(50) NOT NULL,
  `property_id` VARCHAR(50) NULL DEFAULT NULL,
  `host_id` VARCHAR(50) NOT NULL,
  `billing_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `checkin_date` DATETIME NOT NULL,
  `checkout_date` DATETIME NOT NULL,
  `no_of_guests` INT(11) NOT NULL,
  `trip_status` VARCHAR(45) NULL DEFAULT 'PENDING' COMMENT 'Values : â€˜ACCEPTEDâ€™, â€˜REJECTEDâ€™, â€˜PENDINGâ€™',
  `trip_approved_time` DATETIME NULL DEFAULT NULL,
  `property_name` VARCHAR(256) NULL DEFAULT NULL,
  `trip_price` DOUBLE NULL DEFAULT NULL,
  `host_name` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`trip_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 20
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `airbnb`.`billing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airbnb`.`billing` (
  `billing_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `trip_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`billing_id`),
  INDEX `billing_trip_id_idx` (`trip_id` ASC),
  CONSTRAINT `billing_trip_id`
    FOREIGN KEY (`trip_id`)
    REFERENCES `airbnb`.`trip` (`trip_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Trigger `airbnb`.`billing`
-- -----------------------------------------------------
create TRIGGER airbnb.bidding AFTER INSERT on airbnb.bidding_dtl
FOR EACH ROW
	update airbnb.bidding b set b.max_bid_price = new.bid_price, b.max_bid_user_id = new.bidder_id where 
    b.max_bid_price < new.bid_price and b.property_id = new.property_id
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
