-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema GestioneCorsiDiLingue
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `GestioneCorsiDiLingue` ;

-- -----------------------------------------------------
-- Schema GestioneCorsiDiLingue
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `GestioneCorsiDiLingue` DEFAULT CHARACTER SET utf8 ;
USE `GestioneCorsiDiLingue` ;

-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Livelli`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Livelli` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Livelli` (
  `Nome` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Corsi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Corsi` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Corsi` (
  `Codice` INT NOT NULL,
  `Data_attivazione` DATE NOT NULL,
  `Libro` VARCHAR(50) NOT NULL,
  `Esame` VARCHAR(16) NOT NULL,
  `Livelli_Nome` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Codice`, `Livelli_Nome`),
  CONSTRAINT `fk_Corsi_Livello`
    FOREIGN KEY (`Livelli_Nome`)
    REFERENCES `GestioneCorsiDiLingue`.`Livelli` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Corsi_Livello_idx` ON `GestioneCorsiDiLingue`.`Corsi` (`Livelli_Nome` ASC) ;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`User`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`User` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`User` (
  `Username` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  `Ruolo` ENUM('Allievo', 'Insegnante', 'Amministrazione', 'Segreteria') NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Insegnanti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Insegnanti` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Insegnanti` (
  `Nome` VARCHAR(20) NOT NULL,
  `Indirizzo` VARCHAR(45) NOT NULL,
  `Nazione` VARCHAR(20) NOT NULL,
  `User_Username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`, `User_Username`),
  CONSTRAINT `fk_Insegnanti_User1`
    FOREIGN KEY (`User_Username`)
    REFERENCES `GestioneCorsiDiLingue`.`User` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Insegnanti_User1_idx` ON `GestioneCorsiDiLingue`.`Insegnanti` (`User_Username` ASC) ;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Allievi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Allievi` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Allievi` (
  `Nome` VARCHAR(20) NOT NULL,
  `Recapito` VARCHAR(45) NOT NULL,
  `Data_assenze` DATE NULL,
  `User_Username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`, `Recapito`, `User_Username`),
  CONSTRAINT `fk_Allievi_User1`
    FOREIGN KEY (`User_Username`)
    REFERENCES `GestioneCorsiDiLingue`.`User` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Allievi_User1_idx` ON `GestioneCorsiDiLingue`.`Allievi` (`User_Username` ASC) ;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`FasciaOraria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`FasciaOraria` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`FasciaOraria` (
  `Data` DATE NOT NULL,
  `Ora` TIME NOT NULL,
  PRIMARY KEY (`Data`, `Ora`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Lezione_Corsi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Lezione_Corsi` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Lezione_Corsi` (
  `Giorni` DATE NOT NULL,
  `Orario` TIME NOT NULL,
  `Insegnanti_Nome` VARCHAR(20) NOT NULL,
  `Corsi_Codice` INT NOT NULL,
  `Corsi_Livelli_Nome` VARCHAR(10) NOT NULL,
  `FasciaOraria_Data` DATE NOT NULL,
  `FasciaOraria_Ora` TIME NOT NULL,
  `Lezione_Corsi_Insegnanti_username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Giorni`, `Orario`, `Insegnanti_Nome`, `Corsi_Codice`, `Corsi_Livelli_Nome`, `Lezione_Corsi_Insegnanti_username`),
  CONSTRAINT `fk_Lezione_Corsi_Insegnanti1`
    FOREIGN KEY (`Insegnanti_Nome` , `Lezione_Corsi_Insegnanti_username`)
    REFERENCES `GestioneCorsiDiLingue`.`Insegnanti` (`Nome` , `User_Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lezione_Corsi_FasciaOraria1`
    FOREIGN KEY (`FasciaOraria_Data` , `FasciaOraria_Ora`)
    REFERENCES `GestioneCorsiDiLingue`.`FasciaOraria` (`Data` , `Ora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lezione_Corsi_Codice_Corso`
    FOREIGN KEY (`Corsi_Codice` , `Corsi_Livelli_Nome`)
    REFERENCES `GestioneCorsiDiLingue`.`Corsi` (`Codice` , `Livelli_Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Lezione_Corsi_Insegnanti1_idx` ON `GestioneCorsiDiLingue`.`Lezione_Corsi` (`Insegnanti_Nome` ASC, `Lezione_Corsi_Insegnanti_username` ASC) ;

CREATE INDEX `fk_Lezione_Corsi_FasciaOraria1_idx` ON `GestioneCorsiDiLingue`.`Lezione_Corsi` (`FasciaOraria_Data` ASC, `FasciaOraria_Ora` ASC) ;

CREATE INDEX `fk_Lezione_Corsi_Codice_Corso_idx` ON `GestioneCorsiDiLingue`.`Lezione_Corsi` (`Corsi_Codice` ASC, `Corsi_Livelli_Nome` ASC) ;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Lezione_Privata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Lezione_Privata` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Lezione_Privata` (
  `Giorni` DATE NOT NULL,
  `Orario` TIME NOT NULL,
  `FasciaOraria_Data` DATE NOT NULL,
  `FasciaOraria_Ora` TIME NOT NULL,
  `Allievi_Nome` VARCHAR(20) NOT NULL,
  `Allievi_Recapito` VARCHAR(45) NOT NULL,
  `Insegnanti_Nome` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`Giorni`, `Orario`, `Allievi_Nome`, `Allievi_Recapito`, `Insegnanti_Nome`),
  CONSTRAINT `fk_Lezione_Privata_FasciaOraria1`
    FOREIGN KEY (`FasciaOraria_Data` , `FasciaOraria_Ora`)
    REFERENCES `GestioneCorsiDiLingue`.`FasciaOraria` (`Data` , `Ora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lezione_Privata_Allievi1`
    FOREIGN KEY (`Allievi_Nome` , `Allievi_Recapito`)
    REFERENCES `GestioneCorsiDiLingue`.`Allievi` (`Nome` , `Recapito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lezione_Privata_Insegnanti1`
    FOREIGN KEY (`Insegnanti_Nome`)
    REFERENCES `GestioneCorsiDiLingue`.`Insegnanti` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Lezione_Privata_FasciaOraria1_idx` ON `GestioneCorsiDiLingue`.`Lezione_Privata` (`FasciaOraria_Data` ASC, `FasciaOraria_Ora` ASC) ;

CREATE INDEX `fk_Lezione_Privata_Allievi1_idx` ON `GestioneCorsiDiLingue`.`Lezione_Privata` (`Allievi_Nome` ASC, `Allievi_Recapito` ASC) ;

CREATE INDEX `fk_Lezione_Privata_Insegnanti1_idx` ON `GestioneCorsiDiLingue`.`Lezione_Privata` (`Insegnanti_Nome` ASC) ;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Attività_Culturali`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Attività_Culturali` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Attività_Culturali` (
  `Chiave_ID` INT NOT NULL,
  `Tipologia` ENUM('Conferenza', 'Film') NOT NULL,
  `Conferenziere` VARCHAR(20) NULL,
  `Argomento` VARCHAR(45) NULL,
  `Regista` VARCHAR(20) NULL,
  `NomeFilm` VARCHAR(20) NULL,
  PRIMARY KEY (`Chiave_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Iscritto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Iscritto` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Iscritto` (
  `Corsi_Codice` INT NOT NULL,
  `Corsi_Livelli_Nome` VARCHAR(10) NOT NULL,
  `Allievi_Nome` VARCHAR(20) NOT NULL,
  `Allievi_Recapito` VARCHAR(45) NOT NULL,
  `Data_Iscrizione` DATE NOT NULL,
  `Numero_assenze` INT NULL,
  PRIMARY KEY (`Corsi_Codice`, `Corsi_Livelli_Nome`, `Allievi_Nome`, `Allievi_Recapito`),
  CONSTRAINT `fk_Corsi_has_Allievi_Corsi1`
    FOREIGN KEY (`Corsi_Codice` , `Corsi_Livelli_Nome`)
    REFERENCES `GestioneCorsiDiLingue`.`Corsi` (`Codice` , `Livelli_Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Corsi_has_Allievi_Allievi1`
    FOREIGN KEY (`Allievi_Nome` , `Allievi_Recapito`)
    REFERENCES `GestioneCorsiDiLingue`.`Allievi` (`Nome` , `Recapito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Corsi_has_Allievi_Allievi1_idx` ON `GestioneCorsiDiLingue`.`Iscritto` (`Allievi_Nome` ASC, `Allievi_Recapito` ASC) ;

CREATE INDEX `fk_Corsi_has_Allievi_Corsi1_idx` ON `GestioneCorsiDiLingue`.`Iscritto` (`Corsi_Codice` ASC, `Corsi_Livelli_Nome` ASC) ;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Prenotazione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Prenotazione` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Prenotazione` (
  `Allievi_Nome` VARCHAR(20) NOT NULL,
  `Allievi_Recapito` VARCHAR(45) NOT NULL,
  `Attività_Culturali_Chiave_ID` INT NOT NULL,
  PRIMARY KEY (`Allievi_Nome`, `Allievi_Recapito`, `Attività_Culturali_Chiave_ID`),
  CONSTRAINT `fk_Allievi_has_Attività Culturali_Allievi1`
    FOREIGN KEY (`Allievi_Nome` , `Allievi_Recapito`)
    REFERENCES `GestioneCorsiDiLingue`.`Allievi` (`Nome` , `Recapito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Allievi_has_Attività Culturali_Attività Culturali1`
    FOREIGN KEY (`Attività_Culturali_Chiave_ID`)
    REFERENCES `GestioneCorsiDiLingue`.`Attività_Culturali` (`Chiave_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Allievi_has_Attività Culturali_Attività Culturali1_idx` ON `GestioneCorsiDiLingue`.`Prenotazione` (`Attività_Culturali_Chiave_ID` ASC) ;

CREATE INDEX `fk_Allievi_has_Attività Culturali_Allievi1_idx` ON `GestioneCorsiDiLingue`.`Prenotazione` (`Allievi_Nome` ASC, `Allievi_Recapito` ASC) ;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`HaOccupato`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`HaOccupato` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`HaOccupato` (
  `Insegnanti_Nome` VARCHAR(20) NOT NULL,
  `FasciaOraria_Data` DATE NOT NULL,
  `FasciaOraria_Ora` TIME NOT NULL,
  `Insegnanti_username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Insegnanti_Nome`, `FasciaOraria_Data`, `FasciaOraria_Ora`, `Insegnanti_username`),
  CONSTRAINT `fk_Insegnanti_has_FasciaOraria_Insegnanti1`
    FOREIGN KEY (`Insegnanti_Nome` , `Insegnanti_username`)
    REFERENCES `GestioneCorsiDiLingue`.`Insegnanti` (`Nome` , `User_Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Insegnanti_has_FasciaOraria_FasciaOraria1`
    FOREIGN KEY (`FasciaOraria_Data` , `FasciaOraria_Ora`)
    REFERENCES `GestioneCorsiDiLingue`.`FasciaOraria` (`Data` , `Ora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Insegnanti_has_FasciaOraria_FasciaOraria1_idx` ON `GestioneCorsiDiLingue`.`HaOccupato` (`FasciaOraria_Data` ASC, `FasciaOraria_Ora` ASC) ;

CREATE INDEX `fk_Insegnanti_has_FasciaOraria_Insegnanti1_idx` ON `GestioneCorsiDiLingue`.`HaOccupato` (`Insegnanti_Nome` ASC, `Insegnanti_username` ASC) ;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Frequenza`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Frequenza` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Frequenza` (
  `Allievi_Nome` VARCHAR(20) NOT NULL,
  `Allievi_Recapito` VARCHAR(45) NOT NULL,
  `Lezione_Corsi_Giorni` DATE NOT NULL,
  `Lezione_Corsi_Orario` TIME NOT NULL,
  `Lezione_Corsi_Insegnanti_Nome` VARCHAR(20) NOT NULL,
  `Lezione_Corsi_Corsi_Codice` INT NOT NULL,
  `Lezione_Corsi_Corsi_Livelli_Nome` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Allievi_Nome`, `Allievi_Recapito`, `Lezione_Corsi_Giorni`, `Lezione_Corsi_Orario`, `Lezione_Corsi_Insegnanti_Nome`, `Lezione_Corsi_Corsi_Codice`, `Lezione_Corsi_Corsi_Livelli_Nome`),
  CONSTRAINT `fk_Allievi_has_Lezione_Corsi_Allievi1`
    FOREIGN KEY (`Allievi_Nome` , `Allievi_Recapito`)
    REFERENCES `GestioneCorsiDiLingue`.`Allievi` (`Nome` , `Recapito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Allievi_has_Lezione_Corsi_Lezione_Corsi1`
    FOREIGN KEY (`Lezione_Corsi_Giorni` , `Lezione_Corsi_Orario` , `Lezione_Corsi_Insegnanti_Nome` , `Lezione_Corsi_Corsi_Codice` , `Lezione_Corsi_Corsi_Livelli_Nome`)
    REFERENCES `GestioneCorsiDiLingue`.`Lezione_Corsi` (`Giorni` , `Orario` , `Insegnanti_Nome` , `Corsi_Codice` , `Corsi_Livelli_Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Allievi_has_Lezione_Corsi_Lezione_Corsi1_idx` ON `GestioneCorsiDiLingue`.`Frequenza` (`Lezione_Corsi_Giorni` ASC, `Lezione_Corsi_Orario` ASC, `Lezione_Corsi_Insegnanti_Nome` ASC, `Lezione_Corsi_Corsi_Codice` ASC, `Lezione_Corsi_Corsi_Livelli_Nome` ASC) ;

CREATE INDEX `fk_Allievi_has_Lezione_Corsi_Allievi1_idx` ON `GestioneCorsiDiLingue`.`Frequenza` (`Allievi_Nome` ASC, `Allievi_Recapito` ASC) ;


-- -----------------------------------------------------
-- Table `GestioneCorsiDiLingue`.`Corsi_has_Insegnanti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GestioneCorsiDiLingue`.`Corsi_has_Insegnanti` ;

CREATE TABLE IF NOT EXISTS `GestioneCorsiDiLingue`.`Corsi_has_Insegnanti` (
  `Corsi_Codice` INT NOT NULL,
  `Corsi_Livelli_Nome` VARCHAR(10) NOT NULL,
  `Insegnanti_Nome` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`Corsi_Codice`, `Corsi_Livelli_Nome`, `Insegnanti_Nome`),
  CONSTRAINT `fk_Corsi_has_Insegnanti_Corsi1`
    FOREIGN KEY (`Corsi_Codice` , `Corsi_Livelli_Nome`)
    REFERENCES `GestioneCorsiDiLingue`.`Corsi` (`Codice` , `Livelli_Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Corsi_has_Insegnanti_Insegnanti1`
    FOREIGN KEY (`Insegnanti_Nome`)
    REFERENCES `GestioneCorsiDiLingue`.`Insegnanti` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Corsi_has_Insegnanti_Insegnanti1` ON `GestioneCorsiDiLingue`.`Corsi_has_Insegnanti` (`Insegnanti_Nome` ASC) ;

CREATE INDEX `fk_Corsi_has_Insegnanti_Corsi1` ON `GestioneCorsiDiLingue`.`Corsi_has_Insegnanti` (`Corsi_Codice` ASC, `Corsi_Livelli_Nome` ASC) ;

USE `GestioneCorsiDiLingue` ;

-- -----------------------------------------------------
-- procedure Assegnazione_insegnanti_a_corso
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Assegnazione_insegnanti_a_corso`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Assegnazione_insegnanti_a_corso` (In var_Corsi int, in var_livello VARCHAR(10), in var_Insegnanti varchar(20))
BEGIN
	declare exit handler for sqlexception
	BEGIN
		rollback;
        resignal;
    END;
    IF var_Insegnanti not in (Select Corsi_has_Insegnanti.Insegnanti_Nome
														FROM `Corsi_has_Insegnanti`)
						THEN
						Insert into `Corsi_has_Insegnanti` (`Corsi_Codice`, `Corsi_Livelli_Nome`, `Insegnanti_Nome`) values (var_Corsi, var_livello, var_Insegnanti);
    ELSE 
		signal sqlstate '45002' set message_text = 'Insegnante assegnato già ad un corso';
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure iscrizione_Allievo_a_corso
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`iscrizione_Allievo_a_corso`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `iscrizione_Allievo_a_corso` (IN var_nome VARCHAR(20), IN var_recapito VARCHAR(45), in var_corso int, in var_livello VARCHAR(20), in var_data DATE)
BEGIN
		declare exit handler for sqlexception
BEGIN
		rollback;
        resignal;
END;
    IF var_nome not in(Select Iscritto.Allievi_Nome 
								FROM `Iscritto`
                                WHERE 
			Iscritto.Allievi_Nome = var_nome AND Iscritto.Allievi_Recapito = var_recapito)
		THEN 
		INSERT into `Iscritto` ( `Allievi_Nome`, `Allievi_Recapito`, `Corsi_Codice`, `Corsi_Livelli_Nome`, `Data_Iscrizione` ) values (var_nome, var_recapito,var_corso, var_livello, var_data);
	else signal sqlstate '45002' set message_text = 'allievo già presente in un altro corso';
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure assegnazione_insegnante_a_lezione_privata
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`assegnazione_insegnante_a_lezione_privata`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `assegnazione_insegnante_a_lezione_privata` (in var_insegnante VARCHAR(20), in var_allievoNome VARCHAR(20), in var_allievoRecapito VARCHAR(45), in var_giorno DATE, in var_ora TIME)
BEGIN
	declare exit handler for sqlexception
	BEGIN
		rollback;
        resignal;
    END;
    IF var_insegnante not in ( Select HaOccupato.Insegnanti_Nome
														FROM `HaOccupato`
                                                        WHERE HaOccupato.Insegnanti_Nome = var_insegnante and
			HaOccupato.FasciaOraria_Data = var_giorno AND HaOccupato.FasciaOraria_Ora = var_ora)
		THEN
		insert into `Lezione_Privata` (`Giorni`, `Orario`, `FasciaOraria_Data`, `FasciaOraria_Ora`, `Allievi_Nome`, `Allievi_Recapito`, `Insegnanti_Nome`) values (var_giorno, var_ora, var_giorno, var_ora, var_allievoNome, var_allievoRecapito, var_Insegnante);
    ELSE
		signal sqlstate '45002' set message_text = 'Insegnante non disponibile in questa fascia oraria';
        end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Inserimento_degli_allievi_presenti_ad_ogni_Lezione
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Inserimento_degli_allievi_presenti_ad_ogni_Lezione`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Inserimento_degli_allievi_presenti_ad_ogni_Lezione` (in var_nome VARCHAR(20), in var_Recapito VARCHAR(45), in var_giorno DATE, in var_ora TIME,in var_corso INT, in var_Insegnante VARCHAR(20), IN var_Livello varchar(10))
BEGIN
	insert into Frequenza values (var_giorno, var_ora, var_nome, var_Recapito, var_corso, var_Insegnante, var_Livello);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure prenotazione_allievo_ad_un_attivita_culturale
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`prenotazione_allievo_ad_un_attivita_culturale`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `prenotazione_allievo_ad_un_attivita_culturale` (in var_nome VARCHAR(20), in var_recapito VARCHAR(45), in var_attivita INT)
BEGIN
	#select `Allievi.Nome`, `Allievi.Recapito`, `Attività Culturali.Chiave_ID` from `Allievi` join `Attività_Culturali` on 
	INSERT into Prenotazione values ( var_nome, var_recapito, var_attivita);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Creazione_corso
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Creazione_corso`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Creazione_corso` ( in var_corso INT, in var_data DATE, in var_libro VARCHAR(50), in var_esame VARCHAR(16), in var_livello VARCHAR(45))
BEGIN
	declare exit handler for sqlexception
BEGIN
		rollback;
        resignal;
END;	
    IF var_corso not in(Select Corsi.Codice
										FROM `Corsi`
                                        WHERE
	Corsi.Codice = var_corso)
    THEN 
    Insert into `Corsi` ( `Codice`, `Data_attivazione`, `Libro`, `Esame`, `Livelli_nome`) values (var_corso, var_data, var_libro, var_esame, var_livello);
    ELSE 
    signal sqlstate '45002' set message_text = 'Corso già presente';
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Controllo_assenze_studente
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Controllo_assenze_studente`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Controllo_assenze_studente` ( in var_nome VARCHAR(20), in var_recapito VARCHAR(45), in var_giorno DATE, in var_corso INT, out var_allievo_assente VARCHAR(20))
BEGIN
	declare exit handler for sqlexception
	BEGIN
		rollback;
        resignal;
    END;
    start transaction;
    IF var_giorno in (Select Lezione_Corsi.Giorni
													FROM `Lezione_Corsi`
                                                    WHERE
	Lezione_Corsi.Giorni = var_giorno AND Lezione_Corsi.Corsi_Codice = var_corso)
    THEN
			IF var_nome not in (Select Lezione_Corsi.Allievi_Nome
														FROM `Frequenza`
														WHERE
					Lezione_Corsi.Allievi_Nome = var_nome AND Lezione_Corsi.Allievi_Recapito = var_recapito and Frequenza.Lezione_Corsi_Giorni = var_giorno and Frequenza.Lezione_Corsi_Corsi_Codice = var_corso) 
					THEN
					set var_allievo_assente = var_nome;
			ELSE 
				signal sqlstate '45002' set message_text = 'Allievo presente alla lezione';
				end if;
		ELSE 
				signal sqlstate '45002' set message_text = 'Non esiste una lezione di questo corso nel giorno selezionato';
                end if;
                commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Generare_report_Insegnante_Mensile
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Generare_report_Insegnante_Mensile`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Generare_report_Insegnante_Mensile` (in var_insegnante VARCHAR(20))
BEGIN
        drop temporary table if exists `Report Mensile Insegnante`;
        create temporary table `Report Mensile Insegnate`(`Insegnante` VARCHAR(20),`Nome livello corso`VARCHAR(20),`Lezione Corso Giorno` DATE,`Lezione Corso Ora` TIME, `Lezione Privata Giorno` DATE, `Lezione Privata Ora` TIME);
        insert into `Report Mensile Insegnante`
        SELECT Insegnante.Nome, Lezione_Corsi.Corsi_Livelli_Nome, Lezione_Corsi.Giorni, Lezione_Corsi.Orario, Lezione_Privata.Giorni, Lezione_Privata.Orario
        From `Insegnante`
        JOIN Lezione_Corsi on (Insegnante.Nome = Lezione_Corsi.Insegnanti_Nome) JOIN Lezione_Privata on (Insegnante.Nome = Lezione_Privata.Insegnanti.Nome)
        WHERE Insegnante.Nome = var_insegnante and Lezione_Corsi.Giorni < var_giorno and Lezione_Corsi.Giorni > var_giorno - 31 and Lezione_Privata.Giorni < var_giorno and Lezione_Privata.Giorni > var_giorno - 31;
        drop temporary table `Report Mensile Insegnante`;
        commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Creazione_attivita_culturale
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Creazione_attivita_culturale`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Creazione_attivita_culturale` (in var_chiave INT, in var_Tipologia VARCHAR(10), in var_conferenziere VARCHAR(20), in var_argomento VARCHAR(45), in var_regista VARCHAR(20), in var_NomeFilm VARCHAR(20))
BEGIN
		declare exit handler for sqlexception
BEGIN
		rollback;
        resignal;
END;
        IF var_Tipologia = 'Conferenza' then 
        insert into `Attività_Culturali` (`Chiave_ID`, `Tipologia`, `Conferenziere`, `Argomento`) values (var_chiave, var_Tipologia, var_conferenziere, var_argomento);
        elseif
		var_Tipologia = 'Film'
        then insert into `Attività_Culturali` (`Chiave_ID`, `Tipologia`,`Regista`, `NomeFilm`) values (var_chiave, var_Tipologia, var_regista, var_NomeFilm);
        else
        signal sqlstate '45002' set message_text = 'Attività non supportata';
        end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Login
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Login`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Login` (in var_username varchar(45), in var_password varchar(45), out var_role INT)
BEGIN
		declare var_user_role ENUM('Amministrazione', 'Segreteria', 'Insegnante', 'Allievo');
        select `Ruolo`
		from `User`
		where `Username` = var_username
		and `Password` = md5(var_password)
		into var_user_role;
		if var_user_role = 'Amministrazione' then 
				set var_role = 1;
		elseif var_user_role = 'Segreteria' then 
				set var_role = 2;
		elseif var_user_role = 'Insegnante' then
				set var_role = 3;
		elseif var_user_role = 'Allievo' then 
				set var_role = 4;
		else set var_role = 5;
        end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Aggiunta_Allievo
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Aggiunta_Allievo`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Aggiunta_Allievo` (in var_Nome VARCHAR(20), in var_Recapito VARCHAR(45), in var_Username VARCHAR(45))
BEGIN
	declare exit handler for sqlexception
	BEGIN
		rollback;
        resignal;
    END;
    if var_Username not in (select `User_Username` from `Allievi` where var_Username = `User_Username`) then
    INSERT into `Allievi` (`Nome`, `Recapito`,`User_Username`) values (var_Nome, var_Recapito, var_Username);
    else
		signal sqlstate '45002' set message_text = 'Allievo presente o username usato per un altro allievo';
	end if;
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Aggiunta_Insegnante
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Aggiunta_Insegnante`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Aggiunta_Insegnante` (in var_Insegnante VARCHAR(20), in var_username VARCHAR(20), in var_indirizzo VARCHAR(45), in var_nazione VARCHAR(20))
BEGIN
    INSERT into `Insegnanti` (`Nome`, `User_Username`,`Indirizzo`, `Nazione` ) values (var_Insegnante, var_username, var_indirizzo, var_nazione);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Elimina_Corso
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Elimina_Corso`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Elimina_Corso` (in var_Corso INT)
BEGIN
    DELETE FROM `Corsi` Where Corsi.Codice = var_Corso; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Elimina_Allievo
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Elimina_Allievo`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Elimina_Allievo` (in var_Nome VARCHAR(20), in var_Recapito VARCHAR(45))
BEGIN
    DELETE FROM `Allievi` Where Allievi.Nome = var_Nome && `Allievi.Recapito` = var_Recapito; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Elimina_Insegnante
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Elimina_Insegnante`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Elimina_Insegnante` (in var_Nome VARCHAR(20))
BEGIN
    DELETE FROM `Insegnanti` Where Insegnanti.Nome = var_Nome; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Elimina_Tutti_Allievi
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Elimina_Tutti_Allievi`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Elimina_Tutti_Allievi` ()
BEGIN
    DELETE FROM `Allievi`; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Report_agenda_settimanale
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Report_agenda_settimanale`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Report_agenda_settimanale` (in var_Nome VARCHAR(20), in var_giorno DATE)
BEGIN
        drop temporary table if exists `Report Agenda`;
        create temporary table `Report Agenda`(`Insegnante` VARCHAR(20),`Nome livello corso`VARCHAR(20),`Lezione Corso Giorno` DATE,`Lezione Corso Ora` TIME, `Lezione Privata Giorno` DATE, `Lezione Privata Ora` TIME);
        insert into `Report Agenda`
        SELECT Insegnante.Nome, Lezione_Corsi.Corsi_Livelli_Nome, Lezione_Corsi.Giorni, Lezione_Corsi.Orario, Lezione_Privata.Giorni, Lezione_Privata.Orario
        From `Insegnante`
        JOIN Lezione_Corsi on (Insegnante.Nome = Lezione_Corsi.Insegnanti_Nome) JOIN Lezione_Privata on (Insegnante.Nome = Lezione_Privata.Insegnanti.Nome)
        WHERE Insegnante.Nome = var_insegnante and Lezione_Corsi.Giorni = var_giorno + 7 and Lezione_Privata.Giorni = var_giorno + 7;
        drop temporary table `Report Agenda`;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Inserisci_Utente
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`Inserisci_Utente`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `Inserisci_Utente` (in var_username VARCHAR(20), in var_password VARCHAR(20), in var_role VARCHAR(20))
BEGIN
	insert into User values(var_username, md5(var_password), var_role);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_Insegnanti_assegnati_a_corsi
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`visualizza_Insegnanti_assegnati_a_corsi`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `visualizza_Insegnanti_assegnati_a_corsi` (in var_Nome VARCHAR(45), out var_corso INT)
BEGIN
	set transaction read only;
    set transaction isolation level read committed;
    select Corsi_has_Insegnanti.Corsi_Codice from `Corsi_has_Insegnanti` where var_Nome = Corsi_has_Insegnanti.Insegnanti_Nome;
    set var_corso = Corsi_has_Insegnanti.Corsi_Codice;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_corsi_assegnati_a_insegnanti
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`visualizza_corsi_assegnati_a_insegnanti`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `visualizza_corsi_assegnati_a_insegnanti` (in var_Corso INT, out var_insegnante VARCHAR(45))
BEGIN
	set transaction read only;
    set transaction isolation level read committed;
    select Corsi_has_Insegnanti.Insegnanti_Nome from `Corsi_has_Insegnanti` where var_Corso = Corsi_has_Insegnanti.Corsi_Codice;
    set var_insegnante = Corsi_has_Insegnanti.Insegnanti_Nome;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_lezione
-- -----------------------------------------------------

USE `GestioneCorsiDiLingue`;
DROP procedure IF EXISTS `GestioneCorsiDiLingue`.`inserisci_lezione`;

DELIMITER $$
USE `GestioneCorsiDiLingue`$$
CREATE PROCEDURE `inserisci_lezione` (in var_giorno DATE, in var_ora TIME, in var_insegnante VARCHAR(20), in var_corso INT, in var_livello VARCHAR(10), in var_username VARCHAR(45))
BEGIN
	insert into FasciaOraria values (var_giorno, var_ora);
    #insert into HaOccupato values (var_insegnante, var_giorno, var_ora, var_username);
	insert into Lezione_Corsi values (var_giorno, var_ora, var_insegnante, var_corso, var_livello, var_giorno, var_ora, var_username);
END$$

DELIMITER ;
SET SQL_MODE = '';
DROP USER  Amministrazione;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Amministrazione' IDENTIFIED BY 'amministrazione';

GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Generare_report_Insegnante_Mensile` TO 'Amministrazione';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Elimina_Corso` TO 'Amministrazione';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Aggiunta_Insegnante` TO 'Amministrazione';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Elimina_Insegnante` TO 'Amministrazione';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Creazione_corso` TO 'Amministrazione';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Assegnazione_insegnanti_a_corso` TO 'Amministrazione';
SET SQL_MODE = '';
DROP USER  Segreteria;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Segreteria' IDENTIFIED BY 'segreteria';

GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`iscrizione_Allievo_a_corso` TO 'Segreteria';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Elimina_Tutti_Allievi` TO 'Segreteria';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Elimina_Allievo` TO 'Segreteria';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Aggiunta_Allievo` TO 'Segreteria';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Creazione_attivita_culturale` TO 'Segreteria';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`assegnazione_insegnante_a_lezione_privata` TO 'Segreteria';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Inserisci_Utente` TO 'Segreteria';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Controllo_assenze_studente` TO 'Segreteria';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`visualizza_Insegnanti_assegnati_a_corsi` TO 'Segreteria';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`visualizza_corsi_assegnati_a_insegnanti` TO 'Segreteria';
SET SQL_MODE = '';
DROP USER  Insegnante;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Insegnante' IDENTIFIED BY 'insegnante';

GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Inserimento_degli_allievi_presenti_ad_ogni_Lezione` TO 'Insegnante';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Report_agenda_settimanale` TO 'Insegnante';
GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`inserisci_lezione` TO 'Insegnante';
SET SQL_MODE = '';
DROP USER  Allievo;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Allievo' IDENTIFIED BY 'allievo';

GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`prenotazione_allievo_ad_un_attivita_culturale` TO 'Allievo';
SET SQL_MODE = '';
DROP USER Login;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Login' IDENTIFIED BY 'login';

GRANT EXECUTE ON procedure `GestioneCorsiDiLingue`.`Login` TO 'Login';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `GestioneCorsiDiLingue`.`Livelli`
-- -----------------------------------------------------
START TRANSACTION;
USE `GestioneCorsiDiLingue`;
INSERT INTO `GestioneCorsiDiLingue`.`Livelli` (`Nome`) VALUES ('A1');
INSERT INTO `GestioneCorsiDiLingue`.`Livelli` (`Nome`) VALUES ('A2');
INSERT INTO `GestioneCorsiDiLingue`.`Livelli` (`Nome`) VALUES ('B1');
INSERT INTO `GestioneCorsiDiLingue`.`Livelli` (`Nome`) VALUES ('B2');
INSERT INTO `GestioneCorsiDiLingue`.`Livelli` (`Nome`) VALUES ('C1');
INSERT INTO `GestioneCorsiDiLingue`.`Livelli` (`Nome`) VALUES ('C2');

COMMIT;


-- -----------------------------------------------------
-- Data for table `GestioneCorsiDiLingue`.`Corsi`
-- -----------------------------------------------------
START TRANSACTION;
USE `GestioneCorsiDiLingue`;
INSERT INTO `GestioneCorsiDiLingue`.`Corsi` (`Codice`, `Data_attivazione`, `Libro`, `Esame`, `Livelli_Nome`) VALUES (01, '2021-02-07', 'Libro inglese 1', 'Scritto', 'A1');

COMMIT;


-- -----------------------------------------------------
-- Data for table `GestioneCorsiDiLingue`.`User`
-- -----------------------------------------------------
START TRANSACTION;
USE `GestioneCorsiDiLingue`;
INSERT INTO `GestioneCorsiDiLingue`.`User` (`Username`, `Password`, `Ruolo`) VALUES ('aledifi', '81dc9bdb52d04dc20036dbd8313ed055', 'Amministrazione');
INSERT INTO `GestioneCorsiDiLingue`.`User` (`Username`, `Password`, `Ruolo`) VALUES ('alessandro', '81dc9bdb52d04dc20036dbd8313ed055', 'Segreteria');
INSERT INTO `GestioneCorsiDiLingue`.`User` (`Username`, `Password`, `Ruolo`) VALUES ('sandro', '81dc9bdb52d04dc20036dbd8313ed055', 'Insegnante');
INSERT INTO `GestioneCorsiDiLingue`.`User` (`Username`, `Password`, `Ruolo`) VALUES ('ale', '81dc9bdb52d04dc20036dbd8313ed055', 'Allievo');
INSERT INTO `GestioneCorsiDiLingue`.`User` (`Username`, `Password`, `Ruolo`) VALUES ('di filippo', '81dc9bdb52d04dc20036dbd8313ed055', 'Allievo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `GestioneCorsiDiLingue`.`Insegnanti`
-- -----------------------------------------------------
START TRANSACTION;
USE `GestioneCorsiDiLingue`;
INSERT INTO `GestioneCorsiDiLingue`.`Insegnanti` (`Nome`, `Indirizzo`, `Nazione`, `User_Username`) VALUES ('sandro', 'Via Udine', 'Italia', 'sandro');

COMMIT;


-- -----------------------------------------------------
-- Data for table `GestioneCorsiDiLingue`.`Allievi`
-- -----------------------------------------------------
START TRANSACTION;
USE `GestioneCorsiDiLingue`;
INSERT INTO `GestioneCorsiDiLingue`.`Allievi` (`Nome`, `Recapito`, `Data_assenze`, `User_Username`) VALUES ('di filippo', 'via milano', '2021-02-07', 'di filippo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `GestioneCorsiDiLingue`.`FasciaOraria`
-- -----------------------------------------------------
START TRANSACTION;
USE `GestioneCorsiDiLingue`;
INSERT INTO `GestioneCorsiDiLingue`.`FasciaOraria` (`Data`, `Ora`) VALUES ('2021-02-08', '09:30:00');
INSERT INTO `GestioneCorsiDiLingue`.`FasciaOraria` (`Data`, `Ora`) VALUES ('2021-02-07', '11:30:00');
INSERT INTO `GestioneCorsiDiLingue`.`FasciaOraria` (`Data`, `Ora`) VALUES ('2021-02-08', '11:30:00');
INSERT INTO `GestioneCorsiDiLingue`.`FasciaOraria` (`Data`, `Ora`) VALUES ('2021-02-07', '15:30:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `GestioneCorsiDiLingue`.`Attività_Culturali`
-- -----------------------------------------------------
START TRANSACTION;
USE `GestioneCorsiDiLingue`;
INSERT INTO `GestioneCorsiDiLingue`.`Attività_Culturali` (`Chiave_ID`, `Tipologia`, `Conferenziere`, `Argomento`, `Regista`, `NomeFilm`) VALUES (1, 'Conferenza', 'Tizio', 'Inglese', NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `GestioneCorsiDiLingue`.`Corsi_has_Insegnanti`
-- -----------------------------------------------------
START TRANSACTION;
USE `GestioneCorsiDiLingue`;
INSERT INTO `GestioneCorsiDiLingue`.`Corsi_has_Insegnanti` (`Corsi_Codice`, `Corsi_Livelli_Nome`, `Insegnanti_Nome`) VALUES (1, 'A1', 'sandro');

COMMIT;

