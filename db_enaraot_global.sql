-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 15/11/2024 às 14:25
-- Versão do servidor: 5.7.43-log
-- Versão do PHP: 8.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `db_enaraot_global`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `password` text NOT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `created` int(11) NOT NULL DEFAULT '0',
  `rlname` varchar(255) NOT NULL DEFAULT '',
  `location` varchar(255) NOT NULL DEFAULT '',
  `country` varchar(3) NOT NULL DEFAULT '',
  `web_lastlogin` int(11) NOT NULL DEFAULT '0',
  `web_flags` int(11) NOT NULL DEFAULT '0',
  `email_hash` varchar(32) NOT NULL DEFAULT '',
  `email_new` varchar(255) NOT NULL DEFAULT '',
  `email_new_time` int(11) NOT NULL DEFAULT '0',
  `email_code` varchar(255) NOT NULL DEFAULT '',
  `email_next` int(11) NOT NULL DEFAULT '0',
  `email_verified` tinyint(1) NOT NULL DEFAULT '0',
  `phone` varchar(15) DEFAULT NULL,
  `key` varchar(64) NOT NULL DEFAULT '',
  `premdays` int(11) NOT NULL DEFAULT '0',
  `premdays_purchased` int(11) NOT NULL DEFAULT '0',
  `lastday` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
  `coins` int(12) UNSIGNED NOT NULL DEFAULT '0',
  `coins_transferable` int(12) UNSIGNED NOT NULL DEFAULT '0',
  `tournament_coins` int(12) UNSIGNED NOT NULL DEFAULT '0',
  `creation` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `recruiter` int(6) DEFAULT '0',
  `vote` int(11) NOT NULL DEFAULT '0',
  `authToken` varchar(100) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `email`, `created`, `rlname`, `location`, `country`, `web_lastlogin`, `web_flags`, `email_hash`, `email_new`, `email_new_time`, `email_code`, `email_next`, `email_verified`, `phone`, `key`, `premdays`, `premdays_purchased`, `lastday`, `type`, `coins`, `coins_transferable`, `tournament_coins`, `creation`, `recruiter`, `vote`, `authToken`) VALUES
(1, 'god', '21298df8a3277357ee55b01df9530b535cf08ec1', '@god', 0, '', '', '', 0, 0, '', '', 0, '', 0, 0, NULL, '', 0, 0, 0, 5, 0, 0, 0, 1726091667, 0, 0, '0'),
(2, 'EnaraOTomelhor2024', '9c6391a317a45c1bc8ca9a4b7cb901d2985e3d63', 'admin@enaraot.com', 1726085760, 'EnaraOT', 'Vancouver', 'ca', 1731002897, 3, '', '', 0, '', 0, 0, '11111111111', 'I3FDBYDVEAMH2I8365WW', 431, 451, 1768946647, 6, 99999, 96554, 0, 1726091668, 0, 0, '1'),
(3, 'test998877', '1d874ccaa12a98ec96fd31eb160c257e56e423c6', 'almeidaliber@gmail.com', 1726279524, '', '', 'br', 1729187679, 0, '', '', 0, '', 0, 0, NULL, '', 99, 0, 1737756247, 1, 0, 0, 0, 1726279613, 0, 0, '0');

--
-- Acionadores `accounts`
--
DELIMITER $$
CREATE TRIGGER `oncreate_accounts` AFTER INSERT ON `accounts` FOR EACH ROW BEGIN
    INSERT INTO `account_vipgroups` (`account_id`, `name`, `customizable`) VALUES (NEW.`id`, 'Enemies', 0);
    INSERT INTO `account_vipgroups` (`account_id`, `name`, `customizable`) VALUES (NEW.`id`, 'Friends', 0);
    INSERT INTO `account_vipgroups` (`account_id`, `name`, `customizable`) VALUES (NEW.`id`, 'Trading Partner', 0);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_authentication`
--

CREATE TABLE `account_authentication` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `secret` varchar(100) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `account_authentication`
--

INSERT INTO `account_authentication` (`id`, `account_id`, `secret`, `status`) VALUES
(1, 2, '6R7O6Q3SNAU4AWVL', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_bans`
--

