-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 22, 2023 at 11:22 AM
-- Server version: 8.0.33-0ubuntu0.22.04.2
-- PHP Version: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `arclite_db`
--
CREATE DATABASE IF NOT EXISTS `arclite_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `arclite_db`;

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `password` char(40) NOT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `key` varchar(64) NOT NULL DEFAULT '',
  `blocked` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'internal usage',
  `created` int NOT NULL DEFAULT '0',
  `rlname` varchar(255) NOT NULL DEFAULT '',
  `location` varchar(255) NOT NULL DEFAULT '',
  `country` varchar(3) NOT NULL DEFAULT '',
  `web_lastlogin` int NOT NULL DEFAULT '0',
  `web_flags` int NOT NULL DEFAULT '0',
  `email_hash` varchar(32) NOT NULL DEFAULT '',
  `email_new` varchar(255) NOT NULL DEFAULT '',
  `email_new_time` int NOT NULL DEFAULT '0',
  `email_code` varchar(255) NOT NULL DEFAULT '',
  `email_next` int NOT NULL DEFAULT '0',
  `premium_points` int NOT NULL DEFAULT '0',
  `email_verified` tinyint(1) NOT NULL DEFAULT '0',
  `premdays` int NOT NULL DEFAULT '0',
  `lastday` int UNSIGNED NOT NULL DEFAULT '0',
  `type` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `coins` int UNSIGNED NOT NULL DEFAULT '0',
  `tournament_coins` int UNSIGNED NOT NULL DEFAULT '0',
  `creation` int UNSIGNED NOT NULL DEFAULT '0',
  `recruiter` int DEFAULT '0',
  `vote` int NOT NULL DEFAULT '0',
  `page_access` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `account_authentication`
--

DROP TABLE IF EXISTS `account_authentication`;
CREATE TABLE IF NOT EXISTS `account_authentication` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `secret` varchar(100) NOT NULL,
  `status` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `account_bans`
--

DROP TABLE IF EXISTS `account_bans`;
CREATE TABLE IF NOT EXISTS `account_bans` (
  `account_id` int UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint NOT NULL,
  `expires_at` bigint NOT NULL,
  `banned_by` int NOT NULL,
  PRIMARY KEY (`account_id`),
  KEY `banned_by` (`banned_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `account_ban_history`
--

