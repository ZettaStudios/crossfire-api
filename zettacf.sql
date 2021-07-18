CREATE SCHEMA IF NOT EXISTS `zettacf` DEFAULT CHARACTER SET utf8 ;
USE `zettacf` ;

-- -----------------------------------------------------
-- Table `zettacf`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `zettacf`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(13) NOT NULL,
  `password` TEXT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `type` INT NULL DEFAULT 0,
  `name` VARCHAR(16) NOT NULL,
  `exp` INT NULL DEFAULT 0,
  `level` INT NULL DEFAULT 0,
  `gp` INT NULL DEFAULT 1000000,
  `zp` INT NULL DEFAULT 1000000,
  `tutorial_done` INT NULL DEFAULT 0,
  `coupons_owned` INT NULL DEFAULT 0,
  `lastip` TEXT NULL,
  `lastguid` TEXT NULL,
  `kills` INT NULL DEFAULT 0,
  `deaths` INT NULL DEFAULT 0,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `zettacf`.`server`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `zettacf`.`servers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(16) NOT NULL,
  `type` INT NOT NULL,
  `address` TEXT NOT NULL,
  `port` INT NOT NULL,
  `limit` INT NULL DEFAULT 300,
  `nolimit` INT NULL DEFAULT 1,
  `minrank` INT NULL DEFAULT 0,
  `maxrank` INT NULL DEFAULT 100,
  `players` INT NULL DEFAULT 0,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `zettacf`.`battle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `zettacf`.`battles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `gamemode` INT NOT NULL,
  `map` SMALLINT(6) NOT NULL,
  `won` INT NOT NULL,
  `assists` INT NOT NULL,
  `desertion` INT NOT NULL,
  `granade` INT NOT NULL,
  `headshot` INT NOT NULL,
  `knife` INT NOT NULL,
  `totaldeaths` INT NOT NULL,
  `totalkills` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`, `user_id`),
  INDEX `fk_battle_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_battle_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `zettacf`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `zettacf`.`inventory`
-- -----------------------------------------------------
create table `zettacf`.`inventories`
(
	user_id int not null,
	id int not null AUTO_INCREMENT,
	type VARCHAR(1) not null,
	code VARCHAR(5) not null,
	obtained_at datetime default current_date not null,
	expire_at datetime not null,
	current_gauge int not null,
	max_gauge int not null,
	progress_gauge int not null,
	constraint inventory_pk
		primary key (id)
);

alter table inventories
	add constraint inventory_user_id_fk
		foreign key (user_id) references users (id)
			on update cascade on delete cascade;

-- -----------------------------------------------------
-- Table `zettacf`.`character`
-- -----------------------------------------------------
create table `characters`
(
	id int not null,
	sh_part int not null,
	tf_part int not null,
	sf_part int not null,
	ss_part int not null,
	sb_part int not null,
	stl_part int not null,
	sw_part int not null,
	user_id int not null,
	constraint character_pk
		primary key (id),
	constraint character_user_id_fk
		foreign key (user_id) references users (id)
			on update cascade on delete cascade
);

-- -----------------------------------------------------
-- Alter Table `zettacf`.`users`
-- -----------------------------------------------------
alter table users
    add assists int default 0 not null,
	add battles int default 0 not null,
    add desertion int default 0 not null;

create trigger BattleAfterInsert
    after insert
    on battles
    for each row
begin
    if NEW.desertion > 0
    THEN
        UPDATE users SET users.desertion = users.desertion + 1 WHERE id = NEW.user_id;
        UPDATE users SET battles = battles+1 WHERE id = NEW.user_id;
    ELSEIF NEW.desertion < 1
    THEN
        UPDATE users SET kills = kills + NEW.totalkills, deaths = deaths + NEW.totaldeaths, battles = battles+1, assists = assists + NEW.assists  WHERE id = NEW.user_id;
    end if;
end;

create trigger BattleAfterUpdate
    after update
    on battles
    for each row
begin
    if NEW.desertion > 0
    THEN
        UPDATE users SET users.desertion = users.desertion + 1 WHERE id = NEW.user_id;
    ELSEIF NEW.desertion < OLD.desertion
    THEN
        UPDATE users SET users.desertion = users.desertion - 1 WHERE id = NEW.user_id;
    end if;
    UPDATE users SET kills = (kills - OLD.totalkills) + NEW.totalkills, deaths = (deaths - OLD.totaldeaths) + NEW.totaldeaths, assists = (assists - OLD.assists) + NEW.assists WHERE id = NEW.user_id;
end;

create trigger UserAfterInsert
    after insert
    on users
    for each row
begin
    INSERT INTO inventories (user_id, type, code, expire_at, current_gauge, max_gauge, progress_gauge) values (NEW.id, 'w', 'C0001', '3000-12-31 23:59:00', '0', '200', '0');
end;


DELIMITER //
create procedure CheckNameExists(IN name VARCHAR(13))
begin
    DECLARE total int;
    SELECT COUNT(*) INTO total FROM users WHERE LOWER(users.name) = LOWER(name);
    SELECT total > 0 as result;
end;
DELIMITER ;

DELIMITER //
create procedure BattleStatistics(IN user_id INT)
begin
    DECLARE wins, loses, kills, deaths, assists, headshots, granade, knife, desertion int;
    SELECT COUNT(*) INTO wins FROM battles WHERE battles.user_id = user_id AND battles.won > 0;
    SELECT COUNT(*) INTO loses FROM battles WHERE battles.user_id = user_id AND battles.won < 1;
    SELECT SUM(battles.totalkills) INTO kills FROM battles WHERE battles.user_id = user_id;
    SELECT SUM(battles.totaldeaths) INTO deaths FROM battles WHERE battles.user_id = user_id;
    SELECT SUM(battles.assists) INTO assists FROM battles WHERE battles.user_id = user_id;
    SELECT SUM(battles.headshot) INTO headshots FROM battles WHERE battles.user_id = user_id;
    SELECT SUM(battles.desertion) INTO desertion FROM battles WHERE battles.user_id = user_id;
    SELECT SUM(battles.granade) INTO granade FROM battles WHERE battles.user_id = user_id;
    SELECT SUM(battles.knife) INTO knife FROM battles WHERE battles.user_id = user_id;

    # SEND RESULT
    SELECT wins, loses, desertion, kills, deaths, assists, headshots, granade, knife;
end;
DELIMITER ;

# password: oreki
insert into users (id, username, password, email, type, name, exp, level, gp, zp, tutorial_done, coupons_owned, lastip,
                  lastguid, kills, deaths)
values (52142, 'oreki', '$2y$12$.eCm/D/7Ba2OaDVTPjcFfuinAvy4QVj1y0TmBwR3wzbNY4QcnNX2q', 'diego@zettastudios.to', 0, '[GM]Alchemist', 813, 1, 500000, 100000, 1, 10, '127.0.0.1', '', 0, 0);

# password: admin
insert into users (id, username, password, email, type, name, exp, level, gp, zp, tutorial_done, coupons_owned, lastip,
                  lastguid, kills, deaths)
values (52143, 'admin', '$2y$12$tO5CoOfSvQ9yoqANvMxxnOE2JpaJ/a9uX2RKP0Uvk5KUmlTc4janW', 'admin@zettastudios.to', 0, '', 0, 0, 500000, 100000, 1, 10, '127.0.0.1', '', 0, 0);

insert into battles (gamemode, map, won, assists, desertion, granade, headshot, knife, totaldeaths, totalkills, user_id)
values (1, 1, 1, 2, 0, 1, 12, 0, 3, 16, 52142);

insert into battles (gamemode, map, won, assists, desertion, granade, headshot, knife, totaldeaths, totalkills, user_id)
values (1, 1, 0, 0, 1, 1, 1, 0, 3, 4, 52142);