CREATE TABLE `account_bans` (
  `account_id` int(11) UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_ban_history`
--

CREATE TABLE `account_ban_history` (
  `id` int(11) NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expired_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_sessions`
--

CREATE TABLE `account_sessions` (
  `id` varchar(191) NOT NULL,
  `account_id` int(10) UNSIGNED NOT NULL,
  `expires` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_vipgrouplist`
--

CREATE TABLE `account_vipgrouplist` (
  `account_id` int(11) UNSIGNED NOT NULL COMMENT 'id of account whose viplist entry it is',
  `player_id` int(11) NOT NULL COMMENT 'id of target player of viplist entry',
  `vipgroup_id` int(11) UNSIGNED NOT NULL COMMENT 'id of vip group that player belongs'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_vipgroups`
--

CREATE TABLE `account_vipgroups` (
  `id` int(11) UNSIGNED NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL COMMENT 'id of account whose vip group entry it is',
  `name` varchar(128) NOT NULL,
  `customizable` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `account_vipgroups`
--

INSERT INTO `account_vipgroups` (`id`, `account_id`, `name`, `customizable`) VALUES
(1, 1, 'Enemies', 0),
(2, 1, 'Friends', 0),
(3, 1, 'Trading Partner', 0),
(4, 2, 'Enemies', 0),
(5, 2, 'Friends', 0),
(6, 2, 'Trading Partner', 0),
(7, 3, 'Enemies', 0),
(8, 3, 'Friends', 0),
(9, 3, 'Trading Partner', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_viplist`
--

CREATE TABLE `account_viplist` (
  `account_id` int(11) UNSIGNED NOT NULL COMMENT 'id of account whose viplist entry it is',
  `player_id` int(11) NOT NULL COMMENT 'id of target player of viplist entry',
  `description` varchar(128) NOT NULL DEFAULT '',
  `icon` tinyint(2) UNSIGNED NOT NULL DEFAULT '0',
  `notify` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `boosted_boss`
--

CREATE TABLE `boosted_boss` (
  `boostname` text,
  `date` varchar(250) NOT NULL DEFAULT '',
  `raceid` varchar(250) NOT NULL DEFAULT '',
  `looktypeEx` int(11) NOT NULL DEFAULT '0',
  `looktype` int(11) NOT NULL DEFAULT '136',
  `lookfeet` int(11) NOT NULL DEFAULT '0',
  `looklegs` int(11) NOT NULL DEFAULT '0',
  `lookhead` int(11) NOT NULL DEFAULT '0',
  `lookbody` int(11) NOT NULL DEFAULT '0',
  `lookaddons` int(11) NOT NULL DEFAULT '0',
  `lookmount` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `boosted_boss`
--

INSERT INTO `boosted_boss` (`boostname`, `date`, `raceid`, `looktypeEx`, `looktype`, `lookfeet`, `looklegs`, `lookhead`, `lookbody`, `lookaddons`, `lookmount`) VALUES
('Outburst', '14', '1227', 0, 876, 3, 94, 79, 3, 3, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `boosted_creature`
--

CREATE TABLE `boosted_creature` (
  `boostname` text,
  `date` varchar(250) NOT NULL DEFAULT '',
  `raceid` varchar(250) NOT NULL DEFAULT '',
  `looktype` int(11) NOT NULL DEFAULT '136',
  `lookfeet` int(11) NOT NULL DEFAULT '0',
  `looklegs` int(11) NOT NULL DEFAULT '0',
  `lookhead` int(11) NOT NULL DEFAULT '0',
  `lookbody` int(11) NOT NULL DEFAULT '0',
  `lookaddons` int(11) NOT NULL DEFAULT '0',
  `lookmount` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `boosted_creature`
--

INSERT INTO `boosted_creature` (`boostname`, `date`, `raceid`, `looktype`, `lookfeet`, `looklegs`, `lookhead`, `lookbody`, `lookaddons`, `lookmount`) VALUES
('Terrified Elephant', '14', '771', 211, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `coins_transactions`
--

CREATE TABLE `coins_transactions` (
  `id` int(11) UNSIGNED NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  `type` tinyint(1) UNSIGNED NOT NULL,
  `coin_type` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
  `amount` int(12) UNSIGNED NOT NULL,
  `description` varchar(3500) NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `coins_transactions`
--

INSERT INTO `coins_transactions` (`id`, `account_id`, `type`, `coin_type`, `amount`, `description`, `timestamp`) VALUES
(1, 2, 1, 1, 30, 'ADD Coins', '2024-09-13 20:32:16'),
(2, 2, 1, 1, 10, 'ADD Coins', '2024-09-13 20:39:30'),
(3, 2, 1, 1, 10, 'ADD Coins', '2024-09-13 20:49:30'),
(4, 2, 1, 1, 10, 'ADD Coins', '2024-09-13 20:59:30'),
(5, 2, 1, 1, 10, 'ADD Coins', '2024-09-13 21:09:30'),
(6, 2, 1, 3, 10, 'ADD Coins', '2024-09-13 21:20:58'),
(7, 2, 1, 3, 10, 'ADD Coins', '2024-09-13 21:30:58'),
(8, 2, 1, 3, 10, 'ADD Coins', '2024-09-13 21:58:28'),
(9, 2, 1, 3, 10, 'ADD Coins', '2024-09-13 22:08:28'),
(10, 2, 2, 3, 30, 'REMOVE Coins', '2024-09-13 22:13:39'),
(11, 2, 2, 3, 3000, 'REMOVE Coins', '2024-10-25 23:43:14'),
(12, 2, 1, 3, 30, 'ADD Coins', '2024-10-26 05:43:37'),
(13, 2, 2, 3, 900, 'REMOVE Coins', '2024-11-05 06:31:31'),
(14, 2, 1, 3, 300, 'ADD Coins', '2024-11-11 07:00:02'),
(15, 2, 1, 3, 10, 'ADD Coins', '2024-11-13 00:08:39'),
(16, 2, 1, 3, 10, 'ADD Coins', '2024-11-14 03:11:50'),
(17, 2, 1, 3, 10, 'ADD Coins', '2024-11-14 18:29:36'),
(18, 2, 1, 3, 5, 'ADD Coins', '2024-11-14 19:35:59'),
(19, 2, 1, 3, 300, 'ADD Coins', '2024-11-14 20:00:11'),
(20, 2, 1, 3, 5, 'ADD Coins', '2024-11-14 20:36:00'),
(21, 2, 1, 3, 5, 'ADD Coins', '2024-11-14 21:36:02'),
(22, 2, 1, 3, 5, 'ADD Coins', '2024-11-14 23:50:08'),
(23, 2, 1, 3, 5, 'ADD Coins', '2024-11-15 01:37:29'),
(24, 2, 1, 3, 5, 'ADD Coins', '2024-11-15 02:38:07'),
(25, 2, 1, 3, 5, 'ADD Coins', '2024-11-15 03:38:07'),
(26, 2, 1, 3, 5, 'ADD Coins', '2024-11-15 04:38:11'),
(27, 2, 1, 3, 5, 'ADD Coins', '2024-11-15 05:38:17');

-- --------------------------------------------------------

--
-- Estrutura para tabela `daily_reward_history`
--

CREATE TABLE `daily_reward_history` (
  `id` int(11) NOT NULL,
  `daystreak` smallint(2) NOT NULL DEFAULT '0',
  `player_id` int(11) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `daily_reward_history`
--

INSERT INTO `daily_reward_history` (`id`, `daystreak`, `player_id`, `timestamp`, `description`) VALUES
(1, 0, 7, 1726172843, 'Claimed reward no. 1. Picked items: 10x ultimate mana potion.'),
(2, 1, 7, 1726433034, 'Claimed reward no. 2. Picked items: 10x ultimate mana potion.'),
(3, 2, 7, 1726440321, 'Claimed reward no. 3. Picked reward: 2x Prey bonus reroll(s).'),
(4, 0, 8, 1726866097, 'Claimed reward no. 1. Picked items: 10x supreme health potion.'),
(5, 3, 7, 1726867869, 'Claimed reward no. 4. Picked items: 20x ultimate mana potion.'),
(6, 4, 7, 1729891640, 'Claimed reward no. 5. Picked reward: 2x Prey bonus reroll(s).'),
(7, 5, 7, 1731646891, 'Claimed reward no. 6. Picked items: 2x training wand.');

-- --------------------------------------------------------

--
-- Estrutura para tabela `forge_history`
--

CREATE TABLE `forge_history` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `action_type` int(11) NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `is_success` tinyint(4) NOT NULL DEFAULT '0',
  `bonus` tinyint(4) NOT NULL DEFAULT '0',
  `done_at` bigint(20) NOT NULL,
  `done_at_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `cost` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `gained` bigint(20) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `global_storage`
--

CREATE TABLE `global_storage` (
  `key` varchar(32) NOT NULL,
  `value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `global_storage`
--

INSERT INTO `global_storage` (`key`, `value`) VALUES
('14110', '1731621601'),
('40000', '4');

-- --------------------------------------------------------

--
-- Estrutura para tabela `guilds`
--

CREATE TABLE `guilds` (
  `id` int(11) NOT NULL,
  `level` int(11) NOT NULL DEFAULT '1',
  `name` varchar(255) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `creationdata` int(11) NOT NULL,
  `motd` varchar(255) NOT NULL DEFAULT '',
  `residence` int(11) NOT NULL DEFAULT '0',
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `points` int(11) NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `logo_name` varchar(255) NOT NULL DEFAULT 'default.gif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `guilds`
--

INSERT INTO `guilds` (`id`, `level`, `name`, `ownerid`, `creationdata`, `motd`, `residence`, `balance`, `points`, `description`, `logo_name`) VALUES
(1, 1, 'EnaraOT', 7, 1731002912, '', 0, 0, 0, 'New guild. Leader must edit this text :)', 'default.gif');

--
-- Acionadores `guilds`
--
DELIMITER $$
CREATE TRIGGER `oncreate_guilds` AFTER INSERT ON `guilds` FOR EACH ROW BEGIN
    INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('The Leader', 3, NEW.`id`);
    INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Vice-Leader', 2, NEW.`id`);
    INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Member', 1, NEW.`id`);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guildwar_kills`
--

CREATE TABLE `guildwar_kills` (
  `id` int(11) NOT NULL,
  `killer` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  `killerguild` int(11) NOT NULL DEFAULT '0',
  `targetguild` int(11) NOT NULL DEFAULT '0',
  `warid` int(11) NOT NULL DEFAULT '0',
  `time` bigint(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guild_invites`
--

CREATE TABLE `guild_invites` (
  `player_id` int(11) NOT NULL DEFAULT '0',
  `guild_id` int(11) NOT NULL DEFAULT '0',
  `date` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guild_membership`
--

CREATE TABLE `guild_membership` (
  `player_id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL,
  `rank_id` int(11) NOT NULL,
  `nick` varchar(15) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `guild_membership`
--

INSERT INTO `guild_membership` (`player_id`, `guild_id`, `rank_id`, `nick`) VALUES
(7, 1, 1, 'Owner');

-- --------------------------------------------------------

--
-- Estrutura para tabela `guild_ranks`
--

CREATE TABLE `guild_ranks` (
  `id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL COMMENT 'guild',
  `name` varchar(255) NOT NULL COMMENT 'rank name',
  `level` int(11) NOT NULL COMMENT 'rank level - leader, vice, member, maybe something else'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `guild_ranks`
--

INSERT INTO `guild_ranks` (`id`, `guild_id`, `name`, `level`) VALUES
(1, 1, 'The Leader', 3),
(2, 1, 'Vice-Leader', 2),
(3, 1, 'Member', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `guild_wars`
--

CREATE TABLE `guild_wars` (
  `id` int(11) NOT NULL,
  `guild1` int(11) NOT NULL DEFAULT '0',
  `guild2` int(11) NOT NULL DEFAULT '0',
  `name1` varchar(255) NOT NULL,
  `name2` varchar(255) NOT NULL,
  `status` tinyint(2) UNSIGNED NOT NULL DEFAULT '0',
  `started` bigint(15) NOT NULL DEFAULT '0',
  `ended` bigint(15) NOT NULL DEFAULT '0',
  `frags_limit` smallint(4) UNSIGNED NOT NULL DEFAULT '0',
  `payment` bigint(13) UNSIGNED NOT NULL DEFAULT '0',
  `duration_days` tinyint(3) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `houses`
--

CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `new_owner` int(11) NOT NULL DEFAULT '-1',
  `paid` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `warnings` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `rent` int(11) NOT NULL DEFAULT '0',
  `town_id` int(11) NOT NULL DEFAULT '0',
  `bid` int(11) NOT NULL DEFAULT '0',
  `bid_end` int(11) NOT NULL DEFAULT '0',
  `last_bid` int(11) NOT NULL DEFAULT '0',
  `highest_bidder` int(11) NOT NULL DEFAULT '0',
  `size` int(11) NOT NULL DEFAULT '0',
  `guildid` int(11) DEFAULT NULL,
  `beds` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `houses`
--

INSERT INTO `houses` (`id`, `owner`, `new_owner`, `paid`, `warnings`, `name`, `rent`, `town_id`, `bid`, `bid_end`, `last_bid`, `highest_bidder`, `size`, `guildid`, `beds`) VALUES
(1, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(2, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(3, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(4, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(5, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(6, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(7, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(8, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(9, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(10, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(11, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(13, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(14, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(15, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(16, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(17, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(18, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(19, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(20, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(21, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(22, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(23, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(24, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(25, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(26, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(27, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(28, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(29, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(30, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(31, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(32, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(33, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(34, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(35, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(36, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(37, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(38, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(39, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(40, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(41, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(42, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(43, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(44, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(45, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(46, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(47, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(48, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(49, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(53, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(54, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(55, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(56, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(57, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(58, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(59, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(60, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(61, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(62, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(73, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(79, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(82, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(85, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(88, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(89, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(91, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(94, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(108, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(204, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(205, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(206, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(207, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(208, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(209, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(210, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(211, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(356, 0, -1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, NULL, 0),
(2628, 0, -1, 1728683653, 0, 'Castle of the Winds', 500000, 5, 0, 0, 0, 0, 514, NULL, 0),
(2629, 0, -1, 1728683653, 0, 'Ab\'Dendriel Clanhall', 250000, 5, 0, 0, 0, 0, 326, NULL, 0),
(2630, 0, -1, 1728683653, 0, 'Underwood 9', 50000, 5, 0, 0, 0, 0, 14, NULL, 0),
(2631, 0, -1, 1728683653, 0, 'Treetop 13', 100000, 5, 0, 0, 0, 0, 28, NULL, 0),
(2632, 0, -1, 1728683653, 0, 'Underwood 8', 50000, 5, 0, 0, 0, 0, 23, NULL, 0),
(2633, 0, -1, 1728683653, 0, 'Treetop 11', 50000, 5, 0, 0, 0, 0, 24, NULL, 0),
(2635, 0, -1, 1728683653, 0, 'Great Willow 2a', 50000, 5, 0, 0, 0, 0, 20, NULL, 0),
(2637, 0, -1, 1728683653, 0, 'Great Willow 2b', 50000, 5, 0, 0, 0, 0, 25, NULL, 0),
(2638, 0, -1, 1728683653, 0, 'Great Willow Western Wing', 100000, 5, 0, 0, 0, 0, 61, NULL, 0),
(2640, 0, -1, 1728683653, 0, 'Great Willow 1', 100000, 5, 0, 0, 0, 0, 35, NULL, 0),
(2642, 0, -1, 1728683653, 0, 'Great Willow 3a', 50000, 5, 0, 0, 0, 0, 19, NULL, 0),
(2644, 0, -1, 1728683653, 0, 'Great Willow 3b', 80000, 5, 0, 0, 0, 0, 40, NULL, 0),
(2645, 0, -1, 1728683653, 0, 'Great Willow 4a', 25000, 5, 0, 0, 0, 0, 19, NULL, 0),
(2648, 0, -1, 1728683653, 0, 'Great Willow 4b', 25000, 5, 0, 0, 0, 0, 19, NULL, 0),
(2649, 0, -1, 1728683653, 0, 'Underwood 6', 100000, 5, 0, 0, 0, 0, 40, NULL, 0),
(2650, 0, -1, 1728683653, 0, 'Underwood 3', 100000, 5, 0, 0, 0, 0, 39, NULL, 0),
(2651, 0, -1, 1728683653, 0, 'Underwood 5', 80000, 5, 0, 0, 0, 0, 33, NULL, 0),
(2652, 0, -1, 1728683653, 0, 'Underwood 2', 100000, 5, 0, 0, 0, 0, 37, NULL, 0),
(2653, 0, -1, 1728683653, 0, 'Underwood 1', 100000, 5, 0, 0, 0, 0, 39, NULL, 0),
(2654, 0, -1, 1728683653, 0, 'Prima Arbor', 400000, 5, 0, 0, 0, 0, 200, NULL, 0),
(2655, 0, -1, 1728683653, 0, 'Underwood 7', 200000, 5, 0, 0, 0, 0, 34, NULL, 0),
(2656, 0, -1, 1728683653, 0, 'Underwood 10', 25000, 5, 0, 0, 0, 0, 19, NULL, 0),
(2657, 0, -1, 1728683653, 0, 'Underwood 4', 100000, 5, 0, 0, 0, 0, 50, NULL, 0),
(2658, 0, -1, 1728683653, 0, 'Treetop 9', 50000, 5, 0, 0, 0, 0, 24, NULL, 0),
(2659, 0, -1, 1728683653, 0, 'Treetop 10', 80000, 5, 0, 0, 0, 0, 28, NULL, 0),
(2660, 0, -1, 1728683653, 0, 'Treetop 8', 25000, 5, 0, 0, 0, 0, 22, NULL, 0),
(2661, 0, -1, 1728683653, 0, 'Treetop 7', 50000, 5, 0, 0, 0, 0, 20, NULL, 0),
(2662, 0, -1, 1728683653, 0, 'Treetop 6', 25000, 5, 0, 0, 0, 0, 17, NULL, 0),
(2663, 0, -1, 1728683653, 0, 'Treetop 5 (Shop)', 80000, 5, 0, 0, 0, 0, 36, NULL, 0),
(2664, 0, -1, 1728683653, 0, 'Treetop 12 (Shop)', 100000, 5, 0, 0, 0, 0, 39, NULL, 0),
(2665, 0, -1, 1728683653, 0, 'Treetop 4 (Shop)', 80000, 5, 0, 0, 0, 0, 31, NULL, 0),
(2666, 0, -1, 1728683653, 0, 'Treetop 3 (Shop)', 80000, 5, 0, 0, 0, 0, 36, NULL, 0),
(2687, 0, -1, 1728683653, 0, 'Northern Street 1a', 100000, 6, 0, 0, 0, 0, 26, NULL, 0),
(2688, 0, -1, 1728683653, 0, 'Park Lane 3a', 100000, 6, 0, 0, 0, 0, 36, NULL, 0),
(2689, 0, -1, 1728683653, 0, 'Park Lane 1a', 150000, 6, 0, 0, 0, 0, 36, NULL, 0),
(2690, 0, -1, 1728683653, 0, 'Park Lane 4', 150000, 6, 0, 0, 0, 0, 27, NULL, 0),
(2691, 0, -1, 1728683653, 0, 'Park Lane 2', 150000, 6, 0, 0, 0, 0, 28, NULL, 0),
(2692, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 04', 50000, 6, 0, 0, 0, 0, 15, NULL, 0),
(2693, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 03', 25000, 6, 0, 0, 0, 0, 13, NULL, 0),
(2694, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 05', 50000, 6, 0, 0, 0, 0, 13, NULL, 0),
(2695, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 06', 25000, 6, 0, 0, 0, 0, 13, NULL, 0),
(2696, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 02', 25000, 6, 0, 0, 0, 0, 15, NULL, 0),
(2697, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 01', 25000, 6, 0, 0, 0, 0, 13, NULL, 0),
(2698, 0, -1, 1728683653, 0, 'Northern Street 5', 200000, 6, 0, 0, 0, 0, 52, NULL, 0),
(2699, 0, -1, 1728683653, 0, 'Northern Street 7', 150000, 6, 0, 0, 0, 0, 44, NULL, 0),
(2700, 0, -1, 1728683653, 0, 'Theater Avenue 6e', 80000, 6, 0, 0, 0, 0, 25, NULL, 0),
(2701, 0, -1, 1728683653, 0, 'Theater Avenue 6c', 25000, 6, 0, 0, 0, 0, 9, NULL, 0),
(2702, 0, -1, 1728683653, 0, 'Theater Avenue 6a', 80000, 6, 0, 0, 0, 0, 24, NULL, 0),
(2703, 0, -1, 1728683653, 0, 'Theater Avenue, Tower', 300000, 6, 0, 0, 0, 0, 80, NULL, 0),
(2705, 0, -1, 1728683653, 0, 'East Lane 2', 300000, 6, 0, 0, 0, 0, 93, NULL, 0),
(2706, 0, -1, 1728683653, 0, 'Harbour Lane 2a (Shop)', 80000, 6, 0, 0, 0, 0, 18, NULL, 0),
(2707, 0, -1, 1728683653, 0, 'Harbour Lane 2b (Shop)', 80000, 6, 0, 0, 0, 0, 21, NULL, 0),
(2708, 0, -1, 1728683653, 0, 'Harbour Lane 3', 400000, 6, 0, 0, 0, 0, 92, NULL, 0),
(2709, 0, -1, 1728683653, 0, 'Magician\'s Alley 8', 150000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2710, 0, -1, 1728683653, 0, 'Lonely Sea Side Hostel', 400000, 6, 0, 0, 0, 0, 331, NULL, 0),
(2711, 0, -1, 1728683653, 0, 'Suntower', 500000, 6, 0, 0, 0, 0, 306, NULL, 0),
(2712, 0, -1, 1728683653, 0, 'House of Recreation', 500000, 6, 0, 0, 0, 0, 469, NULL, 0),
(2713, 0, -1, 1728683653, 0, 'Carlin Clanhall', 250000, 6, 0, 0, 0, 0, 287, NULL, 0),
(2714, 0, -1, 1728683653, 0, 'Magician\'s Alley 4', 200000, 6, 0, 0, 0, 0, 60, NULL, 0),
(2715, 0, -1, 1728683653, 0, 'Theater Avenue 14 (Shop)', 200000, 6, 0, 0, 0, 0, 54, NULL, 0),
(2716, 0, -1, 1728683653, 0, 'Theater Avenue 12', 80000, 6, 0, 0, 0, 0, 21, NULL, 0),
(2717, 0, -1, 1728683653, 0, 'Magician\'s Alley 1', 100000, 6, 0, 0, 0, 0, 23, NULL, 0),
(2718, 0, -1, 1728683653, 0, 'Theater Avenue 10', 100000, 6, 0, 0, 0, 0, 29, NULL, 0),
(2719, 0, -1, 1728683653, 0, 'Magician\'s Alley 1b', 25000, 6, 0, 0, 0, 0, 16, NULL, 0),
(2720, 0, -1, 1728683653, 0, 'Magician\'s Alley 1a', 25000, 6, 0, 0, 0, 0, 16, NULL, 0),
(2721, 0, -1, 1728683653, 0, 'Magician\'s Alley 1c', 25000, 6, 0, 0, 0, 0, 13, NULL, 0),
(2722, 0, -1, 1728683653, 0, 'Magician\'s Alley 1d', 25000, 6, 0, 0, 0, 0, 16, NULL, 0),
(2723, 0, -1, 1728683653, 0, 'Magician\'s Alley 5c', 100000, 6, 0, 0, 0, 0, 25, NULL, 0),
(2724, 0, -1, 1728683653, 0, 'Magician\'s Alley 5f', 80000, 6, 0, 0, 0, 0, 28, NULL, 0),
(2725, 0, -1, 1728683653, 0, 'Magician\'s Alley 5b', 50000, 6, 0, 0, 0, 0, 25, NULL, 0),
(2727, 0, -1, 1728683653, 0, 'Magician\'s Alley 5a', 50000, 6, 0, 0, 0, 0, 30, NULL, 0),
(2729, 0, -1, 1728683653, 0, 'Central Plaza 3 (Shop)', 50000, 6, 0, 0, 0, 0, 17, NULL, 0),
(2730, 0, -1, 1728683653, 0, 'Central Plaza 2 (Shop)', 25000, 6, 0, 0, 0, 0, 15, NULL, 0),
(2731, 0, -1, 1728683653, 0, 'Central Plaza 1 (Shop)', 50000, 6, 0, 0, 0, 0, 19, NULL, 0),
(2732, 0, -1, 1728683653, 0, 'Theater Avenue 8b', 100000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2733, 0, -1, 1728683653, 0, 'Harbour Lane 1 (Shop)', 100000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2734, 0, -1, 1728683653, 0, 'Theater Avenue 6f', 80000, 6, 0, 0, 0, 0, 24, NULL, 0),
(2735, 0, -1, 1728683653, 0, 'Theater Avenue 6d', 25000, 6, 0, 0, 0, 0, 7, NULL, 0),
(2736, 0, -1, 1728683653, 0, 'Theater Avenue 6b', 50000, 6, 0, 0, 0, 0, 25, NULL, 0),
(2737, 0, -1, 1728683653, 0, 'Northern Street 3a', 80000, 6, 0, 0, 0, 0, 20, NULL, 0),
(2738, 0, -1, 1728683653, 0, 'Northern Street 3b', 80000, 6, 0, 0, 0, 0, 22, NULL, 0),
(2739, 0, -1, 1728683653, 0, 'Northern Street 1b', 80000, 6, 0, 0, 0, 0, 25, NULL, 0),
(2740, 0, -1, 1728683653, 0, 'Northern Street 1c', 80000, 6, 0, 0, 0, 0, 21, NULL, 0),
(2741, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 14', 25000, 6, 0, 0, 0, 0, 13, NULL, 0),
(2742, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 13', 25000, 6, 0, 0, 0, 0, 14, NULL, 0),
(2743, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 15', 25000, 6, 0, 0, 0, 0, 12, NULL, 0),
(2744, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 12', 25000, 6, 0, 0, 0, 0, 14, NULL, 0),
(2745, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 11', 50000, 6, 0, 0, 0, 0, 21, NULL, 0),
(2746, 0, -1, 1728683653, 0, 'Theater Avenue 7, Flat 16', 25000, 6, 0, 0, 0, 0, 16, NULL, 0),
(2747, 0, -1, 1728683653, 0, 'Theater Avenue 5', 200000, 6, 0, 0, 0, 0, 113, NULL, 0),
(2751, 0, -1, 1728683653, 0, 'Harbour Flats, Flat 11', 25000, 6, 0, 0, 0, 0, 17, NULL, 0),
(2752, 0, -1, 1728683653, 0, 'Harbour Flats, Flat 13', 25000, 6, 0, 0, 0, 0, 17, NULL, 0),
(2753, 0, -1, 1728683653, 0, 'Harbour Flats, Flat 15', 50000, 6, 0, 0, 0, 0, 27, NULL, 0),
(2755, 0, -1, 1728683653, 0, 'Harbour Flats, Flat 12', 50000, 6, 0, 0, 0, 0, 33, NULL, 0),
(2757, 0, -1, 1728683653, 0, 'Harbour Flats, Flat 16', 50000, 6, 0, 0, 0, 0, 35, NULL, 0),
(2759, 0, -1, 1728683653, 0, 'Harbour Flats, Flat 21', 50000, 6, 0, 0, 0, 0, 23, NULL, 0),
(2760, 0, -1, 1728683653, 0, 'Harbour Flats, Flat 22', 80000, 6, 0, 0, 0, 0, 30, NULL, 0),
(2761, 0, -1, 1728683653, 0, 'Harbour Flats, Flat 23', 25000, 6, 0, 0, 0, 0, 17, NULL, 0),
(2763, 0, -1, 1728683653, 0, 'Park Lane 1b', 200000, 6, 0, 0, 0, 0, 39, NULL, 0),
(2764, 0, -1, 1728683653, 0, 'Theater Avenue 8a', 100000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2765, 0, -1, 1728683653, 0, 'Theater Avenue 11a', 100000, 6, 0, 0, 0, 0, 32, NULL, 0),
(2767, 0, -1, 1728683653, 0, 'Theater Avenue 11b', 100000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2768, 0, -1, 1728683653, 0, 'Caretaker\'s Residence', 600000, 6, 0, 0, 0, 0, 298, NULL, 0),
(2769, 0, -1, 1728683653, 0, 'Moonkeep', 250000, 6, 0, 0, 0, 0, 298, NULL, 0),
(2770, 0, -1, 1728683653, 0, 'Mangrove 1', 80000, 5, 0, 0, 0, 0, 39, NULL, 0),
(2771, 0, -1, 1728683653, 0, 'Coastwood 2', 50000, 5, 0, 0, 0, 0, 20, NULL, 0),
(2772, 0, -1, 1728683653, 0, 'Coastwood 1', 50000, 5, 0, 0, 0, 0, 23, NULL, 0),
(2773, 0, -1, 1728683653, 0, 'Coastwood 3', 50000, 5, 0, 0, 0, 0, 27, NULL, 0),
(2774, 0, -1, 1728683653, 0, 'Coastwood 4', 50000, 5, 0, 0, 0, 0, 25, NULL, 0),
(2775, 0, -1, 1728683653, 0, 'Mangrove 4', 50000, 5, 0, 0, 0, 0, 23, NULL, 0),
(2776, 0, -1, 1728683653, 0, 'Coastwood 10', 80000, 5, 0, 0, 0, 0, 32, NULL, 0),
(2777, 0, -1, 1728683653, 0, 'Coastwood 5', 50000, 5, 0, 0, 0, 0, 33, NULL, 0),
(2778, 0, -1, 1728683653, 0, 'Coastwood 6 (Shop)', 80000, 5, 0, 0, 0, 0, 32, NULL, 0),
(2779, 0, -1, 1728683653, 0, 'Coastwood 7', 25000, 5, 0, 0, 0, 0, 16, NULL, 0),
(2780, 0, -1, 1728683653, 0, 'Coastwood 8', 50000, 5, 0, 0, 0, 0, 30, NULL, 0),
(2781, 0, -1, 1728683653, 0, 'Coastwood 9', 50000, 5, 0, 0, 0, 0, 25, NULL, 0),
(2782, 0, -1, 1728683653, 0, 'Treetop 2', 25000, 5, 0, 0, 0, 0, 18, NULL, 0),
(2783, 0, -1, 1728683653, 0, 'Treetop 1', 25000, 5, 0, 0, 0, 0, 17, NULL, 0),
(2784, 0, -1, 1728683653, 0, 'Mangrove 3', 80000, 5, 0, 0, 0, 0, 27, NULL, 0),
(2785, 0, -1, 1728683653, 0, 'Mangrove 2', 50000, 5, 0, 0, 0, 0, 32, NULL, 0),
(2786, 0, -1, 1728683653, 0, 'The Hideout', 250000, 5, 0, 0, 0, 0, 449, NULL, 0),
(2787, 0, -1, 1728683653, 0, 'Shadow Towers', 250000, 5, 0, 0, 0, 0, 429, NULL, 0),
(2788, 0, -1, 1728683653, 0, 'Druids Retreat A', 50000, 6, 0, 0, 0, 0, 32, NULL, 0),
(2789, 0, -1, 1728683653, 0, 'Druids Retreat C', 50000, 6, 0, 0, 0, 0, 27, NULL, 0),
(2790, 0, -1, 1728683653, 0, 'Druids Retreat B', 50000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2791, 0, -1, 1728683653, 0, 'Druids Retreat D', 80000, 6, 0, 0, 0, 0, 27, NULL, 0),
(2792, 0, -1, 1728683653, 0, 'East Lane 1b', 150000, 6, 0, 0, 0, 0, 43, NULL, 0),
(2793, 0, -1, 1728683653, 0, 'East Lane 1a', 200000, 6, 0, 0, 0, 0, 62, NULL, 0),
(2794, 0, -1, 1728683653, 0, 'Senja Village 11', 80000, 6, 0, 0, 0, 0, 59, NULL, 0),
(2795, 0, -1, 1728683653, 0, 'Senja Village 10', 50000, 6, 0, 0, 0, 0, 36, NULL, 0),
(2796, 0, -1, 1728683653, 0, 'Senja Village 9', 80000, 6, 0, 0, 0, 0, 55, NULL, 0),
(2797, 0, -1, 1728683653, 0, 'Senja Village 8', 50000, 6, 0, 0, 0, 0, 40, NULL, 0),
(2798, 0, -1, 1728683653, 0, 'Senja Village 7', 25000, 6, 0, 0, 0, 0, 19, NULL, 0),
(2799, 0, -1, 1728683653, 0, 'Senja Village 6b', 25000, 6, 0, 0, 0, 0, 19, NULL, 0),
(2800, 0, -1, 1728683653, 0, 'Senja Village 6a', 50000, 6, 0, 0, 0, 0, 18, NULL, 0),
(2801, 0, -1, 1728683653, 0, 'Senja Village 5', 50000, 6, 0, 0, 0, 0, 28, NULL, 0),
(2802, 0, -1, 1728683653, 0, 'Senja Village 4', 50000, 6, 0, 0, 0, 0, 38, NULL, 0),
(2803, 0, -1, 1728683653, 0, 'Senja Village 3', 50000, 6, 0, 0, 0, 0, 35, NULL, 0),
(2804, 0, -1, 1728683653, 0, 'Senja Village 1b', 50000, 6, 0, 0, 0, 0, 38, NULL, 0),
(2805, 0, -1, 1728683653, 0, 'Senja Village 1a', 25000, 6, 0, 0, 0, 0, 19, NULL, 0),
(2806, 0, -1, 1728683653, 0, 'Rosebud C', 100000, 6, 0, 0, 0, 0, 36, NULL, 0),
(2807, 0, -1, 1728683653, 0, 'Rosebud B', 80000, 6, 0, 0, 0, 0, 29, NULL, 0),
(2808, 0, -1, 1728683653, 0, 'Rosebud A', 50000, 6, 0, 0, 0, 0, 29, NULL, 0),
(2809, 0, -1, 1728683653, 0, 'Park Lane 3b', 100000, 6, 0, 0, 0, 0, 29, NULL, 0),
(2810, 0, -1, 1728683653, 0, 'Northport Village 6', 80000, 6, 0, 0, 0, 0, 42, NULL, 0),
(2811, 0, -1, 1728683653, 0, 'Northport Village 5', 80000, 6, 0, 0, 0, 0, 34, NULL, 0),
(2812, 0, -1, 1728683653, 0, 'Northport Village 4', 100000, 6, 0, 0, 0, 0, 50, NULL, 0),
(2813, 0, -1, 1728683653, 0, 'Northport Village 3', 150000, 6, 0, 0, 0, 0, 104, NULL, 0),
(2814, 0, -1, 1728683653, 0, 'Northport Village 2', 50000, 6, 0, 0, 0, 0, 28, NULL, 0),
(2815, 0, -1, 1728683653, 0, 'Northport Village 1', 50000, 6, 0, 0, 0, 0, 28, NULL, 0),
(2816, 0, -1, 1728683653, 0, 'Nautic Observer', 200000, 6, 0, 0, 0, 0, 220, NULL, 0),
(2817, 0, -1, 1728683653, 0, 'Nordic Stronghold', 250000, 6, 0, 0, 0, 0, 536, NULL, 0),
(2818, 0, -1, 1728683653, 0, 'Senja Clanhall', 250000, 6, 0, 0, 0, 0, 228, NULL, 0),
(2819, 0, -1, 1728683653, 0, 'Seawatch', 250000, 6, 0, 0, 0, 0, 431, NULL, 0),
(2820, 0, -1, 1728683653, 0, 'Dwarven Magnate\'s Estate', 300000, 7, 0, 0, 0, 0, 269, NULL, 0),
(2821, 0, -1, 1728683653, 0, 'Forge Master\'s Quarters', 300000, 7, 0, 0, 0, 0, 79, NULL, 0),
(2822, 0, -1, 1728683653, 0, 'Upper Barracks 13', 25000, 7, 0, 0, 0, 0, 16, NULL, 0),
(2823, 0, -1, 1728683653, 0, 'Upper Barracks 5', 80000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2824, 0, -1, 1728683653, 0, 'Upper Barracks 3', 80000, 7, 0, 0, 0, 0, 16, NULL, 0),
(2825, 0, -1, 1728683653, 0, 'Upper Barracks 4', 50000, 7, 0, 0, 0, 0, 16, NULL, 0),
(2826, 0, -1, 1728683653, 0, 'Upper Barracks 2', 80000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2827, 0, -1, 1728683653, 0, 'Upper Barracks 1', 50000, 7, 0, 0, 0, 0, 16, NULL, 0),
(2828, 0, -1, 1728683653, 0, 'Tunnel Gardens 9', 150000, 7, 0, 0, 0, 0, 74, NULL, 0),
(2829, 0, -1, 1728683653, 0, 'Tunnel Gardens 8', 25000, 7, 0, 0, 0, 0, 24, NULL, 0),
(2830, 0, -1, 1728683653, 0, 'Tunnel Gardens 7', 50000, 7, 0, 0, 0, 0, 21, NULL, 0),
(2831, 0, -1, 1728683653, 0, 'Tunnel Gardens 6', 25000, 7, 0, 0, 0, 0, 21, NULL, 0),
(2832, 0, -1, 1728683653, 0, 'Tunnel Gardens 5', 25000, 7, 0, 0, 0, 0, 21, NULL, 0),
(2835, 0, -1, 1728683653, 0, 'Tunnel Gardens 4', 80000, 7, 0, 0, 0, 0, 33, NULL, 0),
(2836, 0, -1, 1728683653, 0, 'Tunnel Gardens 2', 80000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2837, 0, -1, 1728683653, 0, 'Tunnel Gardens 1', 80000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2838, 0, -1, 1728683653, 0, 'Tunnel Gardens 3', 80000, 7, 0, 0, 0, 0, 33, NULL, 0),
(2839, 0, -1, 1728683653, 0, 'The Market 4 (Shop)', 80000, 7, 0, 0, 0, 0, 32, NULL, 0),
(2840, 0, -1, 1728683653, 0, 'The Market 3 (Shop)', 80000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2841, 0, -1, 1728683653, 0, 'The Market 2 (Shop)', 50000, 7, 0, 0, 0, 0, 23, NULL, 0),
(2842, 0, -1, 1728683653, 0, 'The Market 1 (Shop)', 25000, 7, 0, 0, 0, 0, 11, NULL, 0),
(2843, 0, -1, 1728683653, 0, 'The Farms 6, Fishing Hut', 50000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2844, 0, -1, 1728683653, 0, 'The Farms 5', 50000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2845, 0, -1, 1728683653, 0, 'The Farms 4', 25000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2846, 0, -1, 1728683653, 0, 'The Farms 3', 80000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2847, 0, -1, 1728683653, 0, 'The Farms 2', 50000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2849, 0, -1, 1728683653, 0, 'The Farms 1', 80000, 7, 0, 0, 0, 0, 57, NULL, 0),
(2850, 0, -1, 1728683653, 0, 'Outlaw Camp 14 (Shop)', 25000, 7, 0, 0, 0, 0, 31, NULL, 0),
(2852, 0, -1, 1728683653, 0, 'Outlaw Camp 13 (Shop)', 50000, 7, 0, 0, 0, 0, 33, NULL, 0),
(2853, 0, -1, 1728683653, 0, 'Outlaw Camp 9', 80000, 7, 0, 0, 0, 0, 36, NULL, 0),
(2854, 0, -1, 1728683653, 0, 'Outlaw Camp 7', 25000, 7, 0, 0, 0, 0, 33, NULL, 0),
(2855, 0, -1, 1728683653, 0, 'Outlaw Camp 4', 50000, 7, 0, 0, 0, 0, 31, NULL, 0),
(2856, 0, -1, 1728683653, 0, 'Outlaw Camp 2', 50000, 7, 0, 0, 0, 0, 33, NULL, 0),
(2857, 0, -1, 1728683653, 0, 'Outlaw Camp 3', 50000, 7, 0, 0, 0, 0, 29, NULL, 0),
(2858, 0, -1, 1728683653, 0, 'Outlaw Camp 1', 80000, 7, 0, 0, 0, 0, 47, NULL, 0),
(2859, 0, -1, 1728683653, 0, 'Nobility Quarter 5', 100000, 7, 0, 0, 0, 0, 141, NULL, 0),
(2860, 0, -1, 1728683653, 0, 'Nobility Quarter 4', 50000, 7, 0, 0, 0, 0, 65, NULL, 0),
(2861, 0, -1, 1728683653, 0, 'Nobility Quarter 3', 80000, 7, 0, 0, 0, 0, 51, NULL, 0),
(2862, 0, -1, 1728683653, 0, 'Nobility Quarter 2', 50000, 7, 0, 0, 0, 0, 58, NULL, 0),
(2863, 0, -1, 1728683653, 0, 'Nobility Quarter 1', 80000, 7, 0, 0, 0, 0, 63, NULL, 0),
(2864, 0, -1, 1728683653, 0, 'Lower Barracks 10', 80000, 7, 0, 0, 0, 0, 25, NULL, 0),
(2865, 0, -1, 1728683653, 0, 'Lower Barracks 9', 80000, 7, 0, 0, 0, 0, 25, NULL, 0),
(2866, 0, -1, 1728683653, 0, 'Lower Barracks 8', 80000, 7, 0, 0, 0, 0, 25, NULL, 0),
(2867, 0, -1, 1728683653, 0, 'Lower Barracks 1', 80000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2868, 0, -1, 1728683653, 0, 'Lower Barracks 2', 80000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2869, 0, -1, 1728683653, 0, 'Lower Barracks 3', 80000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2870, 0, -1, 1728683653, 0, 'Lower Barracks 4', 50000, 7, 0, 0, 0, 0, 28, NULL, 0),
(2871, 0, -1, 1728683653, 0, 'Lower Barracks 5', 100000, 7, 0, 0, 0, 0, 63, NULL, 0),
(2872, 0, -1, 1728683653, 0, 'Lower Barracks 6', 100000, 7, 0, 0, 0, 0, 63, NULL, 0),
(2873, 0, -1, 1728683653, 0, 'Lower Barracks 7', 80000, 7, 0, 0, 0, 0, 28, NULL, 0),
(2874, 0, -1, 1728683653, 0, 'Wolftower', 500000, 7, 0, 0, 0, 0, 402, NULL, 0),
(2875, 0, -1, 1728683653, 0, 'Riverspring', 250000, 7, 0, 0, 0, 0, 371, NULL, 0),
(2876, 0, -1, 1728683653, 0, 'Outlaw Castle', 250000, 7, 0, 0, 0, 0, 302, NULL, 0),
(2877, 0, -1, 1728683653, 0, 'Marble Guildhall', 250000, 7, 0, 0, 0, 0, 410, NULL, 0),
(2878, 0, -1, 1728683653, 0, 'Iron Guildhall', 250000, 7, 0, 0, 0, 0, 379, NULL, 0),
(2879, 0, -1, 1728683653, 0, 'Hill Hideout', 250000, 7, 0, 0, 0, 0, 247, NULL, 0),
(2880, 0, -1, 1728683653, 0, 'Granite Guildhall', 250000, 7, 0, 0, 0, 0, 506, NULL, 0),
(2881, 0, -1, 1728683653, 0, 'Alai Flats, Flat 01', 50000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2882, 0, -1, 1728683653, 0, 'Alai Flats, Flat 02', 50000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2883, 0, -1, 1728683653, 0, 'Alai Flats, Flat 03', 50000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2884, 0, -1, 1728683653, 0, 'Alai Flats, Flat 04', 80000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2885, 0, -1, 1728683653, 0, 'Alai Flats, Flat 05', 100000, 8, 0, 0, 0, 0, 28, NULL, 0),
(2886, 0, -1, 1728683653, 0, 'Alai Flats, Flat 06', 100000, 8, 0, 0, 0, 0, 25, NULL, 0),
(2887, 0, -1, 1728683653, 0, 'Alai Flats, Flat 07', 25000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2888, 0, -1, 1728683653, 0, 'Alai Flats, Flat 08', 50000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2889, 0, -1, 1728683653, 0, 'Alai Flats, Flat 11', 80000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2890, 0, -1, 1728683653, 0, 'Alai Flats, Flat 12', 25000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2891, 0, -1, 1728683653, 0, 'Alai Flats, Flat 13', 50000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2892, 0, -1, 1728683653, 0, 'Alai Flats, Flat 14', 80000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2893, 0, -1, 1728683653, 0, 'Alai Flats, Flat 15', 100000, 8, 0, 0, 0, 0, 34, NULL, 0),
(2894, 0, -1, 1728683653, 0, 'Alai Flats, Flat 16', 100000, 8, 0, 0, 0, 0, 31, NULL, 0),
(2895, 0, -1, 1728683653, 0, 'Alai Flats, Flat 17', 80000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2896, 0, -1, 1728683653, 0, 'Alai Flats, Flat 18', 50000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2897, 0, -1, 1728683653, 0, 'Alai Flats, Flat 21', 50000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2898, 0, -1, 1728683653, 0, 'Alai Flats, Flat 22', 50000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2899, 0, -1, 1728683653, 0, 'Alai Flats, Flat 23', 25000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2900, 0, -1, 1728683653, 0, 'Alai Flats, Flat 28', 80000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2901, 0, -1, 1728683653, 0, 'Alai Flats, Flat 27', 80000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2902, 0, -1, 1728683653, 0, 'Alai Flats, Flat 26', 100000, 8, 0, 0, 0, 0, 31, NULL, 0),
(2903, 0, -1, 1728683653, 0, 'Alai Flats, Flat 25', 100000, 8, 0, 0, 0, 0, 34, NULL, 0),
(2904, 0, -1, 1728683653, 0, 'Alai Flats, Flat 24', 80000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2905, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 01', 50000, 8, 0, 0, 0, 0, 16, NULL, 0),
(2906, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 02', 80000, 8, 0, 0, 0, 0, 16, NULL, 0),
(2907, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 03', 80000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2908, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 04', 50000, 8, 0, 0, 0, 0, 14, NULL, 0),
(2909, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 05', 80000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2910, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 06', 100000, 8, 0, 0, 0, 0, 24, NULL, 0),
(2911, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 11', 25000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2912, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 12', 50000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2913, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 13', 80000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2914, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 14', 25000, 8, 0, 0, 0, 0, 8, NULL, 0),
(2915, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 15', 25000, 8, 0, 0, 0, 0, 9, NULL, 0),
(2916, 0, -1, 1728683653, 0, 'Beach Home Apartments, Flat 16', 80000, 8, 0, 0, 0, 0, 21, NULL, 0),
(2917, 0, -1, 1728683653, 0, 'Demon Tower', 100000, 8, 0, 0, 0, 0, 75, NULL, 0),
(2918, 0, -1, 1728683653, 0, 'Farm Lane, 1st floor (Shop)', 80000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2919, 0, -1, 1728683653, 0, 'Farm Lane, 2nd Floor (Shop)', 50000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2920, 0, -1, 1728683653, 0, 'Farm Lane, Basement (Shop)', 50000, 8, 0, 0, 0, 0, 21, NULL, 0),
(2921, 0, -1, 1728683653, 0, 'Fibula Village 1', 25000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2922, 0, -1, 1728683653, 0, 'Fibula Village 2', 25000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2923, 0, -1, 1728683653, 0, 'Fibula Village 4', 25000, 8, 0, 0, 0, 0, 27, NULL, 0),
(2924, 0, -1, 1728683653, 0, 'Fibula Village 5', 50000, 8, 0, 0, 0, 0, 27, NULL, 0),
(2925, 0, -1, 1728683653, 0, 'Fibula Village 3', 80000, 8, 0, 0, 0, 0, 60, NULL, 0),
(2926, 0, -1, 1728683653, 0, 'Fibula Village, Tower Flat', 100000, 8, 0, 0, 0, 0, 94, NULL, 0),
(2927, 0, -1, 1728683653, 0, 'Guildhall of the Red Rose', 250000, 8, 0, 0, 0, 0, 396, NULL, 0),
(2928, 0, -1, 1728683653, 0, 'Fibula Village, Bar (Shop)', 100000, 8, 0, 0, 0, 0, 74, NULL, 0),
(2929, 0, -1, 1728683653, 0, 'Fibula Village, Villa', 200000, 8, 0, 0, 0, 0, 264, NULL, 0),
(2930, 0, -1, 1728683653, 0, 'Greenshore Village 1', 80000, 8, 0, 0, 0, 0, 39, NULL, 0),
(2931, 0, -1, 1728683653, 0, 'Greenshore Clanhall', 250000, 8, 0, 0, 0, 0, 176, NULL, 0),
(2932, 0, -1, 1728683653, 0, 'Castle of Greenshore', 250000, 8, 0, 0, 0, 0, 325, NULL, 0),
(2933, 0, -1, 1728683653, 0, 'Greenshore Village, Shop', 80000, 8, 0, 0, 0, 0, 31, NULL, 0),
(2934, 0, -1, 1728683653, 0, 'Greenshore Village, Villa', 300000, 8, 0, 0, 0, 0, 178, NULL, 0),
(2935, 0, -1, 1728683653, 0, 'Greenshore Village 7', 25000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2936, 0, -1, 1728683653, 0, 'Greenshore Village 3', 50000, 8, 0, 0, 0, 0, 30, NULL, 0),
(2939, 0, -1, 1728683653, 0, 'Greenshore Village 2', 50000, 8, 0, 0, 0, 0, 30, NULL, 0),
(2940, 0, -1, 1728683653, 0, 'Greenshore Village 6', 150000, 8, 0, 0, 0, 0, 79, NULL, 0),
(2941, 0, -1, 1733597121, 0, 'Harbour Place 1 (Shop)', 800000, 8, 0, 0, 0, 0, 21, NULL, 0),
(2942, 0, -1, 1728683653, 0, 'Harbour Place 2 (Shop)', 600000, 8, 0, 0, 0, 0, 25, NULL, 0),
(2943, 0, -1, 1728683653, 0, 'Harbour Place 3', 800000, 8, 0, 0, 0, 0, 88, NULL, 0),
(2944, 0, -1, 1728683653, 0, 'Harbour Place 4', 80000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2945, 0, -1, 1728683653, 0, 'Lower Swamp Lane 1', 400000, 8, 0, 0, 0, 0, 80, NULL, 0),
(2946, 0, -1, 1728683653, 0, 'Lower Swamp Lane 3', 400000, 8, 0, 0, 0, 0, 80, NULL, 0),
(2947, 0, -1, 1728683653, 0, 'Main Street 9, 1st floor (Shop)', 200000, 8, 0, 0, 0, 0, 30, NULL, 0),
(2948, 0, -1, 1728683653, 0, 'Main Street 9a, 2nd floor (Shop)', 100000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2949, 0, -1, 1728683653, 0, 'Main Street 9b, 2nd floor (Shop)', 150000, 8, 0, 0, 0, 0, 27, NULL, 0),
(2950, 0, -1, 1728683653, 0, 'Mill Avenue 1 (Shop)', 200000, 8, 0, 0, 0, 0, 28, NULL, 0),
(2951, 0, -1, 1728683653, 0, 'Mill Avenue 2 (Shop)', 200000, 8, 0, 0, 0, 0, 47, NULL, 0),
(2952, 0, -1, 1728683653, 0, 'Mill Avenue 3', 100000, 8, 0, 0, 0, 0, 32, NULL, 0),
(2953, 0, -1, 1728683653, 0, 'Mill Avenue 4', 100000, 8, 0, 0, 0, 0, 33, NULL, 0),
(2954, 0, -1, 1728683653, 0, 'Mill Avenue 5', 300000, 8, 0, 0, 0, 0, 69, NULL, 0),
(2955, 0, -1, 1728683653, 0, 'Open-Air Theatre', 150000, 8, 0, 0, 0, 0, 81, NULL, 0),
(2956, 0, -1, 1728683653, 0, 'Smuggler\'s Den', 400000, 8, 0, 0, 0, 0, 226, NULL, 0),
(2957, 0, -1, 1728683653, 0, 'Sorcerer\'s Avenue 1a', 100000, 8, 0, 0, 0, 0, 24, NULL, 0),
(2958, 0, -1, 1728683653, 0, 'Sorcerer\'s Avenue 5 (Shop)', 150000, 8, 0, 0, 0, 0, 54, NULL, 0),
(2959, 0, -1, 1728683653, 0, 'Sorcerer\'s Avenue 1b', 80000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2960, 0, -1, 1728683653, 0, 'Sorcerer\'s Avenue 1c', 100000, 8, 0, 0, 0, 0, 25, NULL, 0),
(2961, 0, -1, 1728683653, 0, 'Sorcerer\'s Avenue Labs 2a', 50000, 8, 0, 0, 0, 0, 29, NULL, 0),
(2962, 0, -1, 1728683653, 0, 'Sorcerer\'s Avenue Labs 2c', 50000, 8, 0, 0, 0, 0, 29, NULL, 0),
(2963, 0, -1, 1728683653, 0, 'Sorcerer\'s Avenue Labs 2b', 50000, 8, 0, 0, 0, 0, 29, NULL, 0),
(2964, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 01', 100000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2965, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 02', 80000, 8, 0, 0, 0, 0, 14, NULL, 0),
(2966, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 03', 80000, 8, 0, 0, 0, 0, 14, NULL, 0),
(2967, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 11', 80000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2968, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 12', 50000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2969, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 13', 100000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2970, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 14', 50000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2971, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 21', 50000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2972, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 22', 50000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2973, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 23', 80000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2974, 0, -1, 1728683653, 0, 'Sunset Homes, Flat 24', 50000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2975, 0, -1, 1728683653, 0, 'Thais Hostel', 200000, 8, 0, 0, 0, 0, 129, NULL, 0),
(2976, 0, -1, 1728683653, 0, 'The City Wall 1a', 150000, 8, 0, 0, 0, 0, 32, NULL, 0),
(2977, 0, -1, 1728683653, 0, 'The City Wall 1b', 100000, 8, 0, 0, 0, 0, 31, NULL, 0),
(2978, 0, -1, 1728683653, 0, 'The City Wall 3a', 100000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2979, 0, -1, 1728683653, 0, 'The City Wall 3b', 100000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2980, 0, -1, 1728683653, 0, 'The City Wall 3c', 100000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2981, 0, -1, 1728683653, 0, 'The City Wall 3d', 100000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2982, 0, -1, 1728683653, 0, 'The City Wall 3e', 100000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2983, 0, -1, 1728683653, 0, 'The City Wall 3f', 100000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2984, 0, -1, 1728683653, 0, 'Upper Swamp Lane 12', 300000, 8, 0, 0, 0, 0, 76, NULL, 0),
(2985, 0, -1, 1728683653, 0, 'Upper Swamp Lane 10', 150000, 8, 0, 0, 0, 0, 40, NULL, 0),
(2986, 0, -1, 1728683653, 0, 'Upper Swamp Lane 8', 600000, 8, 0, 0, 0, 0, 159, NULL, 0),
(2987, 0, -1, 1728683653, 0, 'Upper Swamp Lane 4', 600000, 8, 0, 0, 0, 0, 100, NULL, 0),
(2988, 0, -1, 1728683653, 0, 'Upper Swamp Lane 2', 600000, 8, 0, 0, 0, 0, 100, NULL, 0),
(2989, 0, -1, 1728683653, 0, 'The City Wall 9', 80000, 8, 0, 0, 0, 0, 25, NULL, 0),
(2990, 0, -1, 1728683653, 0, 'The City Wall 7h', 50000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2991, 0, -1, 1728683653, 0, 'The City Wall 7b', 25000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2992, 0, -1, 1728683653, 0, 'The City Wall 7d', 50000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2993, 0, -1, 1728683653, 0, 'The City Wall 7f', 80000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2994, 0, -1, 1728683653, 0, 'The City Wall 7c', 80000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2995, 0, -1, 1728683653, 0, 'The City Wall 7a', 80000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2996, 0, -1, 1728683653, 0, 'The City Wall 7g', 50000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2997, 0, -1, 1728683653, 0, 'The City Wall 7e', 80000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2998, 0, -1, 1728683653, 0, 'The City Wall 5b', 50000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2999, 0, -1, 1728683653, 0, 'The City Wall 5d', 50000, 8, 0, 0, 0, 0, 15, NULL, 0),
(3000, 0, -1, 1728683653, 0, 'The City Wall 5f', 25000, 8, 0, 0, 0, 0, 17, NULL, 0),
(3001, 0, -1, 1728683653, 0, 'The City Wall 5a', 50000, 8, 0, 0, 0, 0, 17, NULL, 0),
(3002, 0, -1, 1728683653, 0, 'The City Wall 5c', 50000, 8, 0, 0, 0, 0, 15, NULL, 0),
(3003, 0, -1, 1728683653, 0, 'The City Wall 5e', 50000, 8, 0, 0, 0, 0, 17, NULL, 0),
(3004, 0, -1, 1728683653, 0, 'Warriors\' Guildhall', 5000000, 8, 0, 0, 0, 0, 334, NULL, 0),
(3005, 0, -1, 1728683653, 0, 'The Tibianic', 500000, 8, 0, 0, 0, 0, 809, NULL, 0),
(3006, 0, -1, 1733625309, 0, 'Bloodhall', 500000, 8, 0, 0, 0, 0, 321, NULL, 0),
(3007, 0, -1, 1728683653, 0, 'Fibula Clanhall', 250000, 8, 0, 0, 0, 0, 178, NULL, 0),
(3008, 0, -1, 1728683653, 0, 'Dark Mansion', 1000000, 8, 0, 0, 0, 0, 375, NULL, 0),
(3009, 0, -1, 1728683653, 0, 'Halls of the Adventurers', 250000, 8, 0, 0, 0, 0, 317, NULL, 0),
(3010, 0, -1, 1728683653, 0, 'Mercenary Tower', 250000, 8, 0, 0, 0, 0, 619, NULL, 0),
(3011, 0, -1, 1728683653, 0, 'Snake Tower', 500000, 8, 0, 0, 0, 0, 627, NULL, 0),
(3012, 0, -1, 1728683653, 0, 'Southern Thais Guildhall', 1000000, 8, 0, 0, 0, 0, 374, NULL, 0),
(3013, 0, -1, 1728683653, 0, 'Spiritkeep', 500000, 8, 0, 0, 0, 0, 289, NULL, 0),
(3014, 0, -1, 1728683653, 0, 'Thais Clanhall', 500000, 8, 0, 0, 0, 0, 206, NULL, 0),
(3015, 0, -1, 1728683653, 0, 'The Lair', 200000, 9, 0, 0, 0, 0, 259, NULL, 0),
(3016, 0, -1, 1728683653, 0, 'Silver Street 4', 300000, 9, 0, 0, 0, 0, 119, NULL, 0),
(3017, 0, -1, 1728683653, 0, 'Dream Street 1 (Shop)', 600000, 9, 0, 0, 0, 0, 149, NULL, 0),
(3018, 0, -1, 1728683653, 0, 'Dagger Alley 1', 200000, 9, 0, 0, 0, 0, 103, NULL, 0),
(3019, 0, -1, 1728683653, 0, 'Dream Street 2', 400000, 9, 0, 0, 0, 0, 113, NULL, 0),
(3020, 0, -1, 1728683653, 0, 'Dream Street 3', 300000, 9, 0, 0, 0, 0, 104, NULL, 0),
(3021, 0, -1, 1728683653, 0, 'Elm Street 1', 300000, 9, 0, 0, 0, 0, 99, NULL, 0),
(3022, 0, -1, 1728683653, 0, 'Elm Street 3', 300000, 9, 0, 0, 0, 0, 107, NULL, 0),
(3023, 0, -1, 1728683653, 0, 'Elm Street 2', 300000, 9, 0, 0, 0, 0, 98, NULL, 0),
(3024, 0, -1, 1728683653, 0, 'Elm Street 4', 300000, 9, 0, 0, 0, 0, 108, NULL, 0),
(3025, 0, -1, 1728683653, 0, 'Seagull Walk 1', 800000, 9, 0, 0, 0, 0, 169, NULL, 0),
(3026, 0, -1, 1728683653, 0, 'Seagull Walk 2', 300000, 9, 0, 0, 0, 0, 102, NULL, 0),
(3027, 0, -1, 1728683653, 0, 'Dream Street 4', 400000, 9, 0, 0, 0, 0, 128, NULL, 0),
(3028, 0, -1, 1728683653, 0, 'Old Lighthouse', 200000, 9, 0, 0, 0, 0, 157, NULL, 0),
(3029, 0, -1, 1728683653, 0, 'Market Street 1', 600000, 9, 0, 0, 0, 0, 220, NULL, 0),
(3030, 0, -1, 1728683653, 0, 'Market Street 3', 600000, 9, 0, 0, 0, 0, 127, NULL, 0),
(3031, 0, -1, 1728683653, 0, 'Market Street 4 (Shop)', 800000, 9, 0, 0, 0, 0, 176, NULL, 0),
(3032, 0, -1, 1728683653, 0, 'Market Street 5 (Shop)', 800000, 9, 0, 0, 0, 0, 230, NULL, 0),
(3033, 0, -1, 1728683653, 0, 'Market Street 2', 600000, 9, 0, 0, 0, 0, 173, NULL, 0),
(3034, 0, -1, 1728683653, 0, 'Loot Lane 1 (Shop)', 600000, 9, 0, 0, 0, 0, 159, NULL, 0),
(3035, 0, -1, 1728683653, 0, 'Mystic Lane 1', 300000, 9, 0, 0, 0, 0, 92, NULL, 0),
(3036, 0, -1, 1728683653, 0, 'Mystic Lane 2', 200000, 9, 0, 0, 0, 0, 119, NULL, 0),
(3037, 0, -1, 1728683653, 0, 'Lucky Lane 2 (Tower)', 600000, 9, 0, 0, 0, 0, 216, NULL, 0),
(3038, 0, -1, 1728683653, 0, 'Lucky Lane 3 (Tower)', 600000, 9, 0, 0, 0, 0, 216, NULL, 0),
(3039, 0, -1, 1728683653, 0, 'Iron Alley 1', 300000, 9, 0, 0, 0, 0, 101, NULL, 0),
(3040, 0, -1, 1728683653, 0, 'Iron Alley 2', 300000, 9, 0, 0, 0, 0, 128, NULL, 0),
(3041, 0, -1, 1728683653, 0, 'Swamp Watch', 500000, 9, 0, 0, 0, 0, 379, NULL, 0),
(3042, 0, -1, 1728683653, 0, 'Golden Axe Guildhall', 500000, 9, 0, 0, 0, 0, 344, NULL, 0),
(3043, 0, -1, 1728683653, 0, 'Silver Street 1', 200000, 9, 0, 0, 0, 0, 108, NULL, 0),
(3044, 0, -1, 1728683653, 0, 'Valorous Venore', 500000, 9, 0, 0, 0, 0, 457, NULL, 0),
(3045, 0, -1, 1728683653, 0, 'Salvation Street 2', 300000, 9, 0, 0, 0, 0, 113, NULL, 0),
(3046, 0, -1, 1728683653, 0, 'Salvation Street 3', 300000, 9, 0, 0, 0, 0, 143, NULL, 0),
(3047, 0, -1, 1728683653, 0, 'Silver Street 2', 200000, 9, 0, 0, 0, 0, 76, NULL, 0),
(3048, 0, -1, 1728683653, 0, 'Silver Street 3', 200000, 9, 0, 0, 0, 0, 82, NULL, 0),
(3049, 0, -1, 1728683653, 0, 'Mystic Lane 3 (Tower)', 800000, 9, 0, 0, 0, 0, 214, NULL, 0),
(3050, 0, -1, 1728683653, 0, 'Market Street 7', 200000, 9, 0, 0, 0, 0, 90, NULL, 0),
(3051, 0, -1, 1728683653, 0, 'Market Street 6', 600000, 9, 0, 0, 0, 0, 186, NULL, 0),
(3052, 0, -1, 1728683653, 0, 'Iron Alley Watch, Upper', 600000, 9, 0, 0, 0, 0, 215, NULL, 0),
(3053, 0, -1, 1728683653, 0, 'Iron Alley Watch, Lower', 600000, 9, 0, 0, 0, 0, 217, NULL, 0),
(3054, 0, -1, 1728683653, 0, 'Blessed Shield Guildhall', 500000, 9, 0, 0, 0, 0, 250, NULL, 0),
(3055, 0, -1, 1728683653, 0, 'Steel Home', 500000, 9, 0, 0, 0, 0, 388, NULL, 0),
(3056, 0, -1, 1728683653, 0, 'Salvation Street 1 (Shop)', 600000, 9, 0, 0, 0, 0, 215, NULL, 0),
(3057, 0, -1, 1728683653, 0, 'Lucky Lane 1 (Shop)', 800000, 9, 0, 0, 0, 0, 220, NULL, 0),
(3058, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 34', 100000, 9, 0, 0, 0, 0, 59, NULL, 0),
(3059, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 33', 50000, 9, 0, 0, 0, 0, 35, NULL, 0),
(3060, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 32', 100000, 9, 0, 0, 0, 0, 50, NULL, 0),
(3061, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 31', 80000, 9, 0, 0, 0, 0, 40, NULL, 0),
(3062, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 28', 25000, 9, 0, 0, 0, 0, 13, NULL, 0),
(3063, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 26', 25000, 9, 0, 0, 0, 0, 19, NULL, 0),
(3064, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 24', 25000, 9, 0, 0, 0, 0, 19, NULL, 0),
(3065, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 22', 25000, 9, 0, 0, 0, 0, 19, NULL, 0),
(3066, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 21', 25000, 9, 0, 0, 0, 0, 18, NULL, 0),
(3067, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 27', 50000, 9, 0, 0, 0, 0, 23, NULL, 0),
(3068, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 25', 50000, 9, 0, 0, 0, 0, 24, NULL, 0),
(3069, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 23', 50000, 9, 0, 0, 0, 0, 29, NULL, 0),
(3070, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 11', 25000, 9, 0, 0, 0, 0, 14, NULL, 0),
(3071, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 13', 50000, 9, 0, 0, 0, 0, 20, NULL, 0),
(3072, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 15', 50000, 9, 0, 0, 0, 0, 20, NULL, 0),
(3073, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 17', 25000, 9, 0, 0, 0, 0, 20, NULL, 0),
(3074, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 18', 25000, 9, 0, 0, 0, 0, 20, NULL, 0),
(3075, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 12', 50000, 9, 0, 0, 0, 0, 25, NULL, 0),
(3076, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 14', 50000, 9, 0, 0, 0, 0, 25, NULL, 0),
(3077, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 16', 50000, 9, 0, 0, 0, 0, 30, NULL, 0),
(3078, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 06', 25000, 9, 0, 0, 0, 0, 11, NULL, 0),
(3079, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 05', 25000, 9, 0, 0, 0, 0, 9, NULL, 0),
(3080, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 04', 25000, 9, 0, 0, 0, 0, 17, NULL, 0),
(3081, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 07', 50000, 9, 0, 0, 0, 0, 14, NULL, 0),
(3082, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 03', 25000, 9, 0, 0, 0, 0, 11, NULL, 0),
(3083, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 02', 25000, 9, 0, 0, 0, 0, 14, NULL, 0),
(3084, 0, -1, 1728683653, 0, 'Paupers Palace, Flat 01', 25000, 9, 0, 0, 0, 0, 15, NULL, 0),
(3085, 0, -1, 1728683653, 0, 'Castle, Residence', 600000, 11, 0, 0, 0, 0, 104, NULL, 0),
(3086, 0, -1, 1728683653, 0, 'Castle, 3rd Floor, Flat 07', 80000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3087, 0, -1, 1728683653, 0, 'Castle, 3rd Floor, Flat 04', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3088, 0, -1, 1728683653, 0, 'Castle, 3rd Floor, Flat 03', 50000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3089, 0, -1, 1728683653, 0, 'Castle, 3rd Floor, Flat 06', 100000, 11, 0, 0, 0, 0, 22, NULL, 0),
(3090, 0, -1, 1728683653, 0, 'Castle, 3rd Floor, Flat 05', 80000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3091, 0, -1, 1728683653, 0, 'Castle, 3rd Floor, Flat 02', 80000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3092, 0, -1, 1728683653, 0, 'Castle, 3rd Floor, Flat 01', 50000, 11, 0, 0, 0, 0, 15, NULL, 0),
(3093, 0, -1, 1728683653, 0, 'Castle, 4th Floor, Flat 09', 50000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3094, 0, -1, 1728683653, 0, 'Castle, 4th Floor, Flat 08', 80000, 11, 0, 0, 0, 0, 22, NULL, 0),
(3095, 0, -1, 1728683653, 0, 'Castle, 4th Floor, Flat 07', 80000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3096, 0, -1, 1728683653, 0, 'Castle, 4th Floor, Flat 04', 50000, 11, 0, 0, 0, 0, 14, NULL, 0),
(3097, 0, -1, 1728683653, 0, 'Castle, 4th Floor, Flat 03', 50000, 11, 0, 0, 0, 0, 14, NULL, 0),
(3098, 0, -1, 1728683653, 0, 'Castle, 4th Floor, Flat 06', 100000, 11, 0, 0, 0, 0, 21, NULL, 0),
(3099, 0, -1, 1728683653, 0, 'Castle, 4th Floor, Flat 05', 80000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3100, 0, -1, 1728683653, 0, 'Castle, 4th Floor, Flat 02', 80000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3101, 0, -1, 1728683653, 0, 'Castle, 4th Floor, Flat 01', 50000, 11, 0, 0, 0, 0, 14, NULL, 0),
(3102, 0, -1, 1728683653, 0, 'Castle Street 2', 150000, 11, 0, 0, 0, 0, 35, NULL, 0),
(3103, 0, -1, 1728683653, 0, 'Castle Street 3', 150000, 11, 0, 0, 0, 0, 41, NULL, 0),
(3104, 0, -1, 1728683653, 0, 'Castle Street 4', 150000, 11, 0, 0, 0, 0, 40, NULL, 0),
(3105, 0, -1, 1728683653, 0, 'Castle Street 5', 150000, 11, 0, 0, 0, 0, 40, NULL, 0),
(3106, 0, -1, 1728683653, 0, 'Castle Street 1', 300000, 11, 0, 0, 0, 0, 71, NULL, 0),
(3107, 0, -1, 1728683653, 0, 'Edron Flats, Flat 08', 25000, 11, 0, 0, 0, 0, 10, NULL, 0),
(3108, 0, -1, 1728683653, 0, 'Edron Flats, Flat 05', 25000, 11, 0, 0, 0, 0, 10, NULL, 0),
(3109, 0, -1, 1728683653, 0, 'Edron Flats, Flat 04', 25000, 11, 0, 0, 0, 0, 10, NULL, 0),
(3110, 0, -1, 1728683653, 0, 'Edron Flats, Flat 01', 50000, 11, 0, 0, 0, 0, 11, NULL, 0),
(3111, 0, -1, 1728683653, 0, 'Edron Flats, Flat 07', 25000, 11, 0, 0, 0, 0, 11, NULL, 0),
(3112, 0, -1, 1728683653, 0, 'Edron Flats, Flat 06', 25000, 11, 0, 0, 0, 0, 11, NULL, 0),
(3113, 0, -1, 1728683653, 0, 'Edron Flats, Flat 03', 25000, 11, 0, 0, 0, 0, 11, NULL, 0),
(3114, 0, -1, 1728683653, 0, 'Edron Flats, Flat 02', 100000, 11, 0, 0, 0, 0, 20, NULL, 0),
(3115, 0, -1, 1728683653, 0, 'Edron Flats, Basement Flat 2', 100000, 11, 0, 0, 0, 0, 36, NULL, 0),
(3116, 0, -1, 1728683653, 0, 'Edron Flats, Basement Flat 1', 100000, 11, 0, 0, 0, 0, 36, NULL, 0),
(3119, 0, -1, 1728683653, 0, 'Edron Flats, Flat 13', 80000, 11, 0, 0, 0, 0, 22, NULL, 0),
(3121, 0, -1, 1728683653, 0, 'Edron Flats, Flat 14', 100000, 11, 0, 0, 0, 0, 31, NULL, 0),
(3123, 0, -1, 1728683653, 0, 'Edron Flats, Flat 12', 80000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3124, 0, -1, 1728683653, 0, 'Edron Flats, Flat 11', 100000, 11, 0, 0, 0, 0, 32, NULL, 0),
(3125, 0, -1, 1728683653, 0, 'Edron Flats, Flat 25', 80000, 11, 0, 0, 0, 0, 31, NULL, 0),
(3127, 0, -1, 1728683653, 0, 'Edron Flats, Flat 24', 80000, 11, 0, 0, 0, 0, 22, NULL, 0),
(3128, 0, -1, 1728683653, 0, 'Edron Flats, Flat 21', 80000, 11, 0, 0, 0, 0, 20, NULL, 0),
(3131, 0, -1, 1728683653, 0, 'Edron Flats, Flat 23', 80000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3133, 0, -1, 1728683653, 0, 'Castle Shop 1', 400000, 11, 0, 0, 0, 0, 38, NULL, 0),
(3134, 0, -1, 1728683653, 0, 'Castle Shop 2', 400000, 11, 0, 0, 0, 0, 38, NULL, 0),
(3135, 0, -1, 1728683653, 0, 'Castle Shop 3', 300000, 11, 0, 0, 0, 0, 38, NULL, 0),
(3136, 0, -1, 1728683653, 0, 'Central Circle 1', 800000, 11, 0, 0, 0, 0, 76, NULL, 0),
(3137, 0, -1, 1728683653, 0, 'Central Circle 2', 800000, 11, 0, 0, 0, 0, 90, NULL, 0),
(3138, 0, -1, 1728683653, 0, 'Central Circle 3', 800000, 11, 0, 0, 0, 0, 99, NULL, 0),
(3139, 0, -1, 1728683653, 0, 'Central Circle 4', 800000, 11, 0, 0, 0, 0, 97, NULL, 0),
(3140, 0, -1, 1728683653, 0, 'Central Circle 5', 800000, 11, 0, 0, 0, 0, 99, NULL, 0),
(3141, 0, -1, 1728683653, 0, 'Central Circle 8 (Shop)', 400000, 11, 0, 0, 0, 0, 101, NULL, 0),
(3142, 0, -1, 1728683653, 0, 'Central Circle 7 (Shop)', 400000, 11, 0, 0, 0, 0, 101, NULL, 0),
(3143, 0, -1, 1728683653, 0, 'Central Circle 6 (Shop)', 400000, 11, 0, 0, 0, 0, 101, NULL, 0),
(3144, 0, -1, 1728683653, 0, 'Central Circle 9a', 150000, 11, 0, 0, 0, 0, 23, NULL, 0),
(3145, 0, -1, 1728683653, 0, 'Central Circle 9b', 150000, 11, 0, 0, 0, 0, 23, NULL, 0),
(3146, 0, -1, 1728683653, 0, 'Sky Lane, Guild 1', 1000000, 11, 0, 0, 0, 0, 459, NULL, 0),
(3147, 0, -1, 1728683653, 0, 'Sky Lane, Sea Tower', 300000, 11, 0, 0, 0, 0, 106, NULL, 0),
(3148, 0, -1, 1728683653, 0, 'Sky Lane, Guild 3', 1000000, 11, 0, 0, 0, 0, 391, NULL, 0),
(3149, 0, -1, 1728683653, 0, 'Sky Lane, Guild 2', 1000000, 11, 0, 0, 0, 0, 440, NULL, 0),
(3150, 0, -1, 1728683653, 0, 'Wood Avenue 11', 600000, 11, 0, 0, 0, 0, 165, NULL, 0),
(3151, 0, -1, 1728683653, 0, 'Wood Avenue 8', 800000, 11, 0, 0, 0, 0, 147, NULL, 0),
(3152, 0, -1, 1728683653, 0, 'Wood Avenue 7', 800000, 11, 0, 0, 0, 0, 145, NULL, 0),
(3153, 0, -1, 1728683653, 0, 'Wood Avenue 10a', 200000, 11, 0, 0, 0, 0, 35, NULL, 0),
(3154, 0, -1, 1728683653, 0, 'Wood Avenue 9a', 200000, 11, 0, 0, 0, 0, 33, NULL, 0),
(3155, 0, -1, 1728683653, 0, 'Wood Avenue 6a', 300000, 11, 0, 0, 0, 0, 34, NULL, 0),
(3156, 0, -1, 1728683653, 0, 'Wood Avenue 6b', 200000, 11, 0, 0, 0, 0, 35, NULL, 0),
(3157, 0, -1, 1728683653, 0, 'Wood Avenue 9b', 200000, 11, 0, 0, 0, 0, 33, NULL, 0),
(3158, 0, -1, 1728683653, 0, 'Wood Avenue 10b', 200000, 11, 0, 0, 0, 0, 35, NULL, 0),
(3159, 0, -1, 1728683653, 0, 'Stronghold', 800000, 11, 0, 0, 0, 0, 194, NULL, 0),
(3160, 0, -1, 1728683653, 0, 'Wood Avenue 5', 300000, 11, 0, 0, 0, 0, 40, NULL, 0),
(3161, 0, -1, 1728683653, 0, 'Wood Avenue 3', 200000, 11, 0, 0, 0, 0, 39, NULL, 0),
(3162, 0, -1, 1728683653, 0, 'Wood Avenue 4', 200000, 11, 0, 0, 0, 0, 40, NULL, 0),
(3163, 0, -1, 1728683653, 0, 'Wood Avenue 2', 200000, 11, 0, 0, 0, 0, 39, NULL, 0),
(3164, 0, -1, 1728683653, 0, 'Wood Avenue 1', 200000, 11, 0, 0, 0, 0, 41, NULL, 0),
(3165, 0, -1, 1728683653, 0, 'Wood Avenue 4c', 200000, 11, 0, 0, 0, 0, 41, NULL, 0),
(3166, 0, -1, 1728683653, 0, 'Wood Avenue 4a', 150000, 11, 0, 0, 0, 0, 33, NULL, 0),
(3167, 0, -1, 1728683653, 0, 'Wood Avenue 4b', 150000, 11, 0, 0, 0, 0, 35, NULL, 0),
(3168, 0, -1, 1728683653, 0, 'Stonehome Village 1', 150000, 11, 0, 0, 0, 0, 45, NULL, 0),
(3169, 0, -1, 1728683653, 0, 'Stonehome Flats, Flat 04', 80000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3171, 0, -1, 1728683653, 0, 'Stonehome Flats, Flat 03', 80000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3173, 0, -1, 1728683653, 0, 'Stonehome Flats, Flat 02', 25000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3174, 0, -1, 1728683653, 0, 'Stonehome Flats, Flat 01', 25000, 11, 0, 0, 0, 0, 11, NULL, 0),
(3175, 0, -1, 1728683653, 0, 'Stonehome Flats, Flat 13', 80000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3177, 0, -1, 1728683653, 0, 'Stonehome Flats, Flat 11', 50000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3178, 0, -1, 1728683653, 0, 'Stonehome Flats, Flat 14', 80000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3180, 0, -1, 1728683653, 0, 'Stonehome Flats, Flat 12', 50000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3181, 0, -1, 1728683653, 0, 'Stonehome Village 2', 50000, 11, 0, 0, 0, 0, 19, NULL, 0),
(3182, 0, -1, 1728683653, 0, 'Stonehome Village 3', 50000, 11, 0, 0, 0, 0, 20, NULL, 0),
(3183, 0, -1, 1728683653, 0, 'Stonehome Village 4', 80000, 11, 0, 0, 0, 0, 23, NULL, 0),
(3184, 0, -1, 1728683653, 0, 'Stonehome Village 6', 100000, 11, 0, 0, 0, 0, 34, NULL, 0),
(3185, 0, -1, 1728683653, 0, 'Stonehome Village 5', 80000, 11, 0, 0, 0, 0, 29, NULL, 0),
(3186, 0, -1, 1728683653, 0, 'Stonehome Village 7', 100000, 11, 0, 0, 0, 0, 28, NULL, 0),
(3187, 0, -1, 1728683653, 0, 'Stonehome Village 8', 25000, 11, 0, 0, 0, 0, 19, NULL, 0),
(3188, 0, -1, 1728683653, 0, 'Stonehome Village 9', 50000, 11, 0, 0, 0, 0, 19, NULL, 0),
(3189, 0, -1, 1728683653, 0, 'Stonehome Clanhall', 250000, 11, 0, 0, 0, 0, 205, NULL, 0),
(3190, 0, -1, 1728683653, 0, 'Mad Scientist\'s Lab', 600000, 17, 0, 0, 0, 0, 63, NULL, 0),
(3191, 0, -1, 1728683653, 0, 'Radiant Plaza 4', 800000, 17, 0, 0, 0, 0, 197, NULL, 0),
(3192, 0, -1, 1728683653, 0, 'Radiant Plaza 3', 800000, 17, 0, 0, 0, 0, 126, NULL, 0),
(3193, 0, -1, 1728683653, 0, 'Radiant Plaza 2', 600000, 17, 0, 0, 0, 0, 99, NULL, 0),
(3194, 0, -1, 1728683653, 0, 'Radiant Plaza 1', 800000, 17, 0, 0, 0, 0, 138, NULL, 0),
(3195, 0, -1, 1728683653, 0, 'Aureate Court 3', 400000, 17, 0, 0, 0, 0, 131, NULL, 0),
(3196, 0, -1, 1728683653, 0, 'Aureate Court 4', 400000, 17, 0, 0, 0, 0, 104, NULL, 0),
(3197, 0, -1, 1728683653, 0, 'Aureate Court 5', 600000, 17, 0, 0, 0, 0, 138, NULL, 0),
(3198, 0, -1, 1728683653, 0, 'Aureate Court 2', 400000, 17, 0, 0, 0, 0, 125, NULL, 0),
(3199, 0, -1, 1728683653, 0, 'Aureate Court 1', 600000, 17, 0, 0, 0, 0, 131, NULL, 0),
(3205, 0, -1, 1728683653, 0, 'Halls of Serenity', 5000000, 17, 0, 0, 0, 0, 517, NULL, 0),
(3206, 0, -1, 1728683653, 0, 'Fortune Wing 3', 600000, 17, 0, 0, 0, 0, 148, NULL, 0),
(3207, 0, -1, 1728683653, 0, 'Fortune Wing 4', 600000, 17, 0, 0, 0, 0, 147, NULL, 0),
(3208, 0, -1, 1728683653, 0, 'Fortune Wing 2', 600000, 17, 0, 0, 0, 0, 148, NULL, 0),
(3209, 0, -1, 1728683653, 0, 'Fortune Wing 1', 800000, 17, 0, 0, 0, 0, 254, NULL, 0),
(3211, 0, -1, 1728683653, 0, 'Cascade Towers', 5000000, 17, 0, 0, 0, 0, 419, NULL, 0),
(3212, 0, -1, 1728683653, 0, 'Luminous Arc 5', 800000, 17, 0, 0, 0, 0, 145, NULL, 0),
(3213, 0, -1, 1728683653, 0, 'Luminous Arc 2', 600000, 17, 0, 0, 0, 0, 161, NULL, 0),
(3214, 0, -1, 1728683653, 0, 'Luminous Arc 1', 800000, 17, 0, 0, 0, 0, 167, NULL, 0),
(3215, 0, -1, 1728683653, 0, 'Luminous Arc 3', 600000, 17, 0, 0, 0, 0, 139, NULL, 0),
(3216, 0, -1, 1728683653, 0, 'Luminous Arc 4', 800000, 17, 0, 0, 0, 0, 200, NULL, 0),
(3217, 0, -1, 1728683653, 0, 'Harbour Promenade 1', 800000, 17, 0, 0, 0, 0, 137, NULL, 0),
(3218, 0, -1, 1728683653, 0, 'Sun Palace', 5000000, 17, 0, 0, 0, 0, 533, NULL, 0),
(3219, 0, -1, 1728683653, 0, 'Haggler\'s Hangout 3', 300000, 15, 0, 0, 0, 0, 186, NULL, 0),
(3220, 0, -1, 1728683653, 0, 'Haggler\'s Hangout 7', 400000, 15, 0, 0, 0, 0, 155, NULL, 0),
(3221, 0, -1, 1728683653, 0, 'Big Game Hunter\'s Lodge', 600000, 15, 0, 0, 0, 0, 164, NULL, 0),
(3222, 0, -1, 1728683653, 0, 'Haggler\'s Hangout 6', 400000, 15, 0, 0, 0, 0, 143, NULL, 0),
(3223, 0, -1, 1728683653, 0, 'Haggler\'s Hangout 5 (Shop)', 200000, 15, 0, 0, 0, 0, 42, NULL, 0);
INSERT INTO `houses` (`id`, `owner`, `new_owner`, `paid`, `warnings`, `name`, `rent`, `town_id`, `bid`, `bid_end`, `last_bid`, `highest_bidder`, `size`, `guildid`, `beds`) VALUES
(3224, 0, -1, 1728683653, 0, 'Haggler\'s Hangout 4b (Shop)', 150000, 15, 0, 0, 0, 0, 34, NULL, 0),
(3225, 0, -1, 1728683653, 0, 'Haggler\'s Hangout 4a (Shop)', 200000, 15, 0, 0, 0, 0, 44, NULL, 0),
(3226, 0, -1, 1728683653, 0, 'Haggler\'s Hangout 2', 100000, 15, 0, 0, 0, 0, 35, NULL, 0),
(3227, 0, -1, 1728683653, 0, 'Haggler\'s Hangout 1', 100000, 15, 0, 0, 0, 0, 37, NULL, 0),
(3228, 0, -1, 1728683653, 0, 'Bamboo Garden 3', 150000, 15, 0, 0, 0, 0, 44, NULL, 0),
(3229, 0, -1, 1728683653, 0, 'Bamboo Fortress', 500000, 15, 0, 0, 0, 0, 531, NULL, 0),
(3230, 0, -1, 1728683653, 0, 'Bamboo Garden 2', 80000, 15, 0, 0, 0, 0, 30, NULL, 0),
(3231, 0, -1, 1728683653, 0, 'Bamboo Garden 1', 100000, 15, 0, 0, 0, 0, 44, NULL, 0),
(3232, 0, -1, 1728683653, 0, 'Banana Bay 4', 25000, 15, 0, 0, 0, 0, 17, NULL, 0),
(3233, 0, -1, 1728683653, 0, 'Banana Bay 2', 50000, 15, 0, 0, 0, 0, 27, NULL, 0),
(3234, 0, -1, 1728683653, 0, 'Banana Bay 3', 50000, 15, 0, 0, 0, 0, 18, NULL, 0),
(3235, 0, -1, 1728683653, 0, 'Banana Bay 1', 25000, 15, 0, 0, 0, 0, 17, NULL, 0),
(3236, 0, -1, 1728683653, 0, 'Crocodile Bridge 1', 80000, 15, 0, 0, 0, 0, 29, NULL, 0),
(3237, 0, -1, 1728683653, 0, 'Crocodile Bridge 2', 80000, 15, 0, 0, 0, 0, 25, NULL, 0),
(3238, 0, -1, 1728683653, 0, 'Crocodile Bridge 3', 100000, 15, 0, 0, 0, 0, 34, NULL, 0),
(3239, 0, -1, 1728683653, 0, 'Crocodile Bridge 4', 300000, 15, 0, 0, 0, 0, 119, NULL, 0),
(3240, 0, -1, 1728683653, 0, 'Crocodile Bridge 5', 200000, 15, 0, 0, 0, 0, 102, NULL, 0),
(3241, 0, -1, 1728683653, 0, 'Woodway 1', 80000, 15, 0, 0, 0, 0, 18, NULL, 0),
(3242, 0, -1, 1728683653, 0, 'Woodway 2', 50000, 15, 0, 0, 0, 0, 17, NULL, 0),
(3243, 0, -1, 1728683653, 0, 'Woodway 3', 150000, 15, 0, 0, 0, 0, 42, NULL, 0),
(3244, 0, -1, 1728683653, 0, 'Woodway 4', 25000, 15, 0, 0, 0, 0, 17, NULL, 0),
(3245, 0, -1, 1728683653, 0, 'Flamingo Flats 5', 150000, 15, 0, 0, 0, 0, 53, NULL, 0),
(3246, 0, -1, 1728683653, 0, 'Flamingo Flats 4', 80000, 15, 0, 0, 0, 0, 23, NULL, 0),
(3247, 0, -1, 1728683653, 0, 'Flamingo Flats 1', 50000, 15, 0, 0, 0, 0, 19, NULL, 0),
(3248, 0, -1, 1728683653, 0, 'Flamingo Flats 2', 80000, 15, 0, 0, 0, 0, 28, NULL, 0),
(3249, 0, -1, 1728683653, 0, 'Flamingo Flats 3', 50000, 15, 0, 0, 0, 0, 20, NULL, 0),
(3250, 0, -1, 1728683653, 0, 'Jungle Edge 1', 200000, 15, 0, 0, 0, 0, 63, NULL, 0),
(3251, 0, -1, 1728683653, 0, 'Jungle Edge 2', 200000, 15, 0, 0, 0, 0, 89, NULL, 0),
(3252, 0, -1, 1728683653, 0, 'Jungle Edge 4', 80000, 15, 0, 0, 0, 0, 23, NULL, 0),
(3253, 0, -1, 1728683653, 0, 'Jungle Edge 5', 80000, 15, 0, 0, 0, 0, 27, NULL, 0),
(3254, 0, -1, 1728683653, 0, 'Jungle Edge 6', 25000, 15, 0, 0, 0, 0, 17, NULL, 0),
(3255, 0, -1, 1728683653, 0, 'Jungle Edge 3', 80000, 15, 0, 0, 0, 0, 27, NULL, 0),
(3256, 0, -1, 1728683653, 0, 'River Homes 3', 200000, 15, 0, 0, 0, 0, 111, NULL, 0),
(3257, 0, -1, 1728683653, 0, 'River Homes 2b', 150000, 15, 0, 0, 0, 0, 37, NULL, 0),
(3258, 0, -1, 1728683653, 0, 'River Homes 2a', 100000, 15, 0, 0, 0, 0, 33, NULL, 0),
(3259, 0, -1, 1728683653, 0, 'River Homes 1', 300000, 15, 0, 0, 0, 0, 96, NULL, 0),
(3260, 0, -1, 1728683653, 0, 'Coconut Quay 4', 150000, 15, 0, 0, 0, 0, 52, NULL, 0),
(3261, 0, -1, 1728683653, 0, 'Coconut Quay 3', 200000, 15, 0, 0, 0, 0, 50, NULL, 0),
(3262, 0, -1, 1728683653, 0, 'Coconut Quay 2', 100000, 15, 0, 0, 0, 0, 27, NULL, 0),
(3263, 0, -1, 1728683653, 0, 'Coconut Quay 1', 150000, 15, 0, 0, 0, 0, 47, NULL, 0),
(3264, 0, -1, 1728683653, 0, 'Shark Manor', 250000, 15, 0, 0, 0, 0, 173, NULL, 0),
(3265, 0, -1, 1728683653, 0, 'Glacier Side 2', 300000, 16, 0, 0, 0, 0, 102, NULL, 0),
(3266, 0, -1, 1728683653, 0, 'Glacier Side 1', 150000, 16, 0, 0, 0, 0, 34, NULL, 0),
(3267, 0, -1, 1728683653, 0, 'Glacier Side 3', 150000, 16, 0, 0, 0, 0, 41, NULL, 0),
(3268, 0, -1, 1728683653, 0, 'Glacier Side 4', 150000, 16, 0, 0, 0, 0, 46, NULL, 0),
(3269, 0, -1, 1728683653, 0, 'Shelf Site', 300000, 16, 0, 0, 0, 0, 98, NULL, 0),
(3270, 0, -1, 1728683653, 0, 'Spirit Homes 5', 150000, 16, 0, 0, 0, 0, 29, NULL, 0),
(3271, 0, -1, 1728683653, 0, 'Spirit Homes 4', 80000, 16, 0, 0, 0, 0, 24, NULL, 0),
(3272, 0, -1, 1728683653, 0, 'Spirit Homes 1', 150000, 16, 0, 0, 0, 0, 35, NULL, 0),
(3273, 0, -1, 1728683653, 0, 'Spirit Homes 2', 150000, 16, 0, 0, 0, 0, 39, NULL, 0),
(3274, 0, -1, 1728683653, 0, 'Spirit Homes 3', 300000, 16, 0, 0, 0, 0, 90, NULL, 0),
(3275, 0, -1, 1728683653, 0, 'Arena Walk 3', 300000, 16, 0, 0, 0, 0, 74, NULL, 0),
(3276, 0, -1, 1728683653, 0, 'Arena Walk 2', 150000, 16, 0, 0, 0, 0, 29, NULL, 0),
(3277, 0, -1, 1728683653, 0, 'Arena Walk 1', 300000, 16, 0, 0, 0, 0, 67, NULL, 0),
(3278, 0, -1, 1728683653, 0, 'Bears Paw 2', 300000, 16, 0, 0, 0, 0, 54, NULL, 0),
(3279, 0, -1, 1728683653, 0, 'Bears Paw 1', 200000, 16, 0, 0, 0, 0, 42, NULL, 0),
(3280, 0, -1, 1728683653, 0, 'Crystal Glance', 1000000, 16, 0, 0, 0, 0, 321, NULL, 0),
(3281, 0, -1, 1728683653, 0, 'Shady Rocks 2', 200000, 16, 0, 0, 0, 0, 41, NULL, 0),
(3282, 0, -1, 1728683653, 0, 'Shady Rocks 1', 300000, 16, 0, 0, 0, 0, 79, NULL, 0),
(3283, 0, -1, 1728683653, 0, 'Shady Rocks 3', 300000, 16, 0, 0, 0, 0, 94, NULL, 0),
(3284, 0, -1, 1728683653, 0, 'Shady Rocks 4 (Shop)', 200000, 16, 0, 0, 0, 0, 61, NULL, 0),
(3285, 0, -1, 1728683653, 0, 'Shady Rocks 5', 300000, 16, 0, 0, 0, 0, 66, NULL, 0),
(3286, 0, -1, 1728683653, 0, 'Tusk Flats 2', 80000, 16, 0, 0, 0, 0, 28, NULL, 0),
(3287, 0, -1, 1728683653, 0, 'Tusk Flats 1', 80000, 16, 0, 0, 0, 0, 25, NULL, 0),
(3288, 0, -1, 1728683653, 0, 'Tusk Flats 3', 80000, 16, 0, 0, 0, 0, 26, NULL, 0),
(3289, 0, -1, 1728683653, 0, 'Tusk Flats 4', 25000, 16, 0, 0, 0, 0, 13, NULL, 0),
(3290, 0, -1, 1728683653, 0, 'Tusk Flats 6', 50000, 16, 0, 0, 0, 0, 23, NULL, 0),
(3291, 0, -1, 1728683653, 0, 'Tusk Flats 5', 25000, 16, 0, 0, 0, 0, 18, NULL, 0),
(3292, 0, -1, 1728683653, 0, 'Corner Shop (Shop)', 200000, 16, 0, 0, 0, 0, 50, NULL, 0),
(3293, 0, -1, 1728683653, 0, 'Bears Paw 5', 200000, 16, 0, 0, 0, 0, 45, NULL, 0),
(3294, 0, -1, 1728683653, 0, 'Bears Paw 4', 400000, 16, 0, 0, 0, 0, 119, NULL, 0),
(3295, 0, -1, 1728683653, 0, 'Trout Plaza 2', 150000, 16, 0, 0, 0, 0, 36, NULL, 0),
(3296, 0, -1, 1728683653, 0, 'Trout Plaza 1', 200000, 16, 0, 0, 0, 0, 56, NULL, 0),
(3297, 0, -1, 1728683653, 0, 'Trout Plaza 5 (Shop)', 300000, 16, 0, 0, 0, 0, 89, NULL, 0),
(3298, 0, -1, 1728683653, 0, 'Trout Plaza 3', 80000, 16, 0, 0, 0, 0, 22, NULL, 0),
(3299, 0, -1, 1728683653, 0, 'Trout Plaza 4', 80000, 16, 0, 0, 0, 0, 22, NULL, 0),
(3300, 0, -1, 1728683653, 0, 'Skiffs End 2', 80000, 16, 0, 0, 0, 0, 21, NULL, 0),
(3301, 0, -1, 1728683653, 0, 'Skiffs End 1', 100000, 16, 0, 0, 0, 0, 35, NULL, 0),
(3302, 0, -1, 1728683653, 0, 'Furrier Quarter 3', 100000, 16, 0, 0, 0, 0, 40, NULL, 0),
(3303, 0, -1, 1728683653, 0, 'Fimbul Shelf 4', 100000, 16, 0, 0, 0, 0, 42, NULL, 0),
(3304, 0, -1, 1728683653, 0, 'Fimbul Shelf 3', 100000, 16, 0, 0, 0, 0, 49, NULL, 0),
(3305, 0, -1, 1728683653, 0, 'Furrier Quarter 2', 80000, 16, 0, 0, 0, 0, 37, NULL, 0),
(3306, 0, -1, 1728683653, 0, 'Furrier Quarter 1', 150000, 16, 0, 0, 0, 0, 53, NULL, 0),
(3307, 0, -1, 1728683653, 0, 'Fimbul Shelf 2', 100000, 16, 0, 0, 0, 0, 43, NULL, 0),
(3308, 0, -1, 1728683653, 0, 'Fimbul Shelf 1', 80000, 16, 0, 0, 0, 0, 36, NULL, 0),
(3309, 0, -1, 1728683653, 0, 'Bears Paw 3', 200000, 16, 0, 0, 0, 0, 47, NULL, 0),
(3310, 0, -1, 1728683653, 0, 'Raven Corner 2', 150000, 16, 0, 0, 0, 0, 36, NULL, 0),
(3311, 0, -1, 1728683653, 0, 'Raven Corner 1', 80000, 16, 0, 0, 0, 0, 22, NULL, 0),
(3312, 0, -1, 1728683653, 0, 'Raven Corner 3', 100000, 16, 0, 0, 0, 0, 22, NULL, 0),
(3313, 0, -1, 1728683653, 0, 'Mammoth Belly', 1000000, 16, 0, 0, 0, 0, 404, NULL, 0),
(3314, 0, -1, 1728683653, 0, 'Darashia 3, Flat 01', 150000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3315, 0, -1, 1728683653, 0, 'Darashia 3, Flat 05', 150000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3316, 0, -1, 1728683653, 0, 'Darashia 3, Flat 02', 200000, 13, 0, 0, 0, 0, 41, NULL, 0),
(3317, 0, -1, 1728683653, 0, 'Darashia 3, Flat 04', 150000, 13, 0, 0, 0, 0, 39, NULL, 0),
(3318, 0, -1, 1728683653, 0, 'Darashia 3, Flat 03', 150000, 13, 0, 0, 0, 0, 28, NULL, 0),
(3319, 0, -1, 1728683653, 0, 'Darashia 3, Flat 12', 200000, 13, 0, 0, 0, 0, 56, NULL, 0),
(3320, 0, -1, 1728683653, 0, 'Darashia 3, Flat 11', 100000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3321, 0, -1, 1728683653, 0, 'Darashia 3, Flat 14', 200000, 13, 0, 0, 0, 0, 59, NULL, 0),
(3322, 0, -1, 1728683653, 0, 'Darashia 3, Flat 13', 100000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3323, 0, -1, 1728683653, 0, 'Darashia 8, Flat 01', 300000, 13, 0, 0, 0, 0, 55, NULL, 0),
(3325, 0, -1, 1728683653, 0, 'Darashia 8, Flat 05', 300000, 13, 0, 0, 0, 0, 58, NULL, 0),
(3326, 0, -1, 1728683653, 0, 'Darashia 8, Flat 04', 200000, 13, 0, 0, 0, 0, 63, NULL, 0),
(3327, 0, -1, 1728683653, 0, 'Darashia 8, Flat 03', 300000, 13, 0, 0, 0, 0, 105, NULL, 0),
(3328, 0, -1, 1728683653, 0, 'Darashia 8, Flat 12', 150000, 13, 0, 0, 0, 0, 39, NULL, 0),
(3329, 0, -1, 1728683653, 0, 'Darashia 8, Flat 11', 200000, 13, 0, 0, 0, 0, 46, NULL, 0),
(3330, 0, -1, 1728683653, 0, 'Darashia 8, Flat 14', 150000, 13, 0, 0, 0, 0, 42, NULL, 0),
(3331, 0, -1, 1728683653, 0, 'Darashia 8, Flat 13', 150000, 13, 0, 0, 0, 0, 46, NULL, 0),
(3332, 0, -1, 1728683653, 0, 'Darashia, Villa', 800000, 13, 0, 0, 0, 0, 120, NULL, 0),
(3333, 0, -1, 1728683653, 0, 'Darashia, Eastern Guildhall', 1000000, 13, 0, 0, 0, 0, 272, NULL, 0),
(3334, 0, -1, 1728683653, 0, 'Darashia, Western Guildhall', 500000, 13, 0, 0, 0, 0, 223, NULL, 0),
(3335, 0, -1, 1728683653, 0, 'Darashia 2, Flat 03', 100000, 13, 0, 0, 0, 0, 31, NULL, 0),
(3336, 0, -1, 1728683653, 0, 'Darashia 2, Flat 02', 100000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3337, 0, -1, 1728683653, 0, 'Darashia 2, Flat 01', 150000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3338, 0, -1, 1728683653, 0, 'Darashia 2, Flat 04', 80000, 13, 0, 0, 0, 0, 14, NULL, 0),
(3339, 0, -1, 1728683653, 0, 'Darashia 2, Flat 05', 150000, 13, 0, 0, 0, 0, 31, NULL, 0),
(3340, 0, -1, 1728683653, 0, 'Darashia 2, Flat 06', 80000, 13, 0, 0, 0, 0, 14, NULL, 0),
(3341, 0, -1, 1728683653, 0, 'Darashia 2, Flat 07', 150000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3342, 0, -1, 1728683653, 0, 'Darashia 2, Flat 13', 100000, 13, 0, 0, 0, 0, 31, NULL, 0),
(3343, 0, -1, 1728683653, 0, 'Darashia 2, Flat 14', 50000, 13, 0, 0, 0, 0, 14, NULL, 0),
(3344, 0, -1, 1728683653, 0, 'Darashia 2, Flat 15', 100000, 13, 0, 0, 0, 0, 30, NULL, 0),
(3345, 0, -1, 1728683653, 0, 'Darashia 2, Flat 16', 80000, 13, 0, 0, 0, 0, 18, NULL, 0),
(3346, 0, -1, 1728683653, 0, 'Darashia 2, Flat 17', 100000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3347, 0, -1, 1728683653, 0, 'Darashia 2, Flat 18', 100000, 13, 0, 0, 0, 0, 17, NULL, 0),
(3348, 0, -1, 1728683653, 0, 'Darashia 2, Flat 11', 100000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3349, 0, -1, 1728683653, 0, 'Darashia 2, Flat 12', 80000, 13, 0, 0, 0, 0, 13, NULL, 0),
(3350, 0, -1, 1728683653, 0, 'Darashia 1, Flat 03', 300000, 13, 0, 0, 0, 0, 65, NULL, 0),
(3351, 0, -1, 1728683653, 0, 'Darashia 1, Flat 04', 100000, 13, 0, 0, 0, 0, 28, NULL, 0),
(3352, 0, -1, 1728683653, 0, 'Darashia 1, Flat 02', 100000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3353, 0, -1, 1728683653, 0, 'Darashia 1, Flat 01', 100000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3354, 0, -1, 1728683653, 0, 'Darashia 1, Flat 05', 100000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3355, 0, -1, 1728683653, 0, 'Darashia 1, Flat 12', 150000, 13, 0, 0, 0, 0, 46, NULL, 0),
(3356, 0, -1, 1728683653, 0, 'Darashia 1, Flat 13', 150000, 13, 0, 0, 0, 0, 50, NULL, 0),
(3357, 0, -1, 1728683653, 0, 'Darashia 1, Flat 14', 200000, 13, 0, 0, 0, 0, 69, NULL, 0),
(3358, 0, -1, 1728683653, 0, 'Darashia 1, Flat 11', 100000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3359, 0, -1, 1728683653, 0, 'Darashia 5, Flat 02', 150000, 13, 0, 0, 0, 0, 41, NULL, 0),
(3360, 0, -1, 1728683653, 0, 'Darashia 5, Flat 01', 150000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3361, 0, -1, 1728683653, 0, 'Darashia 5, Flat 05', 100000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3362, 0, -1, 1728683653, 0, 'Darashia 5, Flat 04', 150000, 13, 0, 0, 0, 0, 42, NULL, 0),
(3363, 0, -1, 1728683653, 0, 'Darashia 5, Flat 03', 150000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3364, 0, -1, 1728683653, 0, 'Darashia 5, Flat 11', 150000, 13, 0, 0, 0, 0, 46, NULL, 0),
(3365, 0, -1, 1728683653, 0, 'Darashia 5, Flat 12', 150000, 13, 0, 0, 0, 0, 39, NULL, 0),
(3366, 0, -1, 1728683653, 0, 'Darashia 5, Flat 13', 150000, 13, 0, 0, 0, 0, 42, NULL, 0),
(3367, 0, -1, 1728683653, 0, 'Darashia 5, Flat 14', 150000, 13, 0, 0, 0, 0, 38, NULL, 0),
(3368, 0, -1, 1728683653, 0, 'Darashia 6a', 300000, 13, 0, 0, 0, 0, 67, NULL, 0),
(3369, 0, -1, 1728683653, 0, 'Darashia 6b', 300000, 13, 0, 0, 0, 0, 80, NULL, 0),
(3370, 0, -1, 1728683653, 0, 'Darashia 4, Flat 02', 200000, 13, 0, 0, 0, 0, 44, NULL, 0),
(3371, 0, -1, 1728683653, 0, 'Darashia 4, Flat 03', 150000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3372, 0, -1, 1728683653, 0, 'Darashia 4, Flat 04', 200000, 13, 0, 0, 0, 0, 45, NULL, 0),
(3373, 0, -1, 1728683653, 0, 'Darashia 4, Flat 05', 150000, 13, 0, 0, 0, 0, 30, NULL, 0),
(3374, 0, -1, 1728683653, 0, 'Darashia 4, Flat 01', 100000, 13, 0, 0, 0, 0, 31, NULL, 0),
(3375, 0, -1, 1728683653, 0, 'Darashia 4, Flat 12', 200000, 13, 0, 0, 0, 0, 64, NULL, 0),
(3376, 0, -1, 1728683653, 0, 'Darashia 4, Flat 11', 100000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3377, 0, -1, 1728683653, 0, 'Darashia 4, Flat 13', 200000, 13, 0, 0, 0, 0, 44, NULL, 0),
(3378, 0, -1, 1728683653, 0, 'Darashia 4, Flat 14', 150000, 13, 0, 0, 0, 0, 46, NULL, 0),
(3379, 0, -1, 1728683653, 0, 'Darashia 7, Flat 01', 100000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3380, 0, -1, 1728683653, 0, 'Darashia 7, Flat 02', 100000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3381, 0, -1, 1728683653, 0, 'Darashia 7, Flat 03', 200000, 13, 0, 0, 0, 0, 65, NULL, 0),
(3382, 0, -1, 1728683653, 0, 'Darashia 7, Flat 05', 150000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3383, 0, -1, 1728683653, 0, 'Darashia 7, Flat 04', 150000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3384, 0, -1, 1728683653, 0, 'Darashia 7, Flat 12', 200000, 13, 0, 0, 0, 0, 60, NULL, 0),
(3385, 0, -1, 1728683653, 0, 'Darashia 7, Flat 11', 100000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3386, 0, -1, 1728683653, 0, 'Darashia 7, Flat 14', 200000, 13, 0, 0, 0, 0, 60, NULL, 0),
(3387, 0, -1, 1728683653, 0, 'Darashia 7, Flat 13', 100000, 13, 0, 0, 0, 0, 25, NULL, 0),
(3388, 0, -1, 1728683653, 0, 'Pirate Shipwreck 1', 800000, 13, 0, 0, 0, 0, 187, NULL, 0),
(3389, 0, -1, 1728683653, 0, 'Pirate Shipwreck 2', 800000, 13, 0, 0, 0, 0, 276, NULL, 0),
(3390, 0, -1, 1728683653, 0, 'The Shelter', 250000, 14, 0, 0, 0, 0, 422, NULL, 0),
(3391, 0, -1, 1728683653, 0, 'Litter Promenade 1', 25000, 14, 0, 0, 0, 0, 15, NULL, 0),
(3392, 0, -1, 1728683653, 0, 'Litter Promenade 2', 50000, 14, 0, 0, 0, 0, 14, NULL, 0),
(3394, 0, -1, 1728683653, 0, 'Litter Promenade 3', 25000, 14, 0, 0, 0, 0, 21, NULL, 0),
(3395, 0, -1, 1728683653, 0, 'Litter Promenade 4', 25000, 14, 0, 0, 0, 0, 18, NULL, 0),
(3396, 0, -1, 1728683653, 0, 'Rum Alley 3', 25000, 14, 0, 0, 0, 0, 18, NULL, 0),
(3397, 0, -1, 1728683653, 0, 'Straycat\'s Corner 5', 80000, 14, 0, 0, 0, 0, 25, NULL, 0),
(3398, 0, -1, 1728683653, 0, 'Straycat\'s Corner 6', 25000, 14, 0, 0, 0, 0, 13, NULL, 0),
(3399, 0, -1, 1728683653, 0, 'Litter Promenade 5', 25000, 14, 0, 0, 0, 0, 23, NULL, 0),
(3401, 0, -1, 1728683653, 0, 'Straycat\'s Corner 4', 50000, 14, 0, 0, 0, 0, 23, NULL, 0),
(3402, 0, -1, 1728683653, 0, 'Straycat\'s Corner 2', 50000, 14, 0, 0, 0, 0, 27, NULL, 0),
(3403, 0, -1, 1728683653, 0, 'Straycat\'s Corner 1', 25000, 14, 0, 0, 0, 0, 14, NULL, 0),
(3404, 0, -1, 1728683653, 0, 'Rum Alley 2', 25000, 14, 0, 0, 0, 0, 18, NULL, 0),
(3405, 0, -1, 1728683653, 0, 'Rum Alley 1', 25000, 14, 0, 0, 0, 0, 25, NULL, 0),
(3406, 0, -1, 1728683653, 0, 'Smuggler Backyard 3', 50000, 14, 0, 0, 0, 0, 27, NULL, 0),
(3407, 0, -1, 1728683653, 0, 'Shady Trail 3', 25000, 14, 0, 0, 0, 0, 16, NULL, 0),
(3408, 0, -1, 1728683653, 0, 'Shady Trail 1', 100000, 14, 0, 0, 0, 0, 34, NULL, 0),
(3409, 0, -1, 1728683653, 0, 'Shady Trail 2', 25000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3410, 0, -1, 1728683653, 0, 'Smuggler Backyard 4', 25000, 14, 0, 0, 0, 0, 22, NULL, 0),
(3411, 0, -1, 1728683653, 0, 'Smuggler Backyard 2', 25000, 14, 0, 0, 0, 0, 31, NULL, 0),
(3412, 0, -1, 1728683653, 0, 'Smuggler Backyard 1', 25000, 14, 0, 0, 0, 0, 27, NULL, 0),
(3413, 0, -1, 1728683653, 0, 'Smuggler Backyard 5', 25000, 14, 0, 0, 0, 0, 25, NULL, 0),
(3414, 0, -1, 1728683653, 0, 'Sugar Street 1', 200000, 14, 0, 0, 0, 0, 60, NULL, 0),
(3415, 0, -1, 1728683653, 0, 'Sugar Street 2', 150000, 14, 0, 0, 0, 0, 51, NULL, 0),
(3416, 0, -1, 1728683653, 0, 'Sugar Street 3a', 100000, 14, 0, 0, 0, 0, 33, NULL, 0),
(3417, 0, -1, 1728683653, 0, 'Sugar Street 3b', 150000, 14, 0, 0, 0, 0, 41, NULL, 0),
(3418, 0, -1, 1728683653, 0, 'Sugar Street 4d', 50000, 14, 0, 0, 0, 0, 15, NULL, 0),
(3419, 0, -1, 1728683653, 0, 'Sugar Street 4c', 25000, 14, 0, 0, 0, 0, 14, NULL, 0),
(3420, 0, -1, 1728683653, 0, 'Sugar Street 4b', 100000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3421, 0, -1, 1728683653, 0, 'Sugar Street 4a', 80000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3422, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 01', 50000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3423, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 03', 50000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3424, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 05', 50000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3425, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 06', 50000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3426, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 04', 50000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3427, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 02', 50000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3428, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 07', 80000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3429, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 09', 50000, 14, 0, 0, 0, 0, 18, NULL, 0),
(3430, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 11', 25000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3431, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 08', 50000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3432, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 10', 50000, 14, 0, 0, 0, 0, 18, NULL, 0),
(3433, 0, -1, 1728683653, 0, 'Harvester\'s Haven, Flat 12', 25000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3434, 0, -1, 1728683653, 0, 'Marble Lane 3', 600000, 14, 0, 0, 0, 0, 163, NULL, 0),
(3435, 0, -1, 1728683653, 0, 'Marble Lane 2', 400000, 14, 0, 0, 0, 0, 141, NULL, 0),
(3436, 0, -1, 1728683653, 0, 'Marble Lane 4', 400000, 14, 0, 0, 0, 0, 134, NULL, 0),
(3437, 0, -1, 1728683653, 0, 'Admiral\'s Avenue 1', 400000, 14, 0, 0, 0, 0, 97, NULL, 0),
(3438, 0, -1, 1728683653, 0, 'Admiral\'s Avenue 2', 400000, 14, 0, 0, 0, 0, 111, NULL, 0),
(3439, 0, -1, 1728683653, 0, 'Admiral\'s Avenue 3', 300000, 14, 0, 0, 0, 0, 99, NULL, 0),
(3440, 0, -1, 1728683653, 0, 'Ivory Circle 1', 400000, 14, 0, 0, 0, 0, 101, NULL, 0),
(3441, 0, -1, 1728683653, 0, 'Sugar Street 5', 150000, 14, 0, 0, 0, 0, 25, NULL, 0),
(3442, 0, -1, 1728683653, 0, 'Freedom Street 1', 200000, 14, 0, 0, 0, 0, 47, NULL, 0),
(3443, 0, -1, 1728683653, 0, 'Trader\'s Point 1', 200000, 14, 0, 0, 0, 0, 42, NULL, 0),
(3444, 0, -1, 1728683653, 0, 'Trader\'s Point 2 (Shop)', 600000, 14, 0, 0, 0, 0, 122, NULL, 0),
(3445, 0, -1, 1728683653, 0, 'Trader\'s Point 3 (Shop)', 600000, 14, 0, 0, 0, 0, 130, NULL, 0),
(3446, 0, -1, 1728683653, 0, 'Ivory Mansion', 800000, 14, 0, 0, 0, 0, 319, NULL, 0),
(3447, 0, -1, 1728683653, 0, 'Ivory Circle 2', 400000, 14, 0, 0, 0, 0, 142, NULL, 0),
(3448, 0, -1, 1728683653, 0, 'Ivy Cottage', 500000, 14, 0, 0, 0, 0, 587, NULL, 0),
(3449, 0, -1, 1728683653, 0, 'Marble Lane 1', 600000, 14, 0, 0, 0, 0, 228, NULL, 0),
(3450, 0, -1, 1728683653, 0, 'Freedom Street 2', 400000, 14, 0, 0, 0, 0, 123, NULL, 0),
(3452, 0, -1, 1728683653, 0, 'Meriana Beach', 150000, 14, 0, 0, 0, 0, 172, NULL, 0),
(3453, 0, -1, 1728683653, 0, 'The Tavern 1a', 150000, 14, 0, 0, 0, 0, 52, NULL, 0),
(3454, 0, -1, 1728683653, 0, 'The Tavern 1b', 100000, 14, 0, 0, 0, 0, 38, NULL, 0),
(3455, 0, -1, 1728683653, 0, 'The Tavern 1c', 200000, 14, 0, 0, 0, 0, 85, NULL, 0),
(3456, 0, -1, 1728683653, 0, 'The Tavern 1d', 100000, 14, 0, 0, 0, 0, 33, NULL, 0),
(3457, 0, -1, 1728683653, 0, 'The Tavern 2a', 300000, 14, 0, 0, 0, 0, 111, NULL, 0),
(3458, 0, -1, 1728683653, 0, 'The Tavern 2b', 100000, 14, 0, 0, 0, 0, 36, NULL, 0),
(3459, 0, -1, 1728683653, 0, 'The Tavern 2d', 100000, 14, 0, 0, 0, 0, 27, NULL, 0),
(3460, 0, -1, 1728683653, 0, 'The Tavern 2c', 50000, 14, 0, 0, 0, 0, 20, NULL, 0),
(3461, 0, -1, 1728683653, 0, 'The Yeah Beach Project', 150000, 14, 0, 0, 0, 0, 157, NULL, 0),
(3462, 0, -1, 1728683653, 0, 'Mountain Hideout', 500000, 14, 0, 0, 0, 0, 321, NULL, 0),
(3463, 0, -1, 1728683653, 0, 'Darashia 8, Flat 02', 300000, 13, 0, 0, 0, 0, 76, NULL, 0),
(3464, 0, -1, 1728683653, 0, 'Castle, Basement, Flat 01', 50000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3465, 0, -1, 1728683653, 0, 'Castle, Basement, Flat 02', 50000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3466, 0, -1, 1728683653, 0, 'Castle, Basement, Flat 03', 50000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3467, 0, -1, 1728683653, 0, 'Castle, Basement, Flat 05', 50000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3468, 0, -1, 1728683653, 0, 'Castle, Basement, Flat 04', 50000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3469, 0, -1, 1728683653, 0, 'Castle, Basement, Flat 06', 50000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3470, 0, -1, 1728683653, 0, 'Castle, Basement, Flat 07', 50000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3471, 0, -1, 1728683653, 0, 'Castle, Basement, Flat 09', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3472, 0, -1, 1728683653, 0, 'Castle, Basement, Flat 08', 50000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3473, 0, -1, 1728683653, 0, 'Cormaya 1', 150000, 11, 0, 0, 0, 0, 30, NULL, 0),
(3474, 0, -1, 1728683653, 0, 'Cormaya Flats, Flat 01', 25000, 11, 0, 0, 0, 0, 11, NULL, 0),
(3475, 0, -1, 1728683653, 0, 'Cormaya Flats, Flat 02', 25000, 11, 0, 0, 0, 0, 11, NULL, 0),
(3476, 0, -1, 1728683653, 0, 'Cormaya Flats, Flat 03', 50000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3477, 0, -1, 1728683653, 0, 'Cormaya Flats, Flat 06', 25000, 11, 0, 0, 0, 0, 11, NULL, 0),
(3478, 0, -1, 1728683653, 0, 'Cormaya Flats, Flat 05', 25000, 11, 0, 0, 0, 0, 11, NULL, 0),
(3479, 0, -1, 1728683653, 0, 'Cormaya Flats, Flat 04', 50000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3480, 0, -1, 1728683653, 0, 'Cormaya Flats, Flat 11', 100000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3482, 0, -1, 1728683653, 0, 'Cormaya Flats, Flat 13', 25000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3483, 0, -1, 1728683653, 0, 'Cormaya Flats, Flat 12', 100000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3485, 0, -1, 1728683653, 0, 'Cormaya Flats, Flat 14', 25000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3486, 0, -1, 1728683653, 0, 'Cormaya 2', 300000, 11, 0, 0, 0, 0, 84, NULL, 0),
(3487, 0, -1, 1728683653, 0, 'Cormaya 4', 150000, 11, 0, 0, 0, 0, 39, NULL, 0),
(3488, 0, -1, 1728683653, 0, 'Cormaya 3', 200000, 11, 0, 0, 0, 0, 47, NULL, 0),
(3489, 0, -1, 1728683653, 0, 'Cormaya 6', 200000, 11, 0, 0, 0, 0, 56, NULL, 0),
(3490, 0, -1, 1728683653, 0, 'Cormaya 7', 200000, 11, 0, 0, 0, 0, 54, NULL, 0),
(3491, 0, -1, 1728683653, 0, 'Cormaya 8', 200000, 11, 0, 0, 0, 0, 65, NULL, 0),
(3492, 0, -1, 1728683653, 0, 'Cormaya 5', 300000, 11, 0, 0, 0, 0, 123, NULL, 0),
(3493, 0, -1, 1728683653, 0, 'Castle of the White Dragon', 1000000, 11, 0, 0, 0, 0, 532, NULL, 0),
(3494, 0, -1, 1728683653, 0, 'Cormaya 9b', 150000, 11, 0, 0, 0, 0, 58, NULL, 0),
(3495, 0, -1, 1728683653, 0, 'Cormaya 9a', 80000, 11, 0, 0, 0, 0, 28, NULL, 0),
(3496, 0, -1, 1728683653, 0, 'Cormaya 9d', 150000, 11, 0, 0, 0, 0, 60, NULL, 0),
(3497, 0, -1, 1728683653, 0, 'Cormaya 9c', 80000, 11, 0, 0, 0, 0, 28, NULL, 0),
(3498, 0, -1, 1728683653, 0, 'Cormaya 10', 300000, 11, 0, 0, 0, 0, 85, NULL, 0),
(3499, 0, -1, 1728683653, 0, 'Cormaya 11', 150000, 11, 0, 0, 0, 0, 47, NULL, 0),
(3500, 0, -1, 1728683653, 0, 'Edron Flats, Flat 22', 50000, 11, 0, 0, 0, 0, 12, NULL, 0),
(3501, 0, -1, 1728683653, 0, 'Magic Academy, Shop', 150000, 11, 0, 0, 0, 0, 23, NULL, 0),
(3502, 0, -1, 1728683653, 0, 'Magic Academy, Flat 1', 100000, 11, 0, 0, 0, 0, 23, NULL, 0),
(3503, 0, -1, 1728683653, 0, 'Magic Academy, Guild', 500000, 11, 0, 0, 0, 0, 195, NULL, 0),
(3504, 0, -1, 1728683653, 0, 'Magic Academy, Flat 2', 80000, 11, 0, 0, 0, 0, 26, NULL, 0),
(3505, 0, -1, 1728683653, 0, 'Magic Academy, Flat 3', 100000, 11, 0, 0, 0, 0, 26, NULL, 0),
(3506, 0, -1, 1728683653, 0, 'Magic Academy, Flat 4', 100000, 11, 0, 0, 0, 0, 26, NULL, 0),
(3507, 0, -1, 1728683653, 0, 'Magic Academy, Flat 5', 80000, 11, 0, 0, 0, 0, 26, NULL, 0),
(3508, 0, -1, 1728683653, 0, 'Oskahl I f', 100000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3509, 0, -1, 1728683653, 0, 'Oskahl I g', 100000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3510, 0, -1, 1728683653, 0, 'Oskahl I h', 150000, 10, 0, 0, 0, 0, 39, NULL, 0),
(3511, 0, -1, 1728683653, 0, 'Oskahl I i', 80000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3512, 0, -1, 1728683653, 0, 'Oskahl I j', 80000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3513, 0, -1, 1728683653, 0, 'Oskahl I b', 80000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3514, 0, -1, 1728683653, 0, 'Oskahl I d', 100000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3515, 0, -1, 1728683653, 0, 'Oskahl I e', 80000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3516, 0, -1, 1728683653, 0, 'Oskahl I c', 80000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3517, 0, -1, 1728683653, 0, 'Chameken I', 100000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3518, 0, -1, 1728683653, 0, 'Chameken II', 80000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3519, 0, -1, 1728683653, 0, 'Charsirakh III', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3520, 0, -1, 1728683653, 0, 'Charsirakh II', 100000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3521, 0, -1, 1728683653, 0, 'Murkhol I a', 80000, 10, 0, 0, 0, 0, 23, NULL, 0),
(3523, 0, -1, 1728683653, 0, 'Murkhol I c', 50000, 10, 0, 0, 0, 0, 11, NULL, 0),
(3524, 0, -1, 1728683653, 0, 'Murkhol I b', 50000, 10, 0, 0, 0, 0, 11, NULL, 0),
(3525, 0, -1, 1728683653, 0, 'Charsirakh I b', 150000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3526, 0, -1, 1728683653, 0, 'Harrah I', 250000, 10, 0, 0, 0, 0, 124, NULL, 0),
(3527, 0, -1, 1728683653, 0, 'Thanah I d', 200000, 10, 0, 0, 0, 0, 52, NULL, 0),
(3528, 0, -1, 1728683653, 0, 'Thanah I c', 200000, 10, 0, 0, 0, 0, 61, NULL, 0),
(3529, 0, -1, 1728683653, 0, 'Thanah I b', 150000, 10, 0, 0, 0, 0, 56, NULL, 0),
(3530, 0, -1, 1728683653, 0, 'Thanah I a', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3531, 0, -1, 1728683653, 0, 'Othehothep I c', 150000, 10, 0, 0, 0, 0, 38, NULL, 0),
(3532, 0, -1, 1728683653, 0, 'Othehothep I d', 150000, 10, 0, 0, 0, 0, 43, NULL, 0),
(3533, 0, -1, 1728683653, 0, 'Othehothep I b', 100000, 10, 0, 0, 0, 0, 32, NULL, 0),
(3534, 0, -1, 1728683653, 0, 'Othehothep II c', 80000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3535, 0, -1, 1728683653, 0, 'Othehothep II d', 80000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3536, 0, -1, 1728683653, 0, 'Othehothep II e', 150000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3537, 0, -1, 1728683653, 0, 'Othehothep II f', 100000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3538, 0, -1, 1728683653, 0, 'Othehothep II b', 150000, 10, 0, 0, 0, 0, 43, NULL, 0),
(3539, 0, -1, 1728683653, 0, 'Othehothep II a', 25000, 10, 0, 0, 0, 0, 10, NULL, 0),
(3540, 0, -1, 1728683653, 0, 'Mothrem I', 80000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3541, 0, -1, 1728683653, 0, 'Arakmehn I', 100000, 10, 0, 0, 0, 0, 28, NULL, 0),
(3542, 0, -1, 1728683653, 0, 'Arakmehn II', 80000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3543, 0, -1, 1728683653, 0, 'Arakmehn III', 100000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3544, 0, -1, 1728683653, 0, 'Arakmehn IV', 100000, 10, 0, 0, 0, 0, 28, NULL, 0),
(3545, 0, -1, 1728683653, 0, 'Unklath II b', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3546, 0, -1, 1728683653, 0, 'Unklath II c', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3547, 0, -1, 1728683653, 0, 'Unklath II d', 100000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3548, 0, -1, 1728683653, 0, 'Unklath II a', 50000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3549, 0, -1, 1728683653, 0, 'Rathal I b', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3550, 0, -1, 1728683653, 0, 'Rathal I c', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3551, 0, -1, 1728683653, 0, 'Rathal I d', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3552, 0, -1, 1728683653, 0, 'Rathal I e', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3553, 0, -1, 1728683653, 0, 'Rathal I a', 80000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3554, 0, -1, 1728683653, 0, 'Rathal II b', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3555, 0, -1, 1728683653, 0, 'Rathal II c', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3556, 0, -1, 1728683653, 0, 'Rathal II d', 100000, 10, 0, 0, 0, 0, 34, NULL, 0),
(3557, 0, -1, 1728683653, 0, 'Rathal II a', 80000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3558, 0, -1, 1728683653, 0, 'Esuph I', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3559, 0, -1, 1728683653, 0, 'Esuph II b', 100000, 10, 0, 0, 0, 0, 32, NULL, 0),
(3560, 0, -1, 1728683653, 0, 'Esuph II a', 25000, 10, 0, 0, 0, 0, 7, NULL, 0),
(3561, 0, -1, 1728683653, 0, 'Esuph III b', 100000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3562, 0, -1, 1728683653, 0, 'Esuph III a', 25000, 10, 0, 0, 0, 0, 7, NULL, 0),
(3564, 0, -1, 1728683653, 0, 'Esuph IV c', 80000, 10, 0, 0, 0, 0, 23, NULL, 0),
(3565, 0, -1, 1728683653, 0, 'Esuph IV d', 25000, 10, 0, 0, 0, 0, 20, NULL, 0),
(3566, 0, -1, 1728683653, 0, 'Esuph IV a', 25000, 10, 0, 0, 0, 0, 10, NULL, 0),
(3567, 0, -1, 1728683653, 0, 'Horakhal', 250000, 10, 0, 0, 0, 0, 205, NULL, 0),
(3568, 0, -1, 1728683653, 0, 'Botham II d', 100000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3569, 0, -1, 1728683653, 0, 'Botham II e', 100000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3570, 0, -1, 1728683653, 0, 'Botham II f', 80000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3571, 0, -1, 1728683653, 0, 'Botham II g', 80000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3572, 0, -1, 1728683653, 0, 'Botham II c', 100000, 10, 0, 0, 0, 0, 23, NULL, 0),
(3573, 0, -1, 1728683653, 0, 'Botham II b', 100000, 10, 0, 0, 0, 0, 30, NULL, 0),
(3574, 0, -1, 1728683653, 0, 'Botham II a', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3575, 0, -1, 1728683653, 0, 'Botham III f', 150000, 10, 0, 0, 0, 0, 43, NULL, 0),
(3576, 0, -1, 1728683653, 0, 'Botham III h', 200000, 10, 0, 0, 0, 0, 71, NULL, 0),
(3577, 0, -1, 1728683653, 0, 'Botham III g', 100000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3578, 0, -1, 1728683653, 0, 'Botham III b', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3579, 0, -1, 1728683653, 0, 'Botham III c', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3581, 0, -1, 1728683653, 0, 'Botham III e', 100000, 10, 0, 0, 0, 0, 38, NULL, 0),
(3582, 0, -1, 1728683653, 0, 'Botham III a', 80000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3583, 0, -1, 1728683653, 0, 'Botham IV f', 100000, 10, 0, 0, 0, 0, 32, NULL, 0),
(3584, 0, -1, 1728683653, 0, 'Botham IV h', 100000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3585, 0, -1, 1728683653, 0, 'Botham IV i', 150000, 10, 0, 0, 0, 0, 32, NULL, 0),
(3586, 0, -1, 1728683653, 0, 'Botham IV g', 100000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3587, 0, -1, 1728683653, 0, 'Botham IV e', 100000, 10, 0, 0, 0, 0, 85, NULL, 0),
(3591, 0, -1, 1728683653, 0, 'Botham IV a', 100000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3592, 0, -1, 1728683653, 0, 'Ramen Tah', 250000, 10, 0, 0, 0, 0, 125, NULL, 0),
(3593, 0, -1, 1728683653, 0, 'Botham I c', 150000, 10, 0, 0, 0, 0, 32, NULL, 0),
(3594, 0, -1, 1728683653, 0, 'Botham I e', 80000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3595, 0, -1, 1728683653, 0, 'Botham I d', 150000, 10, 0, 0, 0, 0, 57, NULL, 0),
(3596, 0, -1, 1728683653, 0, 'Botham I b', 150000, 10, 0, 0, 0, 0, 56, NULL, 0),
(3597, 0, -1, 1728683653, 0, 'Botham I a', 50000, 10, 0, 0, 0, 0, 19, NULL, 0),
(3598, 0, -1, 1728683653, 0, 'Charsirakh I a', 25000, 10, 0, 0, 0, 0, 7, NULL, 0),
(3599, 0, -1, 1728683653, 0, 'Low Waters Observatory', 400000, 10, 0, 0, 0, 0, 525, NULL, 0),
(3600, 0, -1, 1728683653, 0, 'Oskahl I a', 150000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3601, 0, -1, 1728683653, 0, 'Othehothep I a', 25000, 10, 0, 0, 0, 0, 7, NULL, 0),
(3602, 0, -1, 1728683653, 0, 'Othehothep III a', 25000, 10, 0, 0, 0, 0, 7, NULL, 0),
(3603, 0, -1, 1728683653, 0, 'Othehothep III b', 80000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3604, 0, -1, 1728683653, 0, 'Othehothep III c', 80000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3605, 0, -1, 1728683653, 0, 'Othehothep III d', 80000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3606, 0, -1, 1728683653, 0, 'Othehothep III e', 50000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3607, 0, -1, 1728683653, 0, 'Othehothep III f', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3608, 0, -1, 1728683653, 0, 'Unklath I f', 100000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3609, 0, -1, 1728683653, 0, 'Unklath I g', 100000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3610, 0, -1, 1728683653, 0, 'Unklath I d', 150000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3611, 0, -1, 1728683653, 0, 'Unklath I e', 150000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3612, 0, -1, 1728683653, 0, 'Unklath I b', 100000, 10, 0, 0, 0, 0, 34, NULL, 0),
(3613, 0, -1, 1728683653, 0, 'Unklath I c', 100000, 10, 0, 0, 0, 0, 34, NULL, 0),
(3614, 0, -1, 1728683653, 0, 'Unklath I a', 100000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3615, 0, -1, 1728683653, 0, 'Thanah II a', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3616, 0, -1, 1728683653, 0, 'Thanah II b', 50000, 10, 0, 0, 0, 0, 9, NULL, 0),
(3617, 0, -1, 1728683653, 0, 'Thanah II d', 50000, 10, 0, 0, 0, 0, 7, NULL, 0),
(3618, 0, -1, 1728683653, 0, 'Thanah II e', 25000, 10, 0, 0, 0, 0, 7, NULL, 0),
(3619, 0, -1, 1728683653, 0, 'Thanah II c', 25000, 10, 0, 0, 0, 0, 9, NULL, 0),
(3620, 0, -1, 1728683653, 0, 'Thanah II f', 150000, 10, 0, 0, 0, 0, 53, NULL, 0),
(3621, 0, -1, 1728683653, 0, 'Thanah II g', 100000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3622, 0, -1, 1728683653, 0, 'Thanah II h', 100000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3623, 0, -1, 1728683653, 0, 'Thrarhor I a (Shop)', 50000, 10, 0, 0, 0, 0, 15, NULL, 0),
(3624, 0, -1, 1728683653, 0, 'Thrarhor I c (Shop)', 50000, 10, 0, 0, 0, 0, 15, NULL, 0),
(3625, 0, -1, 1728683653, 0, 'Thrarhor I d (Shop)', 80000, 10, 0, 0, 0, 0, 15, NULL, 0),
(3626, 0, -1, 1728683653, 0, 'Thrarhor I b (Shop)', 50000, 10, 0, 0, 0, 0, 15, NULL, 0),
(3627, 0, -1, 1728683653, 0, 'Uthemath I a', 25000, 10, 0, 0, 0, 0, 10, NULL, 0),
(3628, 0, -1, 1728683653, 0, 'Uthemath I b', 50000, 10, 0, 0, 0, 0, 20, NULL, 0),
(3629, 0, -1, 1728683653, 0, 'Uthemath I c', 80000, 10, 0, 0, 0, 0, 20, NULL, 0),
(3630, 0, -1, 1728683653, 0, 'Uthemath I d', 80000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3631, 0, -1, 1728683653, 0, 'Uthemath I e', 80000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3632, 0, -1, 1728683653, 0, 'Uthemath I f', 150000, 10, 0, 0, 0, 0, 56, NULL, 0),
(3633, 0, -1, 1728683653, 0, 'Uthemath II', 250000, 10, 0, 0, 0, 0, 93, NULL, 0),
(3634, 0, -1, 1728683653, 0, 'Marketplace 1', 400000, 22, 0, 0, 0, 0, 79, NULL, 0),
(3635, 0, -1, 1728683653, 0, 'Marketplace 2', 400000, 22, 0, 0, 0, 0, 92, NULL, 0),
(3636, 0, -1, 1728683653, 0, 'Quay 1', 200000, 22, 0, 0, 0, 0, 81, NULL, 0),
(3637, 0, -1, 1728683653, 0, 'Quay 2', 200000, 22, 0, 0, 0, 0, 130, NULL, 0),
(3638, 0, -1, 1728683653, 0, 'Halls of Sun and Sea', 1000000, 22, 0, 0, 0, 0, 423, NULL, 0),
(3639, 0, -1, 1728683653, 0, 'Palace Vicinity', 200000, 22, 0, 0, 0, 0, 132, NULL, 0),
(3640, 0, -1, 1728683653, 0, 'Wave Tower', 400000, 22, 0, 0, 0, 0, 212, NULL, 0),
(3641, 0, -1, 1728683653, 0, 'Old Sanctuary of God King Qjell', 300000, 18, 0, 0, 0, 0, 699, NULL, 0),
(3642, 0, -1, 1728683653, 0, 'Old Heritage Estate', 600000, 20, 0, 0, 0, 0, 335, NULL, 0),
(3643, 0, -1, 1728683653, 0, 'Rathleton Plaza 4', 400000, 20, 0, 0, 0, 0, 144, NULL, 0),
(3644, 0, -1, 1728683653, 0, 'Rathleton Plaza 3', 400000, 20, 0, 0, 0, 0, 157, NULL, 0),
(3645, 0, -1, 1728683653, 0, 'Rathleton Plaza 2', 400000, 20, 0, 0, 0, 0, 77, NULL, 0),
(3646, 0, -1, 1728683653, 0, 'Rathleton Plaza 1', 300000, 20, 0, 0, 0, 0, 80, NULL, 0),
(3647, 0, -1, 1728683653, 0, 'Antimony Lane 2', 400000, 20, 0, 0, 0, 0, 127, NULL, 0),
(3648, 0, -1, 1728683653, 0, 'Antimony Lane 1', 400000, 20, 0, 0, 0, 0, 189, NULL, 0),
(3649, 0, -1, 1728683653, 0, 'Wallside Residence', 400000, 20, 0, 0, 0, 0, 182, NULL, 0),
(3650, 0, -1, 1728683653, 0, 'Wallside Lane 1', 800000, 20, 0, 0, 0, 0, 216, NULL, 0),
(3651, 0, -1, 1728683653, 0, 'Wallside Lane 2', 600000, 20, 0, 0, 0, 0, 227, NULL, 0),
(3652, 0, -1, 1728683653, 0, 'Vanward Flats B', 400000, 20, 0, 0, 0, 0, 179, NULL, 0),
(3653, 0, -1, 1728683653, 0, 'Vanward Flats A', 400000, 20, 0, 0, 0, 0, 189, NULL, 0),
(3654, 0, -1, 1728683653, 0, 'Bronze Brothers Bastion', 5000000, 20, 0, 0, 0, 0, 976, NULL, 0),
(3655, 0, -1, 1728683653, 0, 'Cistern Ave', 300000, 20, 0, 0, 0, 0, 111, NULL, 0),
(3656, 0, -1, 1728683653, 0, 'Antimony Lane 4', 400000, 20, 0, 0, 0, 0, 159, NULL, 0),
(3657, 0, -1, 1728683653, 0, 'Antimony Lane 3', 400000, 20, 0, 0, 0, 0, 101, NULL, 0),
(3658, 0, -1, 1728683653, 0, 'Rathleton Hills Residence', 400000, 20, 0, 0, 0, 0, 186, NULL, 0),
(3659, 0, -1, 1728683653, 0, 'Rathleton Hills Estate', 1000000, 20, 0, 0, 0, 0, 534, NULL, 0),
(3660, 0, -1, 1728683653, 0, 'Lion\'s Head Reef', 400000, 25, 0, 0, 0, 0, 166, NULL, 0),
(3661, 0, -1, 1728683653, 0, 'Shadow Caves 1', 50000, 5, 0, 0, 0, 0, 32, NULL, 0),
(3662, 0, -1, 1728683653, 0, 'Shadow Caves 2', 50000, 5, 0, 0, 0, 0, 37, NULL, 0),
(3663, 0, -1, 1728683653, 0, 'Shadow Caves 3', 100000, 5, 0, 0, 0, 0, 61, NULL, 0),
(3664, 0, -1, 1728683653, 0, 'Shadow Caves 4', 100000, 5, 0, 0, 0, 0, 53, NULL, 0),
(3665, 0, -1, 1728683653, 0, 'Shadow Caves 5', 100000, 5, 0, 0, 0, 0, 61, NULL, 0),
(3666, 0, -1, 1728683653, 0, 'Shadow Caves 6', 100000, 5, 0, 0, 0, 0, 50, NULL, 0),
(3667, 0, -1, 1728683653, 0, 'Northport Clanhall', 250000, 6, 0, 0, 0, 0, 172, NULL, 0),
(3668, 0, -1, 1728683653, 0, 'The Treehouse', 250000, 15, 0, 0, 0, 0, 972, NULL, 0),
(3669, 0, -1, 1728683653, 0, 'Frost Manor', 500000, 16, 0, 0, 0, 0, 505, NULL, 0),
(3670, 0, -1, 1728683653, 0, 'Hare\'s Den', 150000, 7, 0, 0, 0, 0, 304, NULL, 0),
(3671, 0, -1, 1728683653, 0, 'Lost Cavern', 200000, 7, 0, 0, 0, 0, 705, NULL, 0),
(3673, 0, -1, 1728683653, 0, 'Caveman Shelter', 150000, 12, 0, 0, 0, 0, 137, NULL, 0),
(3674, 0, -1, 1728683653, 0, 'Eastern House of Tranquility', 200000, 12, 0, 0, 0, 0, 313, NULL, 0),
(3675, 0, -1, 1728683653, 0, 'Lakeside Mansion', 300000, 16, 0, 0, 0, 0, 136, NULL, 0),
(3676, 0, -1, 1728683653, 0, 'Pilchard Bin 1', 80000, 16, 0, 0, 0, 0, 14, NULL, 0),
(3677, 0, -1, 1728683653, 0, 'Pilchard Bin 2', 50000, 16, 0, 0, 0, 0, 14, NULL, 0),
(3678, 0, -1, 1728683653, 0, 'Pilchard Bin 3', 50000, 16, 0, 0, 0, 0, 14, NULL, 0),
(3679, 0, -1, 1728683653, 0, 'Pilchard Bin 4', 50000, 16, 0, 0, 0, 0, 14, NULL, 0),
(3680, 0, -1, 1728683653, 0, 'Pilchard Bin 5', 80000, 16, 0, 0, 0, 0, 14, NULL, 0),
(3681, 0, -1, 1728683653, 0, 'Pilchard Bin 6', 25000, 16, 0, 0, 0, 0, 11, NULL, 0),
(3682, 0, -1, 1728683653, 0, 'Pilchard Bin 7', 25000, 16, 0, 0, 0, 0, 11, NULL, 0),
(3683, 0, -1, 1728683653, 0, 'Pilchard Bin 8', 25000, 16, 0, 0, 0, 0, 11, NULL, 0),
(3684, 0, -1, 1728683653, 0, 'Pilchard Bin 9', 50000, 16, 0, 0, 0, 0, 11, NULL, 0),
(3685, 0, -1, 1728683653, 0, 'Pilchard Bin 10', 0, 16, 0, 0, 0, 0, 11, NULL, 0),
(3686, 0, -1, 1728683653, 0, 'Mammoth House', 300000, 16, 0, 0, 0, 0, 280, NULL, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `house_lists`
--

CREATE TABLE `house_lists` (
  `house_id` int(11) NOT NULL,
  `listid` int(11) NOT NULL,
  `version` bigint(20) NOT NULL DEFAULT '0',
  `list` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ip_bans`
--

CREATE TABLE `ip_bans` (
  `ip` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `kv_store`
--

CREATE TABLE `kv_store` (
  `key_name` varchar(191) NOT NULL,
  `timestamp` bigint(20) NOT NULL,
  `value` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `kv_store`
--

INSERT INTO `kv_store` (`key_name`, `timestamp`, `value`) VALUES
('migrations.20231128213158_move_hireling_data_to_kv', 1726091668324, 0x3001),
('migrations.20241708000535_move_achievement_to_kv', 1726091668869, 0x3001),
('migrations.20241708362079_move_vip_system_to_kv', 1726091669328, 0x3001),
('migrations.20241708485868_move_some_storages_to_kv', 1726091669843, 0x3001),
('migrations.20241715984279_move_wheel_scrolls_from_storagename_to_kv', 1726091670334, 0x3001),
('migrations.20241715984294_quests_storages_to_kv', 1726091670835, 0x3001),
('player.10.combat-protection', 1726871115432, 0x19000000000000f03f),
('player.10.daily-reward.streak', 1726868251612, 0x190000000000000000),
('player.10.summary.hirelings.amount', 1726868251463, 0x1000),
('player.10.titles.unlocked.Prince Charming', 1726935475328, 0x10b3e3bbb706),
('player.2.daily-reward.streak', 1730510412635, 0x190000000000000000),
('player.6.daily-reward.streak', 1730510420682, 0x190000000000000000),
('player.7.account.vip-system', 1729899794595, 0x3001),
('player.7.achievements.Allowance Collector-progress', 1726270593925, 0x19000000000000f03f),
('player.7.achievements.Bluebarian-progress', 1726199223117, 0x19000000000000f03f),
('player.7.achievements.points', 1730949296656, 0x1001),
('player.7.achievements.Snowbunny-progress', 1731308125708, 0x190000000000000840),
('player.7.achievements.unlocked.Si, Ariki!', 1730949296656, 0x10b0e1b0b906),
('player.7.badges.unlocked.Global Player (Grade 1)', 1731631048192, 0x10c8afdab906),
('player.7.badges.unlocked.Global Player (Grade 2)', 1731631048190, 0x10c8afdab906),
('player.7.badges.unlocked.Global Player (Grade 3)', 1731631048188, 0x10c8afdab906),
('player.7.boss.cooldown.1727', 1731214630081, 0x190000809955ccd941),
('player.7.boss.cooldown.1758', 1731214226210, 0x190000803455ccd941),
('player.7.boss.cooldown.1804', 1731214164299, 0x190000002555ccd941),
('player.7.combat-protection', 1726169981260, 0x19000000000000f03f),
('player.7.daily-reward.streak', 1731646891140, 0x19000000000000f03f),
('player.7.exhaustion.itemSellerExhaustion', 1731609688268, 0x190000c01991cdd941),
('player.7.exhaustion.training-exhaustion', 1731647484076, 0x1900008001b6cdd941),
('player.7.features.autoloot', 1730825645820, 0x19000000000000f03f),
('player.7.last-mount', 1731535438658, 0x10e601),
('player.7.roulette-finishes', 1730787245229, 0x19000000000000f0bf),
('player.7.summary.hirelings.amount', 1726092239281, 0x1000),
('player.7.summary.xp-boosts.amount', 1726265619671, 0x1001),
('player.7.titles.unlocked.Admirer of the Crown', 1731631048194, 0x10c8afdab906),
('player.7.titles.unlocked.Beaststrider (Grade 1)', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Beaststrider (Grade 2)', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Beaststrider (Grade 3)', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Beaststrider (Grade 4)', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Beaststrider (Grade 5)', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Big Spender', 1731631048194, 0x10c8afdab906),
('player.7.titles.unlocked.Creature of Habit (Grade 1)', 1726433021434, 0x10fd8d9db706),
('player.7.titles.unlocked.Cyclopscamper', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Demondoom', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Dragondouser', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Drakenbane', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Exalted', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Guild Leader', 1731631048194, 0x10c8afdab906),
('player.7.titles.unlocked.Royal Bounacean Advisor', 1731631048194, 0x10c8afdab906),
('player.7.titles.unlocked.Silencer', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Tibia\'s Topmodel (Grade 1)', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Tibia\'s Topmodel (Grade 2)', 1731631048217, 0x10c8afdab906),
('player.7.titles.unlocked.Trolltrasher', 1731631048217, 0x10c8afdab906),
('player.8.achievements.Bluebarian-progress', 1726279820642, 0x19000000000000f03f),
('player.8.combat-protection', 1726284479378, 0x19000000000000f03f),
('player.8.daily-reward.streak', 1726867830196, 0x190000000000000000),
('player.8.summary.hirelings.amount', 1726279613378, 0x1000),
('player.8.titles.unlocked.Apex Predator', 1727467187792, 0x10b39ddcb706),
('player.8.titles.unlocked.Legend of the Axe', 1727467187790, 0x10b39ddcb706),
('player.8.titles.unlocked.Legend of the Shield', 1727467187787, 0x10b39ddcb706),
('player.8.titles.unlocked.Prince Charming', 1726880828261, 0x10bcb8b8b706),
('player.9.account.vip-system', 1730510205203, 0x3001),
('player.9.badges.unlocked.Global Player (Grade 1)', 1731531268017, 0x1084a4d4b906),
('player.9.badges.unlocked.Global Player (Grade 2)', 1731531268016, 0x1084a4d4b906),
('player.9.badges.unlocked.Global Player (Grade 3)', 1731531268016, 0x1084a4d4b906),
('player.9.combat-protection', 1731001469439, 0x19000000000000f03f),
('player.9.daily-reward.streak', 1731515240500, 0x190000000000000000),
('player.9.exhaustion.training-exhaustion', 1731531432023, 0x19000080ac44cdd941),
('player.9.features.autoloot', 1731515422555, 0x19000000000000f03f),
('player.9.summary.hirelings.amount', 1731001469397, 0x1000),
('player.9.titles.unlocked.Legend of Magic', 1731531268024, 0x1084a4d4b906),
('quest.soul-war.ebb-and-flow-maps.is-active', 1731651045324, 0x3001),
('quest.soul-war.ebb-and-flow-maps.is-loaded-empty-map', 1731651045324, 0x3000),
('raids.ankrahmun.the-welter.checks-today', 1731651105341, 0x1900000000009dc340),
('raids.ankrahmun.the-welter.failed-attempts', 1731651105341, 0x190000000000d5c040),
('raids.ankrahmun.the-welter.last-occurrence', 1726868270734, 0x19000080cb7abbd941),
('raids.ankrahmun.the-welter.trigger-when-possible', 1726868270734, 0x3000),
('raids.darashia.tyrn.checks-today', 1731537920254, 0x19000000000014b740),
('raids.darashia.tyrn.failed-attempts', 1731537860305, 0x190000000000807140),
('raids.darashia.tyrn.last-occurrence', 1731515768106, 0x190000005e35cdd941),
('raids.darashia.tyrn.trigger-when-possible', 1731651105341, 0x3001),
('raids.drefia.arachir.checks-today', 1730693358674, 0x19000000000044ab40),
('raids.drefia.arachir.failed-attempts', 1730693298671, 0x1900000000004ea440),
('raids.drefia.arachir.last-occurrence', 1726868270665, 0x19000080cb7abbd941),
('raids.drefia.arachir.trigger-when-possible', 1731651105340, 0x3001),
('raids.drefia.the-pale-count.checks-today', 1730662789913, 0x19000000000039b340),
('raids.drefia.the-pale-count.failed-attempts', 1730662729936, 0x19000000000038b340),
('raids.drefia.the-pale-count.trigger-when-possible', 1731651105341, 0x3001),
('raids.edron.valorcrest.checks-today', 1731374410326, 0x190000000080b3c140),
('raids.edron.valorcrest.failed-attempts', 1731374350325, 0x190000000000b3c140),
('raids.edron.valorcrest.trigger-when-possible', 1731651105341, 0x3001),
('raids.edron.weakened-shlorg.checks-today', 1731216520095, 0x190000000000f0ba40),
('raids.edron.weakened-shlorg.failed-attempts', 1731216460095, 0x19000000000044b440),
('raids.edron.weakened-shlorg.last-occurrence', 1726868270692, 0x19000080cb7abbd941),
('raids.edron.weakened-shlorg.trigger-when-possible', 1731651105341, 0x3001),
('raids.edron.white-pale.checks-today', 1730923301774, 0x19000000000008b940),
('raids.edron.white-pale.failed-attempts', 1730923300295, 0x19000000000007b940),
('raids.edron.white-pale.trigger-when-possible', 1731651105340, 0x3001),
('raids.farmine.draptor.checks-today', 1731651105341, 0x19000000000068bf40),
('raids.farmine.draptor.failed-attempts', 1731651105341, 0x190000000000c88b40),
('raids.farmine.draptor.last-occurrence', 1731515768106, 0x190000005e35cdd941),
('raids.farmine.draptor.trigger-when-possible', 1731515768106, 0x3000),
('raids.folda.yeti.checks-today', 1731651105340, 0x19000000008088c540),
('raids.folda.yeti.failed-attempts', 1731651105340, 0x19000000000022c040),
('raids.folda.yeti.last-occurrence', 1726869410903, 0x19000080e87bbbd941),
('raids.folda.yeti.trigger-when-possible', 1726869410903, 0x3000),
('raids.fury-gates.furiosa.checks-today', 1731651105341, 0x19000000008089c440),
('raids.fury-gates.furiosa.failed-attempts', 1731651105341, 0x190000000000d5c040),
('raids.fury-gates.furiosa.last-occurrence', 1726868270712, 0x19000080cb7abbd941),
('raids.fury-gates.furiosa.trigger-when-possible', 1726868270712, 0x3000),
('raids.muggy_plains.battlemaster_zunzu.checks-today', 1730689218705, 0x190000000000b2b440),
('raids.muggy_plains.battlemaster_zunzu.failed-attempts', 1730689158704, 0x190000000000b1b440),
('raids.muggy_plains.battlemaster_zunzu.trigger-when-possible', 1731651105340, 0x3001),
('raids.nargor.diblis.checks-today', 1731110216472, 0x190000000000ebbd40),
('raids.nargor.diblis.failed-attempts', 1731110156472, 0x190000000000eabd40),
('raids.nargor.diblis.trigger-when-possible', 1731651105340, 0x3001),
('raids.roshamuul.mawhawk.checks-today', 1729920757548, 0x1900000000002bb040),
('raids.roshamuul.mawhawk.failed-attempts', 1729920697545, 0x19000000000072a040),
('raids.roshamuul.mawhawk.last-occurrence', 1726847169051, 0x190000403066bbd941),
('raids.roshamuul.mawhawk.trigger-when-possible', 1731651105340, 0x3001),
('raids.svargrond.hirintror.checks-today', 1731315017448, 0x1900000000000fc140),
('raids.svargrond.hirintror.failed-attempts', 1731314957451, 0x1900000000800ec140),
('raids.svargrond.hirintror.trigger-when-possible', 1731651105341, 0x3001),
('raids.thais.rats.checks-today', 1731651105341, 0x19000000000011b140),
('raids.thais.rats.failed-attempts', 1731651105341, 0x190000000000005840),
('raids.thais.rats.last-occurrence', 1731515768105, 0x190000005e35cdd941),
('raids.thais.rats.trigger-when-possible', 1731515768105, 0x3000),
('raids.thais.wild-horses.checks-today', 1726091734796, 0x190000000000000040),
('raids.thais.wild-horses.failed-attempts', 1726091734796, 0x190000000000000040),
('raids.tiquanda.midnight-panther.checks-today', 1729910677550, 0x1900000000004cb140),
('raids.tiquanda.midnight-panther.failed-attempts', 1729910617546, 0x1900000000004bb140),
('raids.tiquanda.midnight-panther.trigger-when-possible', 1731651105341, 0x3001),
('raids.venore.the-old-widow.checks-today', 1731216880098, 0x1900000000001abf40),
('raids.venore.the-old-widow.failed-attempts', 1731216820098, 0x19000000000019bf40),
('raids.venore.the-old-widow.trigger-when-possible', 1731651105340, 0x3001);

-- --------------------------------------------------------

--
-- Estrutura para tabela `lottery`
--

CREATE TABLE `lottery` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `qnt` int(11) NOT NULL DEFAULT '1',
  `item_name` varchar(255) NOT NULL,
  `date` varchar(256) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Despejando dados para a tabela `lottery`
--

INSERT INTO `lottery` (`id`, `name`, `item`, `qnt`, `item_name`, `date`) VALUES
(1, 'Administrator', '3043', 70, 'crystal coin', '13/09/2024 - 22:57:01'),
(2, 'Administrator', '35290', 1, 'lasting exercise wand', '20/09/2024 - 13:37:17'),
(3, 'Administrator', '35290', 1, 'lasting exercise wand', '20/09/2024 - 16:23:21'),
(4, 'Test Ed', '35288', 1, 'lasting exercise bow', '20/09/2024 - 18:12:32'),
(5, 'Test Ed', '35290', 1, 'lasting exercise wand', '20/09/2024 - 18:20:31'),
(6, 'Administrator', '35287', 1, 'lasting exercise club', '20/09/2024 - 19:58:31'),
(7, 'Administrator', '35286', 1, 'lasting exercise axe', '20/09/2024 - 20:42:31'),
(8, 'Test Chars', '35285', 1, 'lasting exercise sword', '27/09/2024 - 13:12:28'),
(9, 'Administrator', '35285', 1, 'lasting exercise sword', '04/10/2024 - 13:34:18'),
(10, 'Administrator', '35285', 1, 'lasting exercise sword', '25/10/2024 - 16:45:37'),
(11, 'Administrator', '35287', 1, 'lasting exercise club', '25/10/2024 - 17:55:37'),
(12, 'Administrator', '35290', 1, 'lasting exercise wand', '25/10/2024 - 18:15:37'),
(13, 'Administrator', '35290', 1, 'lasting exercise wand', '25/10/2024 - 19:40:37'),
(14, 'Administrator', '35289', 1, 'lasting exercise rod', '25/10/2024 - 20:18:37'),
(15, 'Administrator', '35286', 1, 'lasting exercise axe', '25/10/2024 - 21:01:37'),
(16, 'Administrator', '35290', 1, 'lasting exercise wand', '25/10/2024 - 22:33:37'),
(17, 'Administrator', '35288', 1, 'lasting exercise bow', '01/11/2024 - 20:22:42'),
(18, 'Administrator', '35286', 1, 'lasting exercise axe', '04/11/2024 - 13:52:17'),
(19, 'Administrator', '35290', 1, 'lasting exercise wand', '05/11/2024 - 09:19:56'),
(20, 'Administrator', '35286', 1, 'lasting exercise axe', '05/11/2024 - 10:31:56'),
(21, 'Administrator', '35287', 1, 'lasting exercise club', '05/11/2024 - 13:28:18'),
(22, 'Administrator', '35285', 1, 'lasting exercise sword', '05/11/2024 - 15:13:49'),
(23, 'Administrator', '3043', 60, 'crystal coin', '06/11/2024 - 15:24:56'),
(24, 'Administrator', '35290', 1, 'lasting exercise wand', '06/11/2024 - 16:47:56'),
(25, 'Administrator', '35285', 1, 'lasting exercise sword', '06/11/2024 - 17:06:56'),
(26, 'Administrator', '35288', 1, 'lasting exercise bow', '06/11/2024 - 18:46:56'),
(27, 'Administrator', '35290', 1, 'lasting exercise wand', '07/11/2024 - 19:58:03'),
(28, 'Administrator', '3043', 80, 'crystal coin', '08/11/2024 - 18:52:17'),
(29, 'Administrator', '35287', 1, 'lasting exercise club', '08/11/2024 - 20:44:36'),
(30, 'Administrator', '35287', 1, 'lasting exercise club', '08/11/2024 - 21:38:41'),
(31, 'Administrator', '35290', 1, 'lasting exercise wand', '09/11/2024 - 21:36:40'),
(32, 'Administrator', '35287', 1, 'lasting exercise club', '10/11/2024 - 19:08:24'),
(33, 'Administrator', '3043', 20, 'crystal coin', '11/11/2024 - 13:45:43'),
(34, 'Administrator', '35287', 1, 'lasting exercise club', '11/11/2024 - 19:32:15'),
(35, 'Administrator', '35290', 1, 'lasting exercise wand', '12/11/2024 - 11:21:06'),
(36, 'Administrator', '35288', 1, 'lasting exercise bow', '12/11/2024 - 12:34:06'),
(37, 'Administrator', '35287', 1, 'lasting exercise club', '12/11/2024 - 14:49:09'),
(38, 'Administrator', '35285', 1, 'lasting exercise sword', '12/11/2024 - 15:30:09'),
(39, 'Administrator', '3043', 90, 'crystal coin', '12/11/2024 - 17:10:09'),
(40, 'Test Ms', '35288', 1, 'lasting exercise bow', '13/11/2024 - 09:01:13'),
(41, 'Test Ms', '35290', 1, 'lasting exercise wand', '13/11/2024 - 09:34:03'),
(42, 'Test Ms', '35290', 1, 'lasting exercise wand', '13/11/2024 - 10:25:10'),
(43, 'Administrator', '35286', 1, 'lasting exercise axe', '13/11/2024 - 10:30:39'),
(44, 'Administrator', '35289', 1, 'lasting exercise rod', '13/11/2024 - 10:52:58'),
(45, 'Administrator', '35286', 1, 'lasting exercise axe', '13/11/2024 - 11:12:42'),
(46, 'Administrator', '3043', 50, 'crystal coin', '13/11/2024 - 11:49:39'),
(47, 'Test Ms', '35289', 1, 'lasting exercise rod', '13/11/2024 - 13:33:34'),
(48, 'Administrator', '35286', 1, 'lasting exercise axe', '13/11/2024 - 14:38:20'),
(49, 'Administrator', '35286', 1, 'lasting exercise axe', '13/11/2024 - 15:20:20'),
(50, 'Administrator', '35287', 1, 'lasting exercise club', '13/11/2024 - 16:02:05'),
(51, 'Administrator', '35285', 1, 'lasting exercise sword', '13/11/2024 - 16:37:00'),
(52, 'Administrator', '35286', 1, 'lasting exercise axe', '13/11/2024 - 16:56:24'),
(53, 'Administrator', '35286', 1, 'lasting exercise axe', '13/11/2024 - 17:50:32'),
(54, 'Administrator', '35287', 1, 'lasting exercise club', '13/11/2024 - 18:28:32'),
(55, 'Administrator', '35288', 1, 'lasting exercise bow', '13/11/2024 - 19:08:32'),
(56, 'Administrator', '3043', 100, 'crystal coin', '14/11/2024 - 08:59:02'),
(57, 'Administrator', '3043', 70, 'crystal coin', '14/11/2024 - 13:18:11'),
(58, 'Administrator', '35287', 1, 'lasting exercise club', '14/11/2024 - 19:08:45');

-- --------------------------------------------------------

--
-- Estrutura para tabela `market_history`
--

CREATE TABLE `market_history` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT '0',
  `itemtype` int(10) UNSIGNED NOT NULL,
  `amount` smallint(5) UNSIGNED NOT NULL,
  `price` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `expires_at` bigint(20) UNSIGNED NOT NULL,
  `inserted` bigint(20) UNSIGNED NOT NULL,
  `state` tinyint(1) UNSIGNED NOT NULL,
  `tier` tinyint(3) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `market_offers`
--

CREATE TABLE `market_offers` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT '0',
  `itemtype` int(10) UNSIGNED NOT NULL,
  `amount` smallint(5) UNSIGNED NOT NULL,
  `created` bigint(20) UNSIGNED NOT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `price` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `tier` tinyint(3) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_account_actions`
--

CREATE TABLE `myaac_account_actions` (
  `account_id` int(11) NOT NULL,
  `ip` varchar(16) NOT NULL DEFAULT '0.0.0.0',
  `ipv6` binary(16) NOT NULL DEFAULT '0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `date` int(11) NOT NULL DEFAULT '0',
  `action` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `myaac_account_actions`
--

INSERT INTO `myaac_account_actions` (`account_id`, `ip`, `ipv6`, `date`, `action`) VALUES
(2, '0', 0x00000000000000000000000000000001, 1729412980, 'Authentication (2FA) <b>Activated</b>.'),
(2, '0', 0x00000000000000000000000000000001, 1729837329, 'Authentication (2FA) <b>Deactivated</b>.'),
(2, '0', 0x00000000000000000000000000000001, 1729837618, 'Authentication (2FA) <b>Deactivated</b>.'),
(2, '0', 0x00000000000000000000000000000001, 1729838153, 'Authentication (2FA) <b>Activated</b>.');

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_admin_menu`
--

CREATE TABLE `myaac_admin_menu` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `page` varchar(255) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `flags` int(11) NOT NULL DEFAULT '0',
  `enabled` int(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_bugtracker`
--

CREATE TABLE `myaac_bugtracker` (
  `account` varchar(255) NOT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  `id` int(11) NOT NULL DEFAULT '0',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `reply` int(11) NOT NULL DEFAULT '0',
  `who` int(11) NOT NULL DEFAULT '0',
  `uid` int(11) NOT NULL,
  `tag` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_changelog`
--

CREATE TABLE `myaac_changelog` (
  `id` int(11) NOT NULL,
  `body` varchar(500) NOT NULL DEFAULT '',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 - added, 2 - removed, 3 - changed, 4 - fixed',
  `where` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 - server, 2 - site',
  `date` int(11) NOT NULL DEFAULT '0',
  `player_id` int(11) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `myaac_changelog`
--

INSERT INTO `myaac_changelog` (`id`, `body`, `type`, `where`, `date`, `player_id`, `hidden`) VALUES
(1, 'MyAAC installed. (:', 3, 2, 1726085499, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_charbazaar`
--

CREATE TABLE `myaac_charbazaar` (
  `id` int(11) NOT NULL,
  `account_old` int(11) NOT NULL,
  `account_new` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `date_end` datetime NOT NULL,
  `date_start` datetime NOT NULL,
  `bid_account` int(11) NOT NULL,
  `bid_price` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_charbazaar_bid`
--

CREATE TABLE `myaac_charbazaar_bid` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `auction_id` int(11) NOT NULL,
  `bid` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_config`
--

CREATE TABLE `myaac_config` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `value` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `myaac_config`
--

INSERT INTO `myaac_config` (`id`, `name`, `value`) VALUES
(1, 'database_version', '35'),
(2, 'status_online', ''),
(3, 'status_players', '0'),
(4, 'status_playersMax', '0'),
(5, 'status_lastCheck', '1731643388'),
(6, 'status_uptime', '21742'),
(7, 'status_monsters', '81543'),
(8, 'views_counter', '1258'),
(9, 'status_uptimeReadable', 'month, day, 03h 02m'),
(10, 'status_motd', 'EnaraOT Global!'),
(11, 'status_mapAuthor', 'OpenTibiaBR'),
(12, 'status_mapName', 'otservbr'),
(13, 'status_mapWidth', '35143'),
(14, 'status_mapHeight', '34812'),
(15, 'status_server', 'Canary'),
(16, 'status_serverVersion', '3.0'),
(17, 'status_clientVersion', '13.40'),
(18, 'status_playersTotal', '1');

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_faq`
--

CREATE TABLE `myaac_faq` (
  `id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL DEFAULT '',
  `answer` varchar(1020) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_forum`
--

CREATE TABLE `myaac_forum` (
  `id` int(11) NOT NULL,
  `first_post` int(11) NOT NULL DEFAULT '0',
  `last_post` int(11) NOT NULL DEFAULT '0',
  `section` int(3) NOT NULL DEFAULT '0',
  `replies` int(20) NOT NULL DEFAULT '0',
  `views` int(20) NOT NULL DEFAULT '0',
  `author_aid` int(20) NOT NULL DEFAULT '0',
  `author_guid` int(20) NOT NULL DEFAULT '0',
  `post_text` text NOT NULL,
  `post_topic` varchar(255) NOT NULL DEFAULT '',
  `post_smile` tinyint(1) NOT NULL DEFAULT '0',
  `post_html` tinyint(1) NOT NULL DEFAULT '0',
  `post_date` int(20) NOT NULL DEFAULT '0',
  `last_edit_aid` int(20) NOT NULL DEFAULT '0',
  `edit_date` int(20) NOT NULL DEFAULT '0',
  `post_ip` varchar(32) NOT NULL DEFAULT '0.0.0.0',
  `sticked` tinyint(1) NOT NULL DEFAULT '0',
  `closed` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_forum_boards`
--

CREATE TABLE `myaac_forum_boards` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `guild` int(11) NOT NULL DEFAULT '0',
  `access` int(11) NOT NULL DEFAULT '0',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `myaac_forum_boards`
--

INSERT INTO `myaac_forum_boards` (`id`, `name`, `description`, `ordering`, `guild`, `access`, `closed`, `hidden`) VALUES
(1, 'News', 'News commenting', 0, 0, 0, 1, 0),
(2, 'Trade', 'Trade offers.', 1, 0, 0, 0, 0),
(3, 'Quests', 'Quest making.', 2, 0, 0, 0, 0),
(4, 'Pictures', 'Your pictures.', 3, 0, 0, 0, 0),
(5, 'Bug Report', 'Report bugs there.', 4, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_gallery`
--

CREATE TABLE `myaac_gallery` (
  `id` int(11) NOT NULL,
  `comment` varchar(255) NOT NULL DEFAULT '',
  `image` varchar(255) NOT NULL,
  `thumb` varchar(255) NOT NULL,
  `author` varchar(50) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `myaac_gallery`
--

INSERT INTO `myaac_gallery` (`id`, `comment`, `image`, `thumb`, `author`, `ordering`, `hidden`) VALUES
(1, 'Demon', 'images/gallery/demon.jpg', 'images/gallery/demon_thumb.gif', 'MyAAC', 1, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_menu`
--

CREATE TABLE `myaac_menu` (
  `id` int(11) NOT NULL,
  `template` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `link` varchar(255) NOT NULL,
  `blank` tinyint(1) NOT NULL DEFAULT '0',
  `color` varchar(6) NOT NULL DEFAULT '',
  `category` int(11) NOT NULL DEFAULT '1',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `enabled` int(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `myaac_menu`
--

INSERT INTO `myaac_menu` (`id`, `template`, `name`, `link`, `blank`, `color`, `category`, `ordering`, `enabled`) VALUES
(1, 'tibiacom', 'Latest News', 'news', 0, '', 1, 0, 1),
(2, 'tibiacom', 'News Archive', 'news/archive', 0, '', 1, 1, 1),
(3, 'tibiacom', 'Event Schedule', 'eventcalendar', 0, '', 1, 2, 1),
(4, 'tibiacom', 'Account Management', 'account/manage', 0, '', 2, 0, 1),
(5, 'tibiacom', 'Create Account', 'account/create', 0, '', 2, 1, 1),
(6, 'tibiacom', 'Lost Account?', 'account/lost', 0, '', 2, 2, 1),
(7, 'tibiacom', 'Server Rules', 'rules', 0, '', 2, 3, 1),
(8, 'tibiacom', 'Downloads', 'downloadclient', 0, '', 2, 4, 1),
(9, 'tibiacom', 'Report Bug', 'bugtracker', 0, '', 2, 5, 1),
(10, 'tibiacom', 'Characters', 'characters', 0, '', 3, 0, 1),
(11, 'tibiacom', 'Who Is Online?', 'online', 0, '', 3, 1, 1),
(12, 'tibiacom', 'Highscores', 'highscores', 0, '', 3, 2, 1),
(13, 'tibiacom', 'Last Kills', 'lastkills', 0, '', 3, 3, 1),
(14, 'tibiacom', 'Houses', 'houses', 0, '', 3, 4, 1),
(15, 'tibiacom', 'Guilds', 'guilds', 0, '', 3, 5, 1),
(16, 'tibiacom', 'Polls', 'polls', 0, '', 3, 6, 1),
(17, 'tibiacom', 'Bans', 'bans', 0, '', 3, 7, 1),
(18, 'tibiacom', 'Support List', 'team', 0, '', 3, 8, 1),
(19, 'tibiacom', 'Forum', 'forum', 0, '', 4, 0, 1),
(20, 'tibiacom', 'Creatures', 'creatures', 0, '', 5, 0, 1),
(21, 'tibiacom', 'Spells', 'spells', 0, '', 5, 1, 1),
(22, 'tibiacom', 'Commands', 'commands', 0, '', 5, 2, 1),
(23, 'tibiacom', 'Gallery', 'gallery', 0, '', 5, 3, 1),
(24, 'tibiacom', 'Server Info', 'serverInfo', 0, '', 5, 4, 1),
(25, 'tibiacom', 'Experience Table', 'experienceTable', 0, '', 5, 5, 1),
(26, 'tibiacom', 'Current Auctions', 'currentcharactertrades', 0, '', 7, 0, 1),
(27, 'tibiacom', 'Auction History', 'pastcharactertrades', 0, '', 7, 1, 1),
(28, 'tibiacom', 'My Bids', 'ownbids', 0, '', 7, 2, 1),
(29, 'tibiacom', 'My Auctions', 'owncharactertrades', 0, '', 7, 3, 1),
(30, 'tibiacom', 'Create Auction', 'createcharacterauction', 0, '', 7, 4, 1),
(31, 'tibiacom', 'Donate', 'donate', 0, '', 6, 0, 1),
(32, 'tibiacom', 'Boxes', 'boxes', 0, '', 6, 0, 1),
(33, 'tibiacom', 'Shop Offer', 'gifts', 0, '', 6, 1, 1),
(34, 'tibiacom', 'Shop History', 'gifts/history', 0, '', 6, 2, 1),
(305, 'enaraot', 'Latest News', 'news', 0, '', 1, 0, 1),
(306, 'enaraot', 'News Archive', 'news/archive', 0, '', 1, 1, 1),
(307, 'enaraot', 'Event Schedule', 'eventcalendar', 0, '', 1, 2, 1),
(308, 'enaraot', 'Account Management', 'account/manage', 0, '', 2, 0, 1),
(309, 'enaraot', 'Create Account', 'account/create', 0, '', 2, 1, 1),
(310, 'enaraot', 'Lost Account?', 'account/lost', 0, '', 2, 2, 1),
(311, 'enaraot', 'Server Rules', 'rules', 0, '', 2, 3, 1),
(312, 'enaraot', 'Downloads', 'subtopic=downloadclient&step=downloadagreement', 0, '', 2, 4, 1),
(313, 'enaraot', 'Report Bug', 'bugtracker', 0, '', 2, 5, 1),
(314, 'enaraot', 'Characters', 'characters', 0, '', 3, 0, 1),
(315, 'enaraot', 'Who Is Online?', 'online', 0, '', 3, 1, 1),
(316, 'enaraot', 'Highscores', 'highscores', 0, '', 3, 2, 1),
(317, 'enaraot', 'Last Deaths', 'lastkills', 0, '', 3, 3, 1),
(318, 'enaraot', 'Houses', 'houses', 0, '', 3, 4, 1),
(319, 'enaraot', 'Guilds', 'guilds', 0, '', 3, 5, 1),
(320, 'enaraot', 'Bans', 'bans', 0, '', 3, 6, 1),
(321, 'enaraot', 'Support List', 'team', 0, '', 3, 7, 1),
(322, 'enaraot', 'Forum', 'forum', 0, '', 4, 0, 1),
(323, 'enaraot', 'Server Info', 'serverInfo', 0, '', 5, 0, 1),
(324, 'enaraot', 'Raid Calendar <img src=\"templates/enaraot/images/icons/new.gif\">', 'raids', 0, 'ffff00', 5, 1, 1),
(325, 'enaraot', 'VIP & Loyalty <img src=\"templates/enaraot/images/icons/new.gif\">', 'vip', 0, 'ffff00', 5, 2, 1),
(326, 'enaraot', 'Spells <img src=\"templates/enaraot/images/icons/new.gif\">', 'spells', 0, '', 8, 0, 1),
(327, 'enaraot', 'Roulette <img src=\"templates/enaraot/images/icons/new.gif\">', 'roulette', 0, '', 8, 1, 1),
(328, 'enaraot', 'War Castle<img src=\"templates/enaraot/images/icons/new.gif\">', 'warCastle', 0, '', 8, 2, 1),
(329, 'enaraot', 'City War<img src=\"templates/enaraot/images/icons/new.gif\">', 'warCity', 0, '', 8, 3, 1),
(330, 'enaraot', 'Hunting Tasks<img src=\"templates/enaraot/images/icons/new.gif\">', 'huntingTasks', 0, '', 8, 4, 1),
(331, 'enaraot', 'Hunting Event<img src=\"templates/enaraot/images/icons/new.gif\">', 'huntingEvent', 0, '', 8, 5, 1),
(332, 'enaraot', 'Lottery<img src=\"templates/enaraot/images/icons/new.gif\">', 'lottery', 0, '', 8, 6, 1),
(333, 'enaraot', 'Current Auctions', 'currentcharactertrades', 0, '', 7, 0, 1),
(334, 'enaraot', 'Auction History', 'pastcharactertrades', 0, '', 7, 1, 1),
(335, 'enaraot', 'My Bids', 'ownbids', 0, '', 7, 2, 1),
(336, 'enaraot', 'My Auctions', 'owncharactertrades', 0, '', 7, 3, 1),
(337, 'enaraot', 'Create Auction', 'createcharacterauction', 0, '', 7, 4, 1),
(338, 'enaraot', 'Shop', 'subtopic=shop&step=terms', 0, '', 6, 0, 1),
(339, 'enaraot', 'Boxes', 'boxes', 0, '', 6, 1, 1),
(340, 'enaraot', 'Donate', 'donate', 0, '', 6, 2, 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_monsters`
--

CREATE TABLE `myaac_monsters` (
  `id` int(11) NOT NULL,
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `mana` int(11) NOT NULL DEFAULT '0',
  `exp` int(11) NOT NULL,
  `health` int(11) NOT NULL,
  `speed_lvl` int(11) NOT NULL DEFAULT '1',
  `use_haste` tinyint(1) NOT NULL,
  `voices` text NOT NULL,
  `immunities` varchar(255) NOT NULL,
  `elements` text NOT NULL,
  `summonable` tinyint(1) NOT NULL,
  `convinceable` tinyint(1) NOT NULL,
  `pushable` tinyint(1) NOT NULL DEFAULT '0',
  `canpushitems` tinyint(1) NOT NULL DEFAULT '0',
  `canwalkonenergy` tinyint(1) NOT NULL DEFAULT '0',
  `canwalkonpoison` tinyint(1) NOT NULL DEFAULT '0',
  `canwalkonfire` tinyint(1) NOT NULL DEFAULT '0',
  `runonhealth` tinyint(1) NOT NULL DEFAULT '0',
  `hostile` tinyint(1) NOT NULL DEFAULT '0',
  `attackable` tinyint(1) NOT NULL DEFAULT '0',
  `rewardboss` tinyint(1) NOT NULL DEFAULT '0',
  `defense` int(11) NOT NULL DEFAULT '0',
  `armor` int(11) NOT NULL DEFAULT '0',
  `canpushcreatures` tinyint(1) NOT NULL DEFAULT '0',
  `race` varchar(255) NOT NULL,
  `loot` text NOT NULL,
  `summons` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_news`
--

CREATE TABLE `myaac_news` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `body` text NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 - news, 2 - ticker, 3 - article',
  `date` int(11) NOT NULL DEFAULT '0',
  `category` tinyint(1) NOT NULL DEFAULT '0',
  `player_id` int(11) NOT NULL DEFAULT '0',
  `last_modified_by` int(11) NOT NULL DEFAULT '0',
  `last_modified_date` int(11) NOT NULL DEFAULT '0',
  `comments` varchar(50) NOT NULL DEFAULT '',
  `article_text` varchar(1000) NOT NULL,
  `article_image` varchar(100) NOT NULL DEFAULT '',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `myaac_news`
--

INSERT INTO `myaac_news` (`id`, `title`, `body`, `type`, `date`, `category`, `player_id`, `last_modified_by`, `last_modified_date`, `comments`, `article_text`, `article_image`, `hidden`) VALUES
(1, '➤ EnaraOT Global Servers ✦ Client: 13.40 ✦ NA & SA Host ✦ Custom features', '', 3, 1726085760, 2, 7, 0, 0, '', 'We are proud to launch the most reliable and requested otserv to the NA and SA communities! It has low ping and high custom features and is reliable for global content and enhancements that all the community likes! Dive into this new world and make new friends!\r\n<br><br>\r\nRemember to keep connected to our Discord server to get all the features, info, and support and to receive alerts like Boss Spawns, Events, and Rare mounts.', 'templates/enaraot/images/header/tibia-logo-artwork-top.png', 0),
(2, 'Hello tickets!', 'https://github.com/opentibiabr/myaac', 2, 1726085760, 4, 7, 0, 0, '', '', '', 0),
(3, 'Hello tickets!', 'https://github.com/opentibiabr/myaac', 1, 1726085760, 4, 7, 0, 0, '', '', '', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_news_categories`
--

CREATE TABLE `myaac_news_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `description` varchar(50) NOT NULL DEFAULT '',
  `icon_id` int(2) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `myaac_news_categories`
--

INSERT INTO `myaac_news_categories` (`id`, `name`, `description`, `icon_id`, `hidden`) VALUES
(1, '', '', 0, 0),
(2, '', '', 1, 0),
(3, '', '', 2, 0),
(4, '', '', 3, 0),
(5, '', '', 4, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_notepad`
--

CREATE TABLE `myaac_notepad` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `content` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_pages`
--

CREATE TABLE `myaac_pages` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `title` varchar(30) NOT NULL,
  `body` longtext NOT NULL,
  `date` int(11) NOT NULL DEFAULT '0',
  `player_id` int(11) NOT NULL DEFAULT '0',
  `php` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 - plain html, 1 - php',
  `enable_tinymce` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 - enabled, 0 - disabled',
  `access` tinyint(2) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `myaac_pages`
--

INSERT INTO `myaac_pages` (`id`, `name`, `title`, `body`, `date`, `player_id`, `php`, `enable_tinymce`, `access`, `hidden`) VALUES
(1, 'downloads', 'Downloads', '<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<div style=\"text-align: center;\">We\'re using official Tibia Client <strong>{{ config.client / 100 }}</strong><br />\r\n<p>Download Tibia Client <strong>{{ config.client / 100 }}</strong>&nbsp;for Windows <a href=\"https://drive.google.com/drive/folders/0B2-sMQkWYzhGSFhGVlY2WGk5czQ\" target=\"_blank\" rel=\"noopener\">HERE</a>.</p>\r\n<h2>IP Changer:</h2>\r\n<a href=\"https://static.otland.net/ipchanger.exe\" target=\"_blank\" rel=\"noopener\">HERE</a></div>', 0, 1, 0, 1, 1, 1),
(2, 'commands', 'Commands', '<table style=\"border-collapse: collapse; width: 87.8471%; height: 57px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 33.3333%; background-color: #505050; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Words</strong></span></td>\r\n<td style=\"width: 33.3333%; background-color: #505050; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Description</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 33.3333%; height: 18px;\"><em>!example</em></td>\r\n<td style=\"width: 33.3333%; height: 18px;\">This is just an example</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #d4c0a1;\">\r\n<td style=\"width: 33.3333%; height: 18px;\"><em>!buyhouse</em></td>\r\n<td style=\"width: 33.3333%; height: 18px;\">Buy house you are looking at</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 33.3333%; height: 18px;\"><em>!aol</em></td>\r\n<td style=\"width: 33.3333%; height: 18px;\">Buy AoL</td>\r\n</tr>\r\n</tbody>\r\n</table>', 0, 1, 0, 1, 1, 0),
(3, 'rules_on_the_page', 'Rules', '1. Names\r\na) Names which contain insulting (e.g. \"Bastard\"), racist (e.g. \"Nigger\"), extremely right-wing (e.g. \"Hitler\"), sexist (e.g. \"Bitch\") or offensive (e.g. \"Copkiller\") language.\r\nb) Names containing parts of sentences (e.g. \"Mike returns\"), nonsensical combinations of letters (e.g. \"Fgfshdsfg\") or invalid formattings (e.g. \"Thegreatknight\").\r\nc) Names that obviously do not describe a person (e.g. \"Christmastree\", \"Matrix\"), names of real life celebrities (e.g. \"Britney Spears\"), names that refer to real countries (e.g. \"Swedish Druid\"), names which were created to fake other players\' identities (e.g. \"Arieswer\" instead of \"Arieswar\") or official positions (e.g. \"System Admin\").\r\n\r\n2. Cheating\r\na) Exploiting obvious errors of the game (\"bugs\"), for instance to duplicate items. If you find an error you must report it to CipSoft immediately.\r\nb) Intentional abuse of weaknesses in the gameplay, for example arranging objects or players in a way that other players cannot move them.\r\nc) Using tools to automatically perform or repeat certain actions without any interaction by the player (\"macros\").\r\nd) Manipulating the client program or using additional software to play the game.\r\ne) Trying to steal other players\' account data (\"hacking\").\r\nf) Playing on more than one account at the same time (\"multi-clienting\").\r\ng) Offering account data to other players or accepting other players\' account data (\"account-trading/sharing\").\r\n\r\n3. Gamemasters\r\na) Threatening a gamemaster because of his or her actions or position as a gamemaster.\r\nb) Pretending to be a gamemaster or to have influence on the decisions of a gamemaster.\r\nc) Intentionally giving wrong or misleading information to a gamemaster concerning his or her investigations or making false reports about rule violations.\r\n\r\n4. Player Killing\r\na) Excessive killing of characters who are not marked with a \"skull\" on worlds which are not PvP-enforced. Please note that killing marked characters is not a reason for a banishment.\r\n\r\nA violation of the Tibia Rules may lead to temporary banishment of characters and accounts. In severe cases removal or modification of character skills, attributes and belongings, as well as the permanent removal of accounts without any compensation may be considered. The sanction is based on the seriousness of the rule violation and the previous record of the player. It is determined by the gamemaster imposing the banishment.\r\n\r\nThese rules may be changed at any time. All changes will be announced on the official website.', 0, 1, 0, 0, 1, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_polls`
--

CREATE TABLE `myaac_polls` (
  `id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `end` int(11) NOT NULL,
  `start` int(11) NOT NULL,
  `answers` int(11) NOT NULL,
  `votes_all` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_polls_answers`
--

CREATE TABLE `myaac_polls_answers` (
  `poll_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `answer` varchar(255) NOT NULL,
  `votes` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_spells`
--

CREATE TABLE `myaac_spells` (
  `id` int(11) NOT NULL,
  `spell` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL,
  `words` varchar(255) NOT NULL DEFAULT '',
  `category` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 - attack, 2 - healing, 3 - summon, 4 - supply, 5 - support',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 - instant, 2 - conjure, 3 - rune',
  `level` int(11) NOT NULL DEFAULT '0',
  `maglevel` int(11) NOT NULL DEFAULT '0',
  `mana` int(11) NOT NULL DEFAULT '0',
  `soul` tinyint(3) NOT NULL DEFAULT '0',
  `conjure_id` int(11) NOT NULL DEFAULT '0',
  `conjure_count` tinyint(3) NOT NULL DEFAULT '0',
  `reagent` int(11) NOT NULL DEFAULT '0',
  `item_id` int(11) NOT NULL DEFAULT '0',
  `premium` tinyint(1) NOT NULL DEFAULT '0',
  `vocations` varchar(100) NOT NULL DEFAULT '',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_videos`
--

CREATE TABLE `myaac_videos` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL DEFAULT '',
  `youtube_id` varchar(20) NOT NULL,
  `author` varchar(50) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_visitors`
--

CREATE TABLE `myaac_visitors` (
  `ip` varchar(45) NOT NULL,
  `lastvisit` int(11) NOT NULL DEFAULT '0',
  `page` varchar(2048) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `myaac_visitors`
--

INSERT INTO `myaac_visitors` (`ip`, `lastvisit`, `page`) VALUES
('10.0.0.136', 1731296870, '/?huntingTasks');

-- --------------------------------------------------------

--
-- Estrutura para tabela `myaac_weapons`
--

CREATE TABLE `myaac_weapons` (
  `id` int(11) NOT NULL,
  `level` int(11) NOT NULL DEFAULT '0',
  `maglevel` int(11) NOT NULL DEFAULT '0',
  `vocations` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `group_id` int(11) NOT NULL DEFAULT '1',
  `account_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `vocation` int(11) NOT NULL DEFAULT '0',
  `health` int(11) NOT NULL DEFAULT '150',
  `healthmax` int(11) NOT NULL DEFAULT '150',
  `experience` bigint(20) NOT NULL DEFAULT '0',
  `lookbody` int(11) NOT NULL DEFAULT '0',
  `lookfeet` int(11) NOT NULL DEFAULT '0',
  `lookhead` int(11) NOT NULL DEFAULT '0',
  `looklegs` int(11) NOT NULL DEFAULT '0',
  `looktype` int(11) NOT NULL DEFAULT '136',
  `lookaddons` int(11) NOT NULL DEFAULT '0',
  `maglevel` int(11) NOT NULL DEFAULT '0',
  `mana` int(11) NOT NULL DEFAULT '0',
  `manamax` int(11) NOT NULL DEFAULT '0',
  `manaspent` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `soul` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `town_id` int(11) NOT NULL DEFAULT '1',
  `posx` int(11) NOT NULL DEFAULT '0',
  `posy` int(11) NOT NULL DEFAULT '0',
  `posz` int(11) NOT NULL DEFAULT '0',
  `conditions` mediumblob NOT NULL,
  `cap` int(11) NOT NULL DEFAULT '0',
  `sex` int(11) NOT NULL DEFAULT '0',
  `pronoun` int(11) NOT NULL DEFAULT '0',
  `lastlogin` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `lastip` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `save` tinyint(1) NOT NULL DEFAULT '1',
  `skull` tinyint(1) NOT NULL DEFAULT '0',
  `skulltime` bigint(20) NOT NULL DEFAULT '0',
  `lastlogout` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `blessings` tinyint(2) NOT NULL DEFAULT '0',
  `blessings1` tinyint(4) NOT NULL DEFAULT '0',
  `blessings2` tinyint(4) NOT NULL DEFAULT '0',
  `blessings3` tinyint(4) NOT NULL DEFAULT '0',
  `blessings4` tinyint(4) NOT NULL DEFAULT '0',
  `blessings5` tinyint(4) NOT NULL DEFAULT '0',
  `blessings6` tinyint(4) NOT NULL DEFAULT '0',
  `blessings7` tinyint(4) NOT NULL DEFAULT '0',
  `blessings8` tinyint(4) NOT NULL DEFAULT '0',
  `onlinetime` int(11) NOT NULL DEFAULT '0',
  `deletion` bigint(15) NOT NULL DEFAULT '0',
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `offlinetraining_time` smallint(5) UNSIGNED NOT NULL DEFAULT '43200',
  `offlinetraining_skill` tinyint(2) NOT NULL DEFAULT '-1',
  `stamina` smallint(5) UNSIGNED NOT NULL DEFAULT '2520',
  `skill_fist` int(10) UNSIGNED NOT NULL DEFAULT '10',
  `skill_fist_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_club` int(10) UNSIGNED NOT NULL DEFAULT '10',
  `skill_club_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_sword` int(10) UNSIGNED NOT NULL DEFAULT '10',
  `skill_sword_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_axe` int(10) UNSIGNED NOT NULL DEFAULT '10',
  `skill_axe_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_dist` int(10) UNSIGNED NOT NULL DEFAULT '10',
  `skill_dist_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_shielding` int(10) UNSIGNED NOT NULL DEFAULT '10',
  `skill_shielding_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_fishing` int(10) UNSIGNED NOT NULL DEFAULT '10',
  `skill_fishing_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_critical_hit_chance` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `skill_critical_hit_chance_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_critical_hit_damage` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `skill_critical_hit_damage_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_life_leech_chance` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `skill_life_leech_chance_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_life_leech_amount` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `skill_life_leech_amount_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_mana_leech_chance` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `skill_mana_leech_chance_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_mana_leech_amount` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `skill_mana_leech_amount_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_criticalhit_chance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_criticalhit_damage` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_lifeleech_chance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_lifeleech_amount` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_manaleech_chance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `skill_manaleech_amount` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `manashield` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `max_manashield` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `xpboost_stamina` smallint(5) UNSIGNED DEFAULT NULL,
  `xpboost_value` tinyint(4) UNSIGNED DEFAULT NULL,
  `marriage_status` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `marriage_spouse` int(11) NOT NULL DEFAULT '-1',
  `bonus_rerolls` bigint(21) NOT NULL DEFAULT '0',
  `prey_wildcard` bigint(21) NOT NULL DEFAULT '0',
  `task_points` bigint(21) NOT NULL DEFAULT '0',
  `quickloot_fallback` tinyint(1) DEFAULT '0',
  `lookmountbody` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `lookmountfeet` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `lookmounthead` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `lookmountlegs` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `lookfamiliarstype` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `isreward` tinyint(1) NOT NULL DEFAULT '1',
  `istutorial` tinyint(1) NOT NULL DEFAULT '0',
  `ismain` tinyint(1) NOT NULL DEFAULT '0',
  `forge_dusts` bigint(21) NOT NULL DEFAULT '0',
  `forge_dust_level` bigint(21) NOT NULL DEFAULT '100',
  `randomize_mount` tinyint(1) NOT NULL DEFAULT '0',
  `boss_points` int(11) NOT NULL DEFAULT '0',
  `created` int(11) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  `comment` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `players`
--

INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `maglevel`, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `pronoun`, `lastlogin`, `lastip`, `save`, `skull`, `skulltime`, `lastlogout`, `blessings`, `blessings1`, `blessings2`, `blessings3`, `blessings4`, `blessings5`, `blessings6`, `blessings7`, `blessings8`, `onlinetime`, `deletion`, `balance`, `offlinetraining_time`, `offlinetraining_skill`, `stamina`, `skill_fist`, `skill_fist_tries`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`, `skill_shielding`, `skill_shielding_tries`, `skill_fishing`, `skill_fishing_tries`, `skill_critical_hit_chance`, `skill_critical_hit_chance_tries`, `skill_critical_hit_damage`, `skill_critical_hit_damage_tries`, `skill_life_leech_chance`, `skill_life_leech_chance_tries`, `skill_life_leech_amount`, `skill_life_leech_amount_tries`, `skill_mana_leech_chance`, `skill_mana_leech_chance_tries`, `skill_mana_leech_amount`, `skill_mana_leech_amount_tries`, `skill_criticalhit_chance`, `skill_criticalhit_damage`, `skill_lifeleech_chance`, `skill_lifeleech_amount`, `skill_manaleech_chance`, `skill_manaleech_amount`, `manashield`, `max_manashield`, `xpboost_stamina`, `xpboost_value`, `marriage_status`, `marriage_spouse`, `bonus_rerolls`, `prey_wildcard`, `task_points`, `quickloot_fallback`, `lookmountbody`, `lookmountfeet`, `lookmounthead`, `lookmountlegs`, `lookfamiliarstype`, `isreward`, `istutorial`, `ismain`, `forge_dusts`, `forge_dust_level`, `randomize_mount`, `boss_points`, `created`, `hidden`, `comment`) VALUES
(1, 'Rook Sample', 1, 1, 2, 0, 155, 155, 100, 113, 115, 95, 39, 129, 0, 2, 60, 60, 5936, 0, 1, 32069, 31901, 6, '', 410, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 12, 155, 12, 155, 12, 155, 12, 93, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 0, 0, 0, 0, ''),
(2, 'Sorcerer Sample', 1, 1, 8, 1, 185, 185, 4200, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 0, 8, 32369, 32241, 7, '', 470, 1, 0, 1730510412, 2281701386, 1, 0, 0, 1730510417, 0, 1, 1, 1, 1, 1, 1, 1, 1, 5, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 0, 0, 0, 0, ''),
(3, 'Druid Sample', 1, 1, 8, 2, 185, 185, 4200, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 0, 8, 32369, 32241, 7, '', 470, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 0, 0, 0, 0, ''),
(4, 'Paladin Sample', 1, 1, 8, 3, 185, 185, 4200, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 0, 8, 32369, 32241, 7, '', 470, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 0, 0, 0, 0, ''),
(5, 'Knight Sample', 1, 1, 8, 4, 185, 185, 4200, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 0, 8, 32369, 32241, 7, '', 470, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 0, 0, 0, 0, ''),
(6, 'GOD', 6, 1, 2, 0, 155, 155, 100, 113, 115, 95, 39, 733, 0, 0, 60, 60, 0, 0, 8, 32369, 32233, 7, 0x011a02ffffffff03000000001b001c000000001f00001e00002300fe, 410, 1, 0, 1730510420, 2281701386, 1, 0, 0, 1730510438, 0, 1, 1, 1, 1, 1, 1, 1, 1, 18, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 0, 0, 0, 0, ''),
(7, 'Administrator', 6, 2, 2000, 1, 135, 135, 132948302150, 94, 94, 94, 107, 1094, 3, 120, 135, 135, 0, 100, 8, 32197, 32295, 6, '', 70, 0, 0, 1731643390, 2281701386, 1, 0, 0, 1731651130, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1099063, 0, 37961, 43200, -1, 2520, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3600, 50, 0, -1, 0, 4, 0, 1, 0, 0, 0, 0, 1367, 0, 0, 0, 0, 100, 0, 10, 1726085760, 0, ''),
(8, 'Test Chars', 1, 3, 29, 4, 500, 500, 346810, 113, 115, 95, 39, 131, 0, 1, 195, 195, 3500, 10, 8, 32369, 32237, 7, '', 995, 1, 0, 1727467187, 2281701386, 1, 0, 0, 1727468478, 0, 1, 1, 1, 1, 1, 1, 1, 1, 68656, 0, 113, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 70, 7279, 10, 0, 69, 23740, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 991, 1, 0, 1, 0, 100, 0, 0, 1726279524, 0, ''),
(9, 'Test Ms', 1, 2, 12, 1, 205, 205, 21518, 113, 115, 95, 39, 129, 0, 71, 208, 210, 876879, 0, 8, 32199, 32297, 6, '', 510, 1, 0, 1731533344, 2281701386, 1, 0, 0, 1731535200, 0, 1, 1, 1, 1, 1, 1, 1, 1, 28219, 0, 13, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 14, 84, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, 0, 994, 1, 0, 0, 0, 100, 0, 0, 1726868107, 0, ''),
(10, 'Test Ed', 1, 3, 12, 2, 176, 205, 17700, 63, 87, 91, 85, 143, 0, 4, 210, 210, 1995, 0, 8, 32369, 32241, 7, '', 510, 1, 0, 1727467171, 2281701386, 1, 0, 0, 1727468449, 0, 1, 1, 1, 1, 1, 1, 1, 1, 16744, 0, 11, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 14, 163, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 993, 1, 0, 0, 0, 100, 0, 0, 1726868191, 0, '');

--
-- Acionadores `players`
--
DELIMITER $$
CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players` FOR EACH ROW BEGIN
    UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id`;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `players_online`
--

CREATE TABLE `players_online` (
  `player_id` int(11) NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_bosstiary`
--

CREATE TABLE `player_bosstiary` (
  `player_id` int(11) NOT NULL,
  `bossIdSlotOne` int(11) NOT NULL DEFAULT '0',
  `bossIdSlotTwo` int(11) NOT NULL DEFAULT '0',
  `removeTimes` int(11) NOT NULL DEFAULT '1',
  `tracker` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `player_bosstiary`
--

INSERT INTO `player_bosstiary` (`player_id`, `bossIdSlotOne`, `bossIdSlotTwo`, `removeTimes`, `tracker`) VALUES
(1, 0, 0, 1, ''),
(3, 0, 0, 1, ''),
(4, 0, 0, 1, ''),
(5, 0, 0, 1, ''),
(10, 0, 0, 1, ''),
(8, 0, 0, 1, ''),
(2, 0, 0, 1, ''),
(6, 0, 0, 1, ''),
(9, 0, 0, 1, ''),
(7, 0, 0, 1, '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_charms`
--

CREATE TABLE `player_charms` (
  `player_guid` int(250) NOT NULL,
  `charm_points` varchar(250) DEFAULT NULL,
  `charm_expansion` tinyint(1) DEFAULT NULL,
  `rune_wound` int(250) DEFAULT NULL,
  `rune_enflame` int(250) DEFAULT NULL,
  `rune_poison` int(250) DEFAULT NULL,
  `rune_freeze` int(250) DEFAULT NULL,
  `rune_zap` int(250) DEFAULT NULL,
  `rune_curse` int(250) DEFAULT NULL,
  `rune_cripple` int(250) DEFAULT NULL,
  `rune_parry` int(250) DEFAULT NULL,
  `rune_dodge` int(250) DEFAULT NULL,
  `rune_adrenaline` int(250) DEFAULT NULL,
  `rune_numb` int(250) DEFAULT NULL,
  `rune_cleanse` int(250) DEFAULT NULL,
  `rune_bless` int(250) DEFAULT NULL,
  `rune_scavenge` int(250) DEFAULT NULL,
  `rune_gut` int(250) DEFAULT NULL,
  `rune_low_blow` int(250) DEFAULT NULL,
  `rune_divine` int(250) DEFAULT NULL,
  `rune_vamp` int(250) DEFAULT NULL,
  `rune_void` int(250) DEFAULT NULL,
  `UsedRunesBit` varchar(250) DEFAULT NULL,
  `UnlockedRunesBit` varchar(250) DEFAULT NULL,
  `tracker list` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `player_charms`
--

INSERT INTO `player_charms` (`player_guid`, `charm_points`, `charm_expansion`, `rune_wound`, `rune_enflame`, `rune_poison`, `rune_freeze`, `rune_zap`, `rune_curse`, `rune_cripple`, `rune_parry`, `rune_dodge`, `rune_adrenaline`, `rune_numb`, `rune_cleanse`, `rune_bless`, `rune_scavenge`, `rune_gut`, `rune_low_blow`, `rune_divine`, `rune_vamp`, `rune_void`, `UsedRunesBit`, `UnlockedRunesBit`, `tracker list`) VALUES
(1, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(2, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(3, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(4, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(5, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(6, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(7, '21', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(8, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(10, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(9, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_deaths`
--

CREATE TABLE `player_deaths` (
  `player_id` int(11) NOT NULL,
  `time` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `killed_by` varchar(255) NOT NULL,
  `is_player` tinyint(1) NOT NULL DEFAULT '1',
  `mostdamage_by` varchar(100) NOT NULL,
  `mostdamage_is_player` tinyint(1) NOT NULL DEFAULT '0',
  `unjustified` tinyint(1) NOT NULL DEFAULT '0',
  `mostdamage_unjustified` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_depotitems`
--

CREATE TABLE `player_depotitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL COMMENT 'any given range eg 0-100 will be reserved for depot lockers and all > 100 will be then normal items inside depots',
  `pid` int(11) NOT NULL DEFAULT '0',
  `itemtype` int(11) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_hirelings`
--

CREATE TABLE `player_hirelings` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `active` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `sex` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `posx` int(11) NOT NULL DEFAULT '0',
  `posy` int(11) NOT NULL DEFAULT '0',
  `posz` int(11) NOT NULL DEFAULT '0',
  `lookbody` int(11) NOT NULL DEFAULT '0',
  `lookfeet` int(11) NOT NULL DEFAULT '0',
  `lookhead` int(11) NOT NULL DEFAULT '0',
  `looklegs` int(11) NOT NULL DEFAULT '0',
  `looktype` int(11) NOT NULL DEFAULT '136'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_inboxitems`
--

CREATE TABLE `player_inboxitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT '0',
  `itemtype` int(11) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `player_inboxitems`
--

INSERT INTO `player_inboxitems` (`player_id`, `sid`, `pid`, `itemtype`, `count`, `attributes`) VALUES
(7, 101, 0, 37317, 2, 0x0f02),
(7, 102, 0, 3043, 26, 0x0f1a),
(7, 103, 0, 3420, 1, ''),
(7, 104, 0, 3079, 1, ''),
(7, 105, 0, 3420, 1, ''),
(7, 106, 0, 30400, 1, ''),
(7, 107, 0, 3079, 1, ''),
(7, 108, 0, 30397, 1, ''),
(7, 109, 0, 3420, 1, ''),
(7, 110, 0, 37317, 3, 0x0f03),
(7, 111, 0, 3420, 1, ''),
(7, 112, 0, 3366, 1, ''),
(7, 113, 0, 37317, 2, 0x0f02),
(7, 114, 0, 3366, 1, ''),
(7, 115, 0, 9019, 1, ''),
(7, 116, 0, 28719, 1, ''),
(7, 117, 0, 37317, 2, 0x0f02),
(7, 118, 0, 28715, 1, ''),
(7, 119, 0, 3079, 1, ''),
(7, 120, 0, 9019, 1, ''),
(7, 121, 0, 39546, 1, ''),
(7, 122, 0, 3079, 1, ''),
(7, 123, 0, 37317, 2, 0x0f02),
(7, 124, 0, 30400, 1, ''),
(7, 125, 0, 3079, 1, ''),
(7, 126, 0, 3079, 1, ''),
(7, 127, 0, 28715, 1, ''),
(7, 128, 0, 3420, 1, ''),
(7, 129, 0, 3043, 43, 0x0f2b),
(7, 130, 0, 9019, 1, ''),
(7, 131, 0, 3079, 1, ''),
(7, 132, 0, 3079, 1, ''),
(7, 133, 0, 3420, 1, '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_items`
--

CREATE TABLE `player_items` (
  `player_id` int(11) NOT NULL DEFAULT '0',
  `pid` int(11) NOT NULL DEFAULT '0',
  `sid` int(11) NOT NULL DEFAULT '0',
  `itemtype` int(11) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `player_items`
--

INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES
(1, 11, 101, 23396, 1, ''),
(2, 1, 101, 7992, 1, ''),
(2, 2, 102, 3572, 1, ''),
(2, 3, 103, 2854, 1, 0x26000000802c00000080),
(2, 4, 104, 7991, 1, ''),
(2, 5, 105, 3059, 1, ''),
(2, 6, 106, 3074, 1, ''),
(2, 7, 107, 3362, 1, ''),
(2, 8, 108, 3552, 1, ''),
(2, 11, 109, 23396, 1, ''),
(2, 103, 110, 268, 10, 0x0f0a),
(2, 103, 111, 5710, 1, ''),
(2, 103, 112, 3003, 1, ''),
(3, 11, 101, 23396, 1, ''),
(4, 11, 101, 23396, 1, ''),
(5, 11, 101, 23396, 1, ''),
(6, 3, 101, 2854, 1, 0x26000000802c00000080),
(6, 11, 102, 23396, 1, ''),
(6, 101, 103, 3457, 1, ''),
(6, 101, 104, 3003, 1, ''),
(7, 1, 101, 28714, 1, ''),
(7, 3, 102, 2854, 1, 0x24002c00000080),
(7, 4, 103, 3366, 1, ''),
(7, 6, 104, 3296, 1, 0x1ce7030000),
(7, 8, 105, 9020, 1, ''),
(7, 10, 106, 3035, 80, 0x0f50),
(7, 11, 107, 23396, 1, 0x2401),
(7, 102, 108, 3031, 85, 0x0f55),
(7, 102, 109, 35287, 14400, 0x164038),
(7, 102, 110, 3043, 96, 0x0f60),
(7, 102, 111, 37317, 1, 0x0f01),
(7, 102, 112, 16277, 1, ''),
(7, 102, 113, 30316, 1, ''),
(7, 102, 114, 2854, 1, 0x2404),
(7, 102, 115, 6579, 1, ''),
(7, 102, 116, 2854, 1, 0x2403),
(7, 102, 117, 3457, 1, ''),
(7, 102, 118, 3003, 1, ''),
(7, 107, 119, 35284, 18188, 0x01af730afe92010000160c47046400076600596f7520776f6e207468697320657865726369736520776561706f6e20617320612072657761726420746f206265206120456e6172614f5420706c617965722e2055736520697420696e20612064756d6d79210a486176652061206e6963652067616d652e2e),
(7, 107, 120, 23721, 1, 0x01b47205fb92010000240226000000c02b07000000),
(7, 107, 121, 23373, 20, 0x0193905811920100000f14),
(7, 107, 122, 23373, 10, 0x0153816df7910100000f0a),
(7, 107, 123, 23373, 10, 0x01034febe7910100000f0a),
(7, 114, 124, 6529, 1, 0x10f6b4db00),
(7, 114, 125, 37317, 68, 0x0f44),
(7, 114, 126, 3079, 1, ''),
(7, 114, 127, 14053, 1, 0x0f01),
(7, 116, 128, 23373, 1, 0x0f01),
(7, 116, 129, 22516, 100, 0x0f64),
(7, 116, 130, 22516, 100, 0x0f64),
(8, 1, 101, 3354, 1, ''),
(8, 2, 102, 3572, 1, ''),
(8, 3, 103, 2854, 1, 0x240126000000802c00000080),
(8, 4, 104, 3359, 1, ''),
(8, 5, 105, 3425, 1, ''),
(8, 6, 106, 7773, 1, ''),
(8, 7, 107, 3372, 1, ''),
(8, 11, 108, 23396, 1, 0x2402),
(8, 103, 109, 35285, 14400, 0x164038),
(8, 103, 110, 37317, 15, 0x0f0f),
(8, 103, 111, 35288, 14400, 0x164038),
(8, 103, 112, 35289, 14400, 0x164038),
(8, 103, 113, 16277, 1, ''),
(8, 103, 114, 5710, 1, ''),
(8, 103, 115, 3003, 1, ''),
(8, 108, 116, 23375, 10, 0x0112863d11920100000f0a),
(8, 108, 117, 35280, 20000, 0x010d06ceee9101000016204e046400076a00596f7520776f6e207468697320657865726369736520776561706f6e20617320612072657761726420746f206265206120456e6172614f542073763120706c617965722e2055736520697420696e20612064756d6d79210a486176652061206e6963652067616d652e2e),
(9, 1, 101, 7992, 1, ''),
(9, 2, 102, 3572, 1, ''),
(9, 3, 103, 2854, 1, 0x240126000000802c00000080),
(9, 4, 104, 7991, 1, ''),
(9, 5, 105, 3059, 1, ''),
(9, 6, 106, 3074, 1, ''),
(9, 7, 107, 3559, 1, ''),
(9, 8, 108, 3552, 1, ''),
(9, 11, 109, 23396, 1, 0x2403),
(9, 103, 110, 35289, 14400, 0x164038),
(9, 103, 111, 35290, 14400, 0x164038),
(9, 103, 112, 35290, 14400, 0x164038),
(9, 103, 113, 35288, 14400, 0x164038),
(9, 103, 114, 2854, 1, 0x2402),
(9, 103, 115, 5710, 1, ''),
(9, 103, 116, 3003, 1, ''),
(9, 109, 117, 35284, 16583, 0x01304a5d269301000016c740046400076600596f7520776f6e207468697320657865726369736520776561706f6e20617320612072657761726420746f206265206120456e6172614f5420706c617965722e2055736520697420696e20612064756d6d79210a486176652061206e6963652067616d652e2e),
(9, 114, 118, 3362, 1, ''),
(9, 114, 119, 7992, 1, ''),
(9, 114, 120, 7991, 1, ''),
(9, 114, 121, 3074, 1, ''),
(9, 114, 122, 3059, 1, ''),
(9, 114, 123, 16277, 1, ''),
(9, 114, 124, 2819, 1, 0x067d01427261766520616476656e74757265722c0a0a74686520416476656e74757265727327204775696c64206269647320796f752077656c636f6d652061732061206e6577206865726f206f6620746865206c616e642e0a0a54616b65207468697320616476656e747572657227732073746f6e6520616e642075736520697420696e20616e7920636974792074656d706c6520746f20696e7374616e746c792074726176656c20746f206f7572206775696c642068616c6c2e20496620796f752073686f756c642065766572206c6f736520796f757220616476656e747572657227732073746f6e652c20796f752063616e207265706c6163652069742062792074616c6b696e6720746f20612070726965737420696e207468652074656d706c652e0a4920686f706520796f752077696c6c206265207669736974696e6720757320736f6f6e2e0a0a4b696e6420726567617264732c0a526f74656d2c2048656164206f662074686520416476656e74757265727327204775696c640a),
(10, 1, 101, 7992, 1, ''),
(10, 2, 102, 3572, 1, ''),
(10, 3, 103, 2854, 1, 0x240026000000802c00000080),
(10, 4, 104, 7991, 1, ''),
(10, 5, 105, 3059, 1, ''),
(10, 6, 106, 3066, 1, ''),
(10, 7, 107, 3362, 1, ''),
(10, 11, 108, 23396, 1, 0x2400),
(10, 103, 109, 35290, 14400, 0x164038),
(10, 103, 110, 35288, 14400, 0x164038),
(10, 103, 111, 3607, 2, 0x0f02),
(10, 103, 112, 2854, 1, 0x2400),
(10, 103, 113, 5710, 1, ''),
(10, 103, 114, 3003, 1, ''),
(10, 108, 115, 35283, 20000, 0x01e852a2119201000016204e046400076a00596f7520776f6e207468697320657865726369736520776561706f6e20617320612072657761726420746f206265206120456e6172614f542073763120706c617965722e2055736520697420696e20612064756d6d79210a486176652061206e6963652067616d652e2e),
(10, 112, 116, 7992, 1, ''),
(10, 112, 117, 7991, 1, ''),
(10, 112, 118, 3559, 1, ''),
(10, 112, 119, 3552, 1, ''),
(10, 112, 120, 3066, 1, ''),
(10, 112, 121, 3059, 1, ''),
(10, 112, 122, 16277, 1, ''),
(10, 112, 123, 2819, 1, 0x067d01427261766520616476656e74757265722c0a0a74686520416476656e74757265727327204775696c64206269647320796f752077656c636f6d652061732061206e6577206865726f206f6620746865206c616e642e0a0a54616b65207468697320616476656e747572657227732073746f6e6520616e642075736520697420696e20616e7920636974792074656d706c6520746f20696e7374616e746c792074726176656c20746f206f7572206775696c642068616c6c2e20496620796f752073686f756c642065766572206c6f736520796f757220616476656e747572657227732073746f6e652c20796f752063616e207265706c6163652069742062792074616c6b696e6720746f20612070726965737420696e207468652074656d706c652e0a4920686f706520796f752077696c6c206265207669736974696e6720757320736f6f6e2e0a0a4b696e6420726567617264732c0a526f74656d2c2048656164206f662074686520416476656e74757265727327204775696c640a);

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_kills`
--

CREATE TABLE `player_kills` (
  `player_id` int(11) NOT NULL,
  `time` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `target` int(11) NOT NULL,
  `unavenged` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_namelocks`
--

CREATE TABLE `player_namelocks` (
  `player_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `namelocked_at` bigint(20) NOT NULL,
  `namelocked_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_prey`
--

CREATE TABLE `player_prey` (
  `player_id` int(11) NOT NULL,
  `slot` tinyint(1) NOT NULL,
  `state` tinyint(1) NOT NULL,
  `raceid` varchar(250) NOT NULL,
  `option` tinyint(1) NOT NULL,
  `bonus_type` tinyint(1) NOT NULL,
  `bonus_rarity` tinyint(1) NOT NULL,
  `bonus_percentage` varchar(250) NOT NULL,
  `bonus_time` varchar(250) NOT NULL,
  `free_reroll` bigint(20) NOT NULL,
  `monster_list` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `player_prey`
--

INSERT INTO `player_prey` (`player_id`, `slot`, `state`, `raceid`, `option`, `bonus_type`, `bonus_rarity`, `bonus_percentage`, `bonus_time`, `free_reroll`, `monster_list`) VALUES
(7, 0, 3, '0', 0, 1, 10, '40', '0', 1726164239009, 0x1007e405420068020302d6009603f700ec00),
(7, 1, 3, '0', 0, 1, 4, '22', '0', 1726164239009, 0x7a03070273004f007a06fb0002015e00ce05),
(7, 2, 0, '0', 0, 2, 10, '40', '0', 1726164239009, ''),
(8, 0, 3, '0', 0, 3, 4, '22', '0', 1726351613258, 0x1e0403027103f500740033081002cd014000),
(8, 1, 3, '0', 0, 0, 2, '16', '0', 1726351613258, 0x470018031d0188016c00f800d00128003400),
(8, 2, 0, '0', 0, 0, 5, '25', '0', 1726351613258, ''),
(9, 0, 3, '0', 0, 1, 5, '25', '0', 1731073469331, 0x2f0803005100f600bc060001fd033e00da08),
(9, 1, 3, '0', 0, 2, 6, '28', '0', 1731073469331, 0xd8056e0617035f00fe013000da007d00d101),
(9, 2, 0, '0', 0, 2, 2, '16', '0', 1731073469331, ''),
(10, 0, 3, '0', 0, 3, 5, '25', '0', 1726940251215, 0x770657093f0068022b00a202df0509004d00),
(10, 1, 3, '0', 0, 2, 6, '28', '0', 1726940251215, 0x190102011c041c0370002a017d007a00f503),
(10, 2, 0, '0', 0, 1, 8, '34', '0', 1726940251215, '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_rewards`
--

CREATE TABLE `player_rewards` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT '0',
  `itemtype` int(11) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_spells`
--

CREATE TABLE `player_spells` (
  `player_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_stash`
--

CREATE TABLE `player_stash` (
  `player_id` int(16) NOT NULL,
  `item_id` int(16) NOT NULL,
  `item_count` int(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_storage`
--

CREATE TABLE `player_storage` (
  `player_id` int(11) NOT NULL DEFAULT '0',
  `key` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `player_storage`
--

INSERT INTO `player_storage` (`player_id`, `key`, `value`) VALUES
(2, 13413, 1729890301),
(2, 13414, 11),
(2, 14903, 1),
(2, 41951, 51),
(2, 41952, 6),
(2, 41953, 8),
(2, 41954, 6),
(2, 41955, 6),
(2, 41956, 8),
(2, 41957, 5),
(2, 41958, 5),
(2, 41959, 4),
(2, 41960, 2),
(2, 41961, 1),
(2, 41962, 1),
(2, 41963, 1),
(2, 41964, 1),
(2, 41965, 1),
(2, 41966, 1),
(2, 41967, 1),
(2, 41968, 1),
(2, 41969, 1),
(2, 41970, 1),
(2, 41971, 1),
(2, 41972, 1),
(2, 41973, 1),
(2, 41974, 1),
(2, 41975, 1),
(2, 41976, 1),
(2, 41977, 1),
(2, 41978, 1),
(2, 41979, 1),
(2, 43851, 23),
(2, 43853, 5),
(2, 43854, 2),
(2, 43863, 1440),
(2, 43890, 2),
(2, 43891, 2),
(2, 43892, 2),
(2, 45851, 10),
(2, 45852, 10),
(2, 45860, 10),
(2, 45875, 10),
(2, 45899, 10),
(2, 45901, 10),
(2, 45903, 30),
(2, 150002, 0),
(2, 10001001, 16449536),
(2, 10001002, 16515072),
(6, 13413, 1729890301),
(6, 13414, 11),
(6, 14903, 1),
(6, 40430, 2),
(6, 40431, 2),
(6, 40432, 2),
(6, 40434, 1),
(6, 40435, 2),
(6, 40436, 2),
(6, 40437, 2),
(6, 40438, 3),
(6, 40441, 1),
(6, 40442, 3),
(6, 40443, 3),
(6, 40444, 3),
(6, 40629, 61),
(6, 40638, 2),
(6, 41174, 8),
(6, 41175, 3),
(6, 41176, 3),
(6, 41177, 3),
(6, 41276, 40),
(6, 41277, 3),
(6, 41278, 5),
(6, 41279, 3),
(6, 41280, 2),
(6, 41281, 6),
(6, 41282, 8),
(6, 41283, 3),
(6, 41284, 4),
(6, 41285, 2),
(6, 41286, 2),
(6, 41287, 2),
(6, 41288, 6),
(6, 41300, 1),
(6, 41691, 25),
(6, 41692, 7),
(6, 41693, 3),
(6, 41694, 6),
(6, 41695, 3),
(6, 41696, 3),
(6, 41697, 3),
(6, 41950, 1),
(6, 41951, 51),
(6, 41952, 6),
(6, 41953, 8),
(6, 41954, 6),
(6, 41955, 6),
(6, 41956, 8),
(6, 41957, 5),
(6, 41958, 5),
(6, 41959, 4),
(6, 41960, 2),
(6, 41961, 1),
(6, 41962, 1),
(6, 41963, 1),
(6, 41964, 1),
(6, 41965, 1),
(6, 41966, 1),
(6, 41967, 1),
(6, 41968, 1),
(6, 41969, 1),
(6, 41970, 1),
(6, 41971, 1),
(6, 41972, 1),
(6, 41973, 1),
(6, 41974, 1),
(6, 41975, 1),
(6, 41976, 1),
(6, 41977, 1),
(6, 41978, 1),
(6, 41979, 1),
(6, 41980, 1),
(6, 41983, 1),
(6, 41984, 1),
(6, 41985, 1),
(6, 41986, 1),
(6, 41987, 1),
(6, 41988, 1),
(6, 41989, 1),
(6, 41994, 5),
(6, 41995, 1),
(6, 41996, 1),
(6, 41997, 1),
(6, 41998, 1),
(6, 41999, 1),
(6, 42000, 1),
(6, 42001, 1),
(6, 42002, 1),
(6, 42003, 1),
(6, 42004, 1),
(6, 42006, 1),
(6, 42601, 21),
(6, 42602, 2),
(6, 42603, 3),
(6, 42604, 5),
(6, 42605, 3),
(6, 42606, 6),
(6, 42607, 3),
(6, 42608, 1),
(6, 42609, 1),
(6, 42610, 1),
(6, 42611, 1),
(6, 43851, 23),
(6, 43853, 5),
(6, 43854, 2),
(6, 43863, 1440),
(6, 43890, 2),
(6, 43891, 2),
(6, 43892, 2),
(6, 45488, 1),
(6, 45489, 1),
(6, 45490, 1),
(6, 45491, 1),
(6, 45492, 1),
(6, 45493, 1),
(6, 45494, 1),
(6, 45495, 1),
(6, 45497, 1),
(6, 45500, 1),
(6, 45651, 7),
(6, 45653, 1),
(6, 45654, 1),
(6, 45655, 1),
(6, 45656, 1),
(6, 45657, 1),
(6, 45658, 1),
(6, 45659, 1),
(6, 45660, 1),
(6, 45661, 1),
(6, 45662, 1),
(6, 45666, 1),
(6, 45668, 3),
(6, 45669, 3),
(6, 45671, 1),
(6, 45672, 1),
(6, 45679, 1),
(6, 45680, 1),
(6, 45681, 1),
(6, 45682, 7),
(6, 45683, 1),
(6, 45685, 1),
(6, 45686, 1),
(6, 45687, 1),
(6, 45688, 1),
(6, 45690, 1),
(6, 45691, 1),
(6, 45692, 1),
(6, 45693, 1),
(6, 45694, 1),
(6, 45851, 10),
(6, 45852, 10),
(6, 45860, 10),
(6, 45875, 10),
(6, 45899, 10),
(6, 45901, 10),
(6, 45903, 30),
(6, 150002, 0),
(6, 10001001, 16449536),
(6, 10001002, 16515072),
(6, 10002011, 102),
(7, 6000, 1731563126),
(7, 12330, 1),
(7, 12332, 13),
(7, 12333, 3),
(7, 12450, 6),
(7, 13412, 1731621601),
(7, 13413, 1731621601),
(7, 13414, 11),
(7, 14897, 6),
(7, 14899, 1731711601),
(7, 14900, 1),
(7, 14903, 0),
(7, 20001, 1),
(7, 20002, 1731051175),
(7, 30057, 1),
(7, 30061, 1),
(7, 32943, 1),
(7, 40430, 2),
(7, 40431, 2),
(7, 40432, 2),
(7, 40434, 1),
(7, 40435, 2),
(7, 40436, 2),
(7, 40437, 2),
(7, 40438, 3),
(7, 40439, 1),
(7, 40440, 1),
(7, 40441, 1),
(7, 40442, 3),
(7, 40443, 3),
(7, 40444, 3),
(7, 40445, 1),
(7, 40446, 1),
(7, 40612, 1),
(7, 40613, 18),
(7, 40629, 61),
(7, 40638, 2),
(7, 40788, 1),
(7, 40789, 1),
(7, 40790, 1),
(7, 40791, 1),
(7, 40822, 1),
(7, 40823, 2),
(7, 40824, 2),
(7, 40825, 12),
(7, 40827, 3),
(7, 40828, 3),
(7, 40829, 2),
(7, 40830, 1),
(7, 40831, 3),
(7, 40832, 5),
(7, 40833, 1),
(7, 40834, 1),
(7, 40835, 2),
(7, 40836, 1),
(7, 40837, 4),
(7, 41153, 1),
(7, 41174, 8),
(7, 41175, 3),
(7, 41176, 3),
(7, 41177, 3),
(7, 41276, 40),
(7, 41277, 3),
(7, 41278, 5),
(7, 41279, 3),
(7, 41280, 2),
(7, 41281, 6),
(7, 41282, 8),
(7, 41283, 3),
(7, 41284, 4),
(7, 41285, 2),
(7, 41286, 2),
(7, 41287, 2),
(7, 41288, 6),
(7, 41300, 1),
(7, 41306, 1),
(7, 41391, 2),
(7, 41392, 5),
(7, 41393, 3),
(7, 41394, 3),
(7, 41395, 3),
(7, 41396, 2),
(7, 41397, 1),
(7, 41685, 2),
(7, 41690, 5),
(7, 41691, 25),
(7, 41692, 7),
(7, 41693, 3),
(7, 41694, 6),
(7, 41695, 3),
(7, 41696, 3),
(7, 41697, 3),
(7, 41698, 1),
(7, 41700, 1),
(7, 41701, 1),
(7, 41703, 1),
(7, 41704, 1),
(7, 41705, 1),
(7, 41710, 1),
(7, 41711, 2),
(7, 41712, 3),
(7, 41713, 3),
(7, 41714, 8),
(7, 41715, 2),
(7, 41716, 4),
(7, 41717, 2),
(7, 41718, 1),
(7, 41912, 1),
(7, 41950, 1),
(7, 41951, 51),
(7, 41952, 6),
(7, 41953, 8),
(7, 41954, 6),
(7, 41955, 6),
(7, 41956, 8),
(7, 41957, 5),
(7, 41958, 5),
(7, 41959, 4),
(7, 41960, 2),
(7, 41961, 1),
(7, 41962, 1),
(7, 41963, 1),
(7, 41964, 1),
(7, 41965, 1),
(7, 41966, 1),
(7, 41967, 1),
(7, 41968, 1),
(7, 41969, 1),
(7, 41970, 1),
(7, 41971, 1),
(7, 41972, 1),
(7, 41973, 1),
(7, 41974, 1),
(7, 41975, 1),
(7, 41976, 1),
(7, 41977, 1),
(7, 41978, 1),
(7, 41979, 1),
(7, 41980, 1),
(7, 41983, 1),
(7, 41984, 1),
(7, 41985, 1),
(7, 41986, 1),
(7, 41987, 1),
(7, 41988, 1),
(7, 41989, 1),
(7, 41994, 5),
(7, 41995, 1),
(7, 41996, 1),
(7, 41997, 1),
(7, 41998, 1),
(7, 41999, 1),
(7, 42000, 1),
(7, 42001, 1),
(7, 42002, 1),
(7, 42003, 1),
(7, 42004, 1),
(7, 42006, 1),
(7, 42166, 0),
(7, 42225, 2),
(7, 42476, 2),
(7, 42601, 21),
(7, 42602, 2),
(7, 42603, 3),
(7, 42604, 5),
(7, 42605, 3),
(7, 42606, 6),
(7, 42607, 3),
(7, 42608, 1),
(7, 42609, 1),
(7, 42610, 1),
(7, 42611, 1),
(7, 42701, 29),
(7, 42703, 3),
(7, 42704, 4),
(7, 42705, 1),
(7, 42706, 1),
(7, 42707, 1),
(7, 42708, 3),
(7, 42709, 2),
(7, 42710, 2),
(7, 42711, 1),
(7, 42712, 1),
(7, 42713, 1),
(7, 42714, 1),
(7, 42715, 1),
(7, 42716, 1),
(7, 42717, 5),
(7, 42718, 2),
(7, 42720, 2),
(7, 42721, 3),
(7, 42724, 2),
(7, 42725, 1),
(7, 42729, 12),
(7, 42731, 1),
(7, 43000, 29),
(7, 43001, 3),
(7, 43002, 3),
(7, 43003, 3),
(7, 43004, 3),
(7, 43005, 3),
(7, 43006, 4),
(7, 43007, 6),
(7, 43008, 2),
(7, 43009, 2),
(7, 43010, 1),
(7, 43021, 1),
(7, 43026, 1),
(7, 43027, 1),
(7, 43028, 1),
(7, 43029, 2),
(7, 43030, 1),
(7, 43031, 1),
(7, 43032, 1),
(7, 43033, 1),
(7, 43851, 23),
(7, 43853, 5),
(7, 43854, 2),
(7, 43863, 1440),
(7, 43890, 2),
(7, 43891, 2),
(7, 43892, 2),
(7, 44751, 1),
(7, 44752, 1),
(7, 44753, 1),
(7, 44956, 1),
(7, 44957, 1),
(7, 45489, 1731286830),
(7, 45751, 1),
(7, 45752, 16),
(7, 45764, 1),
(7, 46309, 1),
(7, 46402, 1),
(7, 46403, 1),
(7, 46404, 1),
(7, 46851, 14),
(7, 46870, 1),
(7, 46875, 1),
(7, 47402, 1),
(7, 47403, 1),
(7, 47512, 1),
(7, 47514, 1),
(7, 47601, 1),
(7, 47902, 1),
(7, 47903, 1),
(7, 47904, 1),
(7, 47905, 1),
(7, 50011, 5),
(7, 50043, 1),
(7, 50052, 1),
(7, 50053, 1),
(7, 50054, 1),
(7, 50055, 1),
(7, 50063, 1),
(7, 50065, 1),
(7, 50066, 1),
(7, 50067, 1),
(7, 50068, 1),
(7, 50069, 1),
(7, 50070, 1),
(7, 50071, 1),
(7, 50072, 1),
(7, 50073, 1),
(7, 50080, 1),
(7, 50081, 10),
(7, 50082, 2),
(7, 50083, 2),
(7, 50090, 10),
(7, 50091, 2),
(7, 50092, 2),
(7, 50115, 10),
(7, 50116, 3),
(7, 50117, 2),
(7, 50118, 2),
(7, 50139, 10),
(7, 50141, 10),
(7, 50143, 30),
(7, 50200, 7),
(7, 50201, 1),
(7, 50202, 1),
(7, 50203, 1),
(7, 50204, 1),
(7, 50205, 1),
(7, 50210, 1),
(7, 50211, 1),
(7, 50212, 1),
(7, 50213, 1),
(7, 50214, 1),
(7, 50215, 1),
(7, 50225, 1),
(7, 50226, 4),
(7, 50227, 3),
(7, 50228, 3),
(7, 50230, 1),
(7, 50231, 1),
(7, 50234, 1),
(7, 50235, 1),
(7, 50236, 1),
(7, 50240, 1),
(7, 50241, 1),
(7, 50242, 1),
(7, 50243, 1),
(7, 50245, 7),
(7, 50246, 1),
(7, 50250, 1),
(7, 50251, 1),
(7, 50252, 1),
(7, 50253, 1),
(7, 50255, 1),
(7, 50256, 1),
(7, 50257, 1),
(7, 50258, 1),
(7, 50259, 1),
(7, 50260, 1),
(7, 50263, 1),
(7, 50264, 1),
(7, 50403, 1),
(7, 50404, 1),
(7, 50405, 1),
(7, 50406, 1),
(7, 50442, 1),
(7, 50443, 1),
(7, 50444, 1),
(7, 50445, 1),
(7, 50446, 1),
(7, 50453, 1),
(7, 50470, 1),
(7, 50471, 1),
(7, 50472, 1),
(7, 50473, 1),
(7, 50474, 1),
(7, 50475, 1),
(7, 50486, 1),
(7, 50488, 1),
(7, 50490, 1),
(7, 50492, 1),
(7, 50494, 1),
(7, 50496, 1),
(7, 50498, 1),
(7, 50501, 1),
(7, 50503, 1),
(7, 50506, 1),
(7, 50850, 1),
(7, 50852, 3000),
(7, 50960, 1),
(7, 51052, 0),
(7, 51480, 1),
(7, 51487, 1),
(7, 51538, 2),
(7, 51680, 1),
(7, 52030, 1),
(7, 52031, 1),
(7, 52032, 2),
(7, 52033, 1),
(7, 52130, 8),
(7, 52146, 2),
(7, 52148, 1),
(7, 52149, 3),
(7, 52251, 1),
(7, 52252, 1),
(7, 52253, 1),
(7, 52254, 1),
(7, 52255, 1),
(7, 52261, 1),
(7, 52262, 1),
(7, 52263, 1),
(7, 52264, 1),
(7, 52265, 1),
(7, 52269, 1),
(7, 52271, 1),
(7, 52273, 1),
(7, 52276, 0),
(7, 52277, 1),
(7, 52279, 1),
(7, 55047, 1),
(7, 100157, 1),
(7, 150002, 0),
(7, 176203, 1),
(7, 176601, 6),
(7, 176602, 5),
(7, 176603, 0),
(7, 176604, 136),
(7, 176605, 0),
(7, 176606, 1731602950),
(7, 176607, 1),
(7, 176608, 0),
(7, 176609, 3),
(7, 176610, 3),
(7, 176611, 3),
(7, 176612, 3),
(7, 176613, 3),
(7, 176614, 2),
(7, 891642, 0),
(7, 891644, 0),
(7, 10001001, 16449536),
(7, 10001002, 16515072),
(7, 10001003, 9699331),
(7, 10001004, 9437187),
(7, 10001005, 8912899),
(7, 10001006, 8388611),
(7, 10001007, 8978435),
(7, 10001008, 8454147),
(7, 10001009, 9175043),
(7, 10001010, 8650755),
(7, 10001011, 9240579),
(7, 10001012, 8716291),
(7, 10001013, 9109507),
(7, 10001014, 8585219),
(7, 10001015, 9633795),
(7, 10001016, 9371651),
(7, 10001017, 9306115),
(7, 10001018, 8781827),
(7, 10001019, 8519681),
(7, 10001020, 9043969),
(7, 10002011, 230),
(7, 61305005, 44),
(7, 61305010, 2),
(7, 61305011, 2),
(7, 61305012, 12),
(7, 61305014, 2),
(7, 61305021, 1114),
(7, 61305022, 134),
(7, 61305025, 6),
(7, 61305026, 2182),
(7, 61305027, 2),
(7, 61305028, 6),
(7, 61305030, 2),
(7, 61305032, 30),
(7, 61305033, 2),
(7, 61305034, 38),
(7, 61305035, 96),
(7, 61305045, 28),
(7, 61305046, 1),
(7, 61305051, 4),
(7, 61305053, 76),
(7, 61305054, 2),
(7, 61305056, 50),
(7, 61305060, 58),
(7, 61305061, 26),
(7, 61305063, 8),
(7, 61305064, 14),
(7, 61305077, 32),
(7, 61305103, 2),
(7, 61305119, 226),
(7, 61305201, 2),
(7, 61305223, 196),
(7, 61305251, 22),
(7, 61305463, 6),
(7, 61305464, 8),
(7, 61305509, 2),
(7, 61305516, 2),
(7, 61305733, 46),
(7, 61305787, 2),
(7, 61305922, 18),
(7, 61306012, 4),
(7, 61306163, 2),
(7, 61306315, 1),
(7, 61306322, 2),
(7, 61306727, 1),
(7, 61306758, 3),
(7, 61307100, 2),
(8, 6000, 1726849340),
(8, 12330, 1),
(8, 12332, 13),
(8, 12333, 3),
(8, 12450, 6),
(8, 13412, 1726434301),
(8, 13413, 1726866301),
(8, 13414, 9),
(8, 14897, 1),
(8, 14899, 1726524301),
(8, 14900, 1),
(8, 14903, 0),
(8, 20001, 1),
(8, 20002, 1),
(8, 30057, 1),
(8, 30061, 1),
(8, 40430, 2),
(8, 40431, 2),
(8, 40432, 2),
(8, 40434, 1),
(8, 40435, 2),
(8, 40436, 2),
(8, 40437, 2),
(8, 40438, 3),
(8, 40439, 1),
(8, 40440, 1),
(8, 40441, 1),
(8, 40442, 3),
(8, 40443, 3),
(8, 40444, 3),
(8, 40445, 1),
(8, 40446, 1),
(8, 40612, 1),
(8, 40613, 18),
(8, 40629, 61),
(8, 40638, 2),
(8, 40788, 1),
(8, 40789, 1),
(8, 40790, 1),
(8, 40791, 1),
(8, 40822, 1),
(8, 40823, 2),
(8, 40824, 2),
(8, 40825, 12),
(8, 40827, 3),
(8, 40828, 3),
(8, 40829, 2),
(8, 40830, 1),
(8, 40831, 3),
(8, 40832, 5),
(8, 40833, 1),
(8, 40834, 1),
(8, 40835, 2),
(8, 40836, 1),
(8, 40837, 4),
(8, 41153, 1),
(8, 41174, 8),
(8, 41175, 3),
(8, 41176, 3),
(8, 41177, 3),
(8, 41276, 40),
(8, 41277, 3),
(8, 41278, 5),
(8, 41279, 3),
(8, 41280, 2),
(8, 41281, 6),
(8, 41282, 8),
(8, 41283, 3),
(8, 41284, 4),
(8, 41285, 2),
(8, 41286, 2),
(8, 41287, 2),
(8, 41288, 6),
(8, 41300, 1),
(8, 41306, 1),
(8, 41391, 2),
(8, 41392, 5),
(8, 41393, 3),
(8, 41394, 3),
(8, 41395, 3),
(8, 41396, 2),
(8, 41397, 1),
(8, 41685, 2),
(8, 41690, 5),
(8, 41691, 25),
(8, 41692, 7),
(8, 41693, 3),
(8, 41694, 6),
(8, 41695, 3),
(8, 41696, 3),
(8, 41697, 3),
(8, 41698, 1),
(8, 41700, 1),
(8, 41701, 1),
(8, 41703, 1),
(8, 41704, 1),
(8, 41705, 1),
(8, 41710, 1),
(8, 41711, 2),
(8, 41712, 3),
(8, 41713, 3),
(8, 41714, 8),
(8, 41715, 2),
(8, 41716, 4),
(8, 41717, 2),
(8, 41718, 1),
(8, 41912, 1),
(8, 41950, 1),
(8, 41951, 51),
(8, 41952, 6),
(8, 41953, 8),
(8, 41954, 6),
(8, 41955, 6),
(8, 41956, 8),
(8, 41957, 5),
(8, 41958, 5),
(8, 41959, 4),
(8, 41960, 2),
(8, 41961, 1),
(8, 41962, 1),
(8, 41963, 1),
(8, 41964, 1),
(8, 41965, 1),
(8, 41966, 1),
(8, 41967, 1),
(8, 41968, 1),
(8, 41969, 1),
(8, 41970, 1),
(8, 41971, 1),
(8, 41972, 1),
(8, 41973, 1),
(8, 41974, 1),
(8, 41975, 1),
(8, 41976, 1),
(8, 41977, 1),
(8, 41978, 1),
(8, 41979, 1),
(8, 41980, 1),
(8, 41983, 1),
(8, 41984, 1),
(8, 41985, 1),
(8, 41986, 1),
(8, 41987, 1),
(8, 41988, 1),
(8, 41989, 1),
(8, 41994, 5),
(8, 41995, 1),
(8, 41996, 1),
(8, 41997, 1),
(8, 41998, 1),
(8, 41999, 1),
(8, 42000, 1),
(8, 42001, 1),
(8, 42002, 1),
(8, 42003, 1),
(8, 42004, 1),
(8, 42006, 1),
(8, 42166, 0),
(8, 42601, 21),
(8, 42602, 2),
(8, 42603, 3),
(8, 42604, 5),
(8, 42605, 3),
(8, 42606, 6),
(8, 42607, 3),
(8, 42608, 1),
(8, 42609, 1),
(8, 42610, 1),
(8, 42611, 1),
(8, 42701, 29),
(8, 42703, 3),
(8, 42704, 4),
(8, 42705, 1),
(8, 42706, 1),
(8, 42707, 1),
(8, 42708, 3),
(8, 42709, 2),
(8, 42710, 2),
(8, 42711, 1),
(8, 42712, 1),
(8, 42713, 1),
(8, 42714, 1),
(8, 42715, 1),
(8, 42716, 1),
(8, 42717, 5),
(8, 42718, 2),
(8, 42720, 2),
(8, 42721, 3),
(8, 42724, 2),
(8, 42725, 1),
(8, 42729, 12),
(8, 42731, 1),
(8, 43000, 29),
(8, 43001, 3),
(8, 43002, 3),
(8, 43003, 3),
(8, 43004, 3),
(8, 43005, 3),
(8, 43006, 4),
(8, 43007, 6),
(8, 43008, 2),
(8, 43009, 2),
(8, 43010, 1),
(8, 43026, 1),
(8, 43027, 1),
(8, 43028, 1),
(8, 43029, 2),
(8, 43030, 1),
(8, 43031, 1),
(8, 43032, 1),
(8, 43033, 1),
(8, 43851, 23),
(8, 43853, 5),
(8, 43854, 2),
(8, 43863, 1440),
(8, 43890, 2),
(8, 43891, 2),
(8, 43892, 2),
(8, 44956, 1),
(8, 44957, 1),
(8, 45751, 1),
(8, 45752, 16),
(8, 45764, 1),
(8, 46309, 1),
(8, 46402, 1),
(8, 46403, 1),
(8, 46404, 1),
(8, 46851, 14),
(8, 46875, 1),
(8, 47402, 1),
(8, 47403, 1),
(8, 47512, 1),
(8, 47514, 1),
(8, 47601, 1),
(8, 47902, 1),
(8, 47903, 1),
(8, 47904, 1),
(8, 47905, 1),
(8, 50011, 5),
(8, 50043, 1),
(8, 50052, 1),
(8, 50053, 1),
(8, 50054, 1),
(8, 50055, 1),
(8, 50063, 1),
(8, 50065, 1),
(8, 50066, 1),
(8, 50067, 1),
(8, 50068, 1),
(8, 50069, 1),
(8, 50070, 1),
(8, 50071, 1),
(8, 50072, 1),
(8, 50073, 1),
(8, 50080, 1),
(8, 50081, 10),
(8, 50082, 2),
(8, 50083, 2),
(8, 50090, 10),
(8, 50091, 2),
(8, 50092, 2),
(8, 50115, 10),
(8, 50116, 3),
(8, 50117, 2),
(8, 50118, 2),
(8, 50139, 10),
(8, 50141, 10),
(8, 50143, 30),
(8, 50200, 7),
(8, 50201, 1),
(8, 50202, 1),
(8, 50203, 1),
(8, 50204, 1),
(8, 50205, 1),
(8, 50210, 1),
(8, 50211, 1),
(8, 50212, 1),
(8, 50213, 1),
(8, 50214, 1),
(8, 50215, 1),
(8, 50225, 1),
(8, 50226, 4),
(8, 50227, 3),
(8, 50228, 3),
(8, 50230, 1),
(8, 50231, 1),
(8, 50234, 1),
(8, 50235, 1),
(8, 50236, 1),
(8, 50240, 1),
(8, 50241, 1),
(8, 50242, 1),
(8, 50243, 1),
(8, 50245, 7),
(8, 50246, 1),
(8, 50250, 1),
(8, 50251, 1),
(8, 50252, 1),
(8, 50253, 1),
(8, 50255, 1),
(8, 50256, 1),
(8, 50257, 1),
(8, 50258, 1),
(8, 50259, 1),
(8, 50260, 1),
(8, 50263, 1),
(8, 50264, 1),
(8, 50403, 1),
(8, 50404, 1),
(8, 50405, 1),
(8, 50406, 1),
(8, 50442, 1),
(8, 50443, 1),
(8, 50444, 1),
(8, 50445, 1),
(8, 50446, 1),
(8, 50453, 1),
(8, 50470, 1),
(8, 50471, 1),
(8, 50472, 1),
(8, 50473, 1),
(8, 50474, 1),
(8, 50475, 1),
(8, 50486, 1),
(8, 50488, 1),
(8, 50490, 1),
(8, 50492, 1),
(8, 50494, 1),
(8, 50496, 1),
(8, 50498, 1),
(8, 50501, 1),
(8, 50503, 1),
(8, 50506, 1),
(8, 50850, 1),
(8, 50852, 3000),
(8, 50960, 1),
(8, 51480, 1),
(8, 51487, 1),
(8, 51538, 2),
(8, 51680, 1),
(8, 52030, 1),
(8, 52031, 1),
(8, 52032, 2),
(8, 52033, 1),
(8, 52141, 1),
(8, 52146, 2),
(8, 52148, 1),
(8, 52149, 3),
(8, 52273, 4),
(8, 52279, 1),
(8, 55047, 1),
(8, 100157, 1),
(8, 150002, 0),
(8, 10001001, 16449536),
(8, 10001002, 16515072),
(8, 61305021, 42),
(8, 61305026, 80),
(8, 61305032, 2),
(9, 10134, 1),
(9, 10135, 1),
(9, 10136, 2),
(9, 10137, 1),
(9, 12330, 1),
(9, 12332, 13),
(9, 12333, 3),
(9, 12450, 6),
(9, 13413, 1731448801),
(9, 13414, 11),
(9, 14900, 1),
(9, 14903, 0),
(9, 30057, 1),
(9, 30061, 1),
(9, 40430, 2),
(9, 40431, 2),
(9, 40432, 2),
(9, 40434, 1),
(9, 40435, 2),
(9, 40436, 2),
(9, 40437, 2),
(9, 40438, 3),
(9, 40439, 1),
(9, 40440, 1),
(9, 40441, 1),
(9, 40442, 3),
(9, 40443, 3),
(9, 40444, 3),
(9, 40445, 1),
(9, 40446, 1),
(9, 40612, 1),
(9, 40613, 18),
(9, 40629, 61),
(9, 40638, 2),
(9, 40788, 1),
(9, 40789, 1),
(9, 40790, 1),
(9, 40791, 1),
(9, 40822, 1),
(9, 40823, 2),
(9, 40824, 2),
(9, 40825, 12),
(9, 40827, 3),
(9, 40828, 3),
(9, 40829, 2),
(9, 40830, 1),
(9, 40831, 3),
(9, 40832, 5),
(9, 40833, 1),
(9, 40834, 1),
(9, 40835, 2),
(9, 40836, 1),
(9, 40837, 4),
(9, 41153, 1),
(9, 41174, 8),
(9, 41175, 3),
(9, 41176, 3),
(9, 41177, 3),
(9, 41276, 40),
(9, 41277, 3),
(9, 41278, 5),
(9, 41279, 3),
(9, 41280, 2),
(9, 41281, 6),
(9, 41282, 8),
(9, 41283, 3),
(9, 41284, 4),
(9, 41285, 2),
(9, 41286, 2),
(9, 41287, 2),
(9, 41288, 6),
(9, 41300, 1),
(9, 41306, 1),
(9, 41472, 1),
(9, 41476, 1),
(9, 41480, 2),
(9, 41481, 5),
(9, 41482, 3),
(9, 41483, 3),
(9, 41484, 3),
(9, 41485, 2),
(9, 41486, 1),
(9, 41492, 2),
(9, 41685, 2),
(9, 41690, 5),
(9, 41691, 25),
(9, 41692, 7),
(9, 41693, 3),
(9, 41694, 6),
(9, 41695, 3),
(9, 41696, 3),
(9, 41697, 3),
(9, 41698, 1),
(9, 41700, 1),
(9, 41701, 1),
(9, 41703, 1),
(9, 41704, 1),
(9, 41705, 1),
(9, 41710, 1),
(9, 41711, 2),
(9, 41712, 3),
(9, 41713, 3),
(9, 41714, 8),
(9, 41715, 2),
(9, 41716, 4),
(9, 41717, 2),
(9, 41718, 1),
(9, 41912, 1),
(9, 41950, 1),
(9, 41951, 51),
(9, 41952, 6),
(9, 41953, 8),
(9, 41954, 6),
(9, 41955, 6),
(9, 41956, 8),
(9, 41957, 5),
(9, 41958, 5),
(9, 41959, 4),
(9, 41960, 2),
(9, 41961, 1),
(9, 41962, 1),
(9, 41963, 1),
(9, 41964, 1),
(9, 41965, 1),
(9, 41966, 1),
(9, 41967, 1),
(9, 41968, 1),
(9, 41969, 1),
(9, 41970, 1),
(9, 41971, 1),
(9, 41972, 1),
(9, 41973, 1),
(9, 41974, 1),
(9, 41975, 1),
(9, 41976, 1),
(9, 41977, 1),
(9, 41978, 1),
(9, 41979, 1),
(9, 41980, 1),
(9, 41983, 1),
(9, 41984, 1),
(9, 41985, 1),
(9, 41986, 1),
(9, 41987, 1),
(9, 41988, 1),
(9, 41989, 1),
(9, 41994, 5),
(9, 41995, 1),
(9, 41996, 1),
(9, 41997, 1),
(9, 41998, 1),
(9, 41999, 1),
(9, 42000, 1),
(9, 42001, 1),
(9, 42002, 1),
(9, 42003, 1),
(9, 42004, 1),
(9, 42006, 1),
(9, 42166, 0),
(9, 42601, 21),
(9, 42602, 2),
(9, 42603, 3),
(9, 42604, 5),
(9, 42605, 3),
(9, 42606, 6),
(9, 42607, 3),
(9, 42608, 1),
(9, 42609, 1),
(9, 42610, 1),
(9, 42611, 1),
(9, 42701, 29),
(9, 42703, 3),
(9, 42704, 4),
(9, 42705, 1),
(9, 42706, 1),
(9, 42707, 1),
(9, 42708, 3),
(9, 42709, 2),
(9, 42710, 2),
(9, 42711, 1),
(9, 42712, 1),
(9, 42713, 1),
(9, 42714, 1),
(9, 42715, 1),
(9, 42716, 1),
(9, 42717, 5),
(9, 42718, 2),
(9, 42720, 2),
(9, 42721, 3),
(9, 42724, 2),
(9, 42725, 1),
(9, 42729, 12),
(9, 42731, 1),
(9, 43000, 29),
(9, 43001, 3),
(9, 43002, 3),
(9, 43003, 3),
(9, 43004, 3),
(9, 43005, 3),
(9, 43006, 4),
(9, 43007, 6),
(9, 43008, 2),
(9, 43009, 2),
(9, 43010, 1),
(9, 43026, 1),
(9, 43027, 1),
(9, 43028, 1),
(9, 43029, 2),
(9, 43030, 1),
(9, 43031, 1),
(9, 43032, 1),
(9, 43033, 1),
(9, 43851, 23),
(9, 43853, 5),
(9, 43854, 2),
(9, 43863, 1440),
(9, 43890, 2),
(9, 43891, 2),
(9, 43892, 2),
(9, 44579, 1),
(9, 44581, 3000),
(9, 44751, 1),
(9, 44752, 1),
(9, 44753, 1),
(9, 45150, 1),
(9, 45151, 1),
(9, 45180, 2),
(9, 45183, 3),
(9, 45215, 1),
(9, 45216, 1),
(9, 45217, 1),
(9, 45218, 1),
(9, 45219, 1),
(9, 45226, 1),
(9, 45472, 1),
(9, 45473, 1),
(9, 45474, 1),
(9, 45475, 1),
(9, 45476, 1),
(9, 45477, 1),
(9, 45488, 1),
(9, 45489, 1),
(9, 45490, 1),
(9, 45491, 1),
(9, 45492, 1),
(9, 45493, 1),
(9, 45494, 1),
(9, 45495, 1),
(9, 45497, 1),
(9, 45500, 1),
(9, 45651, 7),
(9, 45653, 1),
(9, 45654, 1),
(9, 45655, 1),
(9, 45656, 1),
(9, 45657, 1),
(9, 45658, 1),
(9, 45659, 1),
(9, 45660, 1),
(9, 45661, 1),
(9, 45662, 1),
(9, 45666, 1),
(9, 45668, 3),
(9, 45669, 3),
(9, 45671, 1),
(9, 45672, 1),
(9, 45674, 1),
(9, 45675, 1),
(9, 45676, 1),
(9, 45677, 1),
(9, 45679, 1),
(9, 45680, 1),
(9, 45681, 1),
(9, 45682, 7),
(9, 45683, 1),
(9, 45684, 1),
(9, 45685, 1),
(9, 45686, 1),
(9, 45687, 1),
(9, 45688, 1),
(9, 45690, 1),
(9, 45691, 1),
(9, 45692, 1),
(9, 45693, 1),
(9, 45694, 1),
(9, 45695, 1),
(9, 45698, 1),
(9, 45751, 1),
(9, 45752, 16),
(9, 45764, 1),
(9, 45851, 1),
(9, 45852, 10),
(9, 45853, 2),
(9, 45854, 2),
(9, 45860, 10),
(9, 45861, 2),
(9, 45862, 2),
(9, 45875, 10),
(9, 45876, 3),
(9, 45877, 2),
(9, 45878, 2),
(9, 45899, 10),
(9, 45901, 10),
(9, 45903, 30),
(9, 46309, 1),
(9, 46402, 1),
(9, 46403, 1),
(9, 46404, 1),
(9, 46851, 14),
(9, 46875, 1),
(9, 47402, 1),
(9, 47403, 1),
(9, 47512, 1),
(9, 47514, 1),
(9, 47601, 1),
(9, 47902, 1),
(9, 47903, 1),
(9, 47904, 1),
(9, 47905, 1),
(9, 50011, 5),
(9, 50043, 1),
(9, 50403, 1),
(9, 50404, 1),
(9, 50405, 1),
(9, 50406, 1),
(9, 50960, 1),
(9, 51680, 1),
(9, 52130, 8),
(9, 52148, 1),
(9, 52273, 1),
(9, 52279, 1),
(9, 55047, 1),
(9, 100157, 1),
(9, 150002, 0),
(9, 891642, 0),
(9, 891644, 0),
(9, 10001001, 16449536),
(9, 10001002, 16515072),
(9, 10003001, 65142784),
(9, 61305021, 28),
(9, 61305032, 2),
(10, 12330, 1),
(10, 12332, 13),
(10, 12333, 3),
(10, 12450, 6),
(10, 13413, 1726866301),
(10, 13414, 9),
(10, 14900, 1),
(10, 14903, 1),
(10, 20000, 1),
(10, 20001, 1),
(10, 20002, 1),
(10, 30057, 1),
(10, 30061, 1),
(10, 40430, 2),
(10, 40431, 2),
(10, 40432, 2),
(10, 40434, 1),
(10, 40435, 2),
(10, 40436, 2),
(10, 40437, 2),
(10, 40438, 3),
(10, 40439, 1),
(10, 40440, 1),
(10, 40441, 1),
(10, 40442, 3),
(10, 40443, 3),
(10, 40444, 3),
(10, 40445, 1),
(10, 40446, 1),
(10, 40612, 1),
(10, 40613, 18),
(10, 40629, 61),
(10, 40638, 2),
(10, 40788, 1),
(10, 40789, 1),
(10, 40790, 1),
(10, 40791, 1),
(10, 40822, 1),
(10, 40823, 2),
(10, 40824, 2),
(10, 40825, 12),
(10, 40827, 3),
(10, 40828, 3),
(10, 40829, 2),
(10, 40830, 1),
(10, 40831, 3),
(10, 40832, 5),
(10, 40833, 1),
(10, 40834, 1),
(10, 40835, 2),
(10, 40836, 1),
(10, 40837, 4),
(10, 41153, 1),
(10, 41174, 8),
(10, 41175, 3),
(10, 41176, 3),
(10, 41177, 3),
(10, 41276, 40),
(10, 41277, 3),
(10, 41278, 5),
(10, 41279, 3),
(10, 41280, 2),
(10, 41281, 6),
(10, 41282, 8),
(10, 41283, 3),
(10, 41284, 4),
(10, 41285, 2),
(10, 41286, 2),
(10, 41287, 2),
(10, 41288, 6),
(10, 41300, 1),
(10, 41306, 1),
(10, 41391, 2),
(10, 41392, 5),
(10, 41393, 3),
(10, 41394, 3),
(10, 41395, 3),
(10, 41396, 2),
(10, 41397, 1),
(10, 41685, 2),
(10, 41690, 5),
(10, 41691, 25),
(10, 41692, 7),
(10, 41693, 3),
(10, 41694, 6),
(10, 41695, 3),
(10, 41696, 3),
(10, 41697, 3),
(10, 41698, 1),
(10, 41700, 1),
(10, 41701, 1),
(10, 41703, 1),
(10, 41704, 1),
(10, 41705, 1),
(10, 41710, 1),
(10, 41711, 2),
(10, 41712, 3),
(10, 41713, 3),
(10, 41714, 8),
(10, 41715, 2),
(10, 41716, 4),
(10, 41717, 2),
(10, 41718, 1),
(10, 41912, 1),
(10, 41950, 1),
(10, 41951, 51),
(10, 41952, 6),
(10, 41953, 8),
(10, 41954, 6),
(10, 41955, 6),
(10, 41956, 8),
(10, 41957, 5),
(10, 41958, 5),
(10, 41959, 4),
(10, 41960, 2),
(10, 41961, 1),
(10, 41962, 1),
(10, 41963, 1),
(10, 41964, 1),
(10, 41965, 1),
(10, 41966, 1),
(10, 41967, 1),
(10, 41968, 1),
(10, 41969, 1),
(10, 41970, 1),
(10, 41971, 1),
(10, 41972, 1),
(10, 41973, 1),
(10, 41974, 1),
(10, 41975, 1),
(10, 41976, 1),
(10, 41977, 1),
(10, 41978, 1),
(10, 41979, 1),
(10, 41980, 1),
(10, 41983, 1),
(10, 41984, 1),
(10, 41985, 1),
(10, 41986, 1),
(10, 41987, 1),
(10, 41988, 1),
(10, 41989, 1),
(10, 41994, 5),
(10, 41995, 1),
(10, 41996, 1),
(10, 41997, 1),
(10, 41998, 1),
(10, 41999, 1),
(10, 42000, 1),
(10, 42001, 1),
(10, 42002, 1),
(10, 42003, 1),
(10, 42004, 1),
(10, 42006, 1),
(10, 42166, 0),
(10, 42601, 21),
(10, 42602, 2),
(10, 42603, 3),
(10, 42604, 5),
(10, 42605, 3),
(10, 42606, 6),
(10, 42607, 3),
(10, 42608, 1),
(10, 42609, 1),
(10, 42610, 1),
(10, 42611, 1),
(10, 42701, 29),
(10, 42703, 3),
(10, 42704, 4),
(10, 42705, 1),
(10, 42706, 1),
(10, 42707, 1),
(10, 42708, 3),
(10, 42709, 2),
(10, 42710, 2),
(10, 42711, 1),
(10, 42712, 1),
(10, 42713, 1),
(10, 42714, 1),
(10, 42715, 1),
(10, 42716, 1),
(10, 42717, 5),
(10, 42718, 2),
(10, 42720, 2),
(10, 42721, 3),
(10, 42724, 2),
(10, 42725, 1),
(10, 42729, 12),
(10, 42731, 1),
(10, 43000, 29),
(10, 43001, 3),
(10, 43002, 3),
(10, 43003, 3),
(10, 43004, 3),
(10, 43005, 3),
(10, 43006, 4),
(10, 43007, 6),
(10, 43008, 2),
(10, 43009, 2),
(10, 43010, 1),
(10, 43026, 1),
(10, 43027, 1),
(10, 43028, 1),
(10, 43029, 2),
(10, 43030, 1),
(10, 43031, 1),
(10, 43032, 1),
(10, 43033, 1),
(10, 43851, 23),
(10, 43853, 5),
(10, 43854, 2),
(10, 43863, 1440),
(10, 43890, 2),
(10, 43891, 2),
(10, 43892, 2),
(10, 44956, 1),
(10, 44957, 1),
(10, 45751, 1),
(10, 45752, 16),
(10, 45764, 1),
(10, 46309, 1),
(10, 46402, 1),
(10, 46403, 1),
(10, 46404, 1),
(10, 46851, 14),
(10, 46875, 1),
(10, 47402, 1),
(10, 47403, 1),
(10, 47512, 1),
(10, 47514, 1),
(10, 47601, 1),
(10, 47902, 1),
(10, 47903, 1),
(10, 47904, 1),
(10, 47905, 1),
(10, 50011, 5),
(10, 50043, 1),
(10, 50052, 1),
(10, 50053, 1),
(10, 50054, 1),
(10, 50055, 1),
(10, 50063, 1),
(10, 50065, 1),
(10, 50066, 1),
(10, 50067, 1),
(10, 50068, 1),
(10, 50069, 1),
(10, 50070, 1),
(10, 50071, 1),
(10, 50072, 1),
(10, 50073, 1),
(10, 50080, 1),
(10, 50081, 10),
(10, 50082, 2),
(10, 50083, 2),
(10, 50090, 10),
(10, 50091, 2),
(10, 50092, 2),
(10, 50115, 10),
(10, 50116, 3),
(10, 50117, 2),
(10, 50118, 2),
(10, 50139, 10),
(10, 50141, 10),
(10, 50143, 30),
(10, 50200, 7),
(10, 50201, 1),
(10, 50202, 1),
(10, 50203, 1),
(10, 50204, 1),
(10, 50205, 1),
(10, 50210, 1),
(10, 50211, 1),
(10, 50212, 1),
(10, 50213, 1),
(10, 50214, 1),
(10, 50215, 1),
(10, 50225, 1),
(10, 50226, 4),
(10, 50227, 3),
(10, 50228, 3),
(10, 50230, 1),
(10, 50231, 1),
(10, 50234, 1),
(10, 50235, 1),
(10, 50236, 1),
(10, 50240, 1),
(10, 50241, 1),
(10, 50242, 1),
(10, 50243, 1),
(10, 50245, 7),
(10, 50246, 1),
(10, 50250, 1),
(10, 50251, 1),
(10, 50252, 1),
(10, 50253, 1),
(10, 50255, 1),
(10, 50256, 1),
(10, 50257, 1),
(10, 50258, 1),
(10, 50259, 1),
(10, 50260, 1),
(10, 50263, 1),
(10, 50264, 1),
(10, 50403, 1),
(10, 50404, 1),
(10, 50405, 1),
(10, 50406, 1),
(10, 50442, 1),
(10, 50443, 1),
(10, 50444, 1),
(10, 50445, 1),
(10, 50446, 1),
(10, 50453, 1),
(10, 50470, 1),
(10, 50471, 1),
(10, 50472, 1),
(10, 50473, 1),
(10, 50474, 1),
(10, 50475, 1),
(10, 50486, 1),
(10, 50488, 1),
(10, 50490, 1),
(10, 50492, 1),
(10, 50494, 1),
(10, 50496, 1),
(10, 50498, 1),
(10, 50501, 1),
(10, 50503, 1),
(10, 50506, 1),
(10, 50850, 1),
(10, 50852, 3000),
(10, 50960, 1),
(10, 51480, 1),
(10, 51487, 1),
(10, 51538, 2),
(10, 51680, 1),
(10, 52030, 1),
(10, 52031, 1),
(10, 52032, 2),
(10, 52033, 1),
(10, 52146, 2),
(10, 52148, 1),
(10, 52149, 3),
(10, 52273, 2),
(10, 52279, 1),
(10, 55047, 1),
(10, 100157, 1),
(10, 150002, 0),
(10, 10001001, 16449536),
(10, 10001002, 16515072),
(10, 61305021, 20);

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_taskhunt`
--

CREATE TABLE `player_taskhunt` (
  `player_id` int(11) NOT NULL,
  `slot` tinyint(1) NOT NULL,
  `state` tinyint(1) NOT NULL,
  `raceid` varchar(250) NOT NULL,
  `upgrade` tinyint(1) NOT NULL,
  `rarity` tinyint(1) NOT NULL,
  `kills` varchar(250) NOT NULL,
  `disabled_time` bigint(20) NOT NULL,
  `free_reroll` bigint(20) NOT NULL,
  `monster_list` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `player_taskhunt`
--

INSERT INTO `player_taskhunt` (`player_id`, `slot`, `state`, `raceid`, `upgrade`, `rarity`, `kills`, `disabled_time`, `free_reroll`, `monster_list`) VALUES
(7, 0, 2, '0', 0, 1, '0', 0, 1726164239009, 0x20042f081404de005709fb035f002401d204),
(7, 1, 2, '0', 0, 1, '0', 0, 1726164239009, 0x2d000501550901017800b6014d0178060b00),
(7, 2, 0, '0', 0, 1, '0', 0, 1726164239009, ''),
(8, 0, 2, '0', 0, 1, '0', 0, 1726351613258, 0x8a060b02a30536017a00410134087702bd06),
(8, 1, 2, '0', 0, 1, '0', 0, 1726351613258, 0x8d07e9056f043a004d003d00820347004601),
(8, 2, 0, '0', 0, 1, '0', 0, 1726351613258, ''),
(9, 0, 2, '0', 0, 1, '0', 0, 1731073469331, 0x7002750372050e02e3085e00060719002a08),
(9, 1, 2, '0', 0, 1, '0', 0, 1731073469331, 0x5d0720015f043e00ca01f20026000c060c00),
(9, 2, 0, '0', 0, 1, '0', 0, 1731073469331, ''),
(10, 0, 2, '0', 0, 1, '0', 0, 1726940251215, 0x35080103ea05670041007c002f004c00be06),
(10, 1, 2, '0', 0, 1, '0', 0, 1726940251215, 0x2500060112032a0881064700e00030087800),
(10, 2, 0, '0', 0, 1, '0', 0, 1726940251215, '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_wheeldata`
--

CREATE TABLE `player_wheeldata` (
  `player_id` int(11) NOT NULL,
  `slot` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `server_config`
--

CREATE TABLE `server_config` (
  `config` varchar(50) NOT NULL,
  `value` varchar(256) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `server_config`
--

INSERT INTO `server_config` (`config`, `value`, `timestamp`) VALUES
('db_version', '47', '2024-11-10 04:47:41'),
('motd_hash', '0f8265109a3b621e795f41d91767bc4bb0ced5cc', '2024-09-11 22:00:05'),
('motd_num', '1', '2024-09-11 22:00:05'),
('players_record', '3', '2024-09-20 21:37:32');

-- --------------------------------------------------------

--
-- Estrutura para tabela `status`
--

CREATE TABLE `status` (
  `id` smallint(8) NOT NULL,
  `status` text CHARACTER SET latin1 NOT NULL,
  `account` text CHARACTER SET latin1 NOT NULL,
  `points` text CHARACTER SET latin1 NOT NULL,
  `codigo` text CHARACTER SET latin1 NOT NULL,
  `chave` text CHARACTER SET latin1 NOT NULL,
  `processed` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `store_history`
--

CREATE TABLE `store_history` (
  `id` int(11) NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  `mode` smallint(2) NOT NULL DEFAULT '0',
  `description` varchar(3500) NOT NULL,
  `coin_type` tinyint(1) NOT NULL DEFAULT '0',
  `coin_amount` int(12) NOT NULL,
  `time` bigint(20) UNSIGNED NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT '0',
  `coins` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `store_history`
--

INSERT INTO `store_history` (`id`, `account_id`, `mode`, `description`, `coin_type`, `coin_amount`, `time`, `timestamp`, `coins`) VALUES
(1, 2, 0, '[ONLINE REWARD] - Reward', 1, 10, 1726262458, 0, 0),
(2, 2, 0, '[ONLINE REWARD] - Reward', 1, 10, 1726263058, 0, 0),
(3, 2, 0, '[ONLINE REWARD] - Reward', 1, 10, 1726264708, 0, 0),
(4, 2, 0, '[ONLINE REWARD] - Reward', 1, 10, 1726265308, 0, 0),
(5, 2, 0, 'XP Boost', 1, -30, 1726265619, 0, 0),
(6, 2, 0, '360 Days of VIP', 1, -3000, 1729899794, 0, 0),
(7, 2, 0, '[ONLINE REWARD] - Reward', 1, 30, 1729921417, 0, 0),
(8, 2, 0, 'Gold Pouch', 1, -900, 1730788291, 0, 0),
(9, 2, 0, '[Monster Hunt] - Winner', 1, 300, 1731308402, 0, 0),
(10, 2, 0, '[ONLINE REWARD] - Reward', 1, 10, 1731456519, 0, 0),
(11, 2, 0, '[ONLINE REWARD] - Reward', 1, 10, 1731553910, 0, 0),
(12, 2, 0, '[ONLINE REWARD] - Reward', 1, 10, 1731608976, 0, 0),
(13, 2, 0, '[ONLINE REWARD] - Reward', 1, 5, 1731612959, 0, 0),
(14, 2, 0, '[Monster Hunt] - Winner', 1, 300, 1731614411, 0, 0),
(15, 2, 0, '[ONLINE REWARD] - Reward', 1, 5, 1731616560, 0, 0),
(16, 2, 0, '[ONLINE REWARD] - Reward', 1, 5, 1731620162, 0, 0),
(17, 2, 0, '[ONLINE REWARD] - Reward', 1, 5, 1731628208, 0, 0),
(18, 2, 0, '[ONLINE REWARD] - Reward', 1, 5, 1731634649, 0, 0),
(19, 2, 0, '[ONLINE REWARD] - Reward', 1, 5, 1731638287, 0, 0),
(20, 2, 0, '[ONLINE REWARD] - Reward', 1, 5, 1731641887, 0, 0),
(21, 2, 0, '[ONLINE REWARD] - Reward', 1, 5, 1731645491, 0, 0),
(22, 2, 0, '[ONLINE REWARD] - Reward', 1, 5, 1731649098, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `tile_store`
--

CREATE TABLE `tile_store` (
  `house_id` int(11) NOT NULL,
  `data` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `tile_store`
--

INSERT INTO `tile_store` (`house_id`, `data`) VALUES
(10, 0xdf7db7820801000000660600),
(53, 0xdd7d9e820801000000680600),
(54, 0xe97d9e820801000000680600),
(55, 0xe07da5820801000000660600),
(55, 0xdb7da5820801000000660600),
(56, 0xea7da5820801000000660600),
(89, 0xa87d808208010000005c0b00),
(89, 0xa87d81820801000000660600),
(89, 0xaa7d82820801000000690600),
(89, 0xab7d808208010000005c0b00),
(89, 0xab7d81820801000000670600),
(89, 0xac7d828208010000005e0b00),
(89, 0xae7d7d8208010000005e0b00),
(2630, 0xcb7fae7b0701000000341900),
(2632, 0xb27f9e7b0701000000371800),
(2649, 0x917fa47b0701000000321900),
(2650, 0x827fac7b0701000000321900),
(2650, 0x807fae7b0701000000311900),
(2655, 0xa57fbd7b0701000000371800),
(2655, 0xa77fbd7b0701000000331900),
(2907, 0x3d7ee57d0701000000231900),
(2913, 0x3d7ee57d0601000000231900),
(2913, 0x3f7ee77d0601000000241900),
(2918, 0x7a7eeb7d0701000000231900),
(2918, 0x787eea7d07010000005b0b00),
(2918, 0x787ee97d07010000002d0a00),
(2918, 0x787ee87d07010000002d0a00),
(2918, 0x787ee77d07010000005b0b00),
(2918, 0x7b7ee87d0701000000220900),
(2918, 0x7d7ee87d0701000000660600),
(2919, 0x787eea7d06010000005b0b00),
(2919, 0x787ee97d06010000002d0a00),
(2919, 0x787ee87d06010000002d0a00),
(2919, 0x7b7ee87d0601000000220900),
(2919, 0x787ee77d06010000005b0b00),
(2919, 0x7d7ee87d06010000005c0b00),
(2919, 0x7d7ee97d0601000000660600),
(2930, 0x0a7e3e7d07010000005b0b00),
(2930, 0x0e7e417d0701000000271900),
(2930, 0x117e3c7d0701000000281900),
(2930, 0x117e3d7d07010000005c0b00),
(2930, 0x117e3e7d0701000000f51300),
(2930, 0x117e3f7d07010000005c0b00),
(2931, 0x0a7e447d0701000000241900),
(2931, 0x0d7e467d0701000000680600),
(2931, 0x107e427d07010000005d0b00),
(2931, 0x117e467d0701000000680600),
(2931, 0x127e447d07010000005b0b00),
(2931, 0x127e467d07010000005d0b00),
(2931, 0x147e467d0701000000680600),
(2931, 0x157e457d0701000000660600),
(2931, 0x0d7e427d06010000005d0b00),
(2931, 0x0d7e477d0601000000680600),
(2931, 0x0e7e427d0601000000231900),
(2931, 0x0f7e427d0601000000231900),
(2931, 0x0f7e477d06010000005d0b00),
(2931, 0x107e477d0601000000680600),
(2931, 0x127e447d06010000005b0b00),
(2931, 0x127e457d0601000000660600),
(2931, 0x127e467d06010000002d0a00),
(2931, 0x147e477d0601000000680600),
(2931, 0x157e457d0601000000241900),
(2931, 0x157e497d0601000000241900),
(2931, 0x0f7e497d0701000000660600),
(2931, 0x157e497d0701000000241900),
(2931, 0x0f7e4a7d07010000005b0b00),
(2931, 0x107e4b7d0601000000231900),
(2931, 0x127e4b7d0701000000231900),
(2931, 0x137e4b7d0701000000231900),
(2932, 0x1b7e437d07010000005b0b00),
(2932, 0x1d7e437d05010000005d0b00),
(2932, 0x1c7e407d0701000000701800),
(2932, 0x1e7e437d0501000000701800),
(2932, 0x1e7e467d06010000002b1900),
(2932, 0x1f7e3f7d05010000006e1800),
(2932, 0x1e7e3d7d07010000005d0b00),
(2932, 0x1f7e427d06010000006e1800),
(2932, 0x1f7e447d06010000005b0b00),
(2932, 0x1f7e457d06010000006e1800),
(2932, 0x1f7e437d07010000006e1800),
(2932, 0x207e407d0701000000701800),
(2932, 0x217e407d0601000000701800),
(2941, 0x4b7ede7d07010000002d0a00),
(2941, 0x4b7edf7d07010000002d0a00),
(2941, 0x4b7ee07d0701000000f61300),
(2941, 0x4d7edf7d0701000000230900),
(2941, 0x4d7ee17d0701000000271900),
(2941, 0x4e7ee17d0701000000271900),
(2941, 0x4f7ede7d0701000000f51300),
(2942, 0x537ed27d0701000000220900),
(2942, 0x517ed27d0701000000660600),
(2942, 0x517ed37d07010000005b0b00),
(2942, 0x527ed07d0701000000680600),
(2942, 0x537ed07d07010000005d0b00),
(2942, 0x547ed07d0701000000260a00),
(2942, 0x557ed07d0701000000260a00),
(2942, 0x547ecc7d07010000005d0b00),
(2943, 0x477ed47d0601000000690600),
(2943, 0x447ed17d0701000000241900),
(2943, 0x4a7ed07d0701000000660600),
(2943, 0x477ecf7d0701000000680600),
(2943, 0x4d7ed07d0601000000660600),
(2947, 0x7a7ee47d0701000000660600),
(2947, 0x777ee37d07010000005b0b00),
(2947, 0x7a7ee37d07010000002d0a00),
(2947, 0x7a7ee27d07010000002d0a00),
(2947, 0x7a7ee17d07010000005b0b00),
(2947, 0x7a7ee07d0701000000660600),
(2947, 0x7b7ee57d07010000005d0b00),
(2947, 0x7d7ede7d07010000005d0b00),
(2947, 0x7f7ee27d0701000000241900),
(2947, 0x7d7ee17d0701000000240900),
(2948, 0x7a7ede7d0601000000660600),
(2948, 0x7a7edd7d06010000005b0b00),
(2948, 0x7c7eda7d0601000000260a00),
(2948, 0x7d7eda7d0601000000260a00),
(2948, 0x7d7edd7d0601000000240900),
(2948, 0x7e7eda7d06010000005d0b00),
(2948, 0x7f7edc7d0601000000241900),
(2949, 0x7b7ee57d06010000005d0b00),
(2949, 0x7a7ee47d0601000000660600),
(2949, 0x777ee37d06010000005b0b00),
(2949, 0x7a7ee37d06010000002d0a00),
(2949, 0x7a7ee27d06010000002d0a00),
(2949, 0x7a7ee17d06010000005b0b00),
(2949, 0x7a7ee07d0601000000660600),
(2949, 0x7d7ee17d0601000000240900),
(2949, 0x7d7edf7d06010000005e0b00),
(2949, 0x7f7ee37d0601000000241900),
(2949, 0x7f7ee17d0601000000241900),
(2950, 0x8e7eb27d0701000000240900),
(2950, 0x8e7eb47d0701000000680600),
(2950, 0x8b7eb27d07010000005b0b00),
(2950, 0x8a7eb47d0701000000231900),
(2950, 0x887eb27d0701000000241900),
(2950, 0x887eb17d07010000005b0b00),
(2950, 0x8b7eb17d0701000000660600),
(2950, 0x907eb17d0701000000241900),
(2950, 0x8a7eaf7d0701000000231900),
(2950, 0x8c7eaf7d0701000000260a00),
(2950, 0x8d7eaf7d0701000000260a00),
(2950, 0x8e7eaf7d0701000000231900),
(2950, 0x8f7eaf7d07010000005d0b00),
(2951, 0x957eb47d0701000000271900),
(2951, 0x947eb27d0701000000240900),
(2951, 0x947eb47d0701000000ec1300),
(2951, 0x957eb47d0601000000271900),
(2951, 0x927eb17d07010000005b0b00),
(2951, 0x927eb07d0701000000281900),
(2951, 0x937eaf7d0701000000260a00),
(2951, 0x947eaf7d0701000000ec1300),
(2951, 0x957eaf7d0701000000260a00),
(2952, 0x9c7ebb7d0701000000241900),
(2952, 0x9c7ebe7d0701000000241900),
(2952, 0x9b7eb97d07010000005d0b00),
(2952, 0x9b7ebf7d0701000000231900),
(2952, 0x9a7eb97d0701000000680600),
(2952, 0x987eb97d0701000000231900),
(2952, 0x987ebf7d0701000000231900),
(2952, 0x967ebb7d0701000000241900),
(2952, 0x967ebc7d07010000005b0b00),
(2953, 0x9c7ebc7d0601000000241900),
(2953, 0x9c7ebd7d0601000000660600),
(2953, 0x9c7ebe7d0601000000241900),
(2953, 0x9b7eb97d0601000000231900),
(2953, 0x9b7ebf7d0601000000231900),
(2953, 0x9a7eb97d06010000005d0b00),
(2953, 0x987eb97d0601000000231900),
(2953, 0x987ebf7d0601000000231900),
(2953, 0x967ebb7d0601000000241900),
(2953, 0x967ebc7d06010000005b0b00),
(2954, 0xa57eb17d0701000000231900),
(2954, 0xa67eb17d0701000000680600),
(2954, 0xa77eb17d0701000000231900),
(2954, 0xa37eb07d0701000000241900),
(2954, 0xa87eb07d0701000000241900),
(2954, 0xa57eb17d0601000000251900),
(2954, 0xa77eb17d0601000000251900),
(2954, 0xa37eaf7d0701000000660600),
(2954, 0xa87eb07d0601000000261900),
(2954, 0xa37eaf7d0601000000261900),
(2954, 0xa67ead7d0701000000680600),
(2954, 0xa67ead7d0601000000680600),
(2954, 0xa37eac7d0601000000261900),
(2954, 0xa67eaa7d0701000000231900),
(2964, 0x487ee77d0701000000261900),
(2964, 0x4a7ee57d0701000000251900),
(2964, 0x4b7ee57d07010000005d0b00),
(2964, 0x4c7ee87d0701000000660600),
(2965, 0x4c7eea7d07010000005b0b00),
(2967, 0x487ee77d0601000000241900),
(2967, 0x487ee87d06010000005b0b00),
(2967, 0x4a7ee57d0601000000231900),
(2967, 0x4c7ee87d0601000000660600),
(2968, 0x4c7eea7d06010000005b0b00),
(2971, 0x487ee77d0501000000241900),
(2971, 0x487ee87d05010000005b0b00),
(2971, 0x4a7ee57d0501000000231900),
(2971, 0x4c7ee87d0501000000660600),
(2972, 0x4c7eea7d05010000005b0b00),
(2976, 0xa47eb97d07010000005d0b00),
(2976, 0xa27ebf7d0701000000231900),
(2976, 0xa37ebf7d0701000000231900),
(2976, 0xa57ebe7d0701000000241900),
(2976, 0xa57ebd7d0701000000660600),
(2976, 0xa57ebb7d0701000000241900),
(2976, 0xa27eb97d0701000000231900),
(2976, 0x9f7ebc7d0701000000241900),
(2977, 0xa47ebf7d0601000000231900),
(2977, 0xa57ebe7d0601000000241900),
(2977, 0xa57ebd7d0601000000660600),
(2977, 0xa57ebc7d0601000000241900),
(2977, 0xa27eb97d0601000000231900),
(2977, 0xa37eb97d06010000005d0b00),
(2977, 0xa17ebf7d0601000000231900),
(2978, 0xa67ed17d0701000000241900),
(2978, 0xa67ed07d0701000000660600),
(2978, 0xa67ecf7d0701000000241900),
(2979, 0xa47ecd7d07010000005e0b00),
(2979, 0xa67ecc7d0701000000241900),
(2979, 0xa67ecb7d0701000000660600),
(2979, 0xa67eca7d0701000000241900),
(2980, 0xa47ec87d07010000005d0b00),
(2980, 0xa67ec77d0701000000241900),
(2980, 0xa67ec67d0701000000660600),
(2980, 0xa67ec57d0701000000241900),
(2980, 0xa47ec37d07010000005d0b00),
(2981, 0xa67ed17d0601000000241900),
(2981, 0xa67ed07d0601000000660600),
(2981, 0xa67ecf7d0601000000241900),
(2982, 0xa47ecd7d06010000005d0b00),
(2982, 0xa67ecc7d0601000000241900),
(2982, 0xa67ecb7d0601000000660600),
(2982, 0xa67eca7d0601000000241900),
(2983, 0xa47ec87d06010000005d0b00),
(2983, 0xa67ec77d0601000000241900),
(2983, 0xa67ec67d0601000000660600),
(2983, 0xa67ec57d0601000000241900),
(2983, 0xa47ec37d06010000005d0b00),
(2984, 0xa57e057e0701000000241900),
(2987, 0x687efd7d0701000000680600),
(2991, 0xa37ee77d0601000000231900),
(2991, 0xa47ee77d06010000005d0b00),
(2991, 0xa17ee97d0601000000241900),
(2991, 0xa57ee97d0601000000241900),
(2991, 0xa17eeb7d0601000000241900),
(2991, 0xa57eeb7d0601000000241900),
(2991, 0xa37eec7d0601000000680600),
(2992, 0x9d7ee77d0601000000231900),
(2992, 0x9e7ee77d06010000005d0b00),
(2992, 0xa07ee97d0601000000241900),
(2992, 0xa07eeb7d0601000000241900),
(2994, 0x9d7ee77d07010000005d0b00),
(2994, 0x9e7ee77d0701000000231900),
(2994, 0xa07ee97d0701000000241900),
(2994, 0xa07eeb7d0701000000241900),
(2995, 0xa37ee77d07010000005d0b00),
(2995, 0xa47ee77d0701000000231900),
(2995, 0xa17ee97d0701000000241900),
(2995, 0xa57ee97d0701000000241900),
(2995, 0xa17eeb7d0701000000241900),
(2995, 0xa57eeb7d0701000000241900),
(2995, 0xa37eec7d0701000000680600),
(2996, 0xa57ef17d0701000000241900),
(2996, 0xa37eef7d0701000000680600),
(2996, 0xa37ef47d0701000000231900),
(2996, 0xa57ef37d0701000000241900),
(2998, 0x9a7edb7d06010000005b0b00),
(2998, 0x9a7edc7d0601000000241900),
(2998, 0x9c7ed97d0601000000231900),
(2998, 0x9e7ed97d0601000000231900),
(2998, 0x9f7edb7d0601000000241900),
(2998, 0x9f7edc7d0601000000660600),
(2999, 0x9a7edf7d06010000005b0b00),
(2999, 0x9f7edf7d0601000000660600),
(2999, 0x9f7ee07d0601000000241900),
(3000, 0x9f7ee27d0601000000660600),
(3000, 0x9f7ee47d0601000000241900),
(3000, 0x9e7ee57d0601000000231900),
(3000, 0x9c7ee57d0601000000231900),
(3001, 0x9a7edb7d07010000005b0b00),
(3001, 0x9a7edc7d0701000000241900),
(3001, 0x9c7ed97d0701000000231900),
(3001, 0x9e7ed97d0701000000231900),
(3001, 0x9f7edb7d0701000000241900),
(3001, 0x9f7edc7d0701000000660600),
(3002, 0x9f7edf7d0701000000660600),
(3002, 0x9f7ee07d0701000000241900),
(3003, 0x9f7ee27d0701000000660600),
(3003, 0x9f7ee47d0701000000241900),
(3003, 0x9e7ee57d0701000000231900),
(3003, 0x9c7ee57d0701000000231900),
(3004, 0x5c7ed47d0701000000680600),
(3004, 0x5d7ed47d0701000000680600),
(3004, 0x5b7ed27d0601000000231900),
(3004, 0x5c7ed27d06010000005e0b00),
(3004, 0x5e7ed27d0601000000680600),
(3004, 0x5f7ec47d0701000000241900),
(3004, 0x5f7ec47d0601000000241900),
(3004, 0x5d7ec57d07010000005d0b00),
(3004, 0x5c7ec57d0701000000260a00),
(3004, 0x5d7ec17d0601000000231900),
(3004, 0x5b7ec57d0701000000680600),
(3004, 0x5c7ec17d06010000005d0b00),
(3004, 0x5a7ec17d07010000005d0b00),
(3004, 0x5b7ec57d0601000000680600),
(3004, 0x5a7ec17d0601000000231900),
(3004, 0x577ec37d0701000000241900),
(3004, 0x577ec37d0601000000241900),
(3004, 0x5a7ec77d06010000005b0b00),
(3004, 0x577ec87d0601000000241900),
(3004, 0x577ec87d0701000000241900),
(3004, 0x5a7ec97d0601000000660600),
(3004, 0x5a7ecb7d06010000005d0b00),
(3004, 0x597ecb7d0701000000680600),
(3004, 0x5c7ecb7d0701000000680600),
(3004, 0x5e7ec97d0601000000680600),
(3004, 0x5f7ec77d0601000000241900),
(3004, 0x5f7ecb7d0601000000241900),
(3004, 0x5f7ec77d0701000000241900),
(3004, 0x5f7ec97d0701000000241900),
(3004, 0x5d7ecb7d07010000005e0b00),
(3004, 0x5d7ecd7d0601000000660600),
(3004, 0x577ece7d0601000000231900),
(3004, 0x587ece7d07010000005b0b00),
(3004, 0x5a7ece7d0701000000220900),
(3004, 0x5d7ecf7d06010000005c0b00),
(3004, 0x5f7ecf7d0601000000241900),
(3004, 0x5d7ed07d0601000000660600),
(3004, 0x607ec17d08010000005d0b00),
(3004, 0x5e7ec47d08010000006e1800),
(3004, 0x607ec57d08010000005d0b00),
(3004, 0x5b7ec47d08010000006e1800),
(3004, 0x5b7ec57d08010000005b0b00),
(3004, 0x577ec37d08010000005b0b00),
(3006, 0xd07eae7d07010000002c1900),
(3006, 0xd07ead7d07010000005b0b00),
(3006, 0xd07eb17d07010000005b0b00),
(3006, 0xd07eb37d07010000002c1900),
(3006, 0xd37ead7d07010000006f1800),
(3006, 0xd37eb27d07010000006f1800),
(3006, 0xd37eb37d07010000005b0b00),
(3006, 0xd47eab7d07010000005d0b00),
(3006, 0xd57eab7d0701000000711800),
(3006, 0xd67ead7d07010000006f1800),
(3006, 0xd67eb57d07010000002b1900),
(3006, 0xd77eae7d07010000005d0b00),
(3006, 0xd87eab7d07010000005d0b00),
(3006, 0xd87eae7d0701000000711800),
(3006, 0xd97eb17d07010000002c1900),
(3006, 0xd97eb27d07010000002c1900),
(3006, 0xd07ead7d06010000005b0b00),
(3006, 0xd07eb17d06010000002d0a00),
(3006, 0xd07eb27d06010000002d0a00),
(3006, 0xd27eae7d06010000005d0b00),
(3006, 0xd27eb57d06010000002b1900),
(3006, 0xd37eab7d06010000002b1900),
(3006, 0xd37eae7d0601000000701800),
(3006, 0xd47eae7d06010000005d0b00),
(3006, 0xd57ead7d06010000006e1800),
(3006, 0xd67eae7d06010000005d0b00),
(3006, 0xd77eab7d06010000005d0b00),
(3006, 0xd77eae7d0601000000701800),
(3006, 0xd77eb57d06010000002b1900),
(3006, 0xd87eae7d06010000005d0b00),
(3006, 0xd97eb27d06010000002c1900),
(3006, 0xd07ead7d05010000005b0b00),
(3006, 0xd07eae7d05010000002c1900),
(3006, 0xd07eb37d05010000005b0b00),
(3006, 0xd27eb17d0501000000701800),
(3006, 0xd27eb57d05010000002b1900),
(3006, 0xd37eaf7d0501000000701800),
(3006, 0xd37eb37d05010000005b0b00),
(3006, 0xd47eaf7d05010000005d0b00),
(3006, 0xd57eb17d0501000000701800),
(3006, 0xd57eb57d05010000002b1900),
(3006, 0xd67eb37d05010000005b0b00),
(3006, 0xd87eab7d05010000005d0b00),
(3006, 0xd87eb17d0501000000701800),
(3006, 0xd87eb57d05010000002b1900),
(3006, 0xd97eaf7d05010000002c1900),
(3006, 0xd37eb07d04010000005b0b00),
(3006, 0xd57eae7d0401000000701800),
(3006, 0xd57eb17d04010000002b1900),
(3006, 0xd67eb07d04010000002c1900),
(3006, 0xd07ead7d08010000005c0b00),
(3006, 0xd07eb27d08010000005c0b00),
(3006, 0xd67ead7d08010000006e1800),
(3006, 0xd77eab7d08010000005e0b00),
(3006, 0xd87eae7d0801000000711800),
(3006, 0xd97eae7d08010000005e0b00),
(3012, 0x8c7efd7d0701000000231900),
(3012, 0x8d7efd7d0701000000231900),
(3012, 0x8f7efa7d07010000005b0b00),
(3012, 0x917ef87d0701000000680600),
(3135, 0xbc81417c07010000006e1800),
(3135, 0xbf81417c07010000006e1800),
(3160, 0xde81567c0701000000241900),
(3161, 0xca81497c0701000000660600),
(3161, 0xca814a7c07010000005b0b00),
(3166, 0xca81487c0601000000241900),
(3220, 0x637fd37f0701000000391900),
(3220, 0x607fd37f0701000000391900),
(3266, 0xcd7d96790701000000f71a00),
(3270, 0xdd7da27907010000005c0b00),
(3271, 0xdd7d99790701000000f71a00),
(3271, 0xdd7d9a7907010000005c0b00),
(3314, 0xc581ba7e0701000000b71400),
(3314, 0xc581b97e07010000005c0b00),
(3314, 0xcc81ba7e07010000008a1500),
(3316, 0xc581bf7e0701000000b71400),
(3316, 0xc581c07e07010000005c0b00),
(3316, 0xc581c57e0701000000b71400),
(3316, 0xc781c27e07010000005e0b00),
(3316, 0xc881bc7e07020000005e0b005d0b00),
(3316, 0xc881c27e07010000008c1500),
(3316, 0xca81bf7e07010000008a1500),
(3316, 0xc881c77e0701000000b61400),
(3318, 0xcc81c27e07010000005e0b00),
(3318, 0xcd81c27e0701000000b61400),
(3318, 0xcd81c77e0701000000b61400),
(3319, 0xc581c17e06010000005c0b00),
(3319, 0xc581c57e0601000000b71400),
(3319, 0xc581bb7e06010000005b0b00),
(3319, 0xc881bc7e06010000008c1500),
(3319, 0xc881c27e06010000008c1500),
(3319, 0xca81be7e06010000008a1500),
(3320, 0xcc81bc7e06010000008c1500),
(3320, 0xce81bc7e0601000000b61400),
(3322, 0xca81c57e06010000005c0b00),
(3322, 0xcd81c27e06010000005e0b00),
(3322, 0xce81c27e0601000000b61400),
(3322, 0xce81c77e0601000000b61400),
(3334, 0xc081cf7e0601000000b61400),
(3334, 0xc981cf7e0601000000b61400),
(3334, 0xc081cf7e0701000000b61400),
(3334, 0xc181cf7e07010000005d0b00),
(3334, 0xc981cf7e0701000000b61400),
(3334, 0xbe81d17e0601000000b71400),
(3334, 0xc281d17e06010000008a1500),
(3334, 0xc781d17e06010000008a1500),
(3334, 0xbe81d17e07010000005b0b00),
(3334, 0xc481d17e07010000005c0b00),
(3334, 0xbe81d27e06010000005c0b00),
(3334, 0xc281d27e06010000005c0b00),
(3334, 0xc781d27e06010000005c0b00),
(3334, 0xcb81d27e0601000000b71400),
(3334, 0xbe81d27e0701000000b71400),
(3334, 0xc781d27e07010000005b0b00),
(3334, 0xcb81d27e0701000000b71400),
(3334, 0xc481d37e07010000005d0b00),
(3334, 0xc581d37e07010000008c1500),
(3334, 0xc981d47e06010000008c1500),
(3334, 0xca81d47e06010000005e0b00),
(3339, 0xb181bd7e0701000000b61400),
(3339, 0xb381bd7e0701000000b61400),
(3340, 0xb681bb7e07010000005c0b00),
(3340, 0xb881bd7e0701000000b61400),
(3341, 0xba81ba7e07010000005c0b00),
(3341, 0xbd81bd7e0701000000b61400),
(3341, 0xbf81ba7e0701000000b71400),
(3344, 0xb181bd7e0601000000b61400),
(3345, 0xb681bd7e0601000000b61400),
(3346, 0xbc81bd7e0601000000b61400),
(3346, 0xbf81bb7e0601000000b71400);

-- --------------------------------------------------------

--
-- Estrutura para tabela `towns`
--

CREATE TABLE `towns` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `posx` int(11) NOT NULL DEFAULT '0',
  `posy` int(11) NOT NULL DEFAULT '0',
  `posz` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `towns`
--

INSERT INTO `towns` (`id`, `name`, `posx`, `posy`, `posz`) VALUES
(1, 'Dawnport Tutorial', 32069, 31901, 6),
(2, 'Dawnport', 32064, 31894, 6),
(3, 'Rookgaard', 32097, 32219, 7),
(4, 'Island of Destiny', 32091, 32027, 7),
(5, 'Ab\'Dendriel', 32732, 31634, 7),
(6, 'Carlin', 32360, 31782, 7),
(7, 'Kazordoon', 32649, 31925, 11),
(8, 'Thais', 32369, 32241, 7),
(9, 'Venore', 32957, 32076, 7),
(10, 'Ankrahmun', 33194, 32853, 8),
(11, 'Edron', 33217, 31814, 8),
(12, 'Farmine', 33023, 31521, 11),
(13, 'Darashia', 33213, 32454, 1),
(14, 'Liberty Bay', 32317, 32826, 7),
(15, 'Port Hope', 32594, 32745, 7),
(16, 'Svargrond', 32212, 31132, 7),
(17, 'Yalahar', 32787, 31276, 7),
(18, 'Gray Beach', 33447, 31323, 9),
(19, 'Krailos', 33657, 31665, 8),
(20, 'Rathleton', 33594, 31899, 6),
(21, 'Roshamuul', 33513, 32363, 6),
(22, 'Issavi', 33921, 31477, 5),
(23, 'Event Room', 1054, 1040, 7),
(24, 'Weleran', 32311, 33187, 7),
(25, 'Releva', 32623, 33242, 7),
(26, 'BaiakTown', 32229, 33445, 7),
(27, 'Gnomprona', 33517, 32856, 14),
(28, 'Marapur', 33842, 32853, 7),
(29, 'Candia', 33338, 32125, 7);

-- --------------------------------------------------------

--
-- Estrutura para tabela `z_polls`
--

CREATE TABLE `z_polls` (
  `id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `end` int(11) NOT NULL DEFAULT '0',
  `start` int(11) NOT NULL DEFAULT '0',
  `answers` int(11) NOT NULL DEFAULT '0',
  `votes_all` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `z_polls_answers`
--

CREATE TABLE `z_polls_answers` (
  `poll_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `answer` varchar(255) NOT NULL,
  `votes` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `accounts_unique` (`name`);

--
-- Índices de tabela `account_authentication`
--
ALTER TABLE `account_authentication`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `account_bans`
--
ALTER TABLE `account_bans`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Índices de tabela `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Índices de tabela `account_sessions`
--
ALTER TABLE `account_sessions`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `account_vipgrouplist`
--
ALTER TABLE `account_vipgrouplist`
  ADD UNIQUE KEY `account_vipgrouplist_unique` (`account_id`,`player_id`,`vipgroup_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `vipgroup_id` (`vipgroup_id`),
  ADD KEY `account_vipgrouplist_vipgroup_fk` (`vipgroup_id`,`account_id`);

--
-- Índices de tabela `account_vipgroups`
--
ALTER TABLE `account_vipgroups`
  ADD PRIMARY KEY (`id`,`account_id`);

--
-- Índices de tabela `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD UNIQUE KEY `account_viplist_unique` (`account_id`,`player_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `boosted_boss`
--
ALTER TABLE `boosted_boss`
  ADD PRIMARY KEY (`date`);

--
-- Índices de tabela `boosted_creature`
--
ALTER TABLE `boosted_creature`
  ADD PRIMARY KEY (`date`);

--
-- Índices de tabela `coins_transactions`
--
ALTER TABLE `coins_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`);

--
-- Índices de tabela `daily_reward_history`
--
ALTER TABLE `daily_reward_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `forge_history`
--
ALTER TABLE `forge_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `global_storage`
--
ALTER TABLE `global_storage`
  ADD UNIQUE KEY `global_storage_unique` (`key`);

--
-- Índices de tabela `guilds`
--
ALTER TABLE `guilds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `guilds_name_unique` (`name`),
  ADD UNIQUE KEY `guilds_owner_unique` (`ownerid`);

--
-- Índices de tabela `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `warid` (`warid`);

--
-- Índices de tabela `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD PRIMARY KEY (`player_id`,`guild_id`),
  ADD KEY `guild_id` (`guild_id`);

--
-- Índices de tabela `guild_membership`
--
ALTER TABLE `guild_membership`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `guild_id` (`guild_id`),
  ADD KEY `rank_id` (`rank_id`);

--
-- Índices de tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild_id` (`guild_id`);

--
-- Índices de tabela `guild_wars`
--
ALTER TABLE `guild_wars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild1` (`guild1`),
  ADD KEY `guild2` (`guild2`);

--
-- Índices de tabela `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`),
  ADD KEY `town_id` (`town_id`);

--
-- Índices de tabela `house_lists`
--
ALTER TABLE `house_lists`
  ADD PRIMARY KEY (`house_id`,`listid`),
  ADD KEY `house_id_index` (`house_id`),
  ADD KEY `version` (`version`);

--
-- Índices de tabela `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD PRIMARY KEY (`ip`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Índices de tabela `kv_store`
--
ALTER TABLE `kv_store`
  ADD PRIMARY KEY (`key_name`);

--
-- Índices de tabela `lottery`
--
ALTER TABLE `lottery`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `market_history`
--
ALTER TABLE `market_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`,`sale`);

--
-- Índices de tabela `market_offers`
--
ALTER TABLE `market_offers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale` (`sale`,`itemtype`),
  ADD KEY `created` (`created`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `myaac_account_actions`
--
ALTER TABLE `myaac_account_actions`
  ADD KEY `account_id` (`account_id`);

--
-- Índices de tabela `myaac_admin_menu`
--
ALTER TABLE `myaac_admin_menu`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_bugtracker`
--
ALTER TABLE `myaac_bugtracker`
  ADD PRIMARY KEY (`uid`);

--
-- Índices de tabela `myaac_changelog`
--
ALTER TABLE `myaac_changelog`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_charbazaar`
--
ALTER TABLE `myaac_charbazaar`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_charbazaar_bid`
--
ALTER TABLE `myaac_charbazaar_bid`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_config`
--
ALTER TABLE `myaac_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Índices de tabela `myaac_faq`
--
ALTER TABLE `myaac_faq`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_forum`
--
ALTER TABLE `myaac_forum`
  ADD PRIMARY KEY (`id`),
  ADD KEY `section` (`section`);

--
-- Índices de tabela `myaac_forum_boards`
--
ALTER TABLE `myaac_forum_boards`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_gallery`
--
ALTER TABLE `myaac_gallery`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_menu`
--
ALTER TABLE `myaac_menu`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_monsters`
--
ALTER TABLE `myaac_monsters`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_news`
--
ALTER TABLE `myaac_news`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_news_categories`
--
ALTER TABLE `myaac_news_categories`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_notepad`
--
ALTER TABLE `myaac_notepad`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_pages`
--
ALTER TABLE `myaac_pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Índices de tabela `myaac_polls`
--
ALTER TABLE `myaac_polls`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_spells`
--
ALTER TABLE `myaac_spells`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Índices de tabela `myaac_videos`
--
ALTER TABLE `myaac_videos`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `myaac_visitors`
--
ALTER TABLE `myaac_visitors`
  ADD UNIQUE KEY `ip` (`ip`);

--
-- Índices de tabela `myaac_weapons`
--
ALTER TABLE `myaac_weapons`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `players_unique` (`name`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `vocation` (`vocation`);

--
-- Índices de tabela `players_online`
--
ALTER TABLE `players_online`
  ADD PRIMARY KEY (`player_id`);

--
-- Índices de tabela `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `killed_by` (`killed_by`),
  ADD KEY `mostdamage_by` (`mostdamage_by`);

--
-- Índices de tabela `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD UNIQUE KEY `player_depotitems_unique` (`player_id`,`sid`);

--
-- Índices de tabela `player_hirelings`
--
ALTER TABLE `player_hirelings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD UNIQUE KEY `player_inboxitems_unique` (`player_id`,`sid`);

--
-- Índices de tabela `player_items`
--
ALTER TABLE `player_items`
  ADD PRIMARY KEY (`player_id`,`pid`,`sid`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `sid` (`sid`);

--
-- Índices de tabela `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD UNIQUE KEY `player_namelocks_unique` (`player_id`),
  ADD KEY `namelocked_by` (`namelocked_by`);

--
-- Índices de tabela `player_prey`
--
ALTER TABLE `player_prey`
  ADD PRIMARY KEY (`player_id`,`slot`);

--
-- Índices de tabela `player_rewards`
--
ALTER TABLE `player_rewards`
  ADD UNIQUE KEY `player_rewards_unique` (`player_id`,`sid`);

--
-- Índices de tabela `player_spells`
--
ALTER TABLE `player_spells`
  ADD PRIMARY KEY (`player_id`,`name`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_stash`
--
ALTER TABLE `player_stash`
  ADD PRIMARY KEY (`player_id`,`item_id`);

--
-- Índices de tabela `player_storage`
--
ALTER TABLE `player_storage`
  ADD PRIMARY KEY (`player_id`,`key`);

--
-- Índices de tabela `player_taskhunt`
--
ALTER TABLE `player_taskhunt`
  ADD PRIMARY KEY (`player_id`,`slot`);

--
-- Índices de tabela `player_wheeldata`
--
ALTER TABLE `player_wheeldata`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `server_config`
--
ALTER TABLE `server_config`
  ADD PRIMARY KEY (`config`);

--
-- Índices de tabela `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `store_history`
--
ALTER TABLE `store_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`);

--
-- Índices de tabela `tile_store`
--
ALTER TABLE `tile_store`
  ADD KEY `house_id` (`house_id`);

--
-- Índices de tabela `towns`
--
ALTER TABLE `towns`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Índices de tabela `z_polls`
--
ALTER TABLE `z_polls`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `account_authentication`
--
ALTER TABLE `account_authentication`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `account_ban_history`
--
ALTER TABLE `account_ban_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `account_vipgroups`
--
ALTER TABLE `account_vipgroups`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `coins_transactions`
--
ALTER TABLE `coins_transactions`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de tabela `daily_reward_history`
--
ALTER TABLE `daily_reward_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `forge_history`
--
ALTER TABLE `forge_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guilds`
--
ALTER TABLE `guilds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `guild_wars`
--
ALTER TABLE `guild_wars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3687;

--
-- AUTO_INCREMENT de tabela `lottery`
--
ALTER TABLE `lottery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT de tabela `market_history`
--
ALTER TABLE `market_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `market_offers`
--
ALTER TABLE `market_offers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `myaac_admin_menu`
--
ALTER TABLE `myaac_admin_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `myaac_bugtracker`
--
ALTER TABLE `myaac_bugtracker`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `myaac_changelog`
--
ALTER TABLE `myaac_changelog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `myaac_charbazaar`
--
ALTER TABLE `myaac_charbazaar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `myaac_charbazaar_bid`
--
ALTER TABLE `myaac_charbazaar_bid`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `myaac_config`
--
ALTER TABLE `myaac_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de tabela `myaac_faq`
--
ALTER TABLE `myaac_faq`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `myaac_forum`
--
ALTER TABLE `myaac_forum`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `myaac_forum_boards`
--
ALTER TABLE `myaac_forum_boards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `myaac_gallery`
--
ALTER TABLE `myaac_gallery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `myaac_menu`
--
ALTER TABLE `myaac_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=341;

--
-- AUTO_INCREMENT de tabela `myaac_monsters`
--
ALTER TABLE `myaac_monsters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `myaac_news`
--
ALTER TABLE `myaac_news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `myaac_news_categories`
--
ALTER TABLE `myaac_news_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `myaac_notepad`
--
ALTER TABLE `myaac_notepad`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `myaac_pages`
--
ALTER TABLE `myaac_pages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `myaac_spells`
--
ALTER TABLE `myaac_spells`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `myaac_videos`
--
ALTER TABLE `myaac_videos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `player_hirelings`
--
ALTER TABLE `player_hirelings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `status`
--
ALTER TABLE `status`
  MODIFY `id` smallint(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `store_history`
--
ALTER TABLE `store_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de tabela `towns`
--
ALTER TABLE `towns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de tabela `z_polls`
--
ALTER TABLE `z_polls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `account_bans`
--
ALTER TABLE `account_bans`
  ADD CONSTRAINT `account_bans_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_bans_player_fk` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD CONSTRAINT `account_bans_history_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_bans_history_player_fk` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `account_vipgrouplist`
--
ALTER TABLE `account_vipgrouplist`
  ADD CONSTRAINT `account_vipgrouplist_player_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_vipgrouplist_vipgroup_fk` FOREIGN KEY (`vipgroup_id`,`account_id`) REFERENCES `account_vipgroups` (`id`, `account_id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD CONSTRAINT `account_viplist_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_viplist_player_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `coins_transactions`
--
ALTER TABLE `coins_transactions`
  ADD CONSTRAINT `coins_transactions_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `daily_reward_history`
--
ALTER TABLE `daily_reward_history`
  ADD CONSTRAINT `daily_reward_history_player_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `forge_history`
--
ALTER TABLE `forge_history`
  ADD CONSTRAINT `forge_history_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guilds`
--
ALTER TABLE `guilds`
  ADD CONSTRAINT `guilds_ownerid_fk` FOREIGN KEY (`ownerid`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD CONSTRAINT `guildwar_kills_warid_fk` FOREIGN KEY (`warid`) REFERENCES `guild_wars` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD CONSTRAINT `guild_invites_guild_fk` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guild_invites_player_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guild_membership`
--
ALTER TABLE `guild_membership`
  ADD CONSTRAINT `guild_membership_guild_fk` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_membership_player_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_membership_rank_fk` FOREIGN KEY (`rank_id`) REFERENCES `guild_ranks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD CONSTRAINT `guild_ranks_fk` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `house_lists`
--
ALTER TABLE `house_lists`
  ADD CONSTRAINT `houses_list_house_fk` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD CONSTRAINT `ip_bans_players_fk` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `market_history`
--
ALTER TABLE `market_history`
  ADD CONSTRAINT `market_history_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `market_offers`
--
ALTER TABLE `market_offers`
  ADD CONSTRAINT `market_offers_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD CONSTRAINT `player_deaths_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD CONSTRAINT `player_depotitems_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_hirelings`
--
ALTER TABLE `player_hirelings`
  ADD CONSTRAINT `player_hirelings_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD CONSTRAINT `player_inboxitems_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_items`
--
ALTER TABLE `player_items`
  ADD CONSTRAINT `player_items_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD CONSTRAINT `player_namelocks_players2_fk` FOREIGN KEY (`namelocked_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `player_namelocks_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `player_rewards`
--
ALTER TABLE `player_rewards`
  ADD CONSTRAINT `player_rewards_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_spells`
--
ALTER TABLE `player_spells`
  ADD CONSTRAINT `player_spells_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_storage`
--
ALTER TABLE `player_storage`
  ADD CONSTRAINT `player_storage_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_wheeldata`
--
ALTER TABLE `player_wheeldata`
  ADD CONSTRAINT `player_wheeldata_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `store_history`
--
ALTER TABLE `store_history`
  ADD CONSTRAINT `store_history_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `tile_store`
--
ALTER TABLE `tile_store`
  ADD CONSTRAINT `tile_store_account_fk` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