DROP TABLE IF EXISTS `account_ban_history`;
CREATE TABLE IF NOT EXISTS `account_ban_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint NOT NULL,
  `expired_at` bigint NOT NULL,
  `banned_by` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`),
  KEY `banned_by` (`banned_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `account_registration`
--

DROP TABLE IF EXISTS `account_registration`;
CREATE TABLE IF NOT EXISTS `account_registration` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `recovery` varchar(23) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `address` varchar(50) NOT NULL,
  `housenumber` int NOT NULL,
  `additional` varchar(50) NOT NULL,
  `postalcode` varchar(20) NOT NULL,
  `city` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `mobile` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `account_viplist`
--

DROP TABLE IF EXISTS `account_viplist`;
CREATE TABLE IF NOT EXISTS `account_viplist` (
  `account_id` int UNSIGNED NOT NULL COMMENT 'id of account whose viplist entry it is',
  `player_id` int NOT NULL COMMENT 'id of target player of viplist entry',
  `description` varchar(128) NOT NULL DEFAULT '',
  `icon` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `notify` tinyint(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `account_viplist_unique` (`account_id`,`player_id`),
  KEY `account_id` (`account_id`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `boosted_boss`
--

DROP TABLE IF EXISTS `boosted_boss`;
CREATE TABLE IF NOT EXISTS `boosted_boss` (
  `looktype` int NOT NULL DEFAULT '136',
  `lookfeet` int NOT NULL DEFAULT '0',
  `looklegs` int NOT NULL DEFAULT '0',
  `lookhead` int NOT NULL DEFAULT '0',
  `lookbody` int NOT NULL DEFAULT '0',
  `lookaddons` int NOT NULL DEFAULT '0',
  `lookmount` int DEFAULT '0',
  `date` varchar(250) NOT NULL DEFAULT '',
  `boostname` text,
  `raceid` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `boosted_creature`
--

DROP TABLE IF EXISTS `boosted_creature`;
CREATE TABLE IF NOT EXISTS `boosted_creature` (
  `looktype` int NOT NULL DEFAULT '136',
  `lookfeet` int NOT NULL DEFAULT '0',
  `looklegs` int NOT NULL DEFAULT '0',
  `lookhead` int NOT NULL DEFAULT '0',
  `lookbody` int NOT NULL DEFAULT '0',
  `lookaddons` int NOT NULL DEFAULT '0',
  `lookmount` int DEFAULT '0',
  `date` varchar(250) NOT NULL DEFAULT '',
  `boostname` text,
  `raceid` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `canary_achievements`
--

DROP TABLE IF EXISTS `canary_achievements`;
CREATE TABLE IF NOT EXISTS `canary_achievements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `description` text NOT NULL,
  `grade` int NOT NULL,
  `points` int NOT NULL,
  `storage` int NOT NULL,
  `secret` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_badges`
--

DROP TABLE IF EXISTS `canary_badges`;
CREATE TABLE IF NOT EXISTS `canary_badges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `image` varchar(200) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `number` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_boss`
--

DROP TABLE IF EXISTS `canary_boss`;
CREATE TABLE IF NOT EXISTS `canary_boss` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_compendium`
--

DROP TABLE IF EXISTS `canary_compendium`;
CREATE TABLE IF NOT EXISTS `canary_compendium` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` int NOT NULL,
  `headline` varchar(250) NOT NULL,
  `message` text NOT NULL,
  `publishdate` int NOT NULL DEFAULT '0',
  `type` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_countdowns`
--

DROP TABLE IF EXISTS `canary_countdowns`;
CREATE TABLE IF NOT EXISTS `canary_countdowns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date_start` int NOT NULL,
  `date_end` int NOT NULL,
  `themebox` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_creatures`
--

DROP TABLE IF EXISTS `canary_creatures`;
CREATE TABLE IF NOT EXISTS `canary_creatures` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_groups`
--

DROP TABLE IF EXISTS `canary_groups`;
CREATE TABLE IF NOT EXISTS `canary_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_items`
--

DROP TABLE IF EXISTS `canary_items`;
CREATE TABLE IF NOT EXISTS `canary_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `type` varchar(150) NOT NULL,
  `level` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_news`
--

DROP TABLE IF EXISTS `canary_news`;
CREATE TABLE IF NOT EXISTS `canary_news` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `body` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `type` tinyint NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `category` tinyint NOT NULL,
  `player_id` int NOT NULL,
  `last_modified_by` int NOT NULL DEFAULT '0',
  `last_modified_date` datetime NOT NULL,
  `comments` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `article_text` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `article_image` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hidden` tinyint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_payments`
--

DROP TABLE IF EXISTS `canary_payments`;
CREATE TABLE IF NOT EXISTS `canary_payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `method` varchar(100) NOT NULL,
  `reference` varchar(200) NOT NULL,
  `total_coins` int NOT NULL,
  `final_price` int NOT NULL,
  `status` int NOT NULL,
  `date` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_polls`
--

DROP TABLE IF EXISTS `canary_polls`;
CREATE TABLE IF NOT EXISTS `canary_polls` (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL DEFAULT '0',
  `title` varchar(250) NOT NULL,
  `description` varchar(500) NOT NULL,
  `date_start` int NOT NULL,
  `date_end` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_polls_answers`
--

DROP TABLE IF EXISTS `canary_polls_answers`;
CREATE TABLE IF NOT EXISTS `canary_polls_answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `poll_id` int NOT NULL,
  `account_id` int NOT NULL,
  `question_id` int NOT NULL,
  `date` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_polls_questions`
--

DROP TABLE IF EXISTS `canary_polls_questions`;
CREATE TABLE IF NOT EXISTS `canary_polls_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `poll_id` int NOT NULL,
  `question` varchar(250) NOT NULL,
  `description` varchar(500) NOT NULL,
  `votes` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_products`
--

DROP TABLE IF EXISTS `canary_products`;
CREATE TABLE IF NOT EXISTS `canary_products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `coins` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_samples`
--

DROP TABLE IF EXISTS `canary_samples`;
CREATE TABLE IF NOT EXISTS `canary_samples` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vocation` int NOT NULL,
  `experience` int NOT NULL,
  `level` int NOT NULL,
  `health` int NOT NULL,
  `healthmax` int NOT NULL,
  `maglevel` int NOT NULL,
  `mana` int NOT NULL,
  `manamax` int NOT NULL,
  `manaspent` int NOT NULL,
  `soul` int NOT NULL,
  `town_id` int NOT NULL,
  `posx` int NOT NULL,
  `posy` int NOT NULL,
  `posz` int NOT NULL,
  `cap` int NOT NULL,
  `balance` int NOT NULL,
  `lookbody` int NOT NULL,
  `lookfeet` int NOT NULL,
  `lookhead` int NOT NULL,
  `looklegs` int NOT NULL,
  `looktype` int NOT NULL,
  `lookaddons` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_towns`
--

DROP TABLE IF EXISTS `canary_towns`;
CREATE TABLE IF NOT EXISTS `canary_towns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `town_id` int NOT NULL DEFAULT '0',
  `name` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_uploads`
--

DROP TABLE IF EXISTS `canary_uploads`;
CREATE TABLE IF NOT EXISTS `canary_uploads` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `path` varchar(500) NOT NULL,
  `date` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_website`
--

DROP TABLE IF EXISTS `canary_website`;
CREATE TABLE IF NOT EXISTS `canary_website` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timezone` varchar(150) NOT NULL,
  `title` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `downloads` varchar(250) NOT NULL,
  `discord` varchar(250) NOT NULL,
  `player_voc` int NOT NULL COMMENT '0 off and 1 on',
  `player_max` int NOT NULL COMMENT 'players por conta',
  `player_guild` int NOT NULL COMMENT 'level',
  `donates` int NOT NULL COMMENT '0 off and 1 on',
  `coin_price` decimal(10,2) NOT NULL,
  `mercadopago` int NOT NULL,
  `pagseguro` int NOT NULL,
  `paypal` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_worldquests`
--

DROP TABLE IF EXISTS `canary_worldquests`;
CREATE TABLE IF NOT EXISTS `canary_worldquests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `storage` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `canary_worlds`
--

DROP TABLE IF EXISTS `canary_worlds`;
CREATE TABLE IF NOT EXISTS `canary_worlds` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `creation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `location` int NOT NULL DEFAULT '0',
  `pvp_type` int NOT NULL DEFAULT '0',
  `premium_type` int NOT NULL DEFAULT '0',
  `transfer_type` int NOT NULL DEFAULT '0',
  `battle_eye` int NOT NULL DEFAULT '0',
  `world_type` int NOT NULL DEFAULT '0',
  `ip` varchar(18) NOT NULL,
  `port` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `coins_transactions`
--

DROP TABLE IF EXISTS `coins_transactions`;
CREATE TABLE IF NOT EXISTS `coins_transactions` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` int UNSIGNED NOT NULL,
  `type` tinyint UNSIGNED NOT NULL,
  `amount` int UNSIGNED NOT NULL,
  `description` varchar(3500) NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `crypto_payments`
--

DROP TABLE IF EXISTS `crypto_payments`;
CREATE TABLE IF NOT EXISTS `crypto_payments` (
  `paymentID` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `boxID` int UNSIGNED NOT NULL DEFAULT '0',
  `boxType` enum('paymentbox','captchabox') NOT NULL,
  `orderID` varchar(50) NOT NULL DEFAULT '',
  `userID` varchar(50) NOT NULL DEFAULT '',
  `countryID` varchar(3) NOT NULL DEFAULT '',
  `coinLabel` varchar(6) NOT NULL DEFAULT '',
  `amount` double(20,8) NOT NULL DEFAULT '0.00000000',
  `amountUSD` double(20,8) NOT NULL DEFAULT '0.00000000',
  `unrecognised` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `addr` varchar(34) NOT NULL DEFAULT '',
  `txID` char(64) NOT NULL DEFAULT '',
  `txDate` datetime DEFAULT NULL,
  `txConfirmed` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `txCheckDate` datetime DEFAULT NULL,
  `processed` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `processedDate` datetime DEFAULT NULL,
  `recordCreated` datetime DEFAULT NULL,
  PRIMARY KEY (`paymentID`),
  UNIQUE KEY `key3` (`boxID`,`orderID`,`userID`,`txID`,`amount`,`addr`),
  KEY `boxID` (`boxID`),
  KEY `boxType` (`boxType`),
  KEY `userID` (`userID`),
  KEY `countryID` (`countryID`),
  KEY `orderID` (`orderID`),
  KEY `amount` (`amount`),
  KEY `amountUSD` (`amountUSD`),
  KEY `coinLabel` (`coinLabel`),
  KEY `unrecognised` (`unrecognised`),
  KEY `addr` (`addr`),
  KEY `txID` (`txID`),
  KEY `txDate` (`txDate`),
  KEY `txConfirmed` (`txConfirmed`),
  KEY `txCheckDate` (`txCheckDate`),
  KEY `processed` (`processed`),
  KEY `processedDate` (`processedDate`),
  KEY `recordCreated` (`recordCreated`),
  KEY `key1` (`boxID`,`orderID`),
  KEY `key2` (`boxID`,`orderID`,`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `daily_reward_history`
--

DROP TABLE IF EXISTS `daily_reward_history`;
CREATE TABLE IF NOT EXISTS `daily_reward_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `daystreak` smallint NOT NULL DEFAULT '0',
  `player_id` int NOT NULL,
  `timestamp` int NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `forge_history`
--

DROP TABLE IF EXISTS `forge_history`;
CREATE TABLE IF NOT EXISTS `forge_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `action_type` int NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `is_success` tinyint NOT NULL DEFAULT '0',
  `bonus` tinyint NOT NULL DEFAULT '0',
  `done_at` bigint NOT NULL,
  `done_at_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `cost` bigint UNSIGNED NOT NULL DEFAULT '0',
  `gained` bigint UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `global_storage`
--

DROP TABLE IF EXISTS `global_storage`;
CREATE TABLE IF NOT EXISTS `global_storage` (
  `key` varchar(32) NOT NULL,
  `value` text NOT NULL,
  UNIQUE KEY `global_storage_unique` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `guilds`
--

DROP TABLE IF EXISTS `guilds`;
CREATE TABLE IF NOT EXISTS `guilds` (
  `id` int NOT NULL AUTO_INCREMENT,
  `level` int NOT NULL DEFAULT '1',
  `name` varchar(255) NOT NULL,
  `ownerid` int NOT NULL,
  `creationdata` int NOT NULL,
  `motd` varchar(255) NOT NULL DEFAULT '',
  `residence` int NOT NULL DEFAULT '0',
  `balance` bigint UNSIGNED NOT NULL DEFAULT '0',
  `points` int NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `logo_name` varchar(255) NOT NULL DEFAULT 'default.gif',
  `world_id` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `guilds_name_unique` (`name`),
  UNIQUE KEY `guilds_owner_unique` (`ownerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Triggers `guilds`
--
DROP TRIGGER IF EXISTS `oncreate_guilds`;
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
-- Table structure for table `guildwar_kills`
--

DROP TABLE IF EXISTS `guildwar_kills`;
CREATE TABLE IF NOT EXISTS `guildwar_kills` (
  `id` int NOT NULL AUTO_INCREMENT,
  `killer` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  `killerguild` int NOT NULL DEFAULT '0',
  `targetguild` int NOT NULL DEFAULT '0',
  `warid` int NOT NULL DEFAULT '0',
  `time` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `guildwar_kills_unique` (`warid`),
  KEY `warid` (`warid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `guild_applications`
--

DROP TABLE IF EXISTS `guild_applications`;
CREATE TABLE IF NOT EXISTS `guild_applications` (
  `player_id` int NOT NULL DEFAULT '0',
  `account_id` int NOT NULL,
  `guild_id` int NOT NULL DEFAULT '0',
  `text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `status` tinyint NOT NULL DEFAULT '0',
  `date` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `guild_events`
--

DROP TABLE IF EXISTS `guild_events`;
CREATE TABLE IF NOT EXISTS `guild_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `guild_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `date` int NOT NULL,
  `private` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `guild_invites`
--

DROP TABLE IF EXISTS `guild_invites`;
CREATE TABLE IF NOT EXISTS `guild_invites` (
  `player_id` int NOT NULL DEFAULT '0',
  `guild_id` int NOT NULL DEFAULT '0',
  `date` int NOT NULL,
  PRIMARY KEY (`player_id`,`guild_id`),
  KEY `guild_id` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `guild_membership`
--

DROP TABLE IF EXISTS `guild_membership`;
CREATE TABLE IF NOT EXISTS `guild_membership` (
  `player_id` int NOT NULL,
  `guild_id` int NOT NULL,
  `rank_id` int NOT NULL,
  `nick` varchar(15) NOT NULL DEFAULT '',
  `date` int NOT NULL,
  PRIMARY KEY (`player_id`),
  KEY `guild_id` (`guild_id`),
  KEY `rank_id` (`rank_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `guild_ranks`
--

DROP TABLE IF EXISTS `guild_ranks`;
CREATE TABLE IF NOT EXISTS `guild_ranks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `guild_id` int NOT NULL COMMENT 'guild',
  `name` varchar(255) NOT NULL COMMENT 'rank name',
  `level` int NOT NULL COMMENT 'rank level - leader, vice, member, maybe something else',
  PRIMARY KEY (`id`),
  KEY `guild_id` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `guild_wars`
--

DROP TABLE IF EXISTS `guild_wars`;
CREATE TABLE IF NOT EXISTS `guild_wars` (
  `id` int NOT NULL AUTO_INCREMENT,
  `guild1` int NOT NULL DEFAULT '0',
  `guild2` int NOT NULL DEFAULT '0',
  `name1` varchar(255) NOT NULL,
  `name2` varchar(255) NOT NULL,
  `status` tinyint NOT NULL DEFAULT '0',
  `started` bigint NOT NULL DEFAULT '0',
  `ended` bigint NOT NULL DEFAULT '0',
  `price1` int NOT NULL DEFAULT '0',
  `price2` int NOT NULL DEFAULT '0',
  `frags` int NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `guild1` (`guild1`),
  KEY `guild2` (`guild2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

DROP TABLE IF EXISTS `houses`;
CREATE TABLE IF NOT EXISTS `houses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `house_id` int NOT NULL,
  `world_id` int NOT NULL,
  `owner` int NOT NULL DEFAULT '0',
  `paid` int UNSIGNED NOT NULL DEFAULT '0',
  `warnings` int NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `rent` int NOT NULL DEFAULT '0',
  `town_id` int NOT NULL DEFAULT '0',
  `bid` int NOT NULL DEFAULT '0',
  `bid_end` int NOT NULL DEFAULT '0',
  `last_bid` int NOT NULL DEFAULT '0',
  `highest_bidder` int NOT NULL DEFAULT '0',
  `size` int NOT NULL DEFAULT '0',
  `guildid` int DEFAULT NULL,
  `beds` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `town_id` (`town_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `house_lists`
--

DROP TABLE IF EXISTS `house_lists`;
CREATE TABLE IF NOT EXISTS `house_lists` (
  `house_id` int NOT NULL,
  `listid` int NOT NULL,
  `list` text NOT NULL,
  KEY `house_id` (`house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `ip_bans`
--

DROP TABLE IF EXISTS `ip_bans`;
CREATE TABLE IF NOT EXISTS `ip_bans` (
  `ip` int NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint NOT NULL,
  `expires_at` bigint NOT NULL,
  `banned_by` int NOT NULL,
  PRIMARY KEY (`ip`),
  KEY `banned_by` (`banned_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `market_history`
--

DROP TABLE IF EXISTS `market_history`;
CREATE TABLE IF NOT EXISTS `market_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT '0',
  `itemtype` int UNSIGNED NOT NULL,
  `amount` smallint UNSIGNED NOT NULL,
  `price` bigint UNSIGNED NOT NULL DEFAULT '0',
  `expires_at` bigint UNSIGNED NOT NULL,
  `inserted` bigint UNSIGNED NOT NULL,
  `state` tinyint UNSIGNED NOT NULL,
  `tier` tinyint UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`,`sale`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `market_offers`
--

DROP TABLE IF EXISTS `market_offers`;
CREATE TABLE IF NOT EXISTS `market_offers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT '0',
  `itemtype` int UNSIGNED NOT NULL,
  `amount` smallint UNSIGNED NOT NULL,
  `created` bigint UNSIGNED NOT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `price` bigint UNSIGNED NOT NULL DEFAULT '0',
  `tier` tinyint UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sale` (`sale`,`itemtype`),
  KEY `created` (`created`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `pagseguro_transactions`
--

DROP TABLE IF EXISTS `pagseguro_transactions`;
CREATE TABLE IF NOT EXISTS `pagseguro_transactions` (
  `transaction_code` varchar(36) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `payment_method` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL,
  `item_count` int NOT NULL,
  `data` datetime NOT NULL,
  UNIQUE KEY `transaction_code` (`transaction_code`,`status`),
  KEY `name` (`name`),
  KEY `status` (`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
CREATE TABLE IF NOT EXISTS `players` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `group_id` int NOT NULL DEFAULT '1',
  `account_id` int UNSIGNED NOT NULL DEFAULT '0',
  `level` int NOT NULL DEFAULT '1',
  `vocation` int NOT NULL DEFAULT '0',
  `health` int NOT NULL DEFAULT '150',
  `healthmax` int NOT NULL DEFAULT '150',
  `experience` bigint NOT NULL DEFAULT '0',
  `lookbody` int NOT NULL DEFAULT '0',
  `lookfeet` int NOT NULL DEFAULT '0',
  `lookhead` int NOT NULL DEFAULT '0',
  `looklegs` int NOT NULL DEFAULT '0',
  `looktype` int NOT NULL DEFAULT '136',
  `lookaddons` int NOT NULL DEFAULT '0',
  `maglevel` int NOT NULL DEFAULT '0',
  `mana` int NOT NULL DEFAULT '0',
  `manamax` int NOT NULL DEFAULT '0',
  `manaspent` bigint UNSIGNED NOT NULL DEFAULT '0',
  `soul` int UNSIGNED NOT NULL DEFAULT '0',
  `town_id` int NOT NULL DEFAULT '1',
  `posx` int NOT NULL DEFAULT '0',
  `posy` int NOT NULL DEFAULT '0',
  `posz` int NOT NULL DEFAULT '0',
  `conditions` blob,
  `cap` int NOT NULL DEFAULT '0',
  `sex` int NOT NULL DEFAULT '0',
  `lastlogin` bigint UNSIGNED NOT NULL DEFAULT '0',
  `lastip` int UNSIGNED NOT NULL DEFAULT '0',
  `save` tinyint(1) NOT NULL DEFAULT '1',
  `skull` tinyint(1) NOT NULL DEFAULT '0',
  `skulltime` bigint NOT NULL DEFAULT '0',
  `lastlogout` bigint UNSIGNED NOT NULL DEFAULT '0',
  `blessings` tinyint NOT NULL DEFAULT '0',
  `blessings1` tinyint NOT NULL DEFAULT '0',
  `blessings2` tinyint NOT NULL DEFAULT '0',
  `blessings3` tinyint NOT NULL DEFAULT '0',
  `blessings4` tinyint NOT NULL DEFAULT '0',
  `blessings5` tinyint NOT NULL DEFAULT '0',
  `blessings6` tinyint NOT NULL DEFAULT '0',
  `blessings7` tinyint NOT NULL DEFAULT '0',
  `blessings8` tinyint NOT NULL DEFAULT '0',
  `onlinetime` int NOT NULL DEFAULT '0',
  `deletion` bigint NOT NULL DEFAULT '0',
  `balance` bigint UNSIGNED NOT NULL DEFAULT '0',
  `offlinetraining_time` smallint UNSIGNED NOT NULL DEFAULT '43200',
  `offlinetraining_skill` tinyint NOT NULL DEFAULT '-1',
  `stamina` smallint UNSIGNED NOT NULL DEFAULT '2520',
  `skill_fist` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_fist_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_club` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_club_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_sword` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_sword_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_axe` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_axe_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_dist` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_dist_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_shielding` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_shielding_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_fishing` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_fishing_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_divinity` int UNSIGNED NOT NULL DEFAULT '0',
  `skill_divinity_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_critical_hit_chance` int UNSIGNED NOT NULL DEFAULT '0',
  `skill_critical_hit_chance_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_critical_hit_damage` int UNSIGNED NOT NULL DEFAULT '0',
  `skill_critical_hit_damage_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_life_leech_chance` int UNSIGNED NOT NULL DEFAULT '0',
  `skill_life_leech_chance_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_life_leech_amount` int UNSIGNED NOT NULL DEFAULT '0',
  `skill_life_leech_amount_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_mana_leech_chance` int UNSIGNED NOT NULL DEFAULT '0',
  `skill_mana_leech_chance_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_mana_leech_amount` int UNSIGNED NOT NULL DEFAULT '0',
  `skill_mana_leech_amount_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_criticalhit_chance` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_criticalhit_damage` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_lifeleech_chance` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_lifeleech_amount` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_manaleech_chance` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_manaleech_amount` bigint UNSIGNED NOT NULL DEFAULT '0',
  `manashield` smallint UNSIGNED NOT NULL DEFAULT '0',
  `max_manashield` smallint UNSIGNED NOT NULL DEFAULT '0',
  `xpboost_stamina` smallint DEFAULT NULL,
  `xpboost_value` tinyint DEFAULT NULL,
  `marriage_status` bigint UNSIGNED NOT NULL DEFAULT '0',
  `marriage_spouse` int NOT NULL DEFAULT '-1',
  `bonus_rerolls` bigint NOT NULL DEFAULT '0',
  `prey_wildcard` bigint NOT NULL DEFAULT '0',
  `task_points` bigint NOT NULL DEFAULT '0',
  `quickloot_fallback` tinyint(1) DEFAULT '0',
  `lookmountbody` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `lookmountfeet` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `lookmounthead` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `lookmountlegs` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `lookfamiliarstype` int UNSIGNED NOT NULL DEFAULT '0',
  `isreward` tinyint(1) NOT NULL DEFAULT '1',
  `istutorial` tinyint(1) NOT NULL DEFAULT '0',
  `forge_dusts` bigint NOT NULL DEFAULT '0',
  `forge_dust_level` bigint NOT NULL DEFAULT '100',
  `randomize_mount` tinyint(1) NOT NULL DEFAULT '0',
  `boss_points` int NOT NULL DEFAULT '0',
  `created` int NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  `comment` text,
  `main` int NOT NULL DEFAULT '0',
  `world` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `players_unique` (`name`),
  KEY `account_id` (`account_id`),
  KEY `vocation` (`vocation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Triggers `players`
--
DROP TRIGGER IF EXISTS `ondelete_players`;
DELIMITER $$
CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players` FOR EACH ROW BEGIN
        UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id`;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `players_online`
--

DROP TABLE IF EXISTS `players_online`;
CREATE TABLE IF NOT EXISTS `players_online` (
  `player_id` int NOT NULL,
  PRIMARY KEY (`player_id`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_badges`
--

DROP TABLE IF EXISTS `player_badges`;
CREATE TABLE IF NOT EXISTS `player_badges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `badge_id` int NOT NULL,
  `account_id` int NOT NULL,
  `view` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_bosstiary`
--

DROP TABLE IF EXISTS `player_bosstiary`;
CREATE TABLE IF NOT EXISTS `player_bosstiary` (
  `player_id` int NOT NULL,
  `bossIdSlotOne` int NOT NULL DEFAULT '0',
  `bossIdSlotTwo` int NOT NULL DEFAULT '0',
  `removeTimes` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_charms`
--

DROP TABLE IF EXISTS `player_charms`;
CREATE TABLE IF NOT EXISTS `player_charms` (
  `player_guid` int NOT NULL,
  `charm_points` varchar(250) DEFAULT NULL,
  `charm_expansion` tinyint(1) DEFAULT NULL,
  `rune_wound` int DEFAULT NULL,
  `rune_enflame` int DEFAULT NULL,
  `rune_poison` int DEFAULT NULL,
  `rune_freeze` int DEFAULT NULL,
  `rune_zap` int DEFAULT NULL,
  `rune_curse` int DEFAULT NULL,
  `rune_cripple` int DEFAULT NULL,
  `rune_parry` int DEFAULT NULL,
  `rune_dodge` int DEFAULT NULL,
  `rune_adrenaline` int DEFAULT NULL,
  `rune_numb` int DEFAULT NULL,
  `rune_cleanse` int DEFAULT NULL,
  `rune_bless` int DEFAULT NULL,
  `rune_scavenge` int DEFAULT NULL,
  `rune_gut` int DEFAULT NULL,
  `rune_low_blow` int DEFAULT NULL,
  `rune_divine` int DEFAULT NULL,
  `rune_vamp` int DEFAULT NULL,
  `rune_void` int DEFAULT NULL,
  `UsedRunesBit` varchar(250) DEFAULT NULL,
  `UnlockedRunesBit` varchar(250) DEFAULT NULL,
  `tracker list` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_deaths`
--

DROP TABLE IF EXISTS `player_deaths`;
CREATE TABLE IF NOT EXISTS `player_deaths` (
  `player_id` int NOT NULL,
  `time` bigint UNSIGNED NOT NULL DEFAULT '0',
  `level` int NOT NULL DEFAULT '1',
  `killed_by` varchar(255) NOT NULL,
  `is_player` tinyint(1) NOT NULL DEFAULT '1',
  `mostdamage_by` varchar(100) NOT NULL,
  `mostdamage_is_player` tinyint(1) NOT NULL DEFAULT '0',
  `unjustified` tinyint(1) NOT NULL DEFAULT '0',
  `mostdamage_unjustified` tinyint(1) NOT NULL DEFAULT '0',
  KEY `player_id` (`player_id`),
  KEY `killed_by` (`killed_by`),
  KEY `mostdamage_by` (`mostdamage_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_depotitems`
--

DROP TABLE IF EXISTS `player_depotitems`;
CREATE TABLE IF NOT EXISTS `player_depotitems` (
  `player_id` int NOT NULL,
  `sid` int NOT NULL COMMENT 'any given range eg 0-100 will be reserved for depot lockers and all > 100 will be then normal items inside depots',
  `pid` int NOT NULL DEFAULT '0',
  `itemtype` int NOT NULL DEFAULT '0',
  `count` int NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  UNIQUE KEY `player_depotitems_unique` (`player_id`,`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_display`
--

DROP TABLE IF EXISTS `player_display`;
CREATE TABLE IF NOT EXISTS `player_display` (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL DEFAULT '0',
  `account` int NOT NULL DEFAULT '0',
  `outfit` int NOT NULL DEFAULT '0',
  `inventory` int NOT NULL DEFAULT '0',
  `health_mana` int NOT NULL DEFAULT '0',
  `skills` int NOT NULL DEFAULT '0',
  `bonus` int NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_hirelings`
--

DROP TABLE IF EXISTS `player_hirelings`;
CREATE TABLE IF NOT EXISTS `player_hirelings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `active` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `sex` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `posx` int NOT NULL DEFAULT '0',
  `posy` int NOT NULL DEFAULT '0',
  `posz` int NOT NULL DEFAULT '0',
  `lookbody` int NOT NULL DEFAULT '0',
  `lookfeet` int NOT NULL DEFAULT '0',
  `lookhead` int NOT NULL DEFAULT '0',
  `looklegs` int NOT NULL DEFAULT '0',
  `looktype` int NOT NULL DEFAULT '136',
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_inboxitems`
--

DROP TABLE IF EXISTS `player_inboxitems`;
CREATE TABLE IF NOT EXISTS `player_inboxitems` (
  `player_id` int NOT NULL,
  `sid` int NOT NULL,
  `pid` int NOT NULL DEFAULT '0',
  `itemtype` int NOT NULL DEFAULT '0',
  `count` int NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  UNIQUE KEY `player_inboxitems_unique` (`player_id`,`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_items`
--

DROP TABLE IF EXISTS `player_items`;
CREATE TABLE IF NOT EXISTS `player_items` (
  `player_id` int NOT NULL DEFAULT '0',
  `pid` int NOT NULL DEFAULT '0',
  `sid` int NOT NULL DEFAULT '0',
  `itemtype` int NOT NULL DEFAULT '0',
  `count` int NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  KEY `player_id` (`player_id`),
  KEY `sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_kills`
--

DROP TABLE IF EXISTS `player_kills`;
CREATE TABLE IF NOT EXISTS `player_kills` (
  `player_id` int NOT NULL,
  `time` bigint UNSIGNED NOT NULL DEFAULT '0',
  `target` int NOT NULL,
  `unavenged` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_misc`
--

DROP TABLE IF EXISTS `player_misc`;
CREATE TABLE IF NOT EXISTS `player_misc` (
  `player_id` int NOT NULL,
  `info` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_namelocks`
--

DROP TABLE IF EXISTS `player_namelocks`;
CREATE TABLE IF NOT EXISTS `player_namelocks` (
  `player_id` int NOT NULL,
  `reason` varchar(255) NOT NULL,
  `namelocked_at` bigint NOT NULL,
  `namelocked_by` int NOT NULL,
  UNIQUE KEY `player_namelocks_unique` (`player_id`),
  KEY `namelocked_by` (`namelocked_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_prey`
--

DROP TABLE IF EXISTS `player_prey`;
CREATE TABLE IF NOT EXISTS `player_prey` (
  `player_id` int NOT NULL,
  `slot` tinyint(1) NOT NULL,
  `state` tinyint(1) NOT NULL,
  `raceid` varchar(250) NOT NULL,
  `option` tinyint(1) NOT NULL,
  `bonus_type` tinyint(1) NOT NULL,
  `bonus_rarity` tinyint(1) NOT NULL,
  `bonus_percentage` varchar(250) NOT NULL,
  `bonus_time` varchar(250) NOT NULL,
  `free_reroll` bigint NOT NULL,
  `monster_list` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_rewards`
--

DROP TABLE IF EXISTS `player_rewards`;
CREATE TABLE IF NOT EXISTS `player_rewards` (
  `player_id` int NOT NULL,
  `sid` int NOT NULL,
  `pid` int NOT NULL DEFAULT '0',
  `itemtype` int NOT NULL DEFAULT '0',
  `count` int NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  UNIQUE KEY `player_rewards_unique` (`player_id`,`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_spells`
--

DROP TABLE IF EXISTS `player_spells`;
CREATE TABLE IF NOT EXISTS `player_spells` (
  `player_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_stash`
--

DROP TABLE IF EXISTS `player_stash`;
CREATE TABLE IF NOT EXISTS `player_stash` (
  `player_id` int NOT NULL,
  `item_id` int NOT NULL,
  `item_count` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_storage`
--

DROP TABLE IF EXISTS `player_storage`;
CREATE TABLE IF NOT EXISTS `player_storage` (
  `player_id` int NOT NULL DEFAULT '0',
  `key` int UNSIGNED NOT NULL DEFAULT '0',
  `value` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`player_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `player_taskhunt`
--

DROP TABLE IF EXISTS `player_taskhunt`;
CREATE TABLE IF NOT EXISTS `player_taskhunt` (
  `player_id` int NOT NULL,
  `slot` tinyint(1) NOT NULL,
  `state` tinyint(1) NOT NULL,
  `raceid` varchar(250) NOT NULL,
  `upgrade` tinyint(1) NOT NULL,
  `rarity` tinyint(1) NOT NULL,
  `kills` varchar(250) NOT NULL,
  `disabled_time` bigint NOT NULL,
  `free_reroll` bigint NOT NULL,
  `monster_list` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `server_config`
--

DROP TABLE IF EXISTS `server_config`;
CREATE TABLE IF NOT EXISTS `server_config` (
  `config` varchar(50) NOT NULL,
  `value` varchar(256) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`config`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `store_history`
--

DROP TABLE IF EXISTS `store_history`;
CREATE TABLE IF NOT EXISTS `store_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int UNSIGNED NOT NULL,
  `mode` smallint NOT NULL DEFAULT '0',
  `description` varchar(3500) NOT NULL,
  `coin_type` tinyint(1) NOT NULL DEFAULT '0',
  `coin_amount` int NOT NULL,
  `time` bigint UNSIGNED NOT NULL,
  `timestamp` int NOT NULL DEFAULT '0',
  `coins` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `tile_store`
--

DROP TABLE IF EXISTS `tile_store`;
CREATE TABLE IF NOT EXISTS `tile_store` (
  `house_id` int NOT NULL,
  `data` longblob NOT NULL,
  KEY `house_id` (`house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `towns`
--

DROP TABLE IF EXISTS `towns`;
CREATE TABLE IF NOT EXISTS `towns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `posx` int NOT NULL DEFAULT '0',
  `posy` int NOT NULL DEFAULT '0',
  `posz` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account_bans`
--
ALTER TABLE `account_bans`
  ADD CONSTRAINT `account_bans_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_bans_player_fk` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD CONSTRAINT `account_bans_history_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_bans_history_player_fk` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD CONSTRAINT `account_viplist_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_viplist_player_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `coins_transactions`
--
ALTER TABLE `coins_transactions`
  ADD CONSTRAINT `coins_transactions_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `daily_reward_history`
--
ALTER TABLE `daily_reward_history`
  ADD CONSTRAINT `daily_reward_history_player_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `forge_history`
--
ALTER TABLE `forge_history`
  ADD CONSTRAINT `forge_history_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guilds`
--
ALTER TABLE `guilds`
  ADD CONSTRAINT `guilds_ownerid_fk` FOREIGN KEY (`ownerid`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD CONSTRAINT `guildwar_kills_warid_fk` FOREIGN KEY (`warid`) REFERENCES `guild_wars` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD CONSTRAINT `guild_invites_guild_fk` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guild_invites_player_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guild_membership`
--
ALTER TABLE `guild_membership`
  ADD CONSTRAINT `guild_membership_guild_fk` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_membership_player_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_membership_rank_fk` FOREIGN KEY (`rank_id`) REFERENCES `guild_ranks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD CONSTRAINT `guild_ranks_fk` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `house_lists`
--
ALTER TABLE `house_lists`
  ADD CONSTRAINT `houses_list_house_fk` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD CONSTRAINT `ip_bans_players_fk` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `market_history`
--
ALTER TABLE `market_history`
  ADD CONSTRAINT `market_history_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `market_offers`
--
ALTER TABLE `market_offers`
  ADD CONSTRAINT `market_offers_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD CONSTRAINT `player_deaths_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD CONSTRAINT `player_depotitems_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_hirelings`
--
ALTER TABLE `player_hirelings`
  ADD CONSTRAINT `player_hirelings_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD CONSTRAINT `player_inboxitems_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_items`
--
ALTER TABLE `player_items`
  ADD CONSTRAINT `player_items_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD CONSTRAINT `player_namelocks_players2_fk` FOREIGN KEY (`namelocked_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `player_namelocks_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_rewards`
--
ALTER TABLE `player_rewards`
  ADD CONSTRAINT `player_rewards_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_spells`
--
ALTER TABLE `player_spells`
  ADD CONSTRAINT `player_spells_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_storage`
--
ALTER TABLE `player_storage`
  ADD CONSTRAINT `player_storage_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `store_history`
--
ALTER TABLE `store_history`
  ADD CONSTRAINT `store_history_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tile_store`
--
ALTER TABLE `tile_store`
  ADD CONSTRAINT `tile_store_account_fk` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
