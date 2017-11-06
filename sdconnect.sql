-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema sdconnectdb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `sdconnectdb` ;

-- -----------------------------------------------------
-- Schema sdconnectdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sdconnectdb` DEFAULT CHARACTER SET utf8 ;
USE `sdconnectdb` ;

-- -----------------------------------------------------
-- Table `user_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user_type` ;

CREATE TABLE IF NOT EXISTS `user_type` (
  `id` INT NOT NULL,
  `type` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `type_UNIQUE` (`type` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cohort`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cohort` ;

CREATE TABLE IF NOT EXISTS `cohort` (
  `id` INT NOT NULL,
  `name` VARCHAR(80) NOT NULL,
  `start_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `end_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `cohort_num` INT NOT NULL,
  `mascot_img_url` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  UNIQUE INDEX `cohort_num_UNIQUE` (`cohort_num` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

CREATE TABLE IF NOT EXISTS `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `user_type_id` INT NOT NULL DEFAULT 2,
  `cohort_id` INT NOT NULL,
  `active` VARCHAR(45) NOT NULL DEFAULT 'on',
  PRIMARY KEY (`id`),
  INDEX `fk_user_cohort1_idx` (`cohort_id` ASC),
  INDEX `fk_user_user_type_idx` (`user_type_id` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  CONSTRAINT `fk_user_user_type`
    FOREIGN KEY (`user_type_id`)
    REFERENCES `user_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_cohort1`
    FOREIGN KEY (`cohort_id`)
    REFERENCES `cohort` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `form`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `form` ;

CREATE TABLE IF NOT EXISTS `form` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `has_forms`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `has_forms` ;

CREATE TABLE IF NOT EXISTS `has_forms` (
  `form_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`form_id`, `user_id`),
  INDEX `fk_has_forms_forms1_idx` (`form_id` ASC),
  INDEX `fk_has_forms_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_has_forms_forms1`
    FOREIGN KEY (`form_id`)
    REFERENCES `form` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_has_forms_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tag` ;

CREATE TABLE IF NOT EXISTS `tag` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `type_UNIQUE` (`type` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `topic`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `topic` ;

CREATE TABLE IF NOT EXISTS `topic` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(400) NOT NULL,
  `tag_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_topic_tag1_idx` (`tag_id` ASC),
  CONSTRAINT `fk_topic_tag1`
    FOREIGN KEY (`tag_id`)
    REFERENCES `tag` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `post`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `post` ;

CREATE TABLE IF NOT EXISTS `post` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `message` VARCHAR(5000) NULL,
  `post_ts` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date time, but don’t want to name it that to mess up the sql statements',
  `user_id` INT NOT NULL,
  `topic_id` INT NOT NULL,
  `link` VARCHAR(500) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_post_user1_idx` (`user_id` ASC),
  INDEX `fk_post_thread1_idx` (`topic_id` ASC),
  CONSTRAINT `fk_post_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_thread1`
    FOREIGN KEY (`topic_id`)
    REFERENCES `topic` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `project`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `project` ;

CREATE TABLE IF NOT EXISTS `project` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(85) NOT NULL,
  `description` VARCHAR(500) NULL,
  `estimated_hours` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profile`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profile` ;

CREATE TABLE IF NOT EXISTS `profile` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `img_url` VARCHAR(500) NULL DEFAULT 'img/profilePictures/profile.png',
  `background_desc` VARCHAR(5000) NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `prev_industry` VARCHAR(45) NULL,
  `coding_exp` VARCHAR(45) NULL,
  `shirt_size` VARCHAR(2) NULL,
  `user_id` INT NOT NULL,
  `website_url` VARCHAR(500) NULL,
  `github_url` VARCHAR(500) NULL,
  `linkedin_url` VARCHAR(500) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_profile_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_profile_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `career_resources`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `career_resources` ;

CREATE TABLE IF NOT EXISTS `career_resources` (
  `id` INT NOT NULL,
  `type` VARCHAR(45) NULL,
  `upload_id` VARCHAR(45) NULL,
  `link` VARCHAR(45) NULL COMMENT 'now will this be a link or an actual document?\nOr should we have a column for both?…\nuser wants to post a doc from a link or just straight upload it',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `event` ;

CREATE TABLE IF NOT EXISTS `event` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(85) NOT NULL DEFAULT 'No name',
  `description` VARCHAR(500) NULL,
  `date` DATETIME NULL,
  `public` VARCHAR(45) NULL,
  `projects_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_event_projects1_idx` (`projects_id` ASC),
  CONSTRAINT `fk_event_projects1`
    FOREIGN KEY (`projects_id`)
    REFERENCES `project` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cohort_has_event`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cohort_has_event` ;

CREATE TABLE IF NOT EXISTS `cohort_has_event` (
  `cohort_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`cohort_id`, `event_id`),
  INDEX `fk_cohort_has_event_event1_idx` (`event_id` ASC),
  INDEX `fk_cohort_has_event_cohort1_idx` (`cohort_id` ASC),
  CONSTRAINT `fk_cohort_has_event_cohort1`
    FOREIGN KEY (`cohort_id`)
    REFERENCES `cohort` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cohort_has_event_event1`
    FOREIGN KEY (`event_id`)
    REFERENCES `event` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE = '';
GRANT USAGE ON *.* TO sdconnector;
 DROP USER sdconnector;
SET SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
CREATE USER 'sdconnector' IDENTIFIED BY 'root';

GRANT ALL ON * TO 'sdconnector';
SET SQL_MODE = '';
GRANT USAGE ON *.* TO guest;
 DROP USER guest;
SET SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
CREATE USER 'guest' IDENTIFIED BY 'guest';

GRANT SELECT ON TABLE * TO 'guest';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `user_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `sdconnectdb`;
INSERT INTO `user_type` (`id`, `type`) VALUES (1, 'admin');
INSERT INTO `user_type` (`id`, `type`) VALUES (2, 'student');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cohort`
-- -----------------------------------------------------
START TRANSACTION;
USE `sdconnectdb`;
INSERT INTO `cohort` (`id`, `name`, `start_date`, `end_date`, `cohort_num`, `mascot_img_url`) VALUES (1, 'Lions', '2017-07-31', '2017-11-21', 12, NULL);
INSERT INTO `cohort` (`id`, `name`, `start_date`, `end_date`, `cohort_num`, `mascot_img_url`) VALUES (2, 'Manatees', '2017-10-01', '2017-12-23', 13, NULL);
INSERT INTO `cohort` (`id`, `name`, `start_date`, `end_date`, `cohort_num`, `mascot_img_url`) VALUES (3, 'Neanderthals', '2018-10-01', '2018-12-23', 14, NULL);
INSERT INTO `cohort` (`id`, `name`, `start_date`, `end_date`, `cohort_num`, `mascot_img_url`) VALUES (4, 'Octothorpes', '2019-10-01', '2019-12-23', 15, NULL);
INSERT INTO `cohort` (`id`, `name`, `start_date`, `end_date`, `cohort_num`, `mascot_img_url`) VALUES (5, 'Pomeranians', '2020-10-01', '2020-12-23', 16, NULL);
INSERT INTO `cohort` (`id`, `name`, `start_date`, `end_date`, `cohort_num`, `mascot_img_url`) VALUES (6, 'Quails', '2021-10-01', '2021-12-23', 17, NULL);
INSERT INTO `cohort` (`id`, `name`, `start_date`, `end_date`, `cohort_num`, `mascot_img_url`) VALUES (7, 'Raccoons', '2022-10-01', '2022-12-23', 18, NULL);
INSERT INTO `cohort` (`id`, `name`, `start_date`, `end_date`, `cohort_num`, `mascot_img_url`) VALUES (8, 'Sharks', '2023-10-01', '2023-12-23', 19, NULL);
INSERT INTO `cohort` (`id`, `name`, `start_date`, `end_date`, `cohort_num`, `mascot_img_url`) VALUES (9, 'Tigers', '2024-10-01', '2024-12-23', 20, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `user`
-- -----------------------------------------------------
START TRANSACTION;
USE `sdconnectdb`;
INSERT INTO `user` (`id`, `email`, `password`, `user_type_id`, `cohort_id`, `active`) VALUES (1, 'chrishbianchi@gmail.com', '$2a$10$CZ13mvoyPnO4nHjq82p.7.rWh0uizvHhk79domk8Lk06OtJGsjury', 1, 1, 'on');
INSERT INTO `user` (`id`, `email`, `password`, `user_type_id`, `cohort_id`, `active`) VALUES (2, 'jmckenna@gmail.com', '$2a$10$CZ13mvoyPnO4nHjq82p.7.rWh0uizvHhk79domk8Lk06OtJGsjury', 2, 1, 'on');
INSERT INTO `user` (`id`, `email`, `password`, `user_type_id`, `cohort_id`, `active`) VALUES (3, 'kkane@gmail.com', '$2a$10$CZ13mvoyPnO4nHjq82p.7.rWh0uizvHhk79domk8Lk06OtJGsjury', 1, 1, 'on');
INSERT INTO `user` (`id`, `email`, `password`, `user_type_id`, `cohort_id`, `active`) VALUES (4, 'mpentermann@gmail.com', '$2a$10$CZ13mvoyPnO4nHjq82p.7.rWh0uizvHhk79domk8Lk06OtJGsjury', 2, 1, 'on');
INSERT INTO `user` (`id`, `email`, `password`, `user_type_id`, `cohort_id`, `active`) VALUES (5, 'sryzek@gmail.com', '$2a$10$CZ13mvoyPnO4nHjq82p.7.rWh0uizvHhk79domk8Lk06OtJGsjury', 2, 1, 'on');

COMMIT;


-- -----------------------------------------------------
-- Data for table `tag`
-- -----------------------------------------------------
START TRANSACTION;
USE `sdconnectdb`;
INSERT INTO `tag` (`id`, `type`) VALUES (1, 'Roommate');
INSERT INTO `tag` (`id`, `type`) VALUES (2, 'Weekend');
INSERT INTO `tag` (`id`, `type`) VALUES (3, 'Resume');
INSERT INTO `tag` (`id`, `type`) VALUES (4, 'CoverLetter');
INSERT INTO `tag` (`id`, `type`) VALUES (5, 'Interview');

COMMIT;


-- -----------------------------------------------------
-- Data for table `topic`
-- -----------------------------------------------------
START TRANSACTION;
USE `sdconnectdb`;
INSERT INTO `topic` (`id`, `name`, `tag_id`) VALUES (1, 'Searching for roommate.', 1);
INSERT INTO `topic` (`id`, `name`, `tag_id`) VALUES (2, 'Here\'s my resume.', 3);
INSERT INTO `topic` (`id`, `name`, `tag_id`) VALUES (3, 'Interview at Google. Look at some interview questions!', 4);
INSERT INTO `topic` (`id`, `name`, `tag_id`) VALUES (4, 'Cover Letter yes or no? Thoughts?', 5);
INSERT INTO `topic` (`id`, `name`, `tag_id`) VALUES (5, 'Skill Disitllery BBQ this weekend?', 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `post`
-- -----------------------------------------------------
START TRANSACTION;
USE `sdconnectdb`;
INSERT INTO `post` (`id`, `message`, `post_ts`, `user_id`, `topic_id`, `link`) VALUES (1, 'Hi Everyone. Searching for a roommate in SD 12. I\'m coming from California and would like to share rent with someone.', DEFAULT, 1, 1, NULL);
INSERT INTO `post` (`id`, `message`, `post_ts`, `user_id`, `topic_id`, `link`) VALUES (2, 'What\'s up Mr. Bianchi! I\'m an instructor here at SD and have a room available if you\'re interested. Contact me via email at kkris@gmail.com.', DEFAULT, 3, 1, NULL);
INSERT INTO `post` (`id`, `message`, `post_ts`, `user_id`, `topic_id`, `link`) VALUES (3, 'Interested in an entry-level full stack development position at Amazon. Would love to hear your thoughts.', DEFAULT, 2, 2, 'www.google.com');
INSERT INTO `post` (`id`, `message`, `post_ts`, `user_id`, `topic_id`, `link`) VALUES (4, 'Hi Jacqualine, the resume looks great. I would highlight most applicable work experience.', DEFAULT, 1, 2, NULL);
INSERT INTO `post` (`id`, `message`, `post_ts`, `user_id`, `topic_id`, `link`) VALUES (5, 'Thank you! I\'ll put in those changes. Wish me luck.', DEFAULT, 2, 2, NULL);
INSERT INTO `post` (`id`, `message`, `post_ts`, `user_id`, `topic_id`, `link`) VALUES (6, 'Just completed my Google superday. Notable questions: What is OOP? What is the benefit of using an MVC framework? How many ping pong balls could you fit in an entire 747 boeing jet?', DEFAULT, 3, 3, NULL);
INSERT INTO `post` (`id`, `message`, `post_ts`, `user_id`, `topic_id`, `link`) VALUES (7, 'Thanks Kris. I know what I\'m going to go study now. Hope it went well.', DEFAULT, 2, 3, NULL);
INSERT INTO `post` (`id`, `message`, `post_ts`, `user_id`, `topic_id`, `link`) VALUES (8, 'Just finished my Cover Letter. Would love to hear what you all think. The more feedback the better!', DEFAULT, 1, 4, 'www.google.com');
INSERT INTO `post` (`id`, `message`, `post_ts`, `user_id`, `topic_id`, `link`) VALUES (9, 'Put the name of somebody who referred you in the first sentence. If nobody referred you, do some LinkedIn research to find mutual connections and mention one of them. A warm introduction is likely to elicit response.', DEFAULT, 2, 4, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `project`
-- -----------------------------------------------------
START TRANSACTION;
USE `sdconnectdb`;
INSERT INTO `project` (`id`, `name`, `description`, `estimated_hours`) VALUES (1, 'JSCalculator', 'Individual Project', 6);
INSERT INTO `project` (`id`, `name`, `description`, `estimated_hours`) VALUES (2, 'MVCCRUD Project Pt. 1', 'Individual Project', 12);
INSERT INTO `project` (`id`, `name`, `description`, `estimated_hours`) VALUES (3, 'Jets', 'Individual Project', 10);
INSERT INTO `project` (`id`, `name`, `description`, `estimated_hours`) VALUES (4, 'Angular Event Tracker', 'Individual Project', 4);
INSERT INTO `project` (`id`, `name`, `description`, `estimated_hours`) VALUES (5, 'US President\'s Project', 'Team Project', 8);

COMMIT;


-- -----------------------------------------------------
-- Data for table `profile`
-- -----------------------------------------------------
START TRANSACTION;
USE `sdconnectdb`;
INSERT INTO `profile` (`id`, `img_url`, `background_desc`, `first_name`, `last_name`, `prev_industry`, `coding_exp`, `shirt_size`, `user_id`, `website_url`, `github_url`, `linkedin_url`) VALUES (1, 'img/profilePictures/ChrisBProfileImage.jpg', 'Software solutions architect for B2Bi commerce.', 'Christopher', 'Bianchi', 'Business Commerce', '2 years', 'L', 1, NULL, NULL, NULL);
INSERT INTO `profile` (`id`, `img_url`, `background_desc`, `first_name`, `last_name`, `prev_industry`, `coding_exp`, `shirt_size`, `user_id`, `website_url`, `github_url`, `linkedin_url`) VALUES (2, 'img/profilePictures/JacqualineProfileImage.jpg', '8 years in the military.', 'Jacqualine', 'McKenna', 'Intelligence', '1 year', 'S', 2, NULL, NULL, NULL);
INSERT INTO `profile` (`id`, `img_url`, `background_desc`, `first_name`, `last_name`, `prev_industry`, `coding_exp`, `shirt_size`, `user_id`, `website_url`, `github_url`, `linkedin_url`) VALUES (3, 'img/profilePictures/KrisProfileImage.jpg', 'Extensive history in projects implementing variety of technologies', 'Kris', 'Kane', 'Application Development', '21 years', 'XL', 3, NULL, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `event`
-- -----------------------------------------------------
START TRANSACTION;
USE `sdconnectdb`;
INSERT INTO `event` (`id`, `name`, `description`, `date`, `public`, `projects_id`) VALUES (1, 'Dave and Buster\'s Extravaganza', 'Have a ball on the company dime. Free games for all!', '2017-11-13', 'YES', NULL);
INSERT INTO `event` (`id`, `name`, `description`, `date`, `public`, `projects_id`) VALUES (2, 'Check in on Cole\'s Work', 'See if Cole is actually doing any work.', '2017-11-03', 'YES', NULL);
INSERT INTO `event` (`id`, `name`, `description`, `date`, `public`, `projects_id`) VALUES (3, 'MVCCRUD Project Pt. 1', 'Do your MVCCRUD Project part 1. Due at end of weekend.', '2017-11-01', 'NO', 2);
INSERT INTO `event` (`id`, `name`, `description`, `date`, `public`, `projects_id`) VALUES (4, 'JSCalculator', 'Build your calculator using jQuery. Due at end of weekend.', '2017-11-10', 'NO', 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `cohort_has_event`
-- -----------------------------------------------------
START TRANSACTION;
USE `sdconnectdb`;
INSERT INTO `cohort_has_event` (`cohort_id`, `event_id`) VALUES (1, 1);
INSERT INTO `cohort_has_event` (`cohort_id`, `event_id`) VALUES (1, 2);
INSERT INTO `cohort_has_event` (`cohort_id`, `event_id`) VALUES (1, 3);
INSERT INTO `cohort_has_event` (`cohort_id`, `event_id`) VALUES (2, 1);

COMMIT;

