-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 18-Jun-2021 às 15:46
-- Versão do servidor: 10.4.19-MariaDB
-- versão do PHP: 7.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `zettacf`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckNameExists` (IN `name` VARCHAR(13))  begin
    DECLARE total int;
    SELECT COUNT(*) INTO total FROM users WHERE LOWER(users.name) = LOWER(name);
    SELECT total > 0;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `battles`
--

CREATE TABLE `battles` (
  `id` int(11) NOT NULL,
  `gamemode` int(11) NOT NULL,
  `map` smallint(6) NOT NULL,
  `won` int(11) NOT NULL,
  `assists` int(11) NOT NULL,
  `desertion` int(11) NOT NULL,
  `granade` int(11) NOT NULL,
  `headshot` int(11) NOT NULL,
  `knife` int(11) NOT NULL,
  `totaldeaths` int(11) NOT NULL,
  `totalkills` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Acionadores `battles`
--
DELIMITER $$
CREATE TRIGGER `BattleAfterInsert` AFTER INSERT ON `battles` FOR EACH ROW begin
    UPDATE users SET kills = kills + NEW.totalkills, deaths = deaths + NEW.totaldeaths WHERE id = NEW.user_id;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BattleAfterUpdate` AFTER UPDATE ON `battles` FOR EACH ROW begin
    UPDATE users SET kills = (kills - OLD.totalkills) + NEW.totalkills, deaths = (deaths - OLD.totaldeaths) + NEW.totaldeaths WHERE id = NEW.user_id;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `characters`
--

CREATE TABLE `characters` (
  `id` int(11) NOT NULL,
  `sh_part` int(11) NOT NULL,
  `tf_part` int(11) NOT NULL,
  `sf_part` int(11) NOT NULL,
  `ss_part` int(11) NOT NULL,
  `sb_part` int(11) NOT NULL,
  `stl_part` int(11) NOT NULL,
  `sw_part` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `inventories`
--

CREATE TABLE `inventories` (
  `user_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `type` varchar(1) NOT NULL,
  `code` varchar(5) NOT NULL,
  `obtained_at` datetime NOT NULL DEFAULT curdate(),
  `expire_at` datetime NOT NULL,
  `current_gauge` int(11) NOT NULL,
  `max_gauge` int(11) NOT NULL,
  `progress_gauge` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `inventories`
--

INSERT INTO `inventories` (`user_id`, `id`, `type`, `code`, `obtained_at`, `expire_at`, `current_gauge`, `max_gauge`, `progress_gauge`) VALUES
(52142, 1, 'w', 'C0001', '2021-06-14 00:00:00', '3000-12-31 23:59:00', 0, 200, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `servers`
--

CREATE TABLE `servers` (
  `id` int(11) NOT NULL,
  `name` varchar(16) NOT NULL,
  `type` int(11) NOT NULL,
  `address` text NOT NULL,
  `port` int(11) NOT NULL,
  `limit` int(11) DEFAULT 300,
  `nolimit` int(11) DEFAULT 1,
  `minrank` int(11) DEFAULT 0,
  `maxrank` int(11) DEFAULT 100,
  `players` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(13) NOT NULL,
  `password` text NOT NULL,
  `email` varchar(45) NOT NULL,
  `type` int(11) DEFAULT 0,
  `name` varchar(16) NOT NULL,
  `exp` int(11) DEFAULT 0,
  `level` int(11) DEFAULT 0,
  `gp` int(11) DEFAULT 1000000,
  `zp` int(11) DEFAULT 1000000,
  `tutorial_done` int(11) DEFAULT 0,
  `coupons_owned` int(11) DEFAULT 0,
  `lastip` text DEFAULT NULL,
  `lastguid` text DEFAULT NULL,
  `kills` int(11) DEFAULT 0,
  `deaths` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `type`, `name`, `exp`, `level`, `gp`, `zp`, `tutorial_done`, `coupons_owned`, `lastip`, `lastguid`, `kills`, `deaths`) VALUES
(52142, 'oreki', '$2y$12$.eCm/D/7Ba2OaDVTPjcFfuinAvy4QVj1y0TmBwR3wzbNY4QcnNX2q', 'diego@zettastudios.to', 0, 'Gotrax', 512, 2, 500000, 100000, 1, 10, '127.0.0.1', '', 0, 0);

--
-- Acionadores `users`
--
DELIMITER $$
CREATE TRIGGER `UserAfterInsert` AFTER INSERT ON `users` FOR EACH ROW begin
    INSERT INTO inventories (user_id, id, type, code, expire_at, current_gauge, max_gauge, progress_gauge) values (NEW.id, '1', 'w', 'C0001', '3000-12-31 23:59:00', '0', '200', '0');
end
$$
DELIMITER ;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `battles`
--
ALTER TABLE `battles`
  ADD PRIMARY KEY (`id`,`user_id`),
  ADD KEY `fk_battle_user_idx` (`user_id`);

--
-- Índices para tabela `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`id`),
  ADD KEY `character_user_id_fk` (`user_id`);

--
-- Índices para tabela `inventories`
--
ALTER TABLE `inventories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_user_id_fk` (`user_id`);

--
-- Índices para tabela `servers`
--
ALTER TABLE `servers`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `battles`
--
ALTER TABLE `battles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `servers`
--
ALTER TABLE `servers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52143;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `battles`
--
ALTER TABLE `battles`
  ADD CONSTRAINT `fk_battle_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `characters`
--
ALTER TABLE `characters`
  ADD CONSTRAINT `character_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `inventories`
--
ALTER TABLE `inventories`
  ADD CONSTRAINT `inventory_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
