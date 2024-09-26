-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 05, 2024 at 12:42 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nebula`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `password` text NOT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `created` int(11) NOT NULL DEFAULT 0,
  `rlname` varchar(255) NOT NULL DEFAULT '',
  `location` varchar(255) NOT NULL DEFAULT '',
  `country` varchar(3) NOT NULL DEFAULT '',
  `web_lastlogin` int(11) NOT NULL DEFAULT 0,
  `web_flags` int(11) NOT NULL DEFAULT 0,
  `email_hash` varchar(32) NOT NULL DEFAULT '',
  `email_new` varchar(255) NOT NULL DEFAULT '',
  `email_new_time` int(11) NOT NULL DEFAULT 0,
  `email_code` varchar(255) NOT NULL DEFAULT '',
  `email_next` int(11) NOT NULL DEFAULT 0,
  `email_verified` tinyint(1) NOT NULL DEFAULT 0,
  `phone` varchar(15) DEFAULT NULL,
  `key` varchar(64) NOT NULL DEFAULT '',
  `premdays` int(11) NOT NULL DEFAULT 0,
  `premdays_purchased` int(11) NOT NULL DEFAULT 0,
  `lastday` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `coins` int(12) UNSIGNED NOT NULL DEFAULT 0,
  `coins_transferable` int(12) UNSIGNED NOT NULL DEFAULT 0,
  `tournament_coins` int(12) UNSIGNED NOT NULL DEFAULT 0,
  `creation` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `recruiter` int(6) DEFAULT 0,
  `vote` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `email`, `created`, `rlname`, `location`, `country`, `web_lastlogin`, `web_flags`, `email_hash`, `email_new`, `email_new_time`, `email_code`, `email_next`, `email_verified`, `phone`, `key`, `premdays`, `premdays_purchased`, `lastday`, `type`, `coins`, `coins_transferable`, `tournament_coins`, `creation`, `recruiter`, `vote`) VALUES
(1, 'god', '21298df8a3277357ee55b01df9530b535cf08ec1', '@accountsamples', 0, '', '', '', 0, 0, '', '', 0, '', 0, 0, NULL, '', 0, 0, 0, 5, 0, 0, 0, 1715919769, 0, 0),
(2, 'Admin', 'ea0f77c73fd26c4beec8fb97ff46fadb5070b3c6', 'mgvotservers@gmail.com', 1715919698, '', '', 'us', 1722718931, 3, '', '', 0, '', 1715921597, 0, NULL, '', 280, 360, 1747024947, 6, 0, 973554, 0, 1715919769, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `account_bans`
--

CREATE TABLE `account_bans` (
  `account_id` int(11) UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `account_ban_history`
--

CREATE TABLE `account_ban_history` (
  `id` int(11) NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expired_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `account_sessions`
--

CREATE TABLE `account_sessions` (
  `id` varchar(191) NOT NULL,
  `account_id` int(10) UNSIGNED NOT NULL,
  `expires` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `account_viplist`
--

CREATE TABLE `account_viplist` (
  `account_id` int(11) UNSIGNED NOT NULL COMMENT 'id of account whose viplist entry it is',
  `player_id` int(11) NOT NULL COMMENT 'id of target player of viplist entry',
  `description` varchar(128) NOT NULL DEFAULT '',
  `icon` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `notify` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `boosted_boss`
--

CREATE TABLE `boosted_boss` (
  `looktypeEx` int(11) NOT NULL DEFAULT 0,
  `looktype` int(11) NOT NULL DEFAULT 136,
  `lookfeet` int(11) NOT NULL DEFAULT 0,
  `looklegs` int(11) NOT NULL DEFAULT 0,
  `lookhead` int(11) NOT NULL DEFAULT 0,
  `lookbody` int(11) NOT NULL DEFAULT 0,
  `lookaddons` int(11) NOT NULL DEFAULT 0,
  `lookmount` int(11) DEFAULT 0,
  `date` varchar(250) NOT NULL DEFAULT '',
  `boostname` text DEFAULT NULL,
  `raceid` varchar(250) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `boosted_boss`
--

INSERT INTO `boosted_boss` (`looktypeEx`, `looktype`, `lookfeet`, `looklegs`, `lookhead`, `lookbody`, `lookaddons`, `lookmount`, `date`, `boostname`, `raceid`) VALUES
(35105, 0, 0, 0, 0, 0, 0, 0, '4', 'Tentugly\'s Head', '2238');

-- --------------------------------------------------------

--
-- Table structure for table `boosted_creature`
--

CREATE TABLE `boosted_creature` (
  `looktype` int(11) NOT NULL DEFAULT 136,
  `lookfeet` int(11) NOT NULL DEFAULT 0,
  `looklegs` int(11) NOT NULL DEFAULT 0,
  `lookhead` int(11) NOT NULL DEFAULT 0,
  `lookbody` int(11) NOT NULL DEFAULT 0,
  `lookaddons` int(11) NOT NULL DEFAULT 0,
  `lookmount` int(11) DEFAULT 0,
  `date` varchar(250) NOT NULL DEFAULT '',
  `boostname` text DEFAULT NULL,
  `raceid` varchar(250) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `boosted_creature`
--

INSERT INTO `boosted_creature` (`looktype`, `lookfeet`, `looklegs`, `lookhead`, `lookbody`, `lookaddons`, `lookmount`, `date`, `boostname`, `raceid`) VALUES
(357, 0, 0, 0, 0, 0, 0, '4', 'Draken Abomination', '673');

-- --------------------------------------------------------

--
-- Table structure for table `coins_transactions`
--

CREATE TABLE `coins_transactions` (
  `id` int(11) UNSIGNED NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  `type` tinyint(1) UNSIGNED NOT NULL,
  `coin_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `amount` int(12) UNSIGNED NOT NULL,
  `description` varchar(3500) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `coins_transactions`
--

INSERT INTO `coins_transactions` (`id`, `account_id`, `type`, `coin_type`, `amount`, `description`, `timestamp`) VALUES
(1, 2, 1, 3, 1000000, 'ADD Coins', '2024-05-17 04:42:22'),
(2, 2, 2, 3, 3000, 'REMOVE Coins', '2024-05-17 04:42:27'),
(3, 2, 2, 3, 800, 'REMOVE Coins', '2024-05-17 04:44:50'),
(4, 2, 2, 3, 150, 'REMOVE Coins', '2024-05-17 04:46:20'),
(5, 2, 2, 3, 150, 'REMOVE Coins', '2024-05-17 04:46:25'),
(6, 2, 2, 3, 150, 'REMOVE Coins', '2024-05-17 04:46:28'),
(7, 2, 2, 3, 30, 'REMOVE Coins', '2024-05-17 04:46:33'),
(8, 2, 2, 3, 800, 'REMOVE Coins', '2024-05-18 05:50:33'),
(9, 2, 2, 3, 800, 'REMOVE Coins', '2024-05-18 06:29:03'),
(10, 2, 2, 3, 800, 'REMOVE Coins', '2024-05-18 06:29:13'),
(11, 2, 2, 3, 800, 'REMOVE Coins', '2024-05-18 16:14:48'),
(12, 2, 2, 3, 800, 'REMOVE Coins', '2024-05-18 16:14:52'),
(13, 2, 2, 3, 5000, 'REMOVE Coins', '2024-05-18 19:06:02'),
(20, 2, 2, 3, 800, 'REMOVE Coins', '2024-05-18 20:22:05'),
(21, 2, 1, 3, 100, 'ADD Coins', '2024-05-18 21:11:28'),
(22, 2, 1, 3, 51, 'ADD Coins', '2024-05-18 21:11:30'),
(23, 2, 1, 3, 100, 'ADD Coins', '2024-05-18 21:11:39'),
(24, 2, 1, 3, 100, 'ADD Coins', '2024-05-18 21:11:39'),
(25, 2, 1, 3, 100, 'ADD Coins', '2024-05-18 21:11:40'),
(29, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-19 02:50:29'),
(30, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-19 02:50:31'),
(31, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-19 02:50:32'),
(32, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-19 02:50:34'),
(33, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-19 02:50:35'),
(34, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-19 02:50:36'),
(35, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-19 02:50:38'),
(36, 2, 2, 3, 500, 'REMOVE Coins', '2024-05-19 02:54:49'),
(37, 2, 2, 3, 500, 'REMOVE Coins', '2024-05-19 02:56:08'),
(38, 2, 2, 3, 500, 'REMOVE Coins', '2024-05-19 02:57:36'),
(39, 2, 2, 3, 500, 'REMOVE Coins', '2024-05-19 02:59:16'),
(40, 2, 2, 3, 250, 'REMOVE Coins', '2024-05-19 03:00:07'),
(41, 2, 2, 3, 250, 'REMOVE Coins', '2024-05-19 03:00:17'),
(42, 2, 2, 3, 250, 'REMOVE Coins', '2024-05-19 03:03:29'),
(43, 2, 2, 3, 100, 'REMOVE Coins', '2024-05-19 03:04:09'),
(44, 2, 2, 3, 100, 'REMOVE Coins', '2024-05-19 03:04:20'),
(45, 2, 2, 3, 100, 'REMOVE Coins', '2024-05-19 03:04:30'),
(48, 2, 2, 3, 500, 'REMOVE Coins', '2024-05-21 01:30:16'),
(51, 2, 2, 3, 300, 'REMOVE Coins', '2024-05-24 05:45:22'),
(52, 2, 2, 3, 300, 'REMOVE Coins', '2024-05-24 05:47:59'),
(53, 2, 2, 3, 300, 'REMOVE Coins', '2024-05-24 05:49:39'),
(54, 2, 2, 3, 600, 'REMOVE Coins', '2024-05-25 04:18:42'),
(55, 2, 2, 3, 600, 'REMOVE Coins', '2024-05-25 04:18:44'),
(56, 2, 2, 3, 9, 'REMOVE Coins', '2024-05-25 20:54:06'),
(57, 2, 2, 3, 9, 'REMOVE Coins', '2024-05-25 20:54:07'),
(60, 2, 2, 3, 30, 'REMOVE Coins', '2024-05-25 21:32:57'),
(61, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-25 21:47:41'),
(62, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-25 21:47:46'),
(63, 2, 2, 3, 900, 'REMOVE Coins', '2024-05-25 21:48:37'),
(70, 2, 2, 3, 600, 'REMOVE Coins', '2024-05-28 02:32:02'),
(71, 2, 2, 3, 500, 'REMOVE Coins', '2024-05-28 02:33:00'),
(72, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-28 17:17:00'),
(73, 2, 2, 3, 50, 'REMOVE Coins', '2024-05-28 17:17:02'),
(74, 2, 2, 3, 900, 'REMOVE Coins', '2024-05-28 17:17:07'),
(75, 2, 2, 3, 750, 'REMOVE Coins', '2024-05-28 17:24:41'),
(76, 2, 2, 3, 60, 'REMOVE Coins', '2024-05-28 17:39:58'),
(77, 2, 2, 3, 600, 'REMOVE Coins', '2024-05-28 17:40:01'),
(78, 2, 2, 3, 800, 'REMOVE Coins', '2024-05-28 17:40:07'),
(79, 2, 2, 3, 500, 'REMOVE Coins', '2024-05-28 17:40:13'),
(80, 2, 2, 3, 60, 'REMOVE Coins', '2024-05-28 17:41:10'),
(81, 2, 2, 3, 60, 'REMOVE Coins', '2024-05-28 17:41:12'),
(82, 2, 2, 3, 60, 'REMOVE Coins', '2024-05-28 17:41:13'),
(83, 2, 2, 3, 60, 'REMOVE Coins', '2024-05-28 17:41:15'),
(84, 2, 2, 3, 720, 'REMOVE Coins', '2024-05-28 18:48:00'),
(85, 2, 1, 3, 1, 'ADD Coins', '2024-08-03 16:09:44');

-- --------------------------------------------------------

--
-- Table structure for table `daily_reward_history`
--

CREATE TABLE `daily_reward_history` (
  `id` int(11) NOT NULL,
  `daystreak` smallint(2) NOT NULL DEFAULT 0,
  `player_id` int(11) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `forge_history`
--

CREATE TABLE `forge_history` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `action_type` int(11) NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `is_success` tinyint(4) NOT NULL DEFAULT 0,
  `bonus` tinyint(4) NOT NULL DEFAULT 0,
  `done_at` bigint(20) NOT NULL,
  `done_at_date` datetime DEFAULT current_timestamp(),
  `cost` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `gained` bigint(20) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `global_storage`
--

CREATE TABLE `global_storage` (
  `key` varchar(32) NOT NULL,
  `value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `global_storage`
--

INSERT INTO `global_storage` (`key`, `value`) VALUES
('14110', '1722776701'),
('40000', '4');

-- --------------------------------------------------------

--
-- Table structure for table `guilds`
--

CREATE TABLE `guilds` (
  `id` int(11) NOT NULL,
  `level` int(11) NOT NULL DEFAULT 1,
  `name` varchar(255) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `creationdata` int(11) NOT NULL,
  `motd` varchar(255) NOT NULL DEFAULT '',
  `residence` int(11) NOT NULL DEFAULT 0,
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `points` int(11) NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `logo_name` varchar(255) NOT NULL DEFAULT 'default.gif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Triggers `guilds`
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
-- Table structure for table `guildwar_kills`
--

CREATE TABLE `guildwar_kills` (
  `id` int(11) NOT NULL,
  `killer` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  `killerguild` int(11) NOT NULL DEFAULT 0,
  `targetguild` int(11) NOT NULL DEFAULT 0,
  `warid` int(11) NOT NULL DEFAULT 0,
  `time` bigint(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guild_invites`
--

CREATE TABLE `guild_invites` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `guild_id` int(11) NOT NULL DEFAULT 0,
  `date` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guild_membership`
--

CREATE TABLE `guild_membership` (
  `player_id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL,
  `rank_id` int(11) NOT NULL,
  `nick` varchar(15) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guild_ranks`
--

CREATE TABLE `guild_ranks` (
  `id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL COMMENT 'guild',
  `name` varchar(255) NOT NULL COMMENT 'rank name',
  `level` int(11) NOT NULL COMMENT 'rank level - leader, vice, member, maybe something else'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guild_wars`
--

CREATE TABLE `guild_wars` (
  `id` int(11) NOT NULL,
  `guild1` int(11) NOT NULL DEFAULT 0,
  `guild2` int(11) NOT NULL DEFAULT 0,
  `name1` varchar(255) NOT NULL,
  `name2` varchar(255) NOT NULL,
  `status` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `started` bigint(15) NOT NULL DEFAULT 0,
  `ended` bigint(15) NOT NULL DEFAULT 0,
  `frags_limit` smallint(4) UNSIGNED NOT NULL DEFAULT 0,
  `payment` bigint(13) UNSIGNED NOT NULL DEFAULT 0,
  `duration_days` tinyint(3) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `new_owner` int(11) NOT NULL DEFAULT -1,
  `paid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `warnings` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `rent` int(11) NOT NULL DEFAULT 0,
  `town_id` int(11) NOT NULL DEFAULT 0,
  `bid` int(11) NOT NULL DEFAULT 0,
  `bid_end` int(11) NOT NULL DEFAULT 0,
  `last_bid` int(11) NOT NULL DEFAULT 0,
  `highest_bidder` int(11) NOT NULL DEFAULT 0,
  `size` int(11) NOT NULL DEFAULT 0,
  `guildid` int(11) DEFAULT NULL,
  `beds` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `houses`
--

INSERT INTO `houses` (`id`, `owner`, `new_owner`, `paid`, `warnings`, `name`, `rent`, `town_id`, `bid`, `bid_end`, `last_bid`, `highest_bidder`, `size`, `guildid`, `beds`) VALUES
(2628, 0, -1, 1716524607, 0, 'Castle of the Winds', 250000, 5, 0, 0, 0, 0, 514, NULL, 0),
(2629, 0, -1, 1716524607, 0, 'Ab\'Dendriel Clanhall', 125000, 5, 0, 0, 0, 0, 326, NULL, 0),
(2630, 0, -1, 1716524607, 0, 'Underwood 9', 25000, 5, 0, 0, 0, 0, 14, NULL, 0),
(2631, 0, -1, 1716524607, 0, 'Treetop 13', 50000, 5, 0, 0, 0, 0, 28, NULL, 0),
(2632, 0, -1, 1716524607, 0, 'Underwood 8', 25000, 5, 0, 0, 0, 0, 23, NULL, 0),
(2633, 0, -1, 1716524607, 0, 'Treetop 11', 25000, 5, 0, 0, 0, 0, 24, NULL, 0),
(2635, 0, -1, 1716524607, 0, 'Great Willow 2a', 25000, 5, 0, 0, 0, 0, 20, NULL, 0),
(2637, 0, -1, 1716524607, 0, 'Great Willow 2b', 25000, 5, 0, 0, 0, 0, 25, NULL, 0),
(2638, 0, -1, 1716524607, 0, 'Great Willow Western Wing', 50000, 5, 0, 0, 0, 0, 61, NULL, 0),
(2640, 0, -1, 1716524607, 0, 'Great Willow 1', 50000, 5, 0, 0, 0, 0, 35, NULL, 0),
(2642, 0, -1, 1716524607, 0, 'Great Willow 3a', 25000, 5, 0, 0, 0, 0, 19, NULL, 0),
(2644, 0, -1, 1716524607, 0, 'Great Willow 3b', 40000, 5, 0, 0, 0, 0, 40, NULL, 0),
(2645, 0, -1, 1716524607, 0, 'Great Willow 4a', 12500, 5, 0, 0, 0, 0, 19, NULL, 0),
(2648, 0, -1, 1716524607, 0, 'Great Willow 4b', 12500, 5, 0, 0, 0, 0, 19, NULL, 0),
(2649, 0, -1, 1716524607, 0, 'Underwood 6', 50000, 5, 0, 0, 0, 0, 40, NULL, 0),
(2650, 0, -1, 1716524607, 0, 'Underwood 3', 50000, 5, 0, 0, 0, 0, 39, NULL, 0),
(2651, 0, -1, 1716524607, 0, 'Underwood 5', 40000, 5, 0, 0, 0, 0, 33, NULL, 0),
(2652, 0, -1, 1716524607, 0, 'Underwood 2', 50000, 5, 0, 0, 0, 0, 37, NULL, 0),
(2653, 0, -1, 1716524607, 0, 'Underwood 1', 50000, 5, 0, 0, 0, 0, 39, NULL, 0),
(2654, 0, -1, 1716524607, 0, 'Prima Arbor', 200000, 5, 0, 0, 0, 0, 200, NULL, 0),
(2655, 0, -1, 1716524607, 0, 'Underwood 7', 100000, 5, 0, 0, 0, 0, 34, NULL, 0),
(2656, 0, -1, 1716524607, 0, 'Underwood 10', 12500, 5, 0, 0, 0, 0, 19, NULL, 0),
(2657, 0, -1, 1716524607, 0, 'Underwood 4', 50000, 5, 0, 0, 0, 0, 50, NULL, 0),
(2658, 0, -1, 1716524607, 0, 'Treetop 9', 25000, 5, 0, 0, 0, 0, 24, NULL, 0),
(2659, 0, -1, 1716524607, 0, 'Treetop 10', 40000, 5, 0, 0, 0, 0, 28, NULL, 0),
(2660, 0, -1, 1716524607, 0, 'Treetop 8', 12500, 5, 0, 0, 0, 0, 22, NULL, 0),
(2661, 0, -1, 1716524607, 0, 'Treetop 7', 25000, 5, 0, 0, 0, 0, 20, NULL, 0),
(2662, 0, -1, 1716524607, 0, 'Treetop 6', 12500, 5, 0, 0, 0, 0, 17, NULL, 0),
(2663, 0, -1, 1716524607, 0, 'Treetop 5 (Shop)', 40000, 5, 0, 0, 0, 0, 36, NULL, 0),
(2664, 0, -1, 1716524607, 0, 'Treetop 12 (Shop)', 50000, 5, 0, 0, 0, 0, 39, NULL, 0),
(2665, 0, -1, 1716524607, 0, 'Treetop 4 (Shop)', 40000, 5, 0, 0, 0, 0, 31, NULL, 0),
(2666, 0, -1, 1716524607, 0, 'Treetop 3 (Shop)', 40000, 5, 0, 0, 0, 0, 36, NULL, 0),
(2687, 0, -1, 1716524607, 0, 'Northern Street 1a', 50000, 6, 0, 0, 0, 0, 26, NULL, 0),
(2688, 0, -1, 1716524607, 0, 'Park Lane 3a', 50000, 6, 0, 0, 0, 0, 36, NULL, 0),
(2689, 0, -1, 1716524607, 0, 'Park Lane 1a', 75000, 6, 0, 0, 0, 0, 36, NULL, 0),
(2690, 0, -1, 1716524607, 0, 'Park Lane 4', 75000, 6, 0, 0, 0, 0, 27, NULL, 0),
(2691, 0, -1, 1716524607, 0, 'Park Lane 2', 75000, 6, 0, 0, 0, 0, 28, NULL, 0),
(2692, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 04', 25000, 6, 0, 0, 0, 0, 15, NULL, 0),
(2693, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 03', 12500, 6, 0, 0, 0, 0, 13, NULL, 0),
(2694, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 05', 25000, 6, 0, 0, 0, 0, 13, NULL, 0),
(2695, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 06', 12500, 6, 0, 0, 0, 0, 13, NULL, 0),
(2696, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 02', 12500, 6, 0, 0, 0, 0, 15, NULL, 0),
(2697, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 01', 12500, 6, 0, 0, 0, 0, 13, NULL, 0),
(2698, 0, -1, 1716524607, 0, 'Northern Street 5', 100000, 6, 0, 0, 0, 0, 52, NULL, 0),
(2699, 0, -1, 1716524607, 0, 'Northern Street 7', 75000, 6, 0, 0, 0, 0, 44, NULL, 0),
(2700, 0, -1, 1716524607, 0, 'Theater Avenue 6e', 40000, 6, 0, 0, 0, 0, 25, NULL, 0),
(2701, 0, -1, 1716524607, 0, 'Theater Avenue 6c', 12500, 6, 0, 0, 0, 0, 9, NULL, 0),
(2702, 0, -1, 1716524607, 0, 'Theater Avenue 6a', 40000, 6, 0, 0, 0, 0, 24, NULL, 0),
(2703, 0, -1, 1716524607, 0, 'Theater Avenue, Tower', 150000, 6, 0, 0, 0, 0, 80, NULL, 0),
(2705, 0, -1, 1716524607, 0, 'East Lane 2', 150000, 6, 0, 0, 0, 0, 93, NULL, 0),
(2706, 0, -1, 1716524607, 0, 'Harbour Lane 2a (Shop)', 40000, 6, 0, 0, 0, 0, 18, NULL, 0),
(2707, 0, -1, 1716524607, 0, 'Harbour Lane 2b (Shop)', 40000, 6, 0, 0, 0, 0, 21, NULL, 0),
(2708, 0, -1, 1716524607, 0, 'Harbour Lane 3', 200000, 6, 0, 0, 0, 0, 92, NULL, 0),
(2709, 0, -1, 1716524607, 0, 'Magician\'s Alley 8', 75000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2710, 0, -1, 1716524607, 0, 'Lonely Sea Side Hostel', 200000, 6, 0, 0, 0, 0, 331, NULL, 0),
(2711, 0, -1, 1716524607, 0, 'Suntower', 250000, 6, 0, 0, 0, 0, 306, NULL, 0),
(2712, 0, -1, 1716524607, 0, 'House of Recreation', 250000, 6, 0, 0, 0, 0, 469, NULL, 0),
(2713, 0, -1, 1716524607, 0, 'Carlin Clanhall', 125000, 6, 0, 0, 0, 0, 287, NULL, 0),
(2714, 0, -1, 1716524607, 0, 'Magician\'s Alley 4', 100000, 6, 0, 0, 0, 0, 60, NULL, 0),
(2715, 0, -1, 1716524607, 0, 'Theater Avenue 14 (Shop)', 100000, 6, 0, 0, 0, 0, 54, NULL, 0),
(2716, 0, -1, 1716524607, 0, 'Theater Avenue 12', 40000, 6, 0, 0, 0, 0, 21, NULL, 0),
(2717, 0, -1, 1716524607, 0, 'Magician\'s Alley 1', 50000, 6, 0, 0, 0, 0, 23, NULL, 0),
(2718, 0, -1, 1716524607, 0, 'Theater Avenue 10', 50000, 6, 0, 0, 0, 0, 29, NULL, 0),
(2719, 0, -1, 1716524607, 0, 'Magician\'s Alley 1b', 12500, 6, 0, 0, 0, 0, 16, NULL, 0),
(2720, 0, -1, 1716524607, 0, 'Magician\'s Alley 1a', 12500, 6, 0, 0, 0, 0, 16, NULL, 0),
(2721, 0, -1, 1716524607, 0, 'Magician\'s Alley 1c', 12500, 6, 0, 0, 0, 0, 13, NULL, 0),
(2722, 0, -1, 1716524607, 0, 'Magician\'s Alley 1d', 12500, 6, 0, 0, 0, 0, 16, NULL, 0),
(2723, 0, -1, 1716524607, 0, 'Magician\'s Alley 5c', 50000, 6, 0, 0, 0, 0, 25, NULL, 0),
(2724, 0, -1, 1716524607, 0, 'Magician\'s Alley 5f', 40000, 6, 0, 0, 0, 0, 28, NULL, 0),
(2725, 0, -1, 1716524607, 0, 'Magician\'s Alley 5b', 25000, 6, 0, 0, 0, 0, 25, NULL, 0),
(2727, 0, -1, 1716524607, 0, 'Magician\'s Alley 5a', 25000, 6, 0, 0, 0, 0, 30, NULL, 0),
(2729, 0, -1, 1716524607, 0, 'Central Plaza 3 (Shop)', 25000, 6, 0, 0, 0, 0, 17, NULL, 0),
(2730, 0, -1, 1716524607, 0, 'Central Plaza 2 (Shop)', 12500, 6, 0, 0, 0, 0, 15, NULL, 0),
(2731, 0, -1, 1716524607, 0, 'Central Plaza 1 (Shop)', 25000, 6, 0, 0, 0, 0, 19, NULL, 0),
(2732, 0, -1, 1716524607, 0, 'Theater Avenue 8b', 50000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2733, 0, -1, 1716524607, 0, 'Harbour Lane 1 (Shop)', 50000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2734, 0, -1, 1716524607, 0, 'Theater Avenue 6f', 40000, 6, 0, 0, 0, 0, 24, NULL, 0),
(2735, 0, -1, 1716524607, 0, 'Theater Avenue 6d', 12500, 6, 0, 0, 0, 0, 7, NULL, 0),
(2736, 0, -1, 1716524607, 0, 'Theater Avenue 6b', 25000, 6, 0, 0, 0, 0, 25, NULL, 0),
(2737, 0, -1, 1716524607, 0, 'Northern Street 3a', 40000, 6, 0, 0, 0, 0, 20, NULL, 0),
(2738, 0, -1, 1716524607, 0, 'Northern Street 3b', 40000, 6, 0, 0, 0, 0, 22, NULL, 0),
(2739, 0, -1, 1716524607, 0, 'Northern Street 1b', 40000, 6, 0, 0, 0, 0, 25, NULL, 0),
(2740, 0, -1, 1716524607, 0, 'Northern Street 1c', 40000, 6, 0, 0, 0, 0, 21, NULL, 0),
(2741, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 14', 12500, 6, 0, 0, 0, 0, 13, NULL, 0),
(2742, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 13', 12500, 6, 0, 0, 0, 0, 14, NULL, 0),
(2743, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 15', 12500, 6, 0, 0, 0, 0, 12, NULL, 0),
(2744, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 12', 12500, 6, 0, 0, 0, 0, 14, NULL, 0),
(2745, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 11', 25000, 6, 0, 0, 0, 0, 21, NULL, 0),
(2746, 0, -1, 1716524607, 0, 'Theater Avenue 7, Flat 16', 12500, 6, 0, 0, 0, 0, 16, NULL, 0),
(2747, 0, -1, 1716524607, 0, 'Theater Avenue 5', 100000, 6, 0, 0, 0, 0, 113, NULL, 0),
(2751, 0, -1, 1716524607, 0, 'Harbour Flats, Flat 11', 12500, 6, 0, 0, 0, 0, 17, NULL, 0),
(2752, 0, -1, 1716524607, 0, 'Harbour Flats, Flat 13', 12500, 6, 0, 0, 0, 0, 17, NULL, 0),
(2753, 0, -1, 1716524607, 0, 'Harbour Flats, Flat 15', 25000, 6, 0, 0, 0, 0, 27, NULL, 0),
(2755, 0, -1, 1716524607, 0, 'Harbour Flats, Flat 12', 25000, 6, 0, 0, 0, 0, 33, NULL, 0),
(2757, 0, -1, 1716524607, 0, 'Harbour Flats, Flat 16', 25000, 6, 0, 0, 0, 0, 35, NULL, 0),
(2759, 0, -1, 1716524607, 0, 'Harbour Flats, Flat 21', 25000, 6, 0, 0, 0, 0, 23, NULL, 0),
(2760, 0, -1, 1716524607, 0, 'Harbour Flats, Flat 22', 40000, 6, 0, 0, 0, 0, 30, NULL, 0),
(2761, 0, -1, 1716524607, 0, 'Harbour Flats, Flat 23', 12500, 6, 0, 0, 0, 0, 17, NULL, 0),
(2763, 0, -1, 1716524607, 0, 'Park Lane 1b', 100000, 6, 0, 0, 0, 0, 39, NULL, 0),
(2764, 0, -1, 1716524607, 0, 'Theater Avenue 8a', 50000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2765, 0, -1, 1716524607, 0, 'Theater Avenue 11a', 50000, 6, 0, 0, 0, 0, 32, NULL, 0),
(2767, 0, -1, 1716524607, 0, 'Theater Avenue 11b', 50000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2768, 0, -1, 1716524607, 0, 'Caretaker\'s Residence', 300000, 6, 0, 0, 0, 0, 298, NULL, 0),
(2769, 0, -1, 1716524607, 0, 'Moonkeep', 125000, 6, 0, 0, 0, 0, 298, NULL, 0),
(2770, 0, -1, 1716524607, 0, 'Mangrove 1', 40000, 5, 0, 0, 0, 0, 39, NULL, 0),
(2771, 0, -1, 1716524607, 0, 'Coastwood 2', 25000, 5, 0, 0, 0, 0, 20, NULL, 0),
(2772, 0, -1, 1716524607, 0, 'Coastwood 1', 25000, 5, 0, 0, 0, 0, 23, NULL, 0),
(2773, 0, -1, 1716524607, 0, 'Coastwood 3', 25000, 5, 0, 0, 0, 0, 27, NULL, 0),
(2774, 0, -1, 1716524607, 0, 'Coastwood 4', 25000, 5, 0, 0, 0, 0, 25, NULL, 0),
(2775, 0, -1, 1716524607, 0, 'Mangrove 4', 25000, 5, 0, 0, 0, 0, 23, NULL, 0),
(2776, 0, -1, 1716524607, 0, 'Coastwood 10', 40000, 5, 0, 0, 0, 0, 32, NULL, 0),
(2777, 0, -1, 1716524607, 0, 'Coastwood 5', 25000, 5, 0, 0, 0, 0, 33, NULL, 0),
(2778, 0, -1, 1716524607, 0, 'Coastwood 6 (Shop)', 40000, 5, 0, 0, 0, 0, 32, NULL, 0),
(2779, 0, -1, 1716524607, 0, 'Coastwood 7', 12500, 5, 0, 0, 0, 0, 16, NULL, 0),
(2780, 0, -1, 1716524607, 0, 'Coastwood 8', 25000, 5, 0, 0, 0, 0, 30, NULL, 0),
(2781, 0, -1, 1716524607, 0, 'Coastwood 9', 25000, 5, 0, 0, 0, 0, 25, NULL, 0),
(2782, 0, -1, 1716524607, 0, 'Treetop 2', 12500, 5, 0, 0, 0, 0, 18, NULL, 0),
(2783, 0, -1, 1716524607, 0, 'Treetop 1', 12500, 5, 0, 0, 0, 0, 17, NULL, 0),
(2784, 0, -1, 1716524607, 0, 'Mangrove 3', 40000, 5, 0, 0, 0, 0, 27, NULL, 0),
(2785, 0, -1, 1716524607, 0, 'Mangrove 2', 25000, 5, 0, 0, 0, 0, 32, NULL, 0),
(2786, 0, -1, 1716524607, 0, 'The Hideout', 125000, 5, 0, 0, 0, 0, 449, NULL, 0),
(2787, 0, -1, 1716524607, 0, 'Shadow Towers', 125000, 5, 0, 0, 0, 0, 429, NULL, 0),
(2788, 0, -1, 1716524607, 0, 'Druids Retreat A', 25000, 6, 0, 0, 0, 0, 32, NULL, 0),
(2789, 0, -1, 1716524607, 0, 'Druids Retreat C', 25000, 6, 0, 0, 0, 0, 27, NULL, 0),
(2790, 0, -1, 1716524607, 0, 'Druids Retreat B', 25000, 6, 0, 0, 0, 0, 31, NULL, 0),
(2791, 0, -1, 1716524607, 0, 'Druids Retreat D', 40000, 6, 0, 0, 0, 0, 27, NULL, 0),
(2792, 0, -1, 1716524607, 0, 'East Lane 1b', 75000, 6, 0, 0, 0, 0, 43, NULL, 0),
(2793, 0, -1, 1716524607, 0, 'East Lane 1a', 100000, 6, 0, 0, 0, 0, 62, NULL, 0),
(2794, 0, -1, 1716524607, 0, 'Senja Village 11', 40000, 6, 0, 0, 0, 0, 59, NULL, 0),
(2795, 0, -1, 1716524607, 0, 'Senja Village 10', 25000, 6, 0, 0, 0, 0, 36, NULL, 0),
(2796, 0, -1, 1716524607, 0, 'Senja Village 9', 40000, 6, 0, 0, 0, 0, 55, NULL, 0),
(2797, 0, -1, 1716524607, 0, 'Senja Village 8', 25000, 6, 0, 0, 0, 0, 40, NULL, 0),
(2798, 0, -1, 1716524607, 0, 'Senja Village 7', 12500, 6, 0, 0, 0, 0, 19, NULL, 0),
(2799, 0, -1, 1716524607, 0, 'Senja Village 6b', 12500, 6, 0, 0, 0, 0, 19, NULL, 0),
(2800, 0, -1, 1716524607, 0, 'Senja Village 6a', 25000, 6, 0, 0, 0, 0, 18, NULL, 0),
(2801, 0, -1, 1716524607, 0, 'Senja Village 5', 25000, 6, 0, 0, 0, 0, 28, NULL, 0),
(2802, 0, -1, 1716524607, 0, 'Senja Village 4', 25000, 6, 0, 0, 0, 0, 38, NULL, 0),
(2803, 0, -1, 1716524607, 0, 'Senja Village 3', 25000, 6, 0, 0, 0, 0, 35, NULL, 0),
(2804, 0, -1, 1716524607, 0, 'Senja Village 1b', 25000, 6, 0, 0, 0, 0, 38, NULL, 0),
(2805, 0, -1, 1716524607, 0, 'Senja Village 1a', 12500, 6, 0, 0, 0, 0, 19, NULL, 0),
(2806, 0, -1, 1716524607, 0, 'Rosebud C', 50000, 6, 0, 0, 0, 0, 36, NULL, 0),
(2807, 0, -1, 1716524607, 0, 'Rosebud B', 40000, 6, 0, 0, 0, 0, 29, NULL, 0),
(2808, 0, -1, 1716524607, 0, 'Rosebud A', 25000, 6, 0, 0, 0, 0, 29, NULL, 0),
(2809, 0, -1, 1716524607, 0, 'Park Lane 3b', 50000, 6, 0, 0, 0, 0, 29, NULL, 0),
(2810, 0, -1, 1716524607, 0, 'Northport Village 6', 40000, 6, 0, 0, 0, 0, 42, NULL, 0),
(2811, 0, -1, 1716524607, 0, 'Northport Village 5', 40000, 6, 0, 0, 0, 0, 34, NULL, 0),
(2812, 0, -1, 1716524607, 0, 'Northport Village 4', 50000, 6, 0, 0, 0, 0, 50, NULL, 0),
(2813, 0, -1, 1716524607, 0, 'Northport Village 3', 75000, 6, 0, 0, 0, 0, 104, NULL, 0),
(2814, 0, -1, 1716524607, 0, 'Northport Village 2', 25000, 6, 0, 0, 0, 0, 28, NULL, 0),
(2815, 0, -1, 1716524607, 0, 'Northport Village 1', 25000, 6, 0, 0, 0, 0, 28, NULL, 0),
(2816, 0, -1, 1716524607, 0, 'Nautic Observer', 100000, 6, 0, 0, 0, 0, 220, NULL, 0),
(2817, 0, -1, 1716524607, 0, 'Nordic Stronghold', 125000, 6, 0, 0, 0, 0, 536, NULL, 0),
(2818, 0, -1, 1716524607, 0, 'Senja Clanhall', 125000, 6, 0, 0, 0, 0, 228, NULL, 0),
(2819, 0, -1, 1716524607, 0, 'Seawatch', 125000, 6, 0, 0, 0, 0, 431, NULL, 0),
(2820, 0, -1, 1716524607, 0, 'Dwarven Magnate\'s Estate', 150000, 7, 0, 0, 0, 0, 269, NULL, 0),
(2821, 0, -1, 1716524607, 0, 'Forge Master\'s Quarters', 150000, 7, 0, 0, 0, 0, 79, NULL, 0),
(2822, 0, -1, 1716524607, 0, 'Upper Barracks 13', 12500, 7, 0, 0, 0, 0, 16, NULL, 0),
(2823, 0, -1, 1716524607, 0, 'Upper Barracks 5', 40000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2824, 0, -1, 1716524607, 0, 'Upper Barracks 3', 40000, 7, 0, 0, 0, 0, 16, NULL, 0),
(2825, 0, -1, 1716524607, 0, 'Upper Barracks 4', 25000, 7, 0, 0, 0, 0, 16, NULL, 0),
(2826, 0, -1, 1716524607, 0, 'Upper Barracks 2', 40000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2827, 0, -1, 1716524607, 0, 'Upper Barracks 1', 25000, 7, 0, 0, 0, 0, 16, NULL, 0),
(2828, 0, -1, 1716524607, 0, 'Tunnel Gardens 9', 75000, 7, 0, 0, 0, 0, 74, NULL, 0),
(2829, 0, -1, 1716524607, 0, 'Tunnel Gardens 8', 12500, 7, 0, 0, 0, 0, 24, NULL, 0),
(2830, 0, -1, 1716524607, 0, 'Tunnel Gardens 7', 25000, 7, 0, 0, 0, 0, 21, NULL, 0),
(2831, 0, -1, 1716524607, 0, 'Tunnel Gardens 6', 12500, 7, 0, 0, 0, 0, 21, NULL, 0),
(2832, 0, -1, 1716524607, 0, 'Tunnel Gardens 5', 12500, 7, 0, 0, 0, 0, 21, NULL, 0),
(2835, 0, -1, 1716524607, 0, 'Tunnel Gardens 4', 40000, 7, 0, 0, 0, 0, 33, NULL, 0),
(2836, 0, -1, 1716524607, 0, 'Tunnel Gardens 2', 40000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2837, 0, -1, 1716524607, 0, 'Tunnel Gardens 1', 40000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2838, 0, -1, 1716524607, 0, 'Tunnel Gardens 3', 40000, 7, 0, 0, 0, 0, 33, NULL, 0),
(2839, 0, -1, 1716524607, 0, 'The Market 4 (Shop)', 40000, 7, 0, 0, 0, 0, 32, NULL, 0),
(2840, 0, -1, 1716524607, 0, 'The Market 3 (Shop)', 40000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2841, 0, -1, 1716524607, 0, 'The Market 2 (Shop)', 25000, 7, 0, 0, 0, 0, 23, NULL, 0),
(2842, 0, -1, 1716524607, 0, 'The Market 1 (Shop)', 12500, 7, 0, 0, 0, 0, 11, NULL, 0),
(2843, 0, -1, 1716524607, 0, 'The Farms 6, Fishing Hut', 25000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2844, 0, -1, 1716524607, 0, 'The Farms 5', 25000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2845, 0, -1, 1716524607, 0, 'The Farms 4', 12500, 7, 0, 0, 0, 0, 26, NULL, 0),
(2846, 0, -1, 1716524607, 0, 'The Farms 3', 40000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2847, 0, -1, 1716524607, 0, 'The Farms 2', 25000, 7, 0, 0, 0, 0, 26, NULL, 0),
(2849, 0, -1, 1716524607, 0, 'The Farms 1', 40000, 7, 0, 0, 0, 0, 57, NULL, 0),
(2850, 0, -1, 1716524607, 0, 'Outlaw Camp 14 (Shop)', 12500, 7, 0, 0, 0, 0, 31, NULL, 0),
(2852, 0, -1, 1716524607, 0, 'Outlaw Camp 13 (Shop)', 25000, 7, 0, 0, 0, 0, 33, NULL, 0),
(2853, 0, -1, 1716524607, 0, 'Outlaw Camp 9', 40000, 7, 0, 0, 0, 0, 36, NULL, 0),
(2854, 0, -1, 1716524607, 0, 'Outlaw Camp 7', 12500, 7, 0, 0, 0, 0, 33, NULL, 0),
(2855, 0, -1, 1716524607, 0, 'Outlaw Camp 4', 25000, 7, 0, 0, 0, 0, 31, NULL, 0),
(2856, 0, -1, 1716524607, 0, 'Outlaw Camp 2', 25000, 7, 0, 0, 0, 0, 33, NULL, 0),
(2857, 0, -1, 1716524607, 0, 'Outlaw Camp 3', 25000, 7, 0, 0, 0, 0, 29, NULL, 0),
(2858, 0, -1, 1716524607, 0, 'Outlaw Camp 1', 40000, 7, 0, 0, 0, 0, 47, NULL, 0),
(2859, 0, -1, 1716524607, 0, 'Nobility Quarter 5', 50000, 7, 0, 0, 0, 0, 141, NULL, 0),
(2860, 0, -1, 1716524607, 0, 'Nobility Quarter 4', 25000, 7, 0, 0, 0, 0, 65, NULL, 0),
(2861, 0, -1, 1716524607, 0, 'Nobility Quarter 3', 40000, 7, 0, 0, 0, 0, 51, NULL, 0),
(2862, 0, -1, 1716524607, 0, 'Nobility Quarter 2', 25000, 7, 0, 0, 0, 0, 58, NULL, 0),
(2863, 0, -1, 1716524607, 0, 'Nobility Quarter 1', 40000, 7, 0, 0, 0, 0, 63, NULL, 0),
(2864, 0, -1, 1716524607, 0, 'Lower Barracks 10', 40000, 7, 0, 0, 0, 0, 25, NULL, 0),
(2865, 0, -1, 1716524607, 0, 'Lower Barracks 9', 40000, 7, 0, 0, 0, 0, 25, NULL, 0),
(2866, 0, -1, 1716524607, 0, 'Lower Barracks 8', 40000, 7, 0, 0, 0, 0, 25, NULL, 0),
(2867, 0, -1, 1716524607, 0, 'Lower Barracks 1', 40000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2868, 0, -1, 1716524607, 0, 'Lower Barracks 2', 40000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2869, 0, -1, 1716524607, 0, 'Lower Barracks 3', 40000, 7, 0, 0, 0, 0, 27, NULL, 0),
(2870, 0, -1, 1716524607, 0, 'Lower Barracks 4', 25000, 7, 0, 0, 0, 0, 28, NULL, 0),
(2871, 0, -1, 1716524607, 0, 'Lower Barracks 5', 50000, 7, 0, 0, 0, 0, 63, NULL, 0),
(2872, 0, -1, 1716524607, 0, 'Lower Barracks 6', 50000, 7, 0, 0, 0, 0, 63, NULL, 0),
(2873, 0, -1, 1716524607, 0, 'Lower Barracks 7', 40000, 7, 0, 0, 0, 0, 28, NULL, 0),
(2874, 0, -1, 1716524607, 0, 'Wolftower', 250000, 7, 0, 0, 0, 0, 402, NULL, 0),
(2875, 0, -1, 1716524607, 0, 'Riverspring', 125000, 7, 0, 0, 0, 0, 371, NULL, 0),
(2876, 0, -1, 1716524607, 0, 'Outlaw Castle', 125000, 7, 0, 0, 0, 0, 302, NULL, 0),
(2877, 0, -1, 1716524607, 0, 'Marble Guildhall', 125000, 7, 0, 0, 0, 0, 410, NULL, 0),
(2878, 0, -1, 1716524607, 0, 'Iron Guildhall', 125000, 7, 0, 0, 0, 0, 379, NULL, 0),
(2879, 0, -1, 1716524607, 0, 'Hill Hideout', 125000, 7, 0, 0, 0, 0, 247, NULL, 0),
(2880, 0, -1, 1716524607, 0, 'Granite Guildhall', 125000, 7, 0, 0, 0, 0, 506, NULL, 0),
(2881, 0, -1, 1716524607, 0, 'Alai Flats, Flat 01', 25000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2882, 0, -1, 1716524607, 0, 'Alai Flats, Flat 02', 25000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2883, 0, -1, 1716524607, 0, 'Alai Flats, Flat 03', 25000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2884, 0, -1, 1716524607, 0, 'Alai Flats, Flat 04', 40000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2885, 0, -1, 1716524607, 0, 'Alai Flats, Flat 05', 50000, 8, 0, 0, 0, 0, 28, NULL, 0),
(2886, 0, -1, 1716524607, 0, 'Alai Flats, Flat 06', 50000, 8, 0, 0, 0, 0, 25, NULL, 0),
(2887, 0, -1, 1716524607, 0, 'Alai Flats, Flat 07', 12500, 8, 0, 0, 0, 0, 18, NULL, 0),
(2888, 0, -1, 1716524607, 0, 'Alai Flats, Flat 08', 25000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2889, 0, -1, 1716524607, 0, 'Alai Flats, Flat 11', 40000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2890, 0, -1, 1716524607, 0, 'Alai Flats, Flat 12', 12500, 8, 0, 0, 0, 0, 17, NULL, 0),
(2891, 0, -1, 1716524607, 0, 'Alai Flats, Flat 13', 25000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2892, 0, -1, 1716524607, 0, 'Alai Flats, Flat 14', 40000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2893, 0, -1, 1716524607, 0, 'Alai Flats, Flat 15', 50000, 8, 0, 0, 0, 0, 34, NULL, 0),
(2894, 0, -1, 1716524607, 0, 'Alai Flats, Flat 16', 50000, 8, 0, 0, 0, 0, 31, NULL, 0),
(2895, 0, -1, 1716524607, 0, 'Alai Flats, Flat 17', 40000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2896, 0, -1, 1716524607, 0, 'Alai Flats, Flat 18', 25000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2897, 0, -1, 1716524607, 0, 'Alai Flats, Flat 21', 25000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2898, 0, -1, 1716524607, 0, 'Alai Flats, Flat 22', 25000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2899, 0, -1, 1716524607, 0, 'Alai Flats, Flat 23', 12500, 8, 0, 0, 0, 0, 19, NULL, 0),
(2900, 0, -1, 1716524607, 0, 'Alai Flats, Flat 28', 40000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2901, 0, -1, 1716524607, 0, 'Alai Flats, Flat 27', 40000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2902, 0, -1, 1716524607, 0, 'Alai Flats, Flat 26', 50000, 8, 0, 0, 0, 0, 31, NULL, 0),
(2903, 0, -1, 1716524607, 0, 'Alai Flats, Flat 25', 50000, 8, 0, 0, 0, 0, 34, NULL, 0),
(2904, 0, -1, 1716524607, 0, 'Alai Flats, Flat 24', 40000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2905, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 01', 25000, 8, 0, 0, 0, 0, 16, NULL, 0),
(2906, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 02', 40000, 8, 0, 0, 0, 0, 16, NULL, 0),
(2907, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 03', 40000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2908, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 04', 25000, 8, 0, 0, 0, 0, 14, NULL, 0),
(2909, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 05', 40000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2910, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 06', 50000, 8, 0, 0, 0, 0, 24, NULL, 0),
(2911, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 11', 12500, 8, 0, 0, 0, 0, 15, NULL, 0),
(2912, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 12', 25000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2913, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 13', 40000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2914, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 14', 12500, 8, 0, 0, 0, 0, 8, NULL, 0),
(2915, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 15', 12500, 8, 0, 0, 0, 0, 9, NULL, 0),
(2916, 0, -1, 1716524607, 0, 'Beach Home Apartments, Flat 16', 40000, 8, 0, 0, 0, 0, 21, NULL, 0),
(2917, 0, -1, 1716524607, 0, 'Demon Tower', 50000, 8, 0, 0, 0, 0, 75, NULL, 0),
(2918, 0, -1, 1716524607, 0, 'Farm Lane, 1st floor (Shop)', 40000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2919, 0, -1, 1716524607, 0, 'Farm Lane, 2nd Floor (Shop)', 25000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2920, 0, -1, 1716524607, 0, 'Farm Lane, Basement (Shop)', 25000, 8, 0, 0, 0, 0, 21, NULL, 0),
(2921, 0, -1, 1716524607, 0, 'Fibula Village 1', 12500, 8, 0, 0, 0, 0, 15, NULL, 0),
(2922, 0, -1, 1716524607, 0, 'Fibula Village 2', 12500, 8, 0, 0, 0, 0, 15, NULL, 0),
(2923, 0, -1, 1716524607, 0, 'Fibula Village 4', 12500, 8, 0, 0, 0, 0, 27, NULL, 0),
(2924, 0, -1, 1716524607, 0, 'Fibula Village 5', 25000, 8, 0, 0, 0, 0, 27, NULL, 0),
(2925, 0, -1, 1716524607, 0, 'Fibula Village 3', 40000, 8, 0, 0, 0, 0, 60, NULL, 0),
(2926, 0, -1, 1716524607, 0, 'Fibula Village, Tower Flat', 50000, 8, 0, 0, 0, 0, 94, NULL, 0),
(2927, 0, -1, 1716524607, 0, 'Guildhall of the Red Rose', 125000, 8, 0, 0, 0, 0, 396, NULL, 0),
(2928, 0, -1, 1716524607, 0, 'Fibula Village, Bar (Shop)', 50000, 8, 0, 0, 0, 0, 74, NULL, 0),
(2929, 0, -1, 1716524607, 0, 'Fibula Village, Villa', 100000, 8, 0, 0, 0, 0, 264, NULL, 0),
(2930, 0, -1, 1716524607, 0, 'Greenshore Village 1', 40000, 8, 0, 0, 0, 0, 39, NULL, 0),
(2931, 0, -1, 1716524607, 0, 'Greenshore Clanhall', 125000, 8, 0, 0, 0, 0, 176, NULL, 0),
(2932, 0, -1, 1716524607, 0, 'Castle of Greenshore', 125000, 8, 0, 0, 0, 0, 325, NULL, 0),
(2933, 0, -1, 1716524607, 0, 'Greenshore Village, Shop', 40000, 8, 0, 0, 0, 0, 31, NULL, 0),
(2934, 0, -1, 1716524607, 0, 'Greenshore Village, Villa', 150000, 8, 0, 0, 0, 0, 178, NULL, 0),
(2935, 0, -1, 1716524607, 0, 'Greenshore Village 7', 12500, 8, 0, 0, 0, 0, 23, NULL, 0),
(2936, 0, -1, 1716524607, 0, 'Greenshore Village 3', 25000, 8, 0, 0, 0, 0, 30, NULL, 0),
(2939, 0, -1, 1716524607, 0, 'Greenshore Village 2', 25000, 8, 0, 0, 0, 0, 30, NULL, 0),
(2940, 0, -1, 1716524607, 0, 'Greenshore Village 6', 75000, 8, 0, 0, 0, 0, 79, NULL, 0),
(2941, 0, -1, 1716524607, 0, 'Harbour Place 1 (Shop)', 400000, 8, 0, 0, 0, 0, 21, NULL, 0),
(2942, 0, -1, 1716524607, 0, 'Harbour Place 2 (Shop)', 300000, 8, 0, 0, 0, 0, 25, NULL, 0),
(2943, 0, -1, 1716524607, 0, 'Harbour Place 3', 400000, 8, 0, 0, 0, 0, 88, NULL, 0),
(2944, 0, -1, 1716524607, 0, 'Harbour Place 4', 40000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2945, 0, -1, 1716524607, 0, 'Lower Swamp Lane 1', 200000, 8, 0, 0, 0, 0, 80, NULL, 0),
(2946, 0, -1, 1716524607, 0, 'Lower Swamp Lane 3', 200000, 8, 0, 0, 0, 0, 80, NULL, 0),
(2947, 0, -1, 1716524607, 0, 'Main Street 9, 1st floor (Shop)', 100000, 8, 0, 0, 0, 0, 30, NULL, 0),
(2948, 0, -1, 1716524607, 0, 'Main Street 9a, 2nd floor (Shop)', 50000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2949, 0, -1, 1716524607, 0, 'Main Street 9b, 2nd floor (Shop)', 75000, 8, 0, 0, 0, 0, 27, NULL, 0),
(2950, 0, -1, 1716524607, 0, 'Mill Avenue 1 (Shop)', 100000, 8, 0, 0, 0, 0, 28, NULL, 0),
(2951, 0, -1, 1716524607, 0, 'Mill Avenue 2 (Shop)', 100000, 8, 0, 0, 0, 0, 47, NULL, 0),
(2952, 0, -1, 1716524607, 0, 'Mill Avenue 3', 50000, 8, 0, 0, 0, 0, 32, NULL, 0),
(2953, 0, -1, 1716524607, 0, 'Mill Avenue 4', 50000, 8, 0, 0, 0, 0, 33, NULL, 0),
(2954, 0, -1, 1716524607, 0, 'Mill Avenue 5', 150000, 8, 0, 0, 0, 0, 69, NULL, 0),
(2955, 0, -1, 1716524607, 0, 'Open-Air Theatre', 75000, 8, 0, 0, 0, 0, 81, NULL, 0),
(2956, 0, -1, 1716524607, 0, 'Smuggler\'s Den', 200000, 8, 0, 0, 0, 0, 227, NULL, 0),
(2957, 0, -1, 1716524607, 0, 'Sorcerer\'s Avenue 1a', 50000, 8, 0, 0, 0, 0, 24, NULL, 0),
(2958, 0, -1, 1716524607, 0, 'Sorcerer\'s Avenue 5 (Shop)', 75000, 8, 0, 0, 0, 0, 54, NULL, 0),
(2959, 0, -1, 1716524607, 0, 'Sorcerer\'s Avenue 1b', 40000, 8, 0, 0, 0, 0, 19, NULL, 0),
(2960, 0, -1, 1716524607, 0, 'Sorcerer\'s Avenue 1c', 50000, 8, 0, 0, 0, 0, 25, NULL, 0),
(2961, 0, -1, 1716524607, 0, 'Sorcerer\'s Avenue Labs 2a', 25000, 8, 0, 0, 0, 0, 29, NULL, 0),
(2962, 0, -1, 1716524607, 0, 'Sorcerer\'s Avenue Labs 2c', 25000, 8, 0, 0, 0, 0, 29, NULL, 0),
(2963, 0, -1, 1716524607, 0, 'Sorcerer\'s Avenue Labs 2b', 25000, 8, 0, 0, 0, 0, 29, NULL, 0),
(2964, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 01', 50000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2965, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 02', 40000, 8, 0, 0, 0, 0, 14, NULL, 0),
(2966, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 03', 40000, 8, 0, 0, 0, 0, 14, NULL, 0),
(2967, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 11', 40000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2968, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 12', 25000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2969, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 13', 50000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2970, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 14', 25000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2971, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 21', 25000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2972, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 22', 25000, 8, 0, 0, 0, 0, 15, NULL, 0),
(2973, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 23', 40000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2974, 0, -1, 1716524607, 0, 'Sunset Homes, Flat 24', 25000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2975, 0, -1, 1716524607, 0, 'Thais Hostel', 100000, 8, 0, 0, 0, 0, 129, NULL, 0),
(2976, 0, -1, 1716524607, 0, 'The City Wall 1a', 75000, 8, 0, 0, 0, 0, 32, NULL, 0),
(2977, 0, -1, 1716524607, 0, 'The City Wall 1b', 50000, 8, 0, 0, 0, 0, 31, NULL, 0),
(2978, 0, -1, 1716524607, 0, 'The City Wall 3a', 50000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2979, 0, -1, 1716524607, 0, 'The City Wall 3b', 50000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2980, 0, -1, 1716524607, 0, 'The City Wall 3c', 50000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2981, 0, -1, 1716524607, 0, 'The City Wall 3d', 50000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2982, 0, -1, 1716524607, 0, 'The City Wall 3e', 50000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2983, 0, -1, 1716524607, 0, 'The City Wall 3f', 50000, 8, 0, 0, 0, 0, 23, NULL, 0),
(2984, 0, -1, 1716524607, 0, 'Upper Swamp Lane 12', 150000, 8, 0, 0, 0, 0, 76, NULL, 0),
(2985, 0, -1, 1716524607, 0, 'Upper Swamp Lane 10', 75000, 8, 0, 0, 0, 0, 40, NULL, 0),
(2986, 0, -1, 1716524607, 0, 'Upper Swamp Lane 8', 300000, 8, 0, 0, 0, 0, 159, NULL, 0),
(2987, 0, -1, 1716524607, 0, 'Upper Swamp Lane 4', 300000, 8, 0, 0, 0, 0, 100, NULL, 0),
(2988, 0, -1, 1716524607, 0, 'Upper Swamp Lane 2', 300000, 8, 0, 0, 0, 0, 100, NULL, 0),
(2989, 0, -1, 1716524607, 0, 'The City Wall 9', 40000, 8, 0, 0, 0, 0, 25, NULL, 0),
(2990, 0, -1, 1716524607, 0, 'The City Wall 7h', 25000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2991, 0, -1, 1716524607, 0, 'The City Wall 7b', 12500, 8, 0, 0, 0, 0, 18, NULL, 0),
(2992, 0, -1, 1716524607, 0, 'The City Wall 7d', 25000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2993, 0, -1, 1716524607, 0, 'The City Wall 7f', 40000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2994, 0, -1, 1716524607, 0, 'The City Wall 7c', 40000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2995, 0, -1, 1716524607, 0, 'The City Wall 7a', 40000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2996, 0, -1, 1716524607, 0, 'The City Wall 7g', 25000, 8, 0, 0, 0, 0, 18, NULL, 0),
(2997, 0, -1, 1716524607, 0, 'The City Wall 7e', 40000, 8, 0, 0, 0, 0, 22, NULL, 0),
(2998, 0, -1, 1716524607, 0, 'The City Wall 5b', 25000, 8, 0, 0, 0, 0, 17, NULL, 0),
(2999, 0, -1, 1716524607, 0, 'The City Wall 5d', 25000, 8, 0, 0, 0, 0, 15, NULL, 0),
(3000, 0, -1, 1716524607, 0, 'The City Wall 5f', 12500, 8, 0, 0, 0, 0, 17, NULL, 0),
(3001, 0, -1, 1716524607, 0, 'The City Wall 5a', 25000, 8, 0, 0, 0, 0, 17, NULL, 0),
(3002, 0, -1, 1716524607, 0, 'The City Wall 5c', 25000, 8, 0, 0, 0, 0, 15, NULL, 0),
(3003, 0, -1, 1716524607, 0, 'The City Wall 5e', 25000, 8, 0, 0, 0, 0, 17, NULL, 0),
(3004, 0, -1, 1716524607, 0, 'Warriors\' Guildhall', 2500000, 8, 0, 0, 0, 0, 334, NULL, 0),
(3005, 0, -1, 1716524607, 0, 'The Tibianic', 250000, 8, 0, 0, 0, 0, 809, NULL, 0),
(3006, 0, -1, 1716524607, 0, 'Bloodhall', 250000, 8, 0, 0, 0, 0, 321, NULL, 0),
(3007, 0, -1, 1716524607, 0, 'Fibula Clanhall', 125000, 8, 0, 0, 0, 0, 178, NULL, 0),
(3008, 0, -1, 1716524607, 0, 'Dark Mansion', 500000, 8, 0, 0, 0, 0, 375, NULL, 0),
(3009, 0, -1, 1716524607, 0, 'Halls of the Adventurers', 125000, 8, 0, 0, 0, 0, 317, NULL, 0),
(3010, 0, -1, 1716524607, 0, 'Mercenary Tower', 125000, 8, 0, 0, 0, 0, 619, NULL, 0),
(3011, 0, -1, 1716524607, 0, 'Snake Tower', 250000, 8, 0, 0, 0, 0, 627, NULL, 0),
(3012, 0, -1, 1716524607, 0, 'Southern Thais Guildhall', 500000, 8, 0, 0, 0, 0, 374, NULL, 0),
(3013, 0, -1, 1716524607, 0, 'Spiritkeep', 250000, 8, 0, 0, 0, 0, 289, NULL, 0),
(3014, 0, -1, 1716524607, 0, 'Thais Clanhall', 250000, 8, 0, 0, 0, 0, 206, NULL, 0),
(3015, 0, -1, 1716524607, 0, 'The Lair', 100000, 9, 0, 0, 0, 0, 259, NULL, 0),
(3016, 0, -1, 1716524607, 0, 'Silver Street 4', 150000, 9, 0, 0, 0, 0, 119, NULL, 0),
(3017, 0, -1, 1716524607, 0, 'Dream Street 1 (Shop)', 300000, 9, 0, 0, 0, 0, 149, NULL, 0),
(3018, 0, -1, 1716524607, 0, 'Dagger Alley 1', 100000, 9, 0, 0, 0, 0, 103, NULL, 0),
(3019, 0, -1, 1716524607, 0, 'Dream Street 2', 200000, 9, 0, 0, 0, 0, 113, NULL, 0),
(3020, 0, -1, 1716524607, 0, 'Dream Street 3', 150000, 9, 0, 0, 0, 0, 104, NULL, 0),
(3021, 0, -1, 1716524607, 0, 'Elm Street 1', 150000, 9, 0, 0, 0, 0, 99, NULL, 0),
(3022, 0, -1, 1716524607, 0, 'Elm Street 3', 150000, 9, 0, 0, 0, 0, 107, NULL, 0),
(3023, 0, -1, 1716524607, 0, 'Elm Street 2', 150000, 9, 0, 0, 0, 0, 98, NULL, 0),
(3024, 0, -1, 1716524607, 0, 'Elm Street 4', 150000, 9, 0, 0, 0, 0, 108, NULL, 0),
(3025, 0, -1, 1716524607, 0, 'Seagull Walk 1', 400000, 9, 0, 0, 0, 0, 169, NULL, 0),
(3026, 0, -1, 1716524607, 0, 'Seagull Walk 2', 150000, 9, 0, 0, 0, 0, 102, NULL, 0),
(3027, 0, -1, 1716524607, 0, 'Dream Street 4', 200000, 9, 0, 0, 0, 0, 128, NULL, 0),
(3028, 0, -1, 1716524607, 0, 'Old Lighthouse', 100000, 9, 0, 0, 0, 0, 157, NULL, 0),
(3029, 0, -1, 1716524607, 0, 'Market Street 1', 300000, 9, 0, 0, 0, 0, 220, NULL, 0),
(3030, 0, -1, 1716524607, 0, 'Market Street 3', 300000, 9, 0, 0, 0, 0, 127, NULL, 0),
(3031, 0, -1, 1716524607, 0, 'Market Street 4 (Shop)', 400000, 9, 0, 0, 0, 0, 176, NULL, 0),
(3032, 0, -1, 1716524607, 0, 'Market Street 5 (Shop)', 400000, 9, 0, 0, 0, 0, 230, NULL, 0),
(3033, 0, -1, 1716524607, 0, 'Market Street 2', 300000, 9, 0, 0, 0, 0, 173, NULL, 0),
(3034, 0, -1, 1716524607, 0, 'Loot Lane 1 (Shop)', 300000, 9, 0, 0, 0, 0, 159, NULL, 0),
(3035, 0, -1, 1716524607, 0, 'Mystic Lane 1', 150000, 9, 0, 0, 0, 0, 92, NULL, 0),
(3036, 0, -1, 1716524607, 0, 'Mystic Lane 2', 100000, 9, 0, 0, 0, 0, 119, NULL, 0),
(3037, 0, -1, 1716524607, 0, 'Lucky Lane 2 (Tower)', 300000, 9, 0, 0, 0, 0, 216, NULL, 0),
(3038, 0, -1, 1716524607, 0, 'Lucky Lane 3 (Tower)', 300000, 9, 0, 0, 0, 0, 216, NULL, 0),
(3039, 0, -1, 1716524607, 0, 'Iron Alley 1', 150000, 9, 0, 0, 0, 0, 101, NULL, 0),
(3040, 0, -1, 1716524607, 0, 'Iron Alley 2', 150000, 9, 0, 0, 0, 0, 128, NULL, 0),
(3041, 0, -1, 1716524607, 0, 'Swamp Watch', 250000, 9, 0, 0, 0, 0, 379, NULL, 0),
(3042, 0, -1, 1716524607, 0, 'Golden Axe Guildhall', 250000, 9, 0, 0, 0, 0, 344, NULL, 0),
(3043, 0, -1, 1716524607, 0, 'Silver Street 1', 100000, 9, 0, 0, 0, 0, 108, NULL, 0),
(3044, 0, -1, 1716524607, 0, 'Valorous Venore', 250000, 9, 0, 0, 0, 0, 457, NULL, 0),
(3045, 0, -1, 1716524607, 0, 'Salvation Street 2', 150000, 9, 0, 0, 0, 0, 113, NULL, 0),
(3046, 0, -1, 1716524607, 0, 'Salvation Street 3', 150000, 9, 0, 0, 0, 0, 143, NULL, 0),
(3047, 0, -1, 1716524607, 0, 'Silver Street 2', 100000, 9, 0, 0, 0, 0, 76, NULL, 0),
(3048, 0, -1, 1716524607, 0, 'Silver Street 3', 100000, 9, 0, 0, 0, 0, 82, NULL, 0),
(3049, 0, -1, 1716524607, 0, 'Mystic Lane 3 (Tower)', 400000, 9, 0, 0, 0, 0, 214, NULL, 0),
(3050, 0, -1, 1716524607, 0, 'Market Street 7', 100000, 9, 0, 0, 0, 0, 90, NULL, 0),
(3051, 0, -1, 1716524607, 0, 'Market Street 6', 300000, 9, 0, 0, 0, 0, 186, NULL, 0),
(3052, 0, -1, 1716524607, 0, 'Iron Alley Watch, Upper', 300000, 9, 0, 0, 0, 0, 215, NULL, 0),
(3053, 0, -1, 1716524607, 0, 'Iron Alley Watch, Lower', 300000, 9, 0, 0, 0, 0, 217, NULL, 0),
(3054, 0, -1, 1716524607, 0, 'Blessed Shield Guildhall', 250000, 9, 0, 0, 0, 0, 250, NULL, 0),
(3055, 0, -1, 1716524607, 0, 'Steel Home', 250000, 9, 0, 0, 0, 0, 388, NULL, 0),
(3056, 0, -1, 1716524607, 0, 'Salvation Street 1 (Shop)', 300000, 9, 0, 0, 0, 0, 215, NULL, 0),
(3057, 0, -1, 1716524607, 0, 'Lucky Lane 1 (Shop)', 400000, 9, 0, 0, 0, 0, 220, NULL, 0),
(3058, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 34', 50000, 9, 0, 0, 0, 0, 59, NULL, 0),
(3059, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 33', 25000, 9, 0, 0, 0, 0, 35, NULL, 0),
(3060, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 32', 50000, 9, 0, 0, 0, 0, 50, NULL, 0),
(3061, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 31', 40000, 9, 0, 0, 0, 0, 40, NULL, 0),
(3062, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 28', 12500, 9, 0, 0, 0, 0, 13, NULL, 0),
(3063, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 26', 12500, 9, 0, 0, 0, 0, 19, NULL, 0),
(3064, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 24', 12500, 9, 0, 0, 0, 0, 19, NULL, 0),
(3065, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 22', 12500, 9, 0, 0, 0, 0, 19, NULL, 0),
(3066, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 21', 12500, 9, 0, 0, 0, 0, 18, NULL, 0),
(3067, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 27', 25000, 9, 0, 0, 0, 0, 23, NULL, 0),
(3068, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 25', 25000, 9, 0, 0, 0, 0, 24, NULL, 0),
(3069, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 23', 25000, 9, 0, 0, 0, 0, 29, NULL, 0),
(3070, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 11', 12500, 9, 0, 0, 0, 0, 14, NULL, 0),
(3071, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 13', 25000, 9, 0, 0, 0, 0, 20, NULL, 0),
(3072, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 15', 25000, 9, 0, 0, 0, 0, 20, NULL, 0),
(3073, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 17', 12500, 9, 0, 0, 0, 0, 20, NULL, 0),
(3074, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 18', 12500, 9, 0, 0, 0, 0, 20, NULL, 0),
(3075, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 12', 25000, 9, 0, 0, 0, 0, 25, NULL, 0),
(3076, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 14', 25000, 9, 0, 0, 0, 0, 25, NULL, 0),
(3077, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 16', 25000, 9, 0, 0, 0, 0, 30, NULL, 0),
(3078, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 06', 12500, 9, 0, 0, 0, 0, 11, NULL, 0),
(3079, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 05', 12500, 9, 0, 0, 0, 0, 9, NULL, 0),
(3080, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 04', 12500, 9, 0, 0, 0, 0, 17, NULL, 0),
(3081, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 07', 25000, 9, 0, 0, 0, 0, 14, NULL, 0),
(3082, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 03', 12500, 9, 0, 0, 0, 0, 11, NULL, 0),
(3083, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 02', 12500, 9, 0, 0, 0, 0, 14, NULL, 0),
(3084, 0, -1, 1716524607, 0, 'Paupers Palace, Flat 01', 12500, 9, 0, 0, 0, 0, 15, NULL, 0),
(3085, 0, -1, 1716524607, 0, 'Castle, Residence', 300000, 11, 0, 0, 0, 0, 104, NULL, 0),
(3086, 0, -1, 1716524607, 0, 'Castle, 3rd Floor, Flat 07', 40000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3087, 0, -1, 1716524607, 0, 'Castle, 3rd Floor, Flat 04', 12500, 11, 0, 0, 0, 0, 13, NULL, 0),
(3088, 0, -1, 1716524607, 0, 'Castle, 3rd Floor, Flat 03', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3089, 0, -1, 1716524607, 0, 'Castle, 3rd Floor, Flat 06', 50000, 11, 0, 0, 0, 0, 22, NULL, 0),
(3090, 0, -1, 1716524607, 0, 'Castle, 3rd Floor, Flat 05', 40000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3091, 0, -1, 1716524607, 0, 'Castle, 3rd Floor, Flat 02', 40000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3092, 0, -1, 1716524607, 0, 'Castle, 3rd Floor, Flat 01', 25000, 11, 0, 0, 0, 0, 15, NULL, 0),
(3093, 0, -1, 1716524607, 0, 'Castle, 4th Floor, Flat 09', 25000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3094, 0, -1, 1716524607, 0, 'Castle, 4th Floor, Flat 08', 40000, 11, 0, 0, 0, 0, 22, NULL, 0),
(3095, 0, -1, 1716524607, 0, 'Castle, 4th Floor, Flat 07', 40000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3096, 0, -1, 1716524607, 0, 'Castle, 4th Floor, Flat 04', 25000, 11, 0, 0, 0, 0, 14, NULL, 0),
(3097, 0, -1, 1716524607, 0, 'Castle, 4th Floor, Flat 03', 25000, 11, 0, 0, 0, 0, 14, NULL, 0),
(3098, 0, -1, 1716524607, 0, 'Castle, 4th Floor, Flat 06', 50000, 11, 0, 0, 0, 0, 21, NULL, 0),
(3099, 0, -1, 1716524607, 0, 'Castle, 4th Floor, Flat 05', 40000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3100, 0, -1, 1716524607, 0, 'Castle, 4th Floor, Flat 02', 40000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3101, 0, -1, 1716524607, 0, 'Castle, 4th Floor, Flat 01', 25000, 11, 0, 0, 0, 0, 14, NULL, 0),
(3102, 0, -1, 1716524607, 0, 'Castle Street 2', 75000, 11, 0, 0, 0, 0, 35, NULL, 0),
(3103, 0, -1, 1716524607, 0, 'Castle Street 3', 75000, 11, 0, 0, 0, 0, 41, NULL, 0),
(3104, 0, -1, 1716524607, 0, 'Castle Street 4', 75000, 11, 0, 0, 0, 0, 40, NULL, 0),
(3105, 0, -1, 1716524607, 0, 'Castle Street 5', 75000, 11, 0, 0, 0, 0, 40, NULL, 0),
(3106, 0, -1, 1716524607, 0, 'Castle Street 1', 150000, 11, 0, 0, 0, 0, 71, NULL, 0),
(3107, 0, -1, 1716524607, 0, 'Edron Flats, Flat 08', 12500, 11, 0, 0, 0, 0, 10, NULL, 0),
(3108, 0, -1, 1716524607, 0, 'Edron Flats, Flat 05', 12500, 11, 0, 0, 0, 0, 10, NULL, 0),
(3109, 0, -1, 1716524607, 0, 'Edron Flats, Flat 04', 12500, 11, 0, 0, 0, 0, 10, NULL, 0),
(3110, 0, -1, 1716524607, 0, 'Edron Flats, Flat 01', 25000, 11, 0, 0, 0, 0, 11, NULL, 0),
(3111, 0, -1, 1716524607, 0, 'Edron Flats, Flat 07', 12500, 11, 0, 0, 0, 0, 11, NULL, 0),
(3112, 0, -1, 1716524607, 0, 'Edron Flats, Flat 06', 12500, 11, 0, 0, 0, 0, 11, NULL, 0),
(3113, 0, -1, 1716524607, 0, 'Edron Flats, Flat 03', 12500, 11, 0, 0, 0, 0, 11, NULL, 0),
(3114, 0, -1, 1716524607, 0, 'Edron Flats, Flat 02', 50000, 11, 0, 0, 0, 0, 20, NULL, 0),
(3115, 0, -1, 1716524607, 0, 'Edron Flats, Basement Flat 2', 50000, 11, 0, 0, 0, 0, 36, NULL, 0),
(3116, 0, -1, 1716524607, 0, 'Edron Flats, Basement Flat 1', 50000, 11, 0, 0, 0, 0, 36, NULL, 0),
(3119, 0, -1, 1716524607, 0, 'Edron Flats, Flat 13', 40000, 11, 0, 0, 0, 0, 22, NULL, 0),
(3121, 0, -1, 1716524607, 0, 'Edron Flats, Flat 14', 50000, 11, 0, 0, 0, 0, 31, NULL, 0),
(3123, 0, -1, 1716524607, 0, 'Edron Flats, Flat 12', 40000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3124, 0, -1, 1716524607, 0, 'Edron Flats, Flat 11', 50000, 11, 0, 0, 0, 0, 32, NULL, 0),
(3125, 0, -1, 1716524607, 0, 'Edron Flats, Flat 25', 40000, 11, 0, 0, 0, 0, 31, NULL, 0),
(3127, 0, -1, 1716524607, 0, 'Edron Flats, Flat 24', 40000, 11, 0, 0, 0, 0, 22, NULL, 0),
(3128, 0, -1, 1716524607, 0, 'Edron Flats, Flat 21', 40000, 11, 0, 0, 0, 0, 20, NULL, 0),
(3131, 0, -1, 1716524607, 0, 'Edron Flats, Flat 23', 40000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3133, 0, -1, 1716524607, 0, 'Castle Shop 1', 200000, 11, 0, 0, 0, 0, 38, NULL, 0),
(3134, 0, -1, 1716524607, 0, 'Castle Shop 2', 200000, 11, 0, 0, 0, 0, 38, NULL, 0),
(3135, 0, -1, 1716524607, 0, 'Castle Shop 3', 150000, 11, 0, 0, 0, 0, 38, NULL, 0),
(3136, 0, -1, 1716524607, 0, 'Central Circle 1', 400000, 11, 0, 0, 0, 0, 76, NULL, 0),
(3137, 0, -1, 1716524607, 0, 'Central Circle 2', 400000, 11, 0, 0, 0, 0, 90, NULL, 0),
(3138, 0, -1, 1716524607, 0, 'Central Circle 3', 400000, 11, 0, 0, 0, 0, 99, NULL, 0),
(3139, 0, -1, 1716524607, 0, 'Central Circle 4', 400000, 11, 0, 0, 0, 0, 97, NULL, 0),
(3140, 0, -1, 1716524607, 0, 'Central Circle 5', 400000, 11, 0, 0, 0, 0, 99, NULL, 0),
(3141, 0, -1, 1716524607, 0, 'Central Circle 8 (Shop)', 200000, 11, 0, 0, 0, 0, 101, NULL, 0),
(3142, 0, -1, 1716524607, 0, 'Central Circle 7 (Shop)', 200000, 11, 0, 0, 0, 0, 101, NULL, 0),
(3143, 0, -1, 1716524607, 0, 'Central Circle 6 (Shop)', 200000, 11, 0, 0, 0, 0, 101, NULL, 0),
(3144, 0, -1, 1716524607, 0, 'Central Circle 9a', 75000, 11, 0, 0, 0, 0, 23, NULL, 0),
(3145, 0, -1, 1716524607, 0, 'Central Circle 9b', 75000, 11, 0, 0, 0, 0, 23, NULL, 0),
(3146, 0, -1, 1716524607, 0, 'Sky Lane, Guild 1', 500000, 11, 0, 0, 0, 0, 459, NULL, 0),
(3147, 0, -1, 1716524607, 0, 'Sky Lane, Sea Tower', 150000, 11, 0, 0, 0, 0, 106, NULL, 0),
(3148, 0, -1, 1716524607, 0, 'Sky Lane, Guild 3', 500000, 11, 0, 0, 0, 0, 391, NULL, 0),
(3149, 0, -1, 1716524607, 0, 'Sky Lane, Guild 2', 500000, 11, 0, 0, 0, 0, 440, NULL, 0),
(3150, 0, -1, 1716524607, 0, 'Wood Avenue 11', 300000, 11, 0, 0, 0, 0, 165, NULL, 0),
(3151, 0, -1, 1716524607, 0, 'Wood Avenue 8', 400000, 11, 0, 0, 0, 0, 147, NULL, 0),
(3152, 0, -1, 1716524607, 0, 'Wood Avenue 7', 400000, 11, 0, 0, 0, 0, 145, NULL, 0),
(3153, 0, -1, 1716524607, 0, 'Wood Avenue 10a', 100000, 11, 0, 0, 0, 0, 35, NULL, 0),
(3154, 0, -1, 1716524607, 0, 'Wood Avenue 9a', 100000, 11, 0, 0, 0, 0, 33, NULL, 0),
(3155, 0, -1, 1716524607, 0, 'Wood Avenue 6a', 150000, 11, 0, 0, 0, 0, 34, NULL, 0),
(3156, 0, -1, 1716524607, 0, 'Wood Avenue 6b', 100000, 11, 0, 0, 0, 0, 35, NULL, 0),
(3157, 0, -1, 1716524607, 0, 'Wood Avenue 9b', 100000, 11, 0, 0, 0, 0, 33, NULL, 0),
(3158, 0, -1, 1716524607, 0, 'Wood Avenue 10b', 100000, 11, 0, 0, 0, 0, 35, NULL, 0),
(3159, 0, -1, 1716524607, 0, 'Stronghold', 400000, 11, 0, 0, 0, 0, 194, NULL, 0),
(3160, 0, -1, 1716524607, 0, 'Wood Avenue 5', 150000, 11, 0, 0, 0, 0, 40, NULL, 0),
(3161, 0, -1, 1716524607, 0, 'Wood Avenue 3', 100000, 11, 0, 0, 0, 0, 39, NULL, 0),
(3162, 0, -1, 1716524607, 0, 'Wood Avenue 4', 100000, 11, 0, 0, 0, 0, 40, NULL, 0),
(3163, 0, -1, 1716524607, 0, 'Wood Avenue 2', 100000, 11, 0, 0, 0, 0, 39, NULL, 0),
(3164, 0, -1, 1716524607, 0, 'Wood Avenue 1', 100000, 11, 0, 0, 0, 0, 41, NULL, 0),
(3165, 0, -1, 1716524607, 0, 'Wood Avenue 4c', 100000, 11, 0, 0, 0, 0, 41, NULL, 0),
(3166, 0, -1, 1716524607, 0, 'Wood Avenue 4a', 75000, 11, 0, 0, 0, 0, 33, NULL, 0),
(3167, 0, -1, 1716524607, 0, 'Wood Avenue 4b', 75000, 11, 0, 0, 0, 0, 35, NULL, 0),
(3168, 0, -1, 1716524607, 0, 'Stonehome Village 1', 75000, 11, 0, 0, 0, 0, 45, NULL, 0),
(3169, 0, -1, 1716524607, 0, 'Stonehome Flats, Flat 04', 40000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3171, 0, -1, 1716524607, 0, 'Stonehome Flats, Flat 03', 40000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3173, 0, -1, 1716524607, 0, 'Stonehome Flats, Flat 02', 12500, 11, 0, 0, 0, 0, 18, NULL, 0),
(3174, 0, -1, 1716524607, 0, 'Stonehome Flats, Flat 01', 12500, 11, 0, 0, 0, 0, 11, NULL, 0),
(3175, 0, -1, 1716524607, 0, 'Stonehome Flats, Flat 13', 40000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3177, 0, -1, 1716524607, 0, 'Stonehome Flats, Flat 11', 25000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3178, 0, -1, 1716524607, 0, 'Stonehome Flats, Flat 14', 40000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3180, 0, -1, 1716524607, 0, 'Stonehome Flats, Flat 12', 25000, 11, 0, 0, 0, 0, 18, NULL, 0),
(3181, 0, -1, 1716524607, 0, 'Stonehome Village 2', 25000, 11, 0, 0, 0, 0, 19, NULL, 0),
(3182, 0, -1, 1716524607, 0, 'Stonehome Village 3', 25000, 11, 0, 0, 0, 0, 20, NULL, 0),
(3183, 0, -1, 1716524607, 0, 'Stonehome Village 4', 40000, 11, 0, 0, 0, 0, 23, NULL, 0),
(3184, 0, -1, 1716524607, 0, 'Stonehome Village 6', 50000, 11, 0, 0, 0, 0, 34, NULL, 0),
(3185, 0, -1, 1716524607, 0, 'Stonehome Village 5', 40000, 11, 0, 0, 0, 0, 29, NULL, 0),
(3186, 0, -1, 1716524607, 0, 'Stonehome Village 7', 50000, 11, 0, 0, 0, 0, 28, NULL, 0),
(3187, 0, -1, 1716524607, 0, 'Stonehome Village 8', 12500, 11, 0, 0, 0, 0, 19, NULL, 0),
(3188, 0, -1, 1716524607, 0, 'Stonehome Village 9', 25000, 11, 0, 0, 0, 0, 19, NULL, 0),
(3189, 0, -1, 1716524607, 0, 'Stonehome Clanhall', 125000, 11, 0, 0, 0, 0, 205, NULL, 0),
(3190, 0, -1, 1716524607, 0, 'Mad Scientist\'s Lab', 300000, 17, 0, 0, 0, 0, 63, NULL, 0),
(3191, 0, -1, 1716524607, 0, 'Radiant Plaza 4', 400000, 17, 0, 0, 0, 0, 197, NULL, 0),
(3192, 0, -1, 1716524607, 0, 'Radiant Plaza 3', 400000, 17, 0, 0, 0, 0, 126, NULL, 0),
(3193, 0, -1, 1716524607, 0, 'Radiant Plaza 2', 300000, 17, 0, 0, 0, 0, 99, NULL, 0),
(3194, 0, -1, 1716524607, 0, 'Radiant Plaza 1', 400000, 17, 0, 0, 0, 0, 138, NULL, 0),
(3195, 0, -1, 1716524607, 0, 'Aureate Court 3', 200000, 17, 0, 0, 0, 0, 131, NULL, 0),
(3196, 0, -1, 1716524607, 0, 'Aureate Court 4', 200000, 17, 0, 0, 0, 0, 104, NULL, 0),
(3197, 0, -1, 1716524607, 0, 'Aureate Court 5', 300000, 17, 0, 0, 0, 0, 138, NULL, 0),
(3198, 0, -1, 1716524607, 0, 'Aureate Court 2', 200000, 17, 0, 0, 0, 0, 125, NULL, 0),
(3199, 0, -1, 1716524607, 0, 'Aureate Court 1', 300000, 17, 0, 0, 0, 0, 131, NULL, 0),
(3205, 0, -1, 1716524607, 0, 'Halls of Serenity', 2500000, 17, 0, 0, 0, 0, 517, NULL, 0),
(3206, 0, -1, 1716524607, 0, 'Fortune Wing 3', 300000, 17, 0, 0, 0, 0, 148, NULL, 0),
(3207, 0, -1, 1716524607, 0, 'Fortune Wing 4', 300000, 17, 0, 0, 0, 0, 147, NULL, 0),
(3208, 0, -1, 1716524607, 0, 'Fortune Wing 2', 300000, 17, 0, 0, 0, 0, 148, NULL, 0),
(3209, 0, -1, 1716524607, 0, 'Fortune Wing 1', 400000, 17, 0, 0, 0, 0, 254, NULL, 0),
(3211, 0, -1, 1716524607, 0, 'Cascade Towers', 2500000, 17, 0, 0, 0, 0, 419, NULL, 0),
(3212, 0, -1, 1716524607, 0, 'Luminous Arc 5', 400000, 17, 0, 0, 0, 0, 145, NULL, 0),
(3213, 0, -1, 1716524607, 0, 'Luminous Arc 2', 300000, 17, 0, 0, 0, 0, 161, NULL, 0),
(3214, 0, -1, 1716524607, 0, 'Luminous Arc 1', 400000, 17, 0, 0, 0, 0, 167, NULL, 0),
(3215, 0, -1, 1716524607, 0, 'Luminous Arc 3', 300000, 17, 0, 0, 0, 0, 139, NULL, 0),
(3216, 0, -1, 1716524607, 0, 'Luminous Arc 4', 400000, 17, 0, 0, 0, 0, 200, NULL, 0),
(3217, 0, -1, 1716524607, 0, 'Harbour Promenade 1', 400000, 17, 0, 0, 0, 0, 137, NULL, 0),
(3218, 0, -1, 1716524607, 0, 'Sun Palace', 2500000, 17, 0, 0, 0, 0, 533, NULL, 0),
(3219, 0, -1, 1716524607, 0, 'Haggler\'s Hangout 3', 150000, 15, 0, 0, 0, 0, 186, NULL, 0),
(3220, 0, -1, 1716524607, 0, 'Haggler\'s Hangout 7', 200000, 15, 0, 0, 0, 0, 155, NULL, 0),
(3221, 0, -1, 1716524607, 0, 'Big Game Hunter\'s Lodge', 300000, 15, 0, 0, 0, 0, 164, NULL, 0),
(3222, 0, -1, 1716524607, 0, 'Haggler\'s Hangout 6', 200000, 15, 0, 0, 0, 0, 143, NULL, 0),
(3223, 0, -1, 1716524607, 0, 'Haggler\'s Hangout 5 (Shop)', 100000, 15, 0, 0, 0, 0, 42, NULL, 0),
(3224, 0, -1, 1716524607, 0, 'Haggler\'s Hangout 4b (Shop)', 75000, 15, 0, 0, 0, 0, 34, NULL, 0),
(3225, 0, -1, 1716524607, 0, 'Haggler\'s Hangout 4a (Shop)', 100000, 15, 0, 0, 0, 0, 44, NULL, 0),
(3226, 0, -1, 1716524607, 0, 'Haggler\'s Hangout 2', 50000, 15, 0, 0, 0, 0, 35, NULL, 0),
(3227, 0, -1, 1716524607, 0, 'Haggler\'s Hangout 1', 50000, 15, 0, 0, 0, 0, 37, NULL, 0),
(3228, 0, -1, 1716524607, 0, 'Bamboo Garden 3', 75000, 15, 0, 0, 0, 0, 44, NULL, 0),
(3229, 0, -1, 1716524607, 0, 'Bamboo Fortress', 250000, 15, 0, 0, 0, 0, 531, NULL, 0),
(3230, 0, -1, 1716524607, 0, 'Bamboo Garden 2', 40000, 15, 0, 0, 0, 0, 30, NULL, 0),
(3231, 0, -1, 1716524607, 0, 'Bamboo Garden 1', 50000, 15, 0, 0, 0, 0, 44, NULL, 0),
(3232, 0, -1, 1716524607, 0, 'Banana Bay 4', 12500, 15, 0, 0, 0, 0, 17, NULL, 0),
(3233, 0, -1, 1716524607, 0, 'Banana Bay 2', 25000, 15, 0, 0, 0, 0, 27, NULL, 0),
(3234, 0, -1, 1716524607, 0, 'Banana Bay 3', 25000, 15, 0, 0, 0, 0, 18, NULL, 0),
(3235, 0, -1, 1716524607, 0, 'Banana Bay 1', 12500, 15, 0, 0, 0, 0, 17, NULL, 0),
(3236, 0, -1, 1716524607, 0, 'Crocodile Bridge 1', 40000, 15, 0, 0, 0, 0, 29, NULL, 0),
(3237, 0, -1, 1716524607, 0, 'Crocodile Bridge 2', 40000, 15, 0, 0, 0, 0, 25, NULL, 0),
(3238, 0, -1, 1716524607, 0, 'Crocodile Bridge 3', 50000, 15, 0, 0, 0, 0, 34, NULL, 0),
(3239, 0, -1, 1716524607, 0, 'Crocodile Bridge 4', 150000, 15, 0, 0, 0, 0, 119, NULL, 0),
(3240, 0, -1, 1716524607, 0, 'Crocodile Bridge 5', 100000, 15, 0, 0, 0, 0, 102, NULL, 0),
(3241, 0, -1, 1716524607, 0, 'Woodway 1', 40000, 15, 0, 0, 0, 0, 18, NULL, 0),
(3242, 0, -1, 1716524607, 0, 'Woodway 2', 25000, 15, 0, 0, 0, 0, 17, NULL, 0),
(3243, 0, -1, 1716524607, 0, 'Woodway 3', 75000, 15, 0, 0, 0, 0, 42, NULL, 0),
(3244, 0, -1, 1716524607, 0, 'Woodway 4', 12500, 15, 0, 0, 0, 0, 17, NULL, 0),
(3245, 0, -1, 1716524607, 0, 'Flamingo Flats 5', 75000, 15, 0, 0, 0, 0, 53, NULL, 0),
(3246, 0, -1, 1716524607, 0, 'Flamingo Flats 4', 40000, 15, 0, 0, 0, 0, 23, NULL, 0),
(3247, 0, -1, 1716524607, 0, 'Flamingo Flats 1', 25000, 15, 0, 0, 0, 0, 19, NULL, 0),
(3248, 0, -1, 1716524607, 0, 'Flamingo Flats 2', 40000, 15, 0, 0, 0, 0, 28, NULL, 0),
(3249, 0, -1, 1716524607, 0, 'Flamingo Flats 3', 25000, 15, 0, 0, 0, 0, 20, NULL, 0),
(3250, 0, -1, 1716524607, 0, 'Jungle Edge 1', 100000, 15, 0, 0, 0, 0, 63, NULL, 0),
(3251, 0, -1, 1716524607, 0, 'Jungle Edge 2', 100000, 15, 0, 0, 0, 0, 89, NULL, 0),
(3252, 0, -1, 1716524607, 0, 'Jungle Edge 4', 40000, 15, 0, 0, 0, 0, 23, NULL, 0),
(3253, 0, -1, 1716524607, 0, 'Jungle Edge 5', 40000, 15, 0, 0, 0, 0, 27, NULL, 0),
(3254, 0, -1, 1716524607, 0, 'Jungle Edge 6', 12500, 15, 0, 0, 0, 0, 17, NULL, 0),
(3255, 0, -1, 1716524607, 0, 'Jungle Edge 3', 40000, 15, 0, 0, 0, 0, 27, NULL, 0),
(3256, 0, -1, 1716524607, 0, 'River Homes 3', 100000, 15, 0, 0, 0, 0, 111, NULL, 0),
(3257, 0, -1, 1716524607, 0, 'River Homes 2b', 75000, 15, 0, 0, 0, 0, 37, NULL, 0),
(3258, 0, -1, 1716524607, 0, 'River Homes 2a', 50000, 15, 0, 0, 0, 0, 33, NULL, 0),
(3259, 0, -1, 1716524607, 0, 'River Homes 1', 150000, 15, 0, 0, 0, 0, 96, NULL, 0),
(3260, 0, -1, 1716524607, 0, 'Coconut Quay 4', 75000, 15, 0, 0, 0, 0, 52, NULL, 0),
(3261, 0, -1, 1716524607, 0, 'Coconut Quay 3', 100000, 15, 0, 0, 0, 0, 50, NULL, 0),
(3262, 0, -1, 1716524607, 0, 'Coconut Quay 2', 50000, 15, 0, 0, 0, 0, 27, NULL, 0),
(3263, 0, -1, 1716524607, 0, 'Coconut Quay 1', 75000, 15, 0, 0, 0, 0, 47, NULL, 0),
(3264, 0, -1, 1716524607, 0, 'Shark Manor', 125000, 15, 0, 0, 0, 0, 173, NULL, 0),
(3265, 0, -1, 1716524607, 0, 'Glacier Side 2', 150000, 16, 0, 0, 0, 0, 102, NULL, 0),
(3266, 0, -1, 1716524607, 0, 'Glacier Side 1', 75000, 16, 0, 0, 0, 0, 34, NULL, 0),
(3267, 0, -1, 1716524607, 0, 'Glacier Side 3', 75000, 16, 0, 0, 0, 0, 41, NULL, 0),
(3268, 0, -1, 1716524607, 0, 'Glacier Side 4', 75000, 16, 0, 0, 0, 0, 46, NULL, 0),
(3269, 0, -1, 1716524607, 0, 'Shelf Site', 150000, 16, 0, 0, 0, 0, 98, NULL, 0),
(3270, 0, -1, 1716524607, 0, 'Spirit Homes 5', 75000, 16, 0, 0, 0, 0, 29, NULL, 0),
(3271, 0, -1, 1716524607, 0, 'Spirit Homes 4', 40000, 16, 0, 0, 0, 0, 24, NULL, 0);
INSERT INTO `houses` (`id`, `owner`, `new_owner`, `paid`, `warnings`, `name`, `rent`, `town_id`, `bid`, `bid_end`, `last_bid`, `highest_bidder`, `size`, `guildid`, `beds`) VALUES
(3272, 0, -1, 1716524607, 0, 'Spirit Homes 1', 75000, 16, 0, 0, 0, 0, 35, NULL, 0),
(3273, 0, -1, 1716524607, 0, 'Spirit Homes 2', 75000, 16, 0, 0, 0, 0, 39, NULL, 0),
(3274, 0, -1, 1716524607, 0, 'Spirit Homes 3', 150000, 16, 0, 0, 0, 0, 90, NULL, 0),
(3275, 0, -1, 1716524607, 0, 'Arena Walk 3', 150000, 16, 0, 0, 0, 0, 74, NULL, 0),
(3276, 0, -1, 1716524607, 0, 'Arena Walk 2', 75000, 16, 0, 0, 0, 0, 29, NULL, 0),
(3277, 0, -1, 1716524607, 0, 'Arena Walk 1', 150000, 16, 0, 0, 0, 0, 67, NULL, 0),
(3278, 0, -1, 1716524607, 0, 'Bears Paw 2', 150000, 16, 0, 0, 0, 0, 54, NULL, 0),
(3279, 0, -1, 1716524607, 0, 'Bears Paw 1', 100000, 16, 0, 0, 0, 0, 42, NULL, 0),
(3280, 0, -1, 1716524607, 0, 'Crystal Glance', 500000, 16, 0, 0, 0, 0, 321, NULL, 0),
(3281, 0, -1, 1716524607, 0, 'Shady Rocks 2', 100000, 16, 0, 0, 0, 0, 41, NULL, 0),
(3282, 0, -1, 1716524607, 0, 'Shady Rocks 1', 150000, 16, 0, 0, 0, 0, 79, NULL, 0),
(3283, 0, -1, 1716524607, 0, 'Shady Rocks 3', 150000, 16, 0, 0, 0, 0, 94, NULL, 0),
(3284, 0, -1, 1716524607, 0, 'Shady Rocks 4 (Shop)', 100000, 16, 0, 0, 0, 0, 61, NULL, 0),
(3285, 0, -1, 1716524607, 0, 'Shady Rocks 5', 150000, 16, 0, 0, 0, 0, 66, NULL, 0),
(3286, 0, -1, 1716524607, 0, 'Tusk Flats 2', 40000, 16, 0, 0, 0, 0, 28, NULL, 0),
(3287, 0, -1, 1716524607, 0, 'Tusk Flats 1', 40000, 16, 0, 0, 0, 0, 25, NULL, 0),
(3288, 0, -1, 1716524607, 0, 'Tusk Flats 3', 40000, 16, 0, 0, 0, 0, 26, NULL, 0),
(3289, 0, -1, 1716524607, 0, 'Tusk Flats 4', 12500, 16, 0, 0, 0, 0, 13, NULL, 0),
(3290, 0, -1, 1716524607, 0, 'Tusk Flats 6', 25000, 16, 0, 0, 0, 0, 23, NULL, 0),
(3291, 0, -1, 1716524607, 0, 'Tusk Flats 5', 12500, 16, 0, 0, 0, 0, 18, NULL, 0),
(3292, 0, -1, 1716524607, 0, 'Corner Shop (Shop)', 100000, 16, 0, 0, 0, 0, 50, NULL, 0),
(3293, 0, -1, 1716524607, 0, 'Bears Paw 5', 100000, 16, 0, 0, 0, 0, 45, NULL, 0),
(3294, 0, -1, 1716524607, 0, 'Bears Paw 4', 200000, 16, 0, 0, 0, 0, 119, NULL, 0),
(3295, 0, -1, 1716524607, 0, 'Trout Plaza 2', 75000, 16, 0, 0, 0, 0, 36, NULL, 0),
(3296, 0, -1, 1716524607, 0, 'Trout Plaza 1', 100000, 16, 0, 0, 0, 0, 56, NULL, 0),
(3297, 0, -1, 1716524607, 0, 'Trout Plaza 5 (Shop)', 150000, 16, 0, 0, 0, 0, 89, NULL, 0),
(3298, 0, -1, 1716524607, 0, 'Trout Plaza 3', 40000, 16, 0, 0, 0, 0, 22, NULL, 0),
(3299, 0, -1, 1716524607, 0, 'Trout Plaza 4', 40000, 16, 0, 0, 0, 0, 22, NULL, 0),
(3300, 0, -1, 1716524607, 0, 'Skiffs End 2', 40000, 16, 0, 0, 0, 0, 21, NULL, 0),
(3301, 0, -1, 1716524607, 0, 'Skiffs End 1', 50000, 16, 0, 0, 0, 0, 35, NULL, 0),
(3302, 0, -1, 1716524607, 0, 'Furrier Quarter 3', 50000, 16, 0, 0, 0, 0, 40, NULL, 0),
(3303, 0, -1, 1716524607, 0, 'Fimbul Shelf 4', 50000, 16, 0, 0, 0, 0, 42, NULL, 0),
(3304, 0, -1, 1716524607, 0, 'Fimbul Shelf 3', 50000, 16, 0, 0, 0, 0, 49, NULL, 0),
(3305, 0, -1, 1716524607, 0, 'Furrier Quarter 2', 40000, 16, 0, 0, 0, 0, 37, NULL, 0),
(3306, 0, -1, 1716524607, 0, 'Furrier Quarter 1', 75000, 16, 0, 0, 0, 0, 53, NULL, 0),
(3307, 0, -1, 1716524607, 0, 'Fimbul Shelf 2', 50000, 16, 0, 0, 0, 0, 43, NULL, 0),
(3308, 0, -1, 1716524607, 0, 'Fimbul Shelf 1', 40000, 16, 0, 0, 0, 0, 36, NULL, 0),
(3309, 0, -1, 1716524607, 0, 'Bears Paw 3', 100000, 16, 0, 0, 0, 0, 47, NULL, 0),
(3310, 0, -1, 1716524607, 0, 'Raven Corner 2', 75000, 16, 0, 0, 0, 0, 36, NULL, 0),
(3311, 0, -1, 1716524607, 0, 'Raven Corner 1', 40000, 16, 0, 0, 0, 0, 22, NULL, 0),
(3312, 0, -1, 1716524607, 0, 'Raven Corner 3', 50000, 16, 0, 0, 0, 0, 22, NULL, 0),
(3313, 0, -1, 1716524607, 0, 'Mammoth Belly', 500000, 16, 0, 0, 0, 0, 404, NULL, 0),
(3314, 0, -1, 1716524607, 0, 'Darashia 3, Flat 01', 75000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3315, 0, -1, 1716524607, 0, 'Darashia 3, Flat 05', 75000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3316, 0, -1, 1716524607, 0, 'Darashia 3, Flat 02', 100000, 13, 0, 0, 0, 0, 41, NULL, 0),
(3317, 0, -1, 1716524607, 0, 'Darashia 3, Flat 04', 75000, 13, 0, 0, 0, 0, 39, NULL, 0),
(3318, 0, -1, 1716524607, 0, 'Darashia 3, Flat 03', 75000, 13, 0, 0, 0, 0, 28, NULL, 0),
(3319, 0, -1, 1716524607, 0, 'Darashia 3, Flat 12', 100000, 13, 0, 0, 0, 0, 56, NULL, 0),
(3320, 0, -1, 1716524607, 0, 'Darashia 3, Flat 11', 50000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3321, 0, -1, 1716524607, 0, 'Darashia 3, Flat 14', 100000, 13, 0, 0, 0, 0, 59, NULL, 0),
(3322, 0, -1, 1716524607, 0, 'Darashia 3, Flat 13', 50000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3323, 0, -1, 1716524607, 0, 'Darashia 8, Flat 01', 150000, 13, 0, 0, 0, 0, 55, NULL, 0),
(3325, 0, -1, 1716524607, 0, 'Darashia 8, Flat 05', 150000, 13, 0, 0, 0, 0, 58, NULL, 0),
(3326, 0, -1, 1716524607, 0, 'Darashia 8, Flat 04', 100000, 13, 0, 0, 0, 0, 63, NULL, 0),
(3327, 0, -1, 1716524607, 0, 'Darashia 8, Flat 03', 150000, 13, 0, 0, 0, 0, 105, NULL, 0),
(3328, 0, -1, 1716524607, 0, 'Darashia 8, Flat 12', 75000, 13, 0, 0, 0, 0, 39, NULL, 0),
(3329, 0, -1, 1716524607, 0, 'Darashia 8, Flat 11', 100000, 13, 0, 0, 0, 0, 46, NULL, 0),
(3330, 0, -1, 1716524607, 0, 'Darashia 8, Flat 14', 75000, 13, 0, 0, 0, 0, 42, NULL, 0),
(3331, 0, -1, 1716524607, 0, 'Darashia 8, Flat 13', 75000, 13, 0, 0, 0, 0, 46, NULL, 0),
(3332, 0, -1, 1716524607, 0, 'Darashia, Villa', 400000, 13, 0, 0, 0, 0, 120, NULL, 0),
(3333, 0, -1, 1716524607, 0, 'Darashia, Eastern Guildhall', 500000, 13, 0, 0, 0, 0, 272, NULL, 0),
(3334, 0, -1, 1716524607, 0, 'Darashia, Western Guildhall', 250000, 13, 0, 0, 0, 0, 223, NULL, 0),
(3335, 0, -1, 1716524607, 0, 'Darashia 2, Flat 03', 50000, 13, 0, 0, 0, 0, 31, NULL, 0),
(3336, 0, -1, 1716524607, 0, 'Darashia 2, Flat 02', 50000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3337, 0, -1, 1716524607, 0, 'Darashia 2, Flat 01', 75000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3338, 0, -1, 1716524607, 0, 'Darashia 2, Flat 04', 40000, 13, 0, 0, 0, 0, 14, NULL, 0),
(3339, 0, -1, 1716524607, 0, 'Darashia 2, Flat 05', 75000, 13, 0, 0, 0, 0, 31, NULL, 0),
(3340, 0, -1, 1716524607, 0, 'Darashia 2, Flat 06', 40000, 13, 0, 0, 0, 0, 14, NULL, 0),
(3341, 0, -1, 1716524607, 0, 'Darashia 2, Flat 07', 75000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3342, 0, -1, 1716524607, 0, 'Darashia 2, Flat 13', 50000, 13, 0, 0, 0, 0, 31, NULL, 0),
(3343, 0, -1, 1716524607, 0, 'Darashia 2, Flat 14', 25000, 13, 0, 0, 0, 0, 14, NULL, 0),
(3344, 0, -1, 1716524607, 0, 'Darashia 2, Flat 15', 50000, 13, 0, 0, 0, 0, 30, NULL, 0),
(3345, 0, -1, 1716524607, 0, 'Darashia 2, Flat 16', 40000, 13, 0, 0, 0, 0, 18, NULL, 0),
(3346, 0, -1, 1716524607, 0, 'Darashia 2, Flat 17', 50000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3347, 0, -1, 1716524607, 0, 'Darashia 2, Flat 18', 50000, 13, 0, 0, 0, 0, 17, NULL, 0),
(3348, 0, -1, 1716524607, 0, 'Darashia 2, Flat 11', 50000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3349, 0, -1, 1716524607, 0, 'Darashia 2, Flat 12', 40000, 13, 0, 0, 0, 0, 13, NULL, 0),
(3350, 0, -1, 1716524607, 0, 'Darashia 1, Flat 03', 150000, 13, 0, 0, 0, 0, 65, NULL, 0),
(3351, 0, -1, 1716524607, 0, 'Darashia 1, Flat 04', 50000, 13, 0, 0, 0, 0, 28, NULL, 0),
(3352, 0, -1, 1716524607, 0, 'Darashia 1, Flat 02', 50000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3353, 0, -1, 1716524607, 0, 'Darashia 1, Flat 01', 50000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3354, 0, -1, 1716524607, 0, 'Darashia 1, Flat 05', 50000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3355, 0, -1, 1716524607, 0, 'Darashia 1, Flat 12', 75000, 13, 0, 0, 0, 0, 46, NULL, 0),
(3356, 0, -1, 1716524607, 0, 'Darashia 1, Flat 13', 75000, 13, 0, 0, 0, 0, 50, NULL, 0),
(3357, 0, -1, 1716524607, 0, 'Darashia 1, Flat 14', 100000, 13, 0, 0, 0, 0, 69, NULL, 0),
(3358, 0, -1, 1716524607, 0, 'Darashia 1, Flat 11', 50000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3359, 0, -1, 1716524607, 0, 'Darashia 5, Flat 02', 75000, 13, 0, 0, 0, 0, 41, NULL, 0),
(3360, 0, -1, 1716524607, 0, 'Darashia 5, Flat 01', 75000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3361, 0, -1, 1716524607, 0, 'Darashia 5, Flat 05', 50000, 13, 0, 0, 0, 0, 29, NULL, 0),
(3362, 0, -1, 1716524607, 0, 'Darashia 5, Flat 04', 75000, 13, 0, 0, 0, 0, 42, NULL, 0),
(3363, 0, -1, 1716524607, 0, 'Darashia 5, Flat 03', 75000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3364, 0, -1, 1716524607, 0, 'Darashia 5, Flat 11', 75000, 13, 0, 0, 0, 0, 46, NULL, 0),
(3365, 0, -1, 1716524607, 0, 'Darashia 5, Flat 12', 75000, 13, 0, 0, 0, 0, 39, NULL, 0),
(3366, 0, -1, 1716524607, 0, 'Darashia 5, Flat 13', 75000, 13, 0, 0, 0, 0, 42, NULL, 0),
(3367, 0, -1, 1716524607, 0, 'Darashia 5, Flat 14', 75000, 13, 0, 0, 0, 0, 38, NULL, 0),
(3368, 0, -1, 1716524607, 0, 'Darashia 6a', 150000, 13, 0, 0, 0, 0, 67, NULL, 0),
(3369, 0, -1, 1716524607, 0, 'Darashia 6b', 150000, 13, 0, 0, 0, 0, 80, NULL, 0),
(3370, 0, -1, 1716524607, 0, 'Darashia 4, Flat 02', 100000, 13, 0, 0, 0, 0, 44, NULL, 0),
(3371, 0, -1, 1716524607, 0, 'Darashia 4, Flat 03', 75000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3372, 0, -1, 1716524607, 0, 'Darashia 4, Flat 04', 100000, 13, 0, 0, 0, 0, 45, NULL, 0),
(3373, 0, -1, 1716524607, 0, 'Darashia 4, Flat 05', 75000, 13, 0, 0, 0, 0, 30, NULL, 0),
(3374, 0, -1, 1716524607, 0, 'Darashia 4, Flat 01', 50000, 13, 0, 0, 0, 0, 31, NULL, 0),
(3375, 0, -1, 1716524607, 0, 'Darashia 4, Flat 12', 100000, 13, 0, 0, 0, 0, 64, NULL, 0),
(3376, 0, -1, 1716524607, 0, 'Darashia 4, Flat 11', 50000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3377, 0, -1, 1716524607, 0, 'Darashia 4, Flat 13', 100000, 13, 0, 0, 0, 0, 44, NULL, 0),
(3378, 0, -1, 1716524607, 0, 'Darashia 4, Flat 14', 75000, 13, 0, 0, 0, 0, 46, NULL, 0),
(3379, 0, -1, 1716524607, 0, 'Darashia 7, Flat 01', 50000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3380, 0, -1, 1716524607, 0, 'Darashia 7, Flat 02', 50000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3381, 0, -1, 1716524607, 0, 'Darashia 7, Flat 03', 100000, 13, 0, 0, 0, 0, 65, NULL, 0),
(3382, 0, -1, 1716524607, 0, 'Darashia 7, Flat 05', 75000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3383, 0, -1, 1716524607, 0, 'Darashia 7, Flat 04', 75000, 13, 0, 0, 0, 0, 27, NULL, 0),
(3384, 0, -1, 1716524607, 0, 'Darashia 7, Flat 12', 100000, 13, 0, 0, 0, 0, 60, NULL, 0),
(3385, 0, -1, 1716524607, 0, 'Darashia 7, Flat 11', 50000, 13, 0, 0, 0, 0, 26, NULL, 0),
(3386, 0, -1, 1716524607, 0, 'Darashia 7, Flat 14', 100000, 13, 0, 0, 0, 0, 60, NULL, 0),
(3387, 0, -1, 1716524607, 0, 'Darashia 7, Flat 13', 50000, 13, 0, 0, 0, 0, 25, NULL, 0),
(3388, 0, -1, 1716524607, 0, 'Pirate Shipwreck 1', 400000, 13, 0, 0, 0, 0, 187, NULL, 0),
(3389, 0, -1, 1716524607, 0, 'Pirate Shipwreck 2', 400000, 13, 0, 0, 0, 0, 276, NULL, 0),
(3390, 0, -1, 1716524607, 0, 'The Shelter', 125000, 14, 0, 0, 0, 0, 422, NULL, 0),
(3391, 0, -1, 1716524607, 0, 'Litter Promenade 1', 12500, 14, 0, 0, 0, 0, 15, NULL, 0),
(3392, 0, -1, 1716524607, 0, 'Litter Promenade 2', 25000, 14, 0, 0, 0, 0, 14, NULL, 0),
(3394, 0, -1, 1716524607, 0, 'Litter Promenade 3', 12500, 14, 0, 0, 0, 0, 21, NULL, 0),
(3395, 0, -1, 1716524607, 0, 'Litter Promenade 4', 12500, 14, 0, 0, 0, 0, 18, NULL, 0),
(3396, 0, -1, 1716524607, 0, 'Rum Alley 3', 12500, 14, 0, 0, 0, 0, 18, NULL, 0),
(3397, 0, -1, 1716524607, 0, 'Straycat\'s Corner 5', 40000, 14, 0, 0, 0, 0, 25, NULL, 0),
(3398, 0, -1, 1716524607, 0, 'Straycat\'s Corner 6', 12500, 14, 0, 0, 0, 0, 13, NULL, 0),
(3399, 0, -1, 1716524607, 0, 'Litter Promenade 5', 12500, 14, 0, 0, 0, 0, 23, NULL, 0),
(3401, 0, -1, 1716524607, 0, 'Straycat\'s Corner 4', 25000, 14, 0, 0, 0, 0, 23, NULL, 0),
(3402, 0, -1, 1716524607, 0, 'Straycat\'s Corner 2', 25000, 14, 0, 0, 0, 0, 27, NULL, 0),
(3403, 0, -1, 1716524607, 0, 'Straycat\'s Corner 1', 12500, 14, 0, 0, 0, 0, 14, NULL, 0),
(3404, 0, -1, 1716524607, 0, 'Rum Alley 2', 12500, 14, 0, 0, 0, 0, 18, NULL, 0),
(3405, 0, -1, 1716524607, 0, 'Rum Alley 1', 12500, 14, 0, 0, 0, 0, 25, NULL, 0),
(3406, 0, -1, 1716524607, 0, 'Smuggler Backyard 3', 25000, 14, 0, 0, 0, 0, 27, NULL, 0),
(3407, 0, -1, 1716524607, 0, 'Shady Trail 3', 12500, 14, 0, 0, 0, 0, 16, NULL, 0),
(3408, 0, -1, 1716524607, 0, 'Shady Trail 1', 50000, 14, 0, 0, 0, 0, 34, NULL, 0),
(3409, 0, -1, 1716524607, 0, 'Shady Trail 2', 12500, 14, 0, 0, 0, 0, 19, NULL, 0),
(3410, 0, -1, 1716524607, 0, 'Smuggler Backyard 4', 12500, 14, 0, 0, 0, 0, 22, NULL, 0),
(3411, 0, -1, 1716524607, 0, 'Smuggler Backyard 2', 12500, 14, 0, 0, 0, 0, 31, NULL, 0),
(3412, 0, -1, 1716524607, 0, 'Smuggler Backyard 1', 12500, 14, 0, 0, 0, 0, 27, NULL, 0),
(3413, 0, -1, 1716524607, 0, 'Smuggler Backyard 5', 12500, 14, 0, 0, 0, 0, 25, NULL, 0),
(3414, 0, -1, 1716524607, 0, 'Sugar Street 1', 100000, 14, 0, 0, 0, 0, 60, NULL, 0),
(3415, 0, -1, 1716524607, 0, 'Sugar Street 2', 75000, 14, 0, 0, 0, 0, 51, NULL, 0),
(3416, 0, -1, 1716524607, 0, 'Sugar Street 3a', 50000, 14, 0, 0, 0, 0, 33, NULL, 0),
(3417, 0, -1, 1716524607, 0, 'Sugar Street 3b', 75000, 14, 0, 0, 0, 0, 41, NULL, 0),
(3418, 0, -1, 1716524607, 0, 'Sugar Street 4d', 25000, 14, 0, 0, 0, 0, 15, NULL, 0),
(3419, 0, -1, 1716524607, 0, 'Sugar Street 4c', 12500, 14, 0, 0, 0, 0, 14, NULL, 0),
(3420, 0, -1, 1716524607, 0, 'Sugar Street 4b', 50000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3421, 0, -1, 1716524607, 0, 'Sugar Street 4a', 40000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3422, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 01', 25000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3423, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 03', 25000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3424, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 05', 25000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3425, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 06', 25000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3426, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 04', 25000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3427, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 02', 25000, 14, 0, 0, 0, 0, 17, NULL, 0),
(3428, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 07', 40000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3429, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 09', 25000, 14, 0, 0, 0, 0, 18, NULL, 0),
(3430, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 11', 12500, 14, 0, 0, 0, 0, 19, NULL, 0),
(3431, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 08', 25000, 14, 0, 0, 0, 0, 19, NULL, 0),
(3432, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 10', 25000, 14, 0, 0, 0, 0, 18, NULL, 0),
(3433, 0, -1, 1716524607, 0, 'Harvester\'s Haven, Flat 12', 12500, 14, 0, 0, 0, 0, 19, NULL, 0),
(3434, 0, -1, 1716524607, 0, 'Marble Lane 3', 300000, 14, 0, 0, 0, 0, 163, NULL, 0),
(3435, 0, -1, 1716524607, 0, 'Marble Lane 2', 200000, 14, 0, 0, 0, 0, 141, NULL, 0),
(3436, 0, -1, 1716524607, 0, 'Marble Lane 4', 200000, 14, 0, 0, 0, 0, 134, NULL, 0),
(3437, 0, -1, 1716524607, 0, 'Admiral\'s Avenue 1', 200000, 14, 0, 0, 0, 0, 97, NULL, 0),
(3438, 0, -1, 1716524607, 0, 'Admiral\'s Avenue 2', 200000, 14, 0, 0, 0, 0, 111, NULL, 0),
(3439, 0, -1, 1716524607, 0, 'Admiral\'s Avenue 3', 150000, 14, 0, 0, 0, 0, 99, NULL, 0),
(3440, 0, -1, 1716524607, 0, 'Ivory Circle 1', 200000, 14, 0, 0, 0, 0, 101, NULL, 0),
(3441, 0, -1, 1716524607, 0, 'Sugar Street 5', 75000, 14, 0, 0, 0, 0, 25, NULL, 0),
(3442, 0, -1, 1716524607, 0, 'Freedom Street 1', 100000, 14, 0, 0, 0, 0, 47, NULL, 0),
(3443, 0, -1, 1716524607, 0, 'Trader\'s Point 1', 100000, 14, 0, 0, 0, 0, 42, NULL, 0),
(3444, 0, -1, 1716524607, 0, 'Trader\'s Point 2 (Shop)', 300000, 14, 0, 0, 0, 0, 122, NULL, 0),
(3445, 0, -1, 1716524607, 0, 'Trader\'s Point 3 (Shop)', 300000, 14, 0, 0, 0, 0, 130, NULL, 0),
(3446, 0, -1, 1716524607, 0, 'Ivory Mansion', 400000, 14, 0, 0, 0, 0, 319, NULL, 0),
(3447, 0, -1, 1716524607, 0, 'Ivory Circle 2', 200000, 14, 0, 0, 0, 0, 142, NULL, 0),
(3448, 0, -1, 1716524607, 0, 'Ivy Cottage', 250000, 14, 0, 0, 0, 0, 587, NULL, 0),
(3449, 0, -1, 1716524607, 0, 'Marble Lane 1', 300000, 14, 0, 0, 0, 0, 228, NULL, 0),
(3450, 0, -1, 1716524607, 0, 'Freedom Street 2', 200000, 14, 0, 0, 0, 0, 123, NULL, 0),
(3452, 0, -1, 1716524607, 0, 'Meriana Beach', 75000, 14, 0, 0, 0, 0, 172, NULL, 0),
(3453, 0, -1, 1716524607, 0, 'The Tavern 1a', 75000, 14, 0, 0, 0, 0, 52, NULL, 0),
(3454, 0, -1, 1716524607, 0, 'The Tavern 1b', 50000, 14, 0, 0, 0, 0, 38, NULL, 0),
(3455, 0, -1, 1716524607, 0, 'The Tavern 1c', 100000, 14, 0, 0, 0, 0, 85, NULL, 0),
(3456, 0, -1, 1716524607, 0, 'The Tavern 1d', 50000, 14, 0, 0, 0, 0, 33, NULL, 0),
(3457, 0, -1, 1716524607, 0, 'The Tavern 2a', 150000, 14, 0, 0, 0, 0, 111, NULL, 0),
(3458, 0, -1, 1716524607, 0, 'The Tavern 2b', 50000, 14, 0, 0, 0, 0, 36, NULL, 0),
(3459, 0, -1, 1716524607, 0, 'The Tavern 2d', 50000, 14, 0, 0, 0, 0, 27, NULL, 0),
(3460, 0, -1, 1716524607, 0, 'The Tavern 2c', 25000, 14, 0, 0, 0, 0, 20, NULL, 0),
(3461, 0, -1, 1716524607, 0, 'The Yeah Beach Project', 75000, 14, 0, 0, 0, 0, 157, NULL, 0),
(3462, 0, -1, 1716524607, 0, 'Mountain Hideout', 250000, 14, 0, 0, 0, 0, 321, NULL, 0),
(3463, 0, -1, 1716524607, 0, 'Darashia 8, Flat 02', 150000, 13, 0, 0, 0, 0, 76, NULL, 0),
(3464, 0, -1, 1716524607, 0, 'Castle, Basement, Flat 01', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3465, 0, -1, 1716524607, 0, 'Castle, Basement, Flat 02', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3466, 0, -1, 1716524607, 0, 'Castle, Basement, Flat 03', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3467, 0, -1, 1716524607, 0, 'Castle, Basement, Flat 05', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3468, 0, -1, 1716524607, 0, 'Castle, Basement, Flat 04', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3469, 0, -1, 1716524607, 0, 'Castle, Basement, Flat 06', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3470, 0, -1, 1716524607, 0, 'Castle, Basement, Flat 07', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3471, 0, -1, 1716524607, 0, 'Castle, Basement, Flat 09', 12500, 11, 0, 0, 0, 0, 13, NULL, 0),
(3472, 0, -1, 1716524607, 0, 'Castle, Basement, Flat 08', 25000, 11, 0, 0, 0, 0, 13, NULL, 0),
(3473, 0, -1, 1716524607, 0, 'Cormaya 1', 75000, 11, 0, 0, 0, 0, 30, NULL, 0),
(3474, 0, -1, 1716524607, 0, 'Cormaya Flats, Flat 01', 12500, 11, 0, 0, 0, 0, 11, NULL, 0),
(3475, 0, -1, 1716524607, 0, 'Cormaya Flats, Flat 02', 12500, 11, 0, 0, 0, 0, 11, NULL, 0),
(3476, 0, -1, 1716524607, 0, 'Cormaya Flats, Flat 03', 25000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3477, 0, -1, 1716524607, 0, 'Cormaya Flats, Flat 06', 12500, 11, 0, 0, 0, 0, 11, NULL, 0),
(3478, 0, -1, 1716524607, 0, 'Cormaya Flats, Flat 05', 12500, 11, 0, 0, 0, 0, 11, NULL, 0),
(3479, 0, -1, 1716524607, 0, 'Cormaya Flats, Flat 04', 25000, 11, 0, 0, 0, 0, 17, NULL, 0),
(3480, 0, -1, 1716524607, 0, 'Cormaya Flats, Flat 11', 50000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3482, 0, -1, 1716524607, 0, 'Cormaya Flats, Flat 13', 12500, 11, 0, 0, 0, 0, 17, NULL, 0),
(3483, 0, -1, 1716524607, 0, 'Cormaya Flats, Flat 12', 50000, 11, 0, 0, 0, 0, 24, NULL, 0),
(3485, 0, -1, 1716524607, 0, 'Cormaya Flats, Flat 14', 12500, 11, 0, 0, 0, 0, 17, NULL, 0),
(3486, 0, -1, 1716524607, 0, 'Cormaya 2', 150000, 11, 0, 0, 0, 0, 84, NULL, 0),
(3487, 0, -1, 1716524607, 0, 'Cormaya 4', 75000, 11, 0, 0, 0, 0, 39, NULL, 0),
(3488, 0, -1, 1716524607, 0, 'Cormaya 3', 100000, 11, 0, 0, 0, 0, 47, NULL, 0),
(3489, 0, -1, 1716524607, 0, 'Cormaya 6', 100000, 11, 0, 0, 0, 0, 56, NULL, 0),
(3490, 0, -1, 1716524607, 0, 'Cormaya 7', 100000, 11, 0, 0, 0, 0, 54, NULL, 0),
(3491, 0, -1, 1716524607, 0, 'Cormaya 8', 100000, 11, 0, 0, 0, 0, 65, NULL, 0),
(3492, 0, -1, 1716524607, 0, 'Cormaya 5', 150000, 11, 0, 0, 0, 0, 123, NULL, 0),
(3493, 0, -1, 1716524607, 0, 'Castle of the White Dragon', 500000, 11, 0, 0, 0, 0, 532, NULL, 0),
(3494, 0, -1, 1716524607, 0, 'Cormaya 9b', 75000, 11, 0, 0, 0, 0, 58, NULL, 0),
(3495, 0, -1, 1716524607, 0, 'Cormaya 9a', 40000, 11, 0, 0, 0, 0, 28, NULL, 0),
(3496, 0, -1, 1716524607, 0, 'Cormaya 9d', 75000, 11, 0, 0, 0, 0, 60, NULL, 0),
(3497, 0, -1, 1716524607, 0, 'Cormaya 9c', 40000, 11, 0, 0, 0, 0, 28, NULL, 0),
(3498, 0, -1, 1716524607, 0, 'Cormaya 10', 150000, 11, 0, 0, 0, 0, 85, NULL, 0),
(3499, 0, -1, 1716524607, 0, 'Cormaya 11', 75000, 11, 0, 0, 0, 0, 47, NULL, 0),
(3500, 0, -1, 1716524607, 0, 'Edron Flats, Flat 22', 25000, 11, 0, 0, 0, 0, 12, NULL, 0),
(3501, 0, -1, 1716524607, 0, 'Magic Academy, Shop', 75000, 11, 0, 0, 0, 0, 23, NULL, 0),
(3502, 0, -1, 1716524607, 0, 'Magic Academy, Flat 1', 50000, 11, 0, 0, 0, 0, 23, NULL, 0),
(3503, 0, -1, 1716524607, 0, 'Magic Academy, Guild', 250000, 11, 0, 0, 0, 0, 195, NULL, 0),
(3504, 0, -1, 1716524607, 0, 'Magic Academy, Flat 2', 40000, 11, 0, 0, 0, 0, 26, NULL, 0),
(3505, 0, -1, 1716524607, 0, 'Magic Academy, Flat 3', 50000, 11, 0, 0, 0, 0, 26, NULL, 0),
(3506, 0, -1, 1716524607, 0, 'Magic Academy, Flat 4', 50000, 11, 0, 0, 0, 0, 26, NULL, 0),
(3507, 0, -1, 1716524607, 0, 'Magic Academy, Flat 5', 40000, 11, 0, 0, 0, 0, 26, NULL, 0),
(3508, 0, -1, 1716524607, 0, 'Oskahl I f', 50000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3509, 0, -1, 1716524607, 0, 'Oskahl I g', 50000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3510, 0, -1, 1716524607, 0, 'Oskahl I h', 75000, 10, 0, 0, 0, 0, 39, NULL, 0),
(3511, 0, -1, 1716524607, 0, 'Oskahl I i', 40000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3512, 0, -1, 1716524607, 0, 'Oskahl I j', 40000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3513, 0, -1, 1716524607, 0, 'Oskahl I b', 40000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3514, 0, -1, 1716524607, 0, 'Oskahl I d', 50000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3515, 0, -1, 1716524607, 0, 'Oskahl I e', 40000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3516, 0, -1, 1716524607, 0, 'Oskahl I c', 40000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3517, 0, -1, 1716524607, 0, 'Chameken I', 50000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3518, 0, -1, 1716524607, 0, 'Chameken II', 40000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3519, 0, -1, 1716524607, 0, 'Charsirakh III', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3520, 0, -1, 1716524607, 0, 'Charsirakh II', 50000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3521, 0, -1, 1716524607, 0, 'Murkhol I a', 40000, 10, 0, 0, 0, 0, 23, NULL, 0),
(3523, 0, -1, 1716524607, 0, 'Murkhol I c', 25000, 10, 0, 0, 0, 0, 11, NULL, 0),
(3524, 0, -1, 1716524607, 0, 'Murkhol I b', 25000, 10, 0, 0, 0, 0, 11, NULL, 0),
(3525, 0, -1, 1716524607, 0, 'Charsirakh I b', 75000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3526, 0, -1, 1716524607, 0, 'Harrah I', 125000, 10, 0, 0, 0, 0, 124, NULL, 0),
(3527, 0, -1, 1716524607, 0, 'Thanah I d', 100000, 10, 0, 0, 0, 0, 52, NULL, 0),
(3528, 0, -1, 1716524607, 0, 'Thanah I c', 100000, 10, 0, 0, 0, 0, 61, NULL, 0),
(3529, 0, -1, 1716524607, 0, 'Thanah I b', 75000, 10, 0, 0, 0, 0, 56, NULL, 0),
(3530, 0, -1, 1716524607, 0, 'Thanah I a', 12500, 10, 0, 0, 0, 0, 17, NULL, 0),
(3531, 0, -1, 1716524607, 0, 'Othehothep I c', 75000, 10, 0, 0, 0, 0, 38, NULL, 0),
(3532, 0, -1, 1716524607, 0, 'Othehothep I d', 75000, 10, 0, 0, 0, 0, 43, NULL, 0),
(3533, 0, -1, 1716524607, 0, 'Othehothep I b', 50000, 10, 0, 0, 0, 0, 32, NULL, 0),
(3534, 0, -1, 1716524607, 0, 'Othehothep II c', 40000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3535, 0, -1, 1716524607, 0, 'Othehothep II d', 40000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3536, 0, -1, 1716524607, 0, 'Othehothep II e', 75000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3537, 0, -1, 1716524607, 0, 'Othehothep II f', 50000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3538, 0, -1, 1716524607, 0, 'Othehothep II b', 75000, 10, 0, 0, 0, 0, 43, NULL, 0),
(3539, 0, -1, 1716524607, 0, 'Othehothep II a', 12500, 10, 0, 0, 0, 0, 10, NULL, 0),
(3540, 0, -1, 1716524607, 0, 'Mothrem I', 40000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3541, 0, -1, 1716524607, 0, 'Arakmehn I', 50000, 10, 0, 0, 0, 0, 28, NULL, 0),
(3542, 0, -1, 1716524607, 0, 'Arakmehn II', 40000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3543, 0, -1, 1716524607, 0, 'Arakmehn III', 50000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3544, 0, -1, 1716524607, 0, 'Arakmehn IV', 50000, 10, 0, 0, 0, 0, 28, NULL, 0),
(3545, 0, -1, 1716524607, 0, 'Unklath II b', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3546, 0, -1, 1716524607, 0, 'Unklath II c', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3547, 0, -1, 1716524607, 0, 'Unklath II d', 50000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3548, 0, -1, 1716524607, 0, 'Unklath II a', 25000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3549, 0, -1, 1716524607, 0, 'Rathal I b', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3550, 0, -1, 1716524607, 0, 'Rathal I c', 12500, 10, 0, 0, 0, 0, 17, NULL, 0),
(3551, 0, -1, 1716524607, 0, 'Rathal I d', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3552, 0, -1, 1716524607, 0, 'Rathal I e', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3553, 0, -1, 1716524607, 0, 'Rathal I a', 40000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3554, 0, -1, 1716524607, 0, 'Rathal II b', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3555, 0, -1, 1716524607, 0, 'Rathal II c', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3556, 0, -1, 1716524607, 0, 'Rathal II d', 50000, 10, 0, 0, 0, 0, 34, NULL, 0),
(3557, 0, -1, 1716524607, 0, 'Rathal II a', 40000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3558, 0, -1, 1716524607, 0, 'Esuph I', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3559, 0, -1, 1716524607, 0, 'Esuph II b', 50000, 10, 0, 0, 0, 0, 32, NULL, 0),
(3560, 0, -1, 1716524607, 0, 'Esuph II a', 12500, 10, 0, 0, 0, 0, 7, NULL, 0),
(3561, 0, -1, 1716524607, 0, 'Esuph III b', 50000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3562, 0, -1, 1716524607, 0, 'Esuph III a', 12500, 10, 0, 0, 0, 0, 7, NULL, 0),
(3564, 0, -1, 1716524607, 0, 'Esuph IV c', 40000, 10, 0, 0, 0, 0, 23, NULL, 0),
(3565, 0, -1, 1716524607, 0, 'Esuph IV d', 12500, 10, 0, 0, 0, 0, 20, NULL, 0),
(3566, 0, -1, 1716524607, 0, 'Esuph IV a', 12500, 10, 0, 0, 0, 0, 10, NULL, 0),
(3567, 0, -1, 1716524607, 0, 'Horakhal', 125000, 10, 0, 0, 0, 0, 205, NULL, 0),
(3568, 0, -1, 1716524607, 0, 'Botham II d', 50000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3569, 0, -1, 1716524607, 0, 'Botham II e', 50000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3570, 0, -1, 1716524607, 0, 'Botham II f', 40000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3571, 0, -1, 1716524607, 0, 'Botham II g', 40000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3572, 0, -1, 1716524607, 0, 'Botham II c', 50000, 10, 0, 0, 0, 0, 23, NULL, 0),
(3573, 0, -1, 1716524607, 0, 'Botham II b', 50000, 10, 0, 0, 0, 0, 30, NULL, 0),
(3574, 0, -1, 1716524607, 0, 'Botham II a', 12500, 10, 0, 0, 0, 0, 17, NULL, 0),
(3575, 0, -1, 1716524607, 0, 'Botham III f', 75000, 10, 0, 0, 0, 0, 43, NULL, 0),
(3576, 0, -1, 1716524607, 0, 'Botham III h', 100000, 10, 0, 0, 0, 0, 71, NULL, 0),
(3577, 0, -1, 1716524607, 0, 'Botham III g', 50000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3578, 0, -1, 1716524607, 0, 'Botham III b', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3579, 0, -1, 1716524607, 0, 'Botham III c', 12500, 10, 0, 0, 0, 0, 17, NULL, 0),
(3581, 0, -1, 1716524607, 0, 'Botham III e', 50000, 10, 0, 0, 0, 0, 38, NULL, 0),
(3582, 0, -1, 1716524607, 0, 'Botham III a', 40000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3583, 0, -1, 1716524607, 0, 'Botham IV f', 50000, 10, 0, 0, 0, 0, 32, NULL, 0),
(3584, 0, -1, 1716524607, 0, 'Botham IV h', 50000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3585, 0, -1, 1716524607, 0, 'Botham IV i', 75000, 10, 0, 0, 0, 0, 32, NULL, 0),
(3586, 0, -1, 1716524607, 0, 'Botham IV g', 50000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3587, 0, -1, 1716524607, 0, 'Botham IV e', 50000, 10, 0, 0, 0, 0, 85, NULL, 0),
(3591, 0, -1, 1716524607, 0, 'Botham IV a', 50000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3592, 0, -1, 1716524607, 0, 'Ramen Tah', 125000, 10, 0, 0, 0, 0, 125, NULL, 0),
(3593, 0, -1, 1716524607, 0, 'Botham I c', 75000, 10, 0, 0, 0, 0, 32, NULL, 0),
(3594, 0, -1, 1716524607, 0, 'Botham I e', 40000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3595, 0, -1, 1716524607, 0, 'Botham I d', 75000, 10, 0, 0, 0, 0, 57, NULL, 0),
(3596, 0, -1, 1716524607, 0, 'Botham I b', 75000, 10, 0, 0, 0, 0, 56, NULL, 0),
(3597, 0, -1, 1716524607, 0, 'Botham I a', 25000, 10, 0, 0, 0, 0, 19, NULL, 0),
(3598, 0, -1, 1716524607, 0, 'Charsirakh I a', 12500, 10, 0, 0, 0, 0, 7, NULL, 0),
(3599, 0, -1, 1716524607, 0, 'Low Waters Observatory', 200000, 10, 0, 0, 0, 0, 525, NULL, 0),
(3600, 0, -1, 1716524607, 0, 'Oskahl I a', 75000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3601, 0, -1, 1716524607, 0, 'Othehothep I a', 12500, 10, 0, 0, 0, 0, 7, NULL, 0),
(3602, 0, -1, 1716524607, 0, 'Othehothep III a', 12500, 10, 0, 0, 0, 0, 7, NULL, 0),
(3603, 0, -1, 1716524607, 0, 'Othehothep III b', 40000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3604, 0, -1, 1716524607, 0, 'Othehothep III c', 40000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3605, 0, -1, 1716524607, 0, 'Othehothep III d', 40000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3606, 0, -1, 1716524607, 0, 'Othehothep III e', 25000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3607, 0, -1, 1716524607, 0, 'Othehothep III f', 25000, 10, 0, 0, 0, 0, 17, NULL, 0),
(3608, 0, -1, 1716524607, 0, 'Unklath I f', 50000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3609, 0, -1, 1716524607, 0, 'Unklath I g', 50000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3610, 0, -1, 1716524607, 0, 'Unklath I d', 75000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3611, 0, -1, 1716524607, 0, 'Unklath I e', 75000, 10, 0, 0, 0, 0, 37, NULL, 0),
(3612, 0, -1, 1716524607, 0, 'Unklath I b', 50000, 10, 0, 0, 0, 0, 34, NULL, 0),
(3613, 0, -1, 1716524607, 0, 'Unklath I c', 50000, 10, 0, 0, 0, 0, 34, NULL, 0),
(3614, 0, -1, 1716524607, 0, 'Unklath I a', 50000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3615, 0, -1, 1716524607, 0, 'Thanah II a', 12500, 10, 0, 0, 0, 0, 17, NULL, 0),
(3616, 0, -1, 1716524607, 0, 'Thanah II b', 25000, 10, 0, 0, 0, 0, 9, NULL, 0),
(3617, 0, -1, 1716524607, 0, 'Thanah II d', 25000, 10, 0, 0, 0, 0, 7, NULL, 0),
(3618, 0, -1, 1716524607, 0, 'Thanah II e', 12500, 10, 0, 0, 0, 0, 7, NULL, 0),
(3619, 0, -1, 1716524607, 0, 'Thanah II c', 12500, 10, 0, 0, 0, 0, 9, NULL, 0),
(3620, 0, -1, 1716524607, 0, 'Thanah II f', 75000, 10, 0, 0, 0, 0, 53, NULL, 0),
(3621, 0, -1, 1716524607, 0, 'Thanah II g', 50000, 10, 0, 0, 0, 0, 31, NULL, 0),
(3622, 0, -1, 1716524607, 0, 'Thanah II h', 50000, 10, 0, 0, 0, 0, 26, NULL, 0),
(3623, 0, -1, 1716524607, 0, 'Thrarhor I a (Shop)', 25000, 10, 0, 0, 0, 0, 15, NULL, 0),
(3624, 0, -1, 1716524607, 0, 'Thrarhor I c (Shop)', 25000, 10, 0, 0, 0, 0, 15, NULL, 0),
(3625, 0, -1, 1716524607, 0, 'Thrarhor I d (Shop)', 40000, 10, 0, 0, 0, 0, 15, NULL, 0),
(3626, 0, -1, 1716524607, 0, 'Thrarhor I b (Shop)', 25000, 10, 0, 0, 0, 0, 15, NULL, 0),
(3627, 0, -1, 1716524607, 0, 'Uthemath I a', 12500, 10, 0, 0, 0, 0, 10, NULL, 0),
(3628, 0, -1, 1716524607, 0, 'Uthemath I b', 25000, 10, 0, 0, 0, 0, 20, NULL, 0),
(3629, 0, -1, 1716524607, 0, 'Uthemath I c', 40000, 10, 0, 0, 0, 0, 20, NULL, 0),
(3630, 0, -1, 1716524607, 0, 'Uthemath I d', 40000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3631, 0, -1, 1716524607, 0, 'Uthemath I e', 40000, 10, 0, 0, 0, 0, 21, NULL, 0),
(3632, 0, -1, 1716524607, 0, 'Uthemath I f', 75000, 10, 0, 0, 0, 0, 56, NULL, 0),
(3633, 0, -1, 1716524607, 0, 'Uthemath II', 125000, 10, 0, 0, 0, 0, 93, NULL, 0),
(3634, 0, -1, 1716524607, 0, 'Marketplace 1', 200000, 22, 0, 0, 0, 0, 79, NULL, 0),
(3635, 0, -1, 1716524607, 0, 'Marketplace 2', 200000, 22, 0, 0, 0, 0, 92, NULL, 0),
(3636, 0, -1, 1716524607, 0, 'Quay 1', 100000, 22, 0, 0, 0, 0, 81, NULL, 0),
(3637, 0, -1, 1716524607, 0, 'Quay 2', 100000, 22, 0, 0, 0, 0, 130, NULL, 0),
(3638, 0, -1, 1716524607, 0, 'Halls of Sun and Sea', 500000, 22, 0, 0, 0, 0, 423, NULL, 0),
(3639, 0, -1, 1716524607, 0, 'Palace Vicinity', 100000, 22, 0, 0, 0, 0, 132, NULL, 0),
(3640, 0, -1, 1716524607, 0, 'Wave Tower', 200000, 22, 0, 0, 0, 0, 212, NULL, 0),
(3641, 0, -1, 1716524607, 0, 'Old Sanctuary of God King Qjell', 150000, 18, 0, 0, 0, 0, 699, NULL, 0),
(3642, 0, -1, 1716524607, 0, 'Old Heritage Estate', 300000, 20, 0, 0, 0, 0, 335, NULL, 0),
(3643, 0, -1, 1716524607, 0, 'Rathleton Plaza 4', 200000, 20, 0, 0, 0, 0, 144, NULL, 0),
(3644, 0, -1, 1716524607, 0, 'Rathleton Plaza 3', 200000, 20, 0, 0, 0, 0, 157, NULL, 0),
(3645, 0, -1, 1716524607, 0, 'Rathleton Plaza 2', 200000, 20, 0, 0, 0, 0, 77, NULL, 0),
(3646, 0, -1, 1716524607, 0, 'Rathleton Plaza 1', 150000, 20, 0, 0, 0, 0, 80, NULL, 0),
(3647, 0, -1, 1716524607, 0, 'Antimony Lane 2', 200000, 20, 0, 0, 0, 0, 127, NULL, 0),
(3648, 0, -1, 1716524607, 0, 'Antimony Lane 1', 200000, 20, 0, 0, 0, 0, 189, NULL, 0),
(3649, 0, -1, 1716524607, 0, 'Wallside Residence', 200000, 20, 0, 0, 0, 0, 182, NULL, 0),
(3650, 0, -1, 1716524607, 0, 'Wallside Lane 1', 400000, 20, 0, 0, 0, 0, 216, NULL, 0),
(3651, 0, -1, 1716524607, 0, 'Wallside Lane 2', 300000, 20, 0, 0, 0, 0, 227, NULL, 0),
(3652, 0, -1, 1716524607, 0, 'Vanward Flats B', 200000, 20, 0, 0, 0, 0, 179, NULL, 0),
(3653, 0, -1, 1716524607, 0, 'Vanward Flats A', 200000, 20, 0, 0, 0, 0, 189, NULL, 0),
(3654, 0, -1, 1716524607, 0, 'Bronze Brothers Bastion', 2500000, 20, 0, 0, 0, 0, 976, NULL, 0),
(3655, 0, -1, 1716524607, 0, 'Cistern Ave', 150000, 20, 0, 0, 0, 0, 111, NULL, 0),
(3656, 0, -1, 1716524607, 0, 'Antimony Lane 4', 200000, 20, 0, 0, 0, 0, 159, NULL, 0),
(3657, 0, -1, 1716524607, 0, 'Antimony Lane 3', 200000, 20, 0, 0, 0, 0, 101, NULL, 0),
(3658, 0, -1, 1716524607, 0, 'Rathleton Hills Residence', 200000, 20, 0, 0, 0, 0, 186, NULL, 0),
(3659, 0, -1, 1716524607, 0, 'Rathleton Hills Estate', 500000, 20, 0, 0, 0, 0, 534, NULL, 0),
(3660, 0, -1, 1716524607, 0, 'Lion\'s Head Reef', 200000, 25, 0, 0, 0, 0, 166, NULL, 0),
(3661, 0, -1, 1716524607, 0, 'Shadow Caves 1', 25000, 5, 0, 0, 0, 0, 32, NULL, 0),
(3662, 0, -1, 1716524607, 0, 'Shadow Caves 2', 25000, 5, 0, 0, 0, 0, 37, NULL, 0),
(3663, 0, -1, 1716524607, 0, 'Shadow Caves 3', 50000, 5, 0, 0, 0, 0, 61, NULL, 0),
(3664, 0, -1, 1716524607, 0, 'Shadow Caves 4', 50000, 5, 0, 0, 0, 0, 53, NULL, 0),
(3665, 0, -1, 1716524607, 0, 'Shadow Caves 5', 50000, 5, 0, 0, 0, 0, 61, NULL, 0),
(3666, 0, -1, 1716524607, 0, 'Shadow Caves 6', 50000, 5, 0, 0, 0, 0, 50, NULL, 0),
(3667, 0, -1, 1716524607, 0, 'Northport Clanhall', 125000, 6, 0, 0, 0, 0, 172, NULL, 0),
(3668, 0, -1, 1716524607, 0, 'The Treehouse', 125000, 15, 0, 0, 0, 0, 972, NULL, 0),
(3669, 0, -1, 1716524607, 0, 'Frost Manor', 250000, 16, 0, 0, 0, 0, 505, NULL, 0),
(3670, 0, -1, 1716524607, 0, 'Hare\'s Den', 75000, 7, 0, 0, 0, 0, 304, NULL, 0),
(3671, 0, -1, 1716524607, 0, 'Lost Cavern', 100000, 7, 0, 0, 0, 0, 705, NULL, 0),
(3673, 0, -1, 1716524607, 0, 'Caveman Shelter', 75000, 12, 0, 0, 0, 0, 137, NULL, 0),
(3674, 0, -1, 1716524607, 0, 'Eastern House of Tranquility', 100000, 12, 0, 0, 0, 0, 313, NULL, 0),
(3675, 0, -1, 1716524607, 0, 'Lakeside Mansion', 150000, 16, 0, 0, 0, 0, 136, NULL, 0),
(3676, 0, -1, 1716524607, 0, 'Pilchard Bin 1', 40000, 16, 0, 0, 0, 0, 14, NULL, 0),
(3677, 0, -1, 1716524607, 0, 'Pilchard Bin 2', 25000, 16, 0, 0, 0, 0, 14, NULL, 0),
(3678, 0, -1, 1716524607, 0, 'Pilchard Bin 3', 25000, 16, 0, 0, 0, 0, 14, NULL, 0),
(3679, 0, -1, 1716524607, 0, 'Pilchard Bin 4', 25000, 16, 0, 0, 0, 0, 14, NULL, 0),
(3680, 0, -1, 1716524607, 0, 'Pilchard Bin 5', 40000, 16, 0, 0, 0, 0, 14, NULL, 0),
(3681, 0, -1, 1716524607, 0, 'Pilchard Bin 6', 12500, 16, 0, 0, 0, 0, 11, NULL, 0),
(3682, 0, -1, 1716524607, 0, 'Pilchard Bin 7', 12500, 16, 0, 0, 0, 0, 11, NULL, 0),
(3683, 0, -1, 1716524607, 0, 'Pilchard Bin 8', 12500, 16, 0, 0, 0, 0, 11, NULL, 0),
(3684, 0, -1, 1716524607, 0, 'Pilchard Bin 9', 25000, 16, 0, 0, 0, 0, 11, NULL, 0),
(3685, 0, -1, 1716524607, 0, 'Pilchard Bin 10', 0, 16, 0, 0, 0, 0, 11, NULL, 0),
(3686, 0, -1, 1716524607, 0, 'Mammoth House', 150000, 16, 0, 0, 0, 0, 280, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `house_lists`
--

CREATE TABLE `house_lists` (
  `house_id` int(11) NOT NULL,
  `listid` int(11) NOT NULL,
  `version` bigint(20) NOT NULL DEFAULT 0,
  `list` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `house_lists`
--

INSERT INTO `house_lists` (`house_id`, `listid`, `version`, `list`) VALUES
(3004, 256, 1722810987426771, 'falcon\n');

-- --------------------------------------------------------

--
-- Table structure for table `ip_bans`
--

CREATE TABLE `ip_bans` (
  `ip` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kv_store`
--

CREATE TABLE `kv_store` (
  `key_name` varchar(191) NOT NULL,
  `timestamp` bigint(20) NOT NULL,
  `value` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `kv_store`
--

INSERT INTO `kv_store` (`key_name`, `timestamp`, `value`) VALUES
('migrations.20231128213158_move_hireling_data_to_kv', 1715919810852, 0x3001),
('migrations.20241708000535_move_achievement_to_kv', 1715919810907, 0x3001),
('migrations.20241708362079_move_vip_system_to_kv', 1715919810944, 0x3001),
('migrations.20241708485868_move_some_storages_to_kv', 1715919810983, 0x3001),
('player.12.combat-protection', 1716087060244, 0x19000000000000f03f),
('player.12.exhaustion.training-exhaustion', 1716088512590, 0x19000080b25b92d941),
('player.12.titles.unlocked.Legend of Magic', 1716094156320, 0x10cc89a6b206),
('player.12.titles.unlocked.Tibia\'s Topmodel (Grade 1)', 1716094156319, 0x10cc89a6b206),
('player.13.account.vip-system', 1716175921084, 0x3001),
('player.13.achievements.Potion Addict-progress', 1716178571618, 0x190000000000002440),
('player.13.combat-protection', 1716087057387, 0x19000000000000f03f),
('player.13.exhaustion.training-exhaustion', 1716311480506, 0x19000080703593d941),
('player.13.last-mount', 1716311476102, 0x1002),
('player.13.titles.unlocked.Legend of the Shield', 1716311476091, 0x10b4abb3b206),
('player.13.titles.unlocked.Prince Charming', 1716311476091, 0x10b4abb3b206),
('player.13.titles.unlocked.Trolltrasher', 1716311476089, 0x10b4abb3b206),
('player.14.account.vip-system', 1716655078731, 0x3001),
('player.14.achievements.points', 1716684488695, 0x1002),
('player.14.achievements.Potion Addict-progress', 1716685544286, 0x190000000000c07540),
('player.14.achievements.Snowbunny-progress', 1716684543273, 0x190000000000000840),
('player.14.achievements.unlocked.Greenhorn', 1716684488695, 0x10c88dcab206),
('player.14.combat-protection', 1716673348590, 0x19000000000000f03f),
('player.14.exhaustion.training-exhaustion', 1716676484548, 0x19000080e39994d941),
('player.14.last-mount', 1716696990454, 0x10db01),
('player.14.titles.unlocked.Legend of the Sword', 1716696990439, 0x109eefcab206),
('player.14.titles.unlocked.Trolltrasher', 1716696990438, 0x109eefcab206),
('player.15.account.vip-system', 1716312819472, 0x3001),
('player.15.achievements.Potion Addict-progress', 1716778512447, 0x190000000000e08740),
('player.15.badges.unlocked.Global Player (Grade 2)', 1716777335751, 0x10f7e2cfb206),
('player.15.badges.unlocked.Global Player (Grade 3)', 1716777335757, 0x10f7e2cfb206),
('player.15.combat-protection', 1716323336995, 0x19000000000000f03f),
('player.15.exhaustion.training-exhaustion', 1716778535923, 0x190000408cfd94d941),
('player.15.last-mount', 1716777335789, 0x1002),
('player.15.talkaction.potions.flask', 1716776380371, 0x3001),
('player.15.titles.unlocked.Legend of Marksmanship', 1716342939593, 0x109ba1b5b206),
('player.15.titles.unlocked.Trolltrasher', 1716777335775, 0x10f7e2cfb206),
('player.16.account.vip-system', 1716680795959, 0x3001),
('player.16.combat-protection', 1716682187175, 0x19000000000000f03f),
('player.17.account.vip-system', 1716778823316, 0x3001),
('player.17.achievements.Potion Addict-progress', 1716919002890, 0x190000000000e06940),
('player.17.achievements.Ship\'s Kobold-progress', 1716918032895, 0x190000000000000040),
('player.17.achievements.Snowbunny-progress', 1716918680176, 0x190000000000806e40),
('player.17.badges.unlocked.Global Player (Grade 1)', 1716917961391, 0x10c9add8b206),
('player.17.badges.unlocked.Global Player (Grade 2)', 1716917961400, 0x10c9add8b206),
('player.17.badges.unlocked.Global Player (Grade 3)', 1716917961409, 0x10c9add8b206),
('player.17.badges.unlocked.Master Class (Grade 1)', 1716917961418, 0x10c9add8b206),
('player.17.badges.unlocked.Master Class (Grade 2)', 1716917961427, 0x10c9add8b206),
('player.17.badges.unlocked.Master Class (Grade 3)', 1716917961436, 0x10c9add8b206),
('player.17.combat-protection', 1716853349668, 0x19000000000000f03f),
('player.17.familiar-summon-time', 1716918164704, 0x19000000c68695d941),
('player.17.last-mount', 1716918981199, 0x10dd01),
('player.17.npc-exhaustion', 1716918032893, 0x190000c0c48595d941),
('player.17.titles.unlocked.Cyclopscamper', 1716917961436, 0x10c9add8b206),
('player.17.titles.unlocked.Demondoom', 1716917961436, 0x10c9add8b206),
('player.17.titles.unlocked.Dragondouser', 1716917961436, 0x10c9add8b206),
('player.17.titles.unlocked.Drakenbane', 1716917961436, 0x10c9add8b206),
('player.17.titles.unlocked.Trolltrasher', 1716917961436, 0x10c9add8b206),
('player.18.account.vip-system', 1716848542312, 0x3001),
('player.18.achievements.Potion Addict-progress', 1716921947981, 0x190000000000c88c40),
('player.18.achievements.Ship\'s Kobold-progress', 1716921453978, 0x19000000000000f03f),
('player.18.badges.unlocked.Global Player (Grade 1)', 1716921428934, 0x10d4c8d8b206),
('player.18.badges.unlocked.Global Player (Grade 2)', 1716921428943, 0x10d4c8d8b206),
('player.18.badges.unlocked.Global Player (Grade 3)', 1716921428951, 0x10d4c8d8b206),
('player.18.badges.unlocked.Master Class (Grade 1)', 1716921428960, 0x10d4c8d8b206),
('player.18.badges.unlocked.Master Class (Grade 2)', 1716921428969, 0x10d4c8d8b206),
('player.18.badges.unlocked.Master Class (Grade 3)', 1716921428978, 0x10d4c8d8b206),
('player.18.boss.cooldown.1804', 1716864475505, 0x190000c00a6395d941),
('player.18.combat-protection', 1716853354513, 0x19000000000000f03f),
('player.18.exhaustion.training-exhaustion', 1716922083380, 0x19000040bb8995d941),
('player.18.npc-exhaustion', 1716921453977, 0x190000001c8995d941),
('player.18.talkaction.potions.flask', 1716921438910, 0x3001),
('player.18.titles.unlocked.Cyclopscamper', 1716921428978, 0x10d4c8d8b206),
('player.18.titles.unlocked.Demondoom', 1716921428978, 0x10d4c8d8b206),
('player.18.titles.unlocked.Dragondouser', 1716921428978, 0x10d4c8d8b206),
('player.18.titles.unlocked.Drakenbane', 1716921428978, 0x10d4c8d8b206),
('player.18.titles.unlocked.Gold Hoarder', 1716921428978, 0x10d4c8d8b206),
('player.18.titles.unlocked.Legend of the Sword', 1716863525516, 0x10a584d5b206),
('player.18.titles.unlocked.Platinum Hoarder', 1716921428978, 0x10d4c8d8b206),
('player.18.titles.unlocked.Trolltrasher', 1716921428978, 0x10d4c8d8b206),
('player.19.account.vip-system', 1716848537280, 0x3001),
('player.19.badges.unlocked.Global Player (Grade 1)', 1716859482384, 0x10dae4d4b206),
('player.19.badges.unlocked.Global Player (Grade 2)', 1716859482392, 0x10dae4d4b206),
('player.19.badges.unlocked.Global Player (Grade 3)', 1716859482400, 0x10dae4d4b206),
('player.19.badges.unlocked.Master Class (Grade 1)', 1716859482408, 0x10dae4d4b206),
('player.19.badges.unlocked.Master Class (Grade 2)', 1716859482416, 0x10dae4d4b206),
('player.19.badges.unlocked.Master Class (Grade 3)', 1716859482424, 0x10dae4d4b206),
('player.19.titles.unlocked.Cyclopscamper', 1716859482424, 0x10dae4d4b206),
('player.19.titles.unlocked.Demondoom', 1716859482424, 0x10dae4d4b206),
('player.19.titles.unlocked.Dragondouser', 1716859482424, 0x10dae4d4b206),
('player.19.titles.unlocked.Drakenbane', 1716859482424, 0x10dae4d4b206),
('player.19.titles.unlocked.Legend of the Fist', 1716859482426, 0x10dae4d4b206),
('player.19.titles.unlocked.Trolltrasher', 1716859482424, 0x10dae4d4b206),
('player.20.account.vip-system', 1716848549662, 0x3001),
('player.20.badges.unlocked.Global Player (Grade 1)', 1716848549640, 0x10a58fd4b206),
('player.20.badges.unlocked.Global Player (Grade 2)', 1716848549641, 0x10a58fd4b206),
('player.20.badges.unlocked.Global Player (Grade 3)', 1716848549643, 0x10a58fd4b206),
('player.20.badges.unlocked.Master Class (Grade 1)', 1716848549645, 0x10a58fd4b206),
('player.20.badges.unlocked.Master Class (Grade 2)', 1716848549647, 0x10a58fd4b206),
('player.20.badges.unlocked.Master Class (Grade 3)', 1716848549650, 0x10a58fd4b206),
('player.20.titles.unlocked.Cyclopscamper', 1716848549650, 0x10a58fd4b206),
('player.20.titles.unlocked.Demondoom', 1716848549650, 0x10a58fd4b206),
('player.20.titles.unlocked.Dragondouser', 1716848549650, 0x10a58fd4b206),
('player.20.titles.unlocked.Drakenbane', 1716848549650, 0x10a58fd4b206),
('player.20.titles.unlocked.Trolltrasher', 1716848549650, 0x10a58fd4b206),
('player.7.account.vip-system', 1716002791828, 0x3001),
('player.7.achievements.points', 1716499799471, 0x1001),
('player.7.achievements.Ship\'s Kobold-progress', 1716684351509, 0x190000000000000040),
('player.7.achievements.The Undertaker-progress', 1722787761072, 0x19000000000000f03f),
('player.7.achievements.unlocked.Joke\'s on You', 1716499799471, 0x10d7eabeb206),
('player.7.badges.unlocked.Global Player (Grade 1)', 1722788058471, 0x10dad1beb506),
('player.7.badges.unlocked.Global Player (Grade 2)', 1722788058476, 0x10dad1beb506),
('player.7.badges.unlocked.Global Player (Grade 3)', 1722788058480, 0x10dad1beb506),
('player.7.badges.unlocked.Master Class (Grade 1)', 1716917952848, 0x10c0add8b206),
('player.7.badges.unlocked.Master Class (Grade 2)', 1716917952858, 0x10c0add8b206),
('player.7.badges.unlocked.Master Class (Grade 3)', 1716917952869, 0x10c0add8b206),
('player.7.boss.cooldown.0', 1716434077661, 0x19000040bbbe93d941),
('player.7.boss.cooldown.1881', 1716343042815, 0x19000080d46593d941),
('player.7.boss.cooldown.1957', 1716048846514, 0x19000080874692d941),
('player.7.boss.cooldown.2104', 1716261175554, 0x190000c0752793d941),
('player.7.boss.cooldown.2346', 1716258316943, 0x19000000171393d941),
('player.7.boss.cooldown.2367', 1722788154259, 0x190000806e06acd941),
('player.7.combat-protection', 1716006313646, 0x19000000000000f03f),
('player.7.daily-reward.streak', 1722787501026, 0x190000000000000000),
('player.7.last-mount', 1722788058528, 0x103a),
('player.7.npc-exhaustion', 1716684351508, 0x1900008090a194d941),
('player.7.titles.unlocked.Admirer of the Crown', 1722788058502, 0x10dad1beb506),
('player.7.titles.unlocked.Big Spender', 1722788058502, 0x10dad1beb506),
('player.7.titles.unlocked.Challenger of the Iks', 1722788058502, 0x10dad1beb506),
('player.7.titles.unlocked.Cyclopscamper', 1722788058494, 0x10dad1beb506),
('player.7.titles.unlocked.Demondoom', 1722788058494, 0x10dad1beb506),
('player.7.titles.unlocked.Dragondouser', 1722788058494, 0x10dad1beb506),
('player.7.titles.unlocked.Drakenbane', 1722788058494, 0x10dad1beb506),
('player.7.titles.unlocked.Royal Bounacean Advisor', 1722788058502, 0x10dad1beb506),
('player.7.titles.unlocked.Silencer', 1722788058494, 0x10dad1beb506),
('player.7.titles.unlocked.Trolltrasher', 1722788058494, 0x10dad1beb506),
('player.8.account.vip-system', 1716439270639, 0x3001),
('player.8.achievements.Potion Addict-progress', 1716674735430, 0x190000000000307440),
('player.8.achievements.Ship\'s Kobold-progress', 1716670395095, 0x190000000000000840),
('player.8.badges.unlocked.Global Player (Grade 1)', 1716859487463, 0x10dfe4d4b206),
('player.8.badges.unlocked.Global Player (Grade 2)', 1716859487468, 0x10dfe4d4b206),
('player.8.badges.unlocked.Global Player (Grade 3)', 1716859487473, 0x10dfe4d4b206),
('player.8.badges.unlocked.Master Class (Grade 1)', 1716859487478, 0x10dfe4d4b206),
('player.8.badges.unlocked.Master Class (Grade 2)', 1716859487483, 0x10dfe4d4b206),
('player.8.badges.unlocked.Master Class (Grade 3)', 1716859487488, 0x10dfe4d4b206),
('player.8.boss.cooldown.0', 1716439280780, 0x19000000d0c393d941),
('player.8.boss.cooldown.1904', 1716674417453, 0x1900004070a994d941),
('player.8.combat-protection', 1716655849971, 0x19000000000000f03f),
('player.8.familiar-summon-time', 1716859487500, 0x190000c0109c96d941),
('player.8.npc-exhaustion', 1716670395094, 0x19000080ef9394d941),
('player.8.titles.unlocked.Apex Predator', 1716859487488, 0x10dfe4d4b206),
('player.8.titles.unlocked.Crystal Hoarder', 1716859487488, 0x10dfe4d4b206),
('player.8.titles.unlocked.Cyclopscamper', 1716859487488, 0x10dfe4d4b206),
('player.8.titles.unlocked.Demondoom', 1716859487488, 0x10dfe4d4b206),
('player.8.titles.unlocked.Dragondouser', 1716859487488, 0x10dfe4d4b206),
('player.8.titles.unlocked.Drakenbane', 1716859487488, 0x10dfe4d4b206),
('player.8.titles.unlocked.Gold Hoarder', 1716859487488, 0x10dfe4d4b206),
('player.8.titles.unlocked.Legend of Magic', 1716859487488, 0x10dfe4d4b206),
('player.8.titles.unlocked.Platinum Hoarder', 1716859487488, 0x10dfe4d4b206),
('player.8.titles.unlocked.Trolltrasher', 1716859487488, 0x10dfe4d4b206),
('player.9.account.vip-system', 1715920947471, 0x3001),
('player.9.achievements.Potion Addict-progress', 1716619116928, 0x190000000000907e40),
('player.9.achievements.Ship\'s Kobold-progress', 1716612949061, 0x190000000000000040),
('player.9.achievements.Snowbunny-progress', 1716260595917, 0x190000000000003940),
('player.9.badges.unlocked.Global Player (Grade 1)', 1716859476261, 0x10d4e4d4b206),
('player.9.badges.unlocked.Global Player (Grade 2)', 1716859476272, 0x10d4e4d4b206),
('player.9.badges.unlocked.Global Player (Grade 3)', 1716859476283, 0x10d4e4d4b206),
('player.9.badges.unlocked.Master Class (Grade 1)', 1716859476294, 0x10d4e4d4b206),
('player.9.badges.unlocked.Master Class (Grade 2)', 1716859476304, 0x10d4e4d4b206),
('player.9.badges.unlocked.Master Class (Grade 3)', 1716859476315, 0x10d4e4d4b206),
('player.9.boss.cooldown.0', 1716439236850, 0x19000000c5c393d941),
('player.9.boss.cooldown.1645', 1716255259297, 0x190000c01a1093d941),
('player.9.boss.cooldown.1744', 1716260539879, 0x190000c0421593d941),
('player.9.boss.cooldown.2006', 1716255372642, 0x19000000371093d941),
('player.9.boss.cooldown.2346', 1716254376065, 0x190000003e0f93d941),
('player.9.combat-protection', 1716074386573, 0x19000000000000f03f),
('player.9.familiar-summon-time', 1715978913618, 0x190000003ef191d941),
('player.9.npc-exhaustion', 1716612949061, 0x19000000d65b94d941),
('player.9.titles.unlocked.Apex Predator', 1715995737335, 0x10d988a0b206),
('player.9.titles.unlocked.Challenger of the Iks', 1716859476319, 0x10d4e4d4b206),
('player.9.titles.unlocked.Cyclopscamper', 1716859476315, 0x10d4e4d4b206),
('player.9.titles.unlocked.Demondoom', 1716859476315, 0x10d4e4d4b206),
('player.9.titles.unlocked.Dragondouser', 1716859476315, 0x10d4e4d4b206),
('player.9.titles.unlocked.Gold Hoarder', 1716859476315, 0x10d4e4d4b206),
('player.9.titles.unlocked.Legend of Magic', 1715995737336, 0x10d988a0b206),
('player.9.titles.unlocked.Legend of Marksmanship', 1716859476316, 0x10d4e4d4b206),
('player.9.titles.unlocked.Legend of the Fist', 1716858505868, 0x1089ddd4b206),
('player.9.titles.unlocked.Legend of the Shield', 1716859476317, 0x10d4e4d4b206),
('player.9.titles.unlocked.Trolltrasher', 1716859476315, 0x10d4e4d4b206),
('raids.ankrahmun.the-welter.checks-today', 1722810957521, 0x190000000000b1b540),
('raids.ankrahmun.the-welter.failed-attempts', 1722810957521, 0x190000000000b1b540),
('raids.darashia.tyrn.checks-today', 1722682533707, 0x190000000000a2ab40),
('raids.darashia.tyrn.failed-attempts', 1722682473709, 0x1900000000009aa040),
('raids.darashia.tyrn.last-occurrence', 1716342975389, 0x190000c02f5493d941),
('raids.darashia.tyrn.trigger-when-possible', 1722810957521, 0x3001),
('raids.drefia.arachir.checks-today', 1722810957517, 0x190000000000a0af40),
('raids.drefia.arachir.failed-attempts', 1722810957517, 0x190000000000c4a940),
('raids.drefia.arachir.last-occurrence', 1716523718269, 0x19000080b10494d941),
('raids.drefia.arachir.trigger-when-possible', 1716523718269, 0x3000),
('raids.drefia.the-pale-count.checks-today', 1722684333712, 0x1900000000000aae40),
('raids.drefia.the-pale-count.failed-attempts', 1722684273711, 0x19000000000008ae40),
('raids.drefia.the-pale-count.trigger-when-possible', 1722810957517, 0x3001),
('raids.edron.valorcrest.checks-today', 1722756898881, 0x1900000000001db240),
('raids.edron.valorcrest.failed-attempts', 1722756838880, 0x190000000000a89c40),
('raids.edron.valorcrest.last-occurrence', 1716843991858, 0x190000c0753d95d941),
('raids.edron.valorcrest.trigger-when-possible', 1722810957519, 0x3001),
('raids.edron.weakened-shlorg.checks-today', 1722810957518, 0x190000000000b1b540),
('raids.edron.weakened-shlorg.failed-attempts', 1722810957518, 0x190000000000b1b540),
('raids.edron.white-pale.checks-today', 1722810957518, 0x190000000000e2b340),
('raids.edron.white-pale.failed-attempts', 1722810957518, 0x19000000000008a240),
('raids.edron.white-pale.last-occurrence', 1716858535720, 0x190000c0a94b95d941),
('raids.edron.white-pale.trigger-when-possible', 1716858535720, 0x3000),
('raids.farmine.draptor.checks-today', 1722704707081, 0x19000000000034af40),
('raids.farmine.draptor.failed-attempts', 1722704647072, 0x190000000000bea240),
('raids.farmine.draptor.last-occurrence', 1716342975382, 0x190000c02f5493d941),
('raids.farmine.draptor.trigger-when-possible', 1722810957519, 0x3001),
('raids.folda.yeti.checks-today', 1722810957521, 0x190000000000b1b540),
('raids.folda.yeti.failed-attempts', 1722810957521, 0x190000000000b1b540),
('raids.fury-gates.furiosa.checks-today', 1716869851812, 0x1900000000005eaa40),
('raids.fury-gates.furiosa.failed-attempts', 1716869791811, 0x1900000000005caa40),
('raids.fury-gates.furiosa.trigger-when-possible', 1722810957518, 0x3001),
('raids.nargor.diblis.checks-today', 1716865654884, 0x1900000000001aa840),
('raids.nargor.diblis.failed-attempts', 1716865594886, 0x190000000000208240),
('raids.nargor.diblis.last-occurrence', 1716670713519, 0x190000403e9494d941),
('raids.nargor.diblis.trigger-when-possible', 1722810957518, 0x3001),
('raids.roshamuul.mawhawk.checks-today', 1722670248811, 0x19000000000036ac40),
('raids.roshamuul.mawhawk.failed-attempts', 1722670188809, 0x19000000000034ac40),
('raids.roshamuul.mawhawk.trigger-when-possible', 1722810957519, 0x3001),
('raids.svargrond.hirintror.checks-today', 1722810957519, 0x190000000000b1b540),
('raids.svargrond.hirintror.failed-attempts', 1722810957519, 0x190000000000b1b540),
('raids.thais.rats.checks-today', 1722809277515, 0x190000000000608640),
('raids.thais.rats.failed-attempts', 1722809277515, 0x190000000000000000),
('raids.thais.rats.last-occurrence', 1722809277517, 0x19000040effeabd941),
('raids.thais.rats.trigger-when-possible', 1722809277515, 0x3000),
('raids.thais.wild-horses.checks-today', 1716002823211, 0x190000000000000040),
('raids.thais.wild-horses.failed-attempts', 1716002823211, 0x19000000000000f03f),
('raids.thais.wild-horses.last-occurrence', 1715919861253, 0x19000040fdb691d941),
('raids.thais.wild-horses.trigger-when-possible', 1715919861253, 0x3000),
('raids.tiquanda.midnight-panther.checks-today', 1716932326890, 0x19000000000026a340),
('raids.tiquanda.midnight-panther.failed-attempts', 1716932266884, 0x1900000000005c9440),
('raids.tiquanda.midnight-panther.last-occurrence', 1716523718268, 0x19000080b10494d941),
('raids.tiquanda.midnight-panther.trigger-when-possible', 1722810957519, 0x3001),
('raids.venore.the-old-widow.checks-today', 1722810957520, 0x190000000000b1b540),
('raids.venore.the-old-widow.failed-attempts', 1722810957520, 0x190000000000b1b540);

-- --------------------------------------------------------

--
-- Table structure for table `market_history`
--

CREATE TABLE `market_history` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT 0,
  `itemtype` int(10) UNSIGNED NOT NULL,
  `amount` smallint(5) UNSIGNED NOT NULL,
  `price` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `expires_at` bigint(20) UNSIGNED NOT NULL,
  `inserted` bigint(20) UNSIGNED NOT NULL,
  `state` tinyint(1) UNSIGNED NOT NULL,
  `tier` tinyint(3) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `market_offers`
--

CREATE TABLE `market_offers` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT 0,
  `itemtype` int(10) UNSIGNED NOT NULL,
  `amount` smallint(5) UNSIGNED NOT NULL,
  `created` bigint(20) UNSIGNED NOT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT 0,
  `price` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `tier` tinyint(3) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_account_actions`
--

CREATE TABLE `myaac_account_actions` (
  `account_id` int(11) NOT NULL,
  `ip` varchar(16) NOT NULL DEFAULT '0.0.0.0',
  `ipv6` binary(16) NOT NULL DEFAULT '0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `date` int(11) NOT NULL DEFAULT 0,
  `action` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `myaac_account_actions`
--

INSERT INTO `myaac_account_actions` (`account_id`, `ip`, `ipv6`, `date`, `action`) VALUES
(2, '0', 0x00000000000000000000000000000001, 1715919698, 'Account created.'),
(2, '0', 0x00000000000000000000000000000001, 1715920231, 'Created character <b>Falcon</b>.'),
(2, '0', 0x00000000000000000000000000000001, 1715920246, 'Created character <b>Falkon</b>.'),
(3, '0', 0x00000000000000000000000000000001, 1716004881, 'Account created.'),
(3, '0', 0x00000000000000000000000000000001, 1716004881, 'Created character <b>Test</b>.'),
(3, '0', 0x00000000000000000000000000000001, 1716086237, 'Created character <b>Test Sorcerer</b>.'),
(3, '0', 0x00000000000000000000000000000001, 1716311775, 'Deleted character <b>Test</b>.'),
(3, '0', 0x00000000000000000000000000000001, 1716311790, 'Created character <b>Test Knight</b>.'),
(3, '0', 0x00000000000000000000000000000001, 1716311808, 'Created character <b>Test Paladin</b>.'),
(3, '0', 0x00000000000000000000000000000001, 1716311824, 'Created character <b>Test Druid</b>.'),
(2, '0', 0x00000000000000000000000000000001, 1716778809, 'Created character <b>Falcock</b>.'),
(2, '0', 0x00000000000000000000000000000001, 1716846058, 'Created character <b>Falconek</b>.'),
(2, '0', 0x00000000000000000000000000000001, 1716846176, 'Created character <b>Quintoenlapt</b>.'),
(2, '0', 0x00000000000000000000000000000001, 1716846186, 'Created character <b>Sextoenlapt</b>.');

-- --------------------------------------------------------

--
-- Table structure for table `myaac_admin_menu`
--

CREATE TABLE `myaac_admin_menu` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `page` varchar(255) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT 0,
  `flags` int(11) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_bugtracker`
--

CREATE TABLE `myaac_bugtracker` (
  `account` varchar(255) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 0,
  `text` text NOT NULL,
  `id` int(11) NOT NULL DEFAULT 0,
  `subject` varchar(255) NOT NULL DEFAULT '',
  `reply` int(11) NOT NULL DEFAULT 0,
  `who` int(11) NOT NULL DEFAULT 0,
  `uid` int(11) NOT NULL,
  `tag` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_changelog`
--

CREATE TABLE `myaac_changelog` (
  `id` int(11) NOT NULL,
  `body` varchar(500) NOT NULL DEFAULT '',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 - added, 2 - removed, 3 - changed, 4 - fixed',
  `where` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 - server, 2 - site',
  `date` int(11) NOT NULL DEFAULT 0,
  `player_id` int(11) NOT NULL DEFAULT 0,
  `hidden` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `myaac_changelog`
--

INSERT INTO `myaac_changelog` (`id`, `body`, `type`, `where`, `date`, `player_id`, `hidden`) VALUES
(1, 'MyAAC installed. (:', 3, 2, 1715919692, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `myaac_charbazaar`
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_charbazaar_bid`
--

CREATE TABLE `myaac_charbazaar_bid` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `auction_id` int(11) NOT NULL,
  `bid` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_config`
--

CREATE TABLE `myaac_config` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `value` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `myaac_config`
--

INSERT INTO `myaac_config` (`id`, `name`, `value`) VALUES
(1, 'database_version', '35'),
(2, 'status_online', '1'),
(3, 'status_players', '0'),
(4, 'status_playersMax', '0'),
(5, 'status_lastCheck', '1722811148'),
(6, 'status_uptime', '1722811148'),
(7, 'status_monsters', '82722'),
(8, 'views_counter', '880'),
(9, 'status_uptimeReadable', '08 months, 04 days, 16h 39m'),
(10, 'status_motd', 'Welcome to Nebula Ot!'),
(11, 'status_mapAuthor', 'Nebula'),
(12, 'status_mapName', 'otservbr'),
(13, 'status_mapWidth', '33112'),
(14, 'status_mapHeight', '32895'),
(15, 'status_server', 'Canary'),
(16, 'status_serverVersion', '3.0'),
(17, 'status_clientVersion', '13.32'),
(18, 'status_playersTotal', '0');

-- --------------------------------------------------------

--
-- Table structure for table `myaac_faq`
--

CREATE TABLE `myaac_faq` (
  `id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL DEFAULT '',
  `answer` varchar(1020) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT 0,
  `hidden` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_forum`
--

CREATE TABLE `myaac_forum` (
  `id` int(11) NOT NULL,
  `first_post` int(11) NOT NULL DEFAULT 0,
  `last_post` int(11) NOT NULL DEFAULT 0,
  `section` int(3) NOT NULL DEFAULT 0,
  `replies` int(20) NOT NULL DEFAULT 0,
  `views` int(20) NOT NULL DEFAULT 0,
  `author_aid` int(20) NOT NULL DEFAULT 0,
  `author_guid` int(20) NOT NULL DEFAULT 0,
  `post_text` text NOT NULL,
  `post_topic` varchar(255) NOT NULL DEFAULT '',
  `post_smile` tinyint(1) NOT NULL DEFAULT 0,
  `post_html` tinyint(1) NOT NULL DEFAULT 0,
  `post_date` int(20) NOT NULL DEFAULT 0,
  `last_edit_aid` int(20) NOT NULL DEFAULT 0,
  `edit_date` int(20) NOT NULL DEFAULT 0,
  `post_ip` varchar(32) NOT NULL DEFAULT '0.0.0.0',
  `sticked` tinyint(1) NOT NULL DEFAULT 0,
  `closed` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_forum_boards`
--

CREATE TABLE `myaac_forum_boards` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT 0,
  `guild` int(11) NOT NULL DEFAULT 0,
  `access` int(11) NOT NULL DEFAULT 0,
  `closed` tinyint(1) NOT NULL DEFAULT 0,
  `hidden` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `myaac_forum_boards`
--

INSERT INTO `myaac_forum_boards` (`id`, `name`, `description`, `ordering`, `guild`, `access`, `closed`, `hidden`) VALUES
(1, 'News', 'News commenting', 0, 0, 0, 1, 0),
(2, 'Trade', 'Trade offers.', 1, 0, 0, 0, 0),
(3, 'Quests', 'Quest making.', 2, 0, 0, 0, 0),
(4, 'Pictures', 'Your pictures.', 3, 0, 0, 0, 0),
(5, 'Bug Report', 'Report bugs there.', 4, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `myaac_gallery`
--

CREATE TABLE `myaac_gallery` (
  `id` int(11) NOT NULL,
  `comment` varchar(255) NOT NULL DEFAULT '',
  `image` varchar(255) NOT NULL,
  `thumb` varchar(255) NOT NULL,
  `author` varchar(50) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT 0,
  `hidden` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `myaac_gallery`
--

INSERT INTO `myaac_gallery` (`id`, `comment`, `image`, `thumb`, `author`, `ordering`, `hidden`) VALUES
(1, 'Demon', 'images/gallery/demon.jpg', 'images/gallery/demon_thumb.gif', 'MyAAC', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `myaac_menu`
--

CREATE TABLE `myaac_menu` (
  `id` int(11) NOT NULL,
  `template` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `link` varchar(255) NOT NULL,
  `blank` tinyint(1) NOT NULL DEFAULT 0,
  `color` varchar(6) NOT NULL DEFAULT '',
  `category` int(11) NOT NULL DEFAULT 1,
  `ordering` int(11) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `myaac_menu`
--

INSERT INTO `myaac_menu` (`id`, `template`, `name`, `link`, `blank`, `color`, `category`, `ordering`, `enabled`) VALUES
(428, 'tibiacom', 'Latest News', 'news', 0, '', 1, 0, 1),
(429, 'tibiacom', 'News Archive', 'news/archive', 0, '', 1, 1, 1),
(430, 'tibiacom', 'Event Schedule', 'eventcalendar', 0, '', 1, 2, 1),
(431, 'tibiacom', 'Account Management', 'account/manage', 0, '', 2, 0, 1),
(432, 'tibiacom', 'Create Account', 'account/create', 0, '', 2, 1, 1),
(433, 'tibiacom', 'Lost Account?', 'account/lost', 0, '', 2, 2, 1),
(434, 'tibiacom', 'Server Rules', 'rules', 0, '', 2, 3, 1),
(435, 'tibiacom', 'Downloads', 'downloadclient', 0, '', 2, 4, 1),
(436, 'tibiacom', 'Report Bug', 'bugtracker', 0, '', 2, 5, 1),
(437, 'tibiacom', 'Characters', 'characters', 0, '', 3, 0, 1),
(438, 'tibiacom', 'Who Is Online?', 'online', 0, '', 3, 1, 1),
(439, 'tibiacom', 'Highscores', 'highscores', 0, '', 3, 2, 1),
(440, 'tibiacom', 'Last Kills', 'lastkills', 0, '', 3, 3, 1),
(441, 'tibiacom', 'Houses', 'houses', 0, '', 3, 4, 1),
(442, 'tibiacom', 'Guilds', 'guilds', 0, '', 3, 5, 1),
(443, 'tibiacom', 'Polls', 'polls', 0, '', 3, 6, 1),
(444, 'tibiacom', 'Bans', 'bans', 0, '', 3, 7, 1),
(445, 'tibiacom', 'Support List', 'team', 0, '', 3, 8, 1),
(446, 'tibiacom', 'Forum', 'forum', 0, '', 4, 0, 1),
(447, 'tibiacom', 'Creatures', 'creatures', 0, '', 5, 0, 1),
(448, 'tibiacom', 'Spells', 'spells', 0, '', 5, 1, 1),
(449, 'tibiacom', 'Commands', 'commands', 0, '', 5, 2, 1),
(450, 'tibiacom', 'Gallery', 'gallery', 0, '', 5, 3, 1),
(451, 'tibiacom', 'Server Info', 'serverInfo', 0, '', 5, 4, 1),
(452, 'tibiacom', 'Experience Table', 'experienceTable', 0, '', 5, 5, 1),
(453, 'tibiacom', 'Addons Buff', 'addonsbuff', 0, 'eb0000', 5, 6, 1),
(454, 'tibiacom', 'Beneficios Vip', 'beneficiosvip', 0, 'b5e01b', 5, 7, 1),
(455, 'tibiacom', 'Download Clients!', 'downloads', 0, 'd513bb', 5, 8, 1),
(456, 'tibiacom', 'Koliseum', 'koliseum', 0, 'fba9a9', 5, 9, 1),
(457, 'tibiacom', 'Online Tokens', 'onlinetokens', 0, '0ab8dd', 5, 10, 1),
(458, 'tibiacom', 'Puntos por Addon', 'puntosporaddon', 0, '227600', 5, 11, 1),
(459, 'tibiacom', 'Niveles de Addon Buff', 'nivelesdeaddonbuff', 0, 'e78810', 5, 12, 1),
(460, 'tibiacom', 'Current Auctions', 'currentcharactertrades', 0, '', 7, 0, 1),
(461, 'tibiacom', 'Auction History', 'pastcharactertrades', 0, '', 7, 1, 1),
(462, 'tibiacom', 'My Bids', 'ownbids', 0, '', 7, 2, 1),
(463, 'tibiacom', 'My Auctions', 'owncharactertrades', 0, '', 7, 3, 1),
(464, 'tibiacom', 'Create Auction', 'createcharacterauction', 0, '', 7, 4, 1),
(465, 'tibiacom', 'Buy Tibia Coins', 'donate', 0, 'ffff00', 6, 0, 1),
(466, 'tibiacom', 'Tibia Coins Promos', 'tibiacoinspromoss', 0, 'ffff00', 6, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `myaac_monsters`
--

CREATE TABLE `myaac_monsters` (
  `id` int(11) NOT NULL,
  `hidden` tinyint(1) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `mana` int(11) NOT NULL DEFAULT 0,
  `exp` int(11) NOT NULL,
  `health` int(11) NOT NULL,
  `speed_lvl` int(11) NOT NULL DEFAULT 1,
  `use_haste` tinyint(1) NOT NULL,
  `voices` text NOT NULL,
  `immunities` varchar(255) NOT NULL,
  `elements` text NOT NULL,
  `summonable` tinyint(1) NOT NULL,
  `convinceable` tinyint(1) NOT NULL,
  `pushable` tinyint(1) NOT NULL DEFAULT 0,
  `canpushitems` tinyint(1) NOT NULL DEFAULT 0,
  `canwalkonenergy` tinyint(1) NOT NULL DEFAULT 0,
  `canwalkonpoison` tinyint(1) NOT NULL DEFAULT 0,
  `canwalkonfire` tinyint(1) NOT NULL DEFAULT 0,
  `runonhealth` tinyint(1) NOT NULL DEFAULT 0,
  `hostile` tinyint(1) NOT NULL DEFAULT 0,
  `attackable` tinyint(1) NOT NULL DEFAULT 0,
  `rewardboss` tinyint(1) NOT NULL DEFAULT 0,
  `defense` int(11) NOT NULL DEFAULT 0,
  `armor` int(11) NOT NULL DEFAULT 0,
  `canpushcreatures` tinyint(1) NOT NULL DEFAULT 0,
  `race` varchar(255) NOT NULL,
  `loot` text NOT NULL,
  `summons` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_news`
--

CREATE TABLE `myaac_news` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `body` text NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 - news, 2 - ticker, 3 - article',
  `date` int(11) NOT NULL DEFAULT 0,
  `category` tinyint(1) NOT NULL DEFAULT 0,
  `player_id` int(11) NOT NULL DEFAULT 0,
  `last_modified_by` int(11) NOT NULL DEFAULT 0,
  `last_modified_date` int(11) NOT NULL DEFAULT 0,
  `comments` varchar(50) NOT NULL DEFAULT '',
  `article_text` varchar(300) NOT NULL DEFAULT '',
  `article_image` varchar(100) NOT NULL DEFAULT '',
  `hidden` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `myaac_news`
--

INSERT INTO `myaac_news` (`id`, `title`, `body`, `type`, `date`, `category`, `player_id`, `last_modified_by`, `last_modified_date`, `comments`, `article_text`, `article_image`, `hidden`) VALUES
(3, 'Bienvenidos a Nebula', '<p>Bienvenidos a Nebula! Revisa la seccion de Library y Shop.</p>', 2, 1722719026, 1, 7, 7, 1722719067, '0', '', 'images/news/announcement.jpg', 0),
(4, 'Bienvenidos a Nebula', '<p style=\"text-align: left;\">Estamos por comenzar este proyecto llamado Nebula el cual tiene la idea de ofrecer un servidor a la comunidad Tibiana que tenga esa escencia de Tibia Rl&nbsp; sin dejar de ser un OT server y hacer lo que mas disfrutes junto con tus amigos o incluso conocer amigos aca</p>\r\n<p>Contamos con Mapa Rl 13.30<img style=\"float: right;\" src=\"https://static.tibia.com/images/news/warriornewsreader_left_250.png\" width=\"164\" height=\"315\" /></p>\r\n<ul style=\"list-style-type: square;\">\r\n<li>Cliente Androd OTCv8</li>\r\n<li>Todos los Quests habilitados</li>\r\n<li>Sistema de Autoloot mediante Manage Loot Containers</li>\r\n<li>Sistema de Teleport Cube (30+ Bosses, Cities y House)</li>\r\n<li>Sistema de Tokens Online para intercambiar por items</li>\r\n<li>Gnomprona y Hazard</li>\r\n<li>Soul War&nbsp;</li>\r\n<li>Rotten Blood</li>\r\n<li>Oskayaat</li>\r\n<li>Respawn de Libreria mejorado</li>\r\n<li>Nuevos items de utilidad en el Gamestore</li>\r\n<li>Sistema de Forja con mas facilidad de Success</li>\r\n<li>Sistema de Tasks (250+ disponibles)</li>\r\n<li>Bosses con cooldown de 8 hrs en vez de 20 hrs</li>\r\n<li>Party de 5 players&nbsp;</li>\r\n<li>Sistema de Ruleta</li>\r\n</ul>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p style=\"text-align: center;\">&nbsp;Entre muchas otras cosas que puedes checar en la seccion de <span style=\"color: #008000;\"><strong>Library</strong></span></p>\r\n<p style=\"text-align: center;\"><span style=\"color: #800000;\"><strong>No personajes editados&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</strong><strong>No preferencia a players</strong></span></p>\r\n<p style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Por un servidor que se pueda disfrutar y se valore el avance de cada player.</strong></span></p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>', 1, 1722719493, 1, 7, 7, 1722720126, '0', '', 'images/news/announcement.jpg', 0);

-- --------------------------------------------------------

--
-- Table structure for table `myaac_news_categories`
--

CREATE TABLE `myaac_news_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `description` varchar(50) NOT NULL DEFAULT '',
  `icon_id` int(2) NOT NULL DEFAULT 0,
  `hidden` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `myaac_news_categories`
--

INSERT INTO `myaac_news_categories` (`id`, `name`, `description`, `icon_id`, `hidden`) VALUES
(1, '', '', 0, 0),
(2, '', '', 1, 0),
(3, '', '', 2, 0),
(4, '', '', 3, 0),
(5, '', '', 4, 0);

-- --------------------------------------------------------

--
-- Table structure for table `myaac_notepad`
--

CREATE TABLE `myaac_notepad` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `content` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_pages`
--

CREATE TABLE `myaac_pages` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `title` varchar(30) NOT NULL,
  `body` longtext NOT NULL,
  `date` int(11) NOT NULL DEFAULT 0,
  `player_id` int(11) NOT NULL DEFAULT 0,
  `php` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 - plain html, 1 - php',
  `enable_tinymce` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 - enabled, 0 - disabled',
  `access` tinyint(2) NOT NULL DEFAULT 0,
  `hidden` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `myaac_pages`
--

INSERT INTO `myaac_pages` (`id`, `name`, `title`, `body`, `date`, `player_id`, `php`, `enable_tinymce`, `access`, `hidden`) VALUES
(1, 'downloads', 'Download Clients', '<h1 style=\"text-align: center;\">CLIENTE NEBULA 13.32</h1>\r\n<p><a title=\"Nebula Client 1332\" href=\"https://www.mediafire.com/file/a1pvyh8c40uqip5/Nebula_Client.rar/file\" target=\"_blank\" rel=\"noopener\"><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"https://i.ibb.co/VCqq8m8/Nebula-Logo.jpg\" alt=\"Nebula-Logo\" width=\"229\" height=\"229\" border=\"0\" /></a></p>\r\n<h3 style=\"text-align: center;\"><a title=\"Latinot 13.21\" href=\"https://www.mediafire.com/file/a1pvyh8c40uqip5/Nebula_Client.rar/file\" target=\"_blank\" rel=\"noopener\"><span style=\"text-decoration: underline;\">Descarga aqui</span></a></h3>\r\n<div style=\"text-align: center;\">\r\n<h2>  CLIENTE OTCV8 ANDROID SIN BOT</h2>\r\n<a title=\"Android Client Otcv8\" href=\"https://www.mediafire.com/file/99ywg2krjmu8rwo/NebulaOT.apk/file\" target=\"_blank\" rel=\"noopener\"><img src=\"https://avatars.githubusercontent.com/u/56050652?s=48\" alt=\"Ver las imágenes de origen\" width=\"123\" height=\"123\" /></a></div>\r\n<div style=\"text-align: center;\"><a title=\"Android Client Otcv8\" href=\"https://www.mediafire.com/file/99ywg2krjmu8rwo/NebulaOT.apk/file\" target=\"_blank\" rel=\"noopener\">Descarga aqui</a></div>', 0, 1, 0, 1, 1, 0),
(2, 'commands', 'Commands', '<table style=\"border-collapse: collapse; width: 580.138px; height: 64px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 129.538px; background-color: #505050; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Words</strong></span></td>\r\n<td style=\"width: 444.2px; background-color: #505050; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Description</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!commands</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Show your commands ingame</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #d4c0a1;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!buyhouse</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Buy house you are looking at</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 10px;\"><strong><em>!aol</em></strong></td>\r\n<td style=\"width: 444.2px; height: 10px;\">Buy Amulet of Loss</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table style=\"border-collapse: collapse; width: 580.138px; height: 82px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!autoloot on/off</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">After turned on, configure manage loot containers on your bp</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #d4c0a1;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!backpack</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Buy a Lucky pig and get a random backpack</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 10px;\"><strong><em>!balance</em></strong></td>\r\n<td style=\"width: 444.2px; height: 10px;\">Show your money balance</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table style=\"border-collapse: collapse; width: 580.138px; height: 64px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!bless</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Buy all blessings</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #d4c0a1;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!buffpoints</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Show how many <strong>Addon Buff points</strong> you have</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 10px;\"><strong><em>!vip</em></strong></td>\r\n<td style=\"width: 444.2px; height: 10px;\">Check your remaining Vip days</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table style=\"border-collapse: collapse; width: 580.138px; height: 82px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!deposit xxxx</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Deposit cash on bank</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #d4c0a1;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!emote on/off</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Activate or deactivate spells in local chat</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 10px;\"><strong><em>!flask on/off</em></strong></td>\r\n<td style=\"width: 444.2px; height: 10px;\">Receive or not receive empty potion flasks when used</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table style=\"border-collapse: collapse; width: 580.138px; height: 82px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!food</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Buy 100 brown mushroom</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #d4c0a1;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!leavehouse</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Leave house you are looking at</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 10px;\"><strong><em>!online</em></strong></td>\r\n<td style=\"width: 444.2px; height: 10px;\">Show players online</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table style=\"border-collapse: collapse; width: 580.138px; height: 82px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!reward</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Get a daily training weapon based on your highest skill</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #d4c0a1;\">\r\n<td style=\"width: 129.538px; height: 18px;\"><strong><em>!sellhouse</em></strong></td>\r\n<td style=\"width: 444.2px; height: 18px;\">Sell house you are looking at</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 10px;\"><strong><em>!serverinfo</em></strong></td>\r\n<td style=\"width: 444.2px; height: 10px;\">Show the server info</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 10px;\"><strong><em>!shared</em></strong></td>\r\n<td style=\"width: 444.2px; height: 10px;\">Show the max and min level to share experience on a party</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.538px; height: 10px;\"><strong><em>!taskpoints</em></strong></td>\r\n<td style=\"width: 444.2px; height: 10px;\">Show how many <strong>Task Points</strong> you have</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table style=\"border-collapse: collapse; width: 579px; height: 66px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.337px; height: 18px;\"><strong><em>!time</em></strong></td>\r\n<td style=\"width: 443.263px; height: 18px;\">Show what time is it on Nebula</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #d4c0a1;\">\r\n<td style=\"width: 129.337px; height: 18px;\"><strong><em>!tools</em></strong></td>\r\n<td style=\"width: 443.263px; height: 18px;\">Buy a pack of basic tools</td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 129.337px; height: 10px;\"><strong><em>!transfer xxxx</em></strong></td>\r\n<td style=\"width: 443.263px; height: 10px;\">!transfer (playername), (amount). Transfer money</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table style=\"border-collapse: collapse; width: 578px; height: 23px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\r\n<td style=\"width: 128.863px; height: 15px;\"><strong><em>!withdraw xxxx</em></strong></td>\r\n<td style=\"width: 442.737px; height: 15px;\">Withdraw money from your bank acount</td>\r\n</tr>\r\n</tbody>\r\n</table>', 0, 1, 0, 1, 1, 0),
(3, 'rules_on_the_page', 'Rules', '1. Names\na) Names which contain insulting (e.g. \"Bastard\"), racist (e.g. \"Nigger\"), extremely right-wing (e.g. \"Hitler\"), sexist (e.g. \"Bitch\") or offensive (e.g. \"Copkiller\") language.\nb) Names containing parts of sentences (e.g. \"Mike returns\"), nonsensical combinations of letters (e.g. \"Fgfshdsfg\") or invalid formattings (e.g. \"Thegreatknight\").\nc) Names that obviously do not describe a person (e.g. \"Christmastree\", \"Matrix\"), names of real life celebrities (e.g. \"Britney Spears\"), names that refer to real countries (e.g. \"Swedish Druid\"), names which were created to fake other players\' identities (e.g. \"Arieswer\" instead of \"Arieswar\") or official positions (e.g. \"System Admin\").\n\n2. Cheating\na) Exploiting obvious errors of the game (\"bugs\"), for instance to duplicate items. If you find an error you must report it to CipSoft immediately.\nb) Intentional abuse of weaknesses in the gameplay, for example arranging objects or players in a way that other players cannot move them.\nc) Using tools to automatically perform or repeat certain actions without any interaction by the player (\"macros\").\nd) Manipulating the client program or using additional software to play the game.\ne) Trying to steal other players\' account data (\"hacking\").\nf) Playing on more than one account at the same time (\"multi-clienting\").\ng) Offering account data to other players or accepting other players\' account data (\"account-trading/sharing\").\n\n3. Gamemasters\na) Threatening a gamemaster because of his or her actions or position as a gamemaster.\nb) Pretending to be a gamemaster or to have influence on the decisions of a gamemaster.\nc) Intentionally giving wrong or misleading information to a gamemaster concerning his or her investigations or making false reports about rule violations.\n\n4. Player Killing\na) Excessive killing of characters who are not marked with a \"skull\" on worlds which are not PvP-enforced. Please note that killing marked characters is not a reason for a banishment.\n\nA violation of the Tibia Rules may lead to temporary banishment of characters and accounts. In severe cases removal or modification of character skills, attributes and belongings, as well as the permanent removal of accounts without any compensation may be considered. The sanction is based on the seriousness of the rule violation and the previous record of the player. It is determined by the gamemaster imposing the banishment.\n\nThese rules may be changed at any time. All changes will be announced on the official website.', 0, 1, 0, 0, 1, 0),
(4, 'addonsbuff', 'Addons Buff', '<table style=\"border-collapse: collapse; width: 100%;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"background-color: #800909; border-color: #000000; border-style: solid;\">\r\n<td style=\"width: 20%; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>SISTEMA DE ADDONS BUFF</strong></span></td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p><span style=\"color: #5a2800; font-family: Verdana, Arial, \'Times New Roman\', sans-serif; font-size: 12px; background-color: #fff2db;\">En Nebula tenemos un sistema de mejoras que se aplican en base a la cantidad de <strong><span style=\"text-decoration: underline;\">Addons obtenidos</span></strong> por el personaje, al momento de desbloquear un addon, ya sea<strong> <span style=\"text-decoration: underline;\">First Addon</span></strong> o <span style=\"text-decoration: underline;\"><strong>Second Addon</strong></span> mediante el npc <strong>\"<span style=\"text-decoration: underline;\">Addoner</span>\"</strong> este te otorgara los llamados <strong>\"<span style=\"text-decoration: underline;\">Buff</span></strong><span style=\"text-decoration: underline;\"><strong> poi</strong></span><strong><span style=\"text-decoration: underline;\">nts</span>\"</strong>, la cantidad de Buff Points obtenidos por cada Addon va a variar dependiendo de la <span style=\"text-decoration: underline;\"><strong>rareza o dificultad</strong></span> para obtenerlos. Los <strong><span style=\"text-decoration: underline;\">Outfits de Store</span> </strong>te asignaran <span style=\"text-decoration: underline;\"><strong>automaticamente</strong></span> los puntos equivalentes al outfit que hayas comprado. Puedes consultar la cantidad de puntos que tienes con el comando !buffpoints.</span></p>\r\n<p> </p>\r\n<p><span style=\"color: #5a2800; font-family: Verdana, Arial, Times New Roman, sans-serif;\"><span style=\"font-size: 12px; background-color: #fff2db;\"><span style=\"color: #ff0000;\"><strong>Importante</strong></span>: Solo se otorgaran puntos a los addons obtenidos mediante el npc <strong>\"<span style=\"text-decoration: underline;\">Addoner</span>\", </strong>addons obtenidos mediante otros npcs <span style=\"text-decoration: underline;\"><span style=\"color: #ff0000; text-decoration: underline;\">NO</span></span> otorgaran puntos. <span style=\"text-decoration: underline; color: #ff0000;\">Este ha sido configurado para pedir y recibir los items necesarios para todos los outfits del juego.</span></span></span></p>\r\n<p> </p>\r\n<p style=\"text-align: center;\"><span style=\"color: #5a2800; font-family: Verdana, Arial, Times New Roman, sans-serif;\"><span style=\"font-size: 12px; background-color: #fff2db;\"><span style=\"text-decoration: underline;\">El npc <strong>\"Addoner\"</strong> lo puedes encontrar en el <strong>\"Thais Depot\"</strong> .</span></span></span></p>\r\n<p style=\"text-align: center;\"><img src=\"https://i.ibb.co/6Pw3jh4/Addoner-Npc.png\" alt=\"Addoner-Npc\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\">Mas informacion acerca de los <a href=\"http://latinot.servegame.com/?puntosporaddon\">Puntos por Addon</a>.</p>\r\n<p style=\"text-align: center;\">Mas informacion acerca de <a href=\"http://latinot.servegame.com/?nivelesdeaddonbuff\">Niveles de Addons Buff.</a></p>', 0, 1, 0, 1, 1, 0);
INSERT INTO `myaac_pages` (`id`, `name`, `title`, `body`, `date`, `player_id`, `php`, `enable_tinymce`, `access`, `hidden`) VALUES
(5, 'puntosporaddon', 'Puntos por Addon', '<table style=\"border-collapse: collapse; width: 100%;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"background-color: #800909; border-color: #000000; border-style: solid;\">\r\n<td style=\"width: 100%; text-align: center;\"><span style=\"color: #ffffff;\"><strong>ADDONS </strong></span></td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p>A continuacion una lista de los addons obtenibles con el Npc \"<span style=\"color: #008000;\"><strong>Addoner</strong></span>\" y la respectiva cantidad de buffpoints obtenidos por cada uno, y tambien se desbloquea automaticamente el <span style=\"text-decoration: underline;\"><strong><span style=\"color: #008000; text-decoration: underline;\">Outfit</span></strong></span> al adquirir su <span style=\"color: #008000;\"><strong>Addon.</strong></span></p>\r\n<table style=\"height: 892px; width: 78.7584%; border-collapse: collapse;\" border=\"4\">\r\n<tbody>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 38.0771%; height: 18px; text-align: center; background-color: #800909;\" colspan=\"2\"><span style=\"color: #ffffff;\"><strong>Outfits</strong></span></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #800909;\"><span style=\"color: #ffffff;\"><strong>First Addon</strong></span></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #800909;\"><span style=\"color: #ffffff;\"><strong>Second Addon</strong></span></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #800909;\"><span style=\"color: #ffffff;\"><strong>Look</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 38.0771%; height: 18px; background-color: #d6c076; text-align: center;\" colspan=\"2\"><strong> Citizen Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/w7FfKrR/Outfit-Citizen-Male-Addon-3.gif\" alt=\"Outfit-Citizen-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/SnFCmMZ/Outfit-Citizen-Female-Addon-3.gif\" alt=\"Outfit-Citizen-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 38.0771%; height: 18px; text-align: center; background-color: #d6c076;\" colspan=\"2\"><strong>Hunter Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>5</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/DDT9YHv/Outfit-Hunter-Male-Addon-3.gif\" alt=\"Outfit-Hunter-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/bLJxXbf/Outfit-Hunter-Female-Addon-3.gif\" alt=\"Outfit-Hunter-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 38.0771%; height: 18px; text-align: center; background-color: #d6c076;\" colspan=\"2\"><strong>Mage Outfit (Male)</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>185</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/j5fv3hs/Outfit-Mage-Male-Addon-3.gif\" alt=\"Outfit-Mage-Male-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 38.0771%; height: 18px; text-align: center; background-color: #d6c076;\" colspan=\"2\"><strong>Mage Outfit (Female)</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><span style=\"color: #0000ee;\"><u><img src=\"https://i.ibb.co/PQMGGfJ/Outfit-Mage-Female-Addon-3.gif\" alt=\"Outfit-Mage-Female-Addon-3\" border=\"0\" /></u></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 38.0771%; height: 18px; text-align: center; background-color: #d6c076;\" colspan=\"2\"><strong>Knight Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/HgmH9f3/Outfit-Knight-Male-Addon-3.gif\" alt=\"Outfit-Knight-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/1KLktPM/Outfit-Knight-Female-Addon-3.gif\" alt=\"Outfit-Knight-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 38.0771%; height: 18px; text-align: center; background-color: #d6c076;\" colspan=\"2\"><strong>Nobleman Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/vcjfv3q/Outfit-Nobleman-Male-Addon-3.gif\" alt=\"Outfit-Nobleman-Male-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 38.0771%; height: 18px; text-align: center; background-color: #d6c076;\" colspan=\"2\"><strong>Summoner Outfit (Male)</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/Qv5ndTb/Outfit-Summoner-Male-Addon-3.gif\" alt=\"Outfit-Summoner-Male-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 38.0771%; height: 18px; text-align: center; background-color: #d6c076;\" colspan=\"2\"><strong>Summoner Outfit (Female)</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>185</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/1Q8pNXj/Outfit-Summoner-Female-Addon-3.gif\" alt=\"Outfit-Summoner-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"height: 18px; text-align: center; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Warrior Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/b6dGrTN/Outfit-Warrior-Male-Addon-3.gif\" alt=\"Outfit-Warrior-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/k2R16D9/Outfit-Warrior-Female-Addon-3.gif\" alt=\"Outfit-Warrior-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Barbarian Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/fGgbKSx/Outfit-Barbarian-Male-Addon-3.gif\" alt=\"Outfit-Barbarian-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/tx193VQ/Outfit-Barbarian-Female-Addon-3.gif\" alt=\"Outfit-Barbarian-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Druid Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/zPZp7Sp/Outfit-Druid-Male-Addon-3.gif\" alt=\"Outfit-Druid-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/pPR5Pnf/Outfit-Druid-Female-Addon-3.gif\" alt=\"Outfit-Druid-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Wizard Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/99WZhqM/Outfit-Wizard-Male-Addon-3.gif\" alt=\"Outfit-Wizard-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/Vp53tGZ/Outfit-Wizard-Female-Addon-3.gif\" alt=\"Outfit-Wizard-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Oriental Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>25</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/jg3mt3D/Outfit-Oriental-Male-Addon-3.gif\" alt=\"Outfit-Oriental-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/jh2nMdh/Outfit-Oriental-Female-Addon-3.gif\" alt=\"Outfit-Oriental-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Pirate Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/Xz4yBmD/Outfit-Pirate-Male-Addon-3.gif\" alt=\"Outfit-Pirate-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/ZXH5Q0Q/Outfit-Pirate-Female-Addon-3.gif\" alt=\"Outfit-Pirate-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Assassin Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/Xbz9WQV/Outfit-Assassin-Male-Addon-3.gif\" alt=\"Outfit-Assassin-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/MM6s0Rw/Outfit-Assassin-Female-Addon-3.gif\" alt=\"Outfit-Assassin-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Beggar Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/0Bsw5VP/Outfit-Beggar-Male-Addon-3.gif\" alt=\"Outfit-Beggar-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/CH0jstR/Outfit-Beggar-Female-Addon-3.gif\" alt=\"Outfit-Beggar-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Shaman Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/vz5tHx3/Outfit-Shaman-Male-Addon-3.gif\" alt=\"Outfit-Shaman-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/H2NMVW6/Outfit-Shaman-Female-Addon-3.gif\" alt=\"Outfit-Shaman-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Norseman Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/xLqGVT1/Outfit-Norseman-Male-Addon-3.gif\" alt=\"Outfit-Norseman-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/Mfdw3KH/Outfit-Norseman-Female-Addon-3.gif\" alt=\"Outfit-Norseman-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Nightmare Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/rcT6D1x/Outfit-Nightmare-Male-Addon-3.gif\" alt=\"Outfit-Nightmare-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/6yVLwy2/Outfit-Nightmare-Female-Addon-3.gif\" alt=\"Outfit-Nightmare-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Jester Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/Ws9126y/Outfit-Jester-Male-Addon-3.gif\" alt=\"Outfit-Jester-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/T4rn1c5/Outfit-Jester-Female-Addon-3.gif\" alt=\"Outfit-Jester-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Brotherhood Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/XSn6HN1/Outfit-Brotherhood-Male-Addon-3.gif\" alt=\"Outfit-Brotherhood-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/g6NdgQG/Outfit-Brotherhood-Female-Addon-3.gif\" alt=\"Outfit-Brotherhood-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Demon Hunter Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/hfyjXx1/Outfit-Demon-Hunter-Male-Addon-3.gif\" alt=\"Outfit-Demon-Hunter-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/02xkwFx/Outfit-Demon-Hunter-Female-Addon-3.gif\" alt=\"Outfit-Demon-Hunter-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Yalaharian Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/mzrnGhY/Outfit-Yalaharian-Male-Addon-3.gif\" alt=\"Outfit-Yalaharian-Male-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Warmaster Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/ykQWW8t/Outfit-Warmaster-Male-Addon-3.gif\" alt=\"Outfit-Warmaster-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/CK5pSbs/Outfit-Warmaster-Female-Addon-3.gif\" alt=\"Outfit-Warmaster-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Wayfarer Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/VWPBy40/Outfit-Wayfarer-Male-Addon-3.gif\" alt=\"Outfit-Wayfarer-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/Gncbtrv/Outfit-Wayfarer-Female-Addon-3.gif\" alt=\"Outfit-Wayfarer-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Afflicted Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/2vGyY3t/Outfit-Afflicted-Male-Addon-3.gif\" alt=\"Outfit-Afflicted-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/tHbsy03/Outfit-Afflicted-Female-Addon-3.gif\" alt=\"Outfit-Afflicted-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Elementalist Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>25</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>25</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/k2Jnqdx/Outfit-Elementalist-Male-Addon-3.gif\" alt=\"Outfit-Elementalist-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/Pz2nhQW/Outfit-Elementalist-Female-Addon-3.gif\" alt=\"Outfit-Elementalist-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Deepling Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/7JV1D5W/Outfit-Deepling-Male-Addon-3.gif\" alt=\"Outfit-Deepling-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/3hBhxMh/Outfit-Deepling-Female-Addon-3.gif\" alt=\"Outfit-Deepling-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Insectoid Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/rx5zgTz/Outfit-Insectoid-Male-Addon-3.gif\" alt=\"Outfit-Insectoid-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/cr8q3Yd/Outfit-Insectoid-Female-Addon-3.gif\" alt=\"Outfit-Insectoid-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Crystal Warlord Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/J3yYyhs/Outfit-Crystal-Warlord-Male-Addon-3.gif\" alt=\"Outfit-Crystal-Warlord-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/x1yqW6B/Outfit-Crystal-Warlord-Female-Addon-3.gif\" alt=\"Outfit-Crystal-Warlord-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Soil Guardian Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/VBDXxH7/Outfit-Soil-Guardian-Male-Addon-3.gif\" alt=\"Outfit-Soil-Guardian-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/vjrvQ5f/Outfit-Soil-Guardian-Female-Addon-3.gif\" alt=\"Outfit-Soil-Guardian-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 10px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Demon Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 10px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 10px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 10px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/F3DTC8z/Outfit-Demon-Male-Addon-3.gif\" alt=\"Outfit-Demon-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/yFrDgQK/Outfit-Demon-Female-Addon-3.gif\" alt=\"Outfit-Demon-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Dream Warden Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/DGmV0rX/Outfit-Dream-Warden-Male-Addon-3.gif\" alt=\"Outfit-Dream-Warden-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/V9z1SyJ/Outfit-Dream-Warden-Female-Addon-3.gif\" alt=\"Outfit-Dream-Warden-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Glooth Engineer Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/DQttWd1/Outfit-Glooth-Engineer-Male-Addon-3.gif\" alt=\"Outfit-Glooth-Engineer-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/h2TsfxZ/Outfit-Glooth-Engineer-Female-Addon-3.gif\" alt=\"Outfit-Glooth-Engineer-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Rift Warrior Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/SPxbMXV/Outfit-Rift-Warrior-Male-Addon-3.gif\" alt=\"Outfit-Rift-Warrior-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/F3NSp9B/Outfit-Rift-Warrior-Female-Addon-3.gif\" alt=\"Outfit-Rift-Warrior-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; background-color: #d6c076;\" colspan=\"2\"><strong>Makeshift Warrior Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/p1xSDLf/Outfit-Makeshift-Warrior-Male-Addon-3.gif\" alt=\"Outfit-Makeshift-Warrior-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/8cbYpRW/Outfit-Makeshift-Warrior-Female-Addon-3.gif\" alt=\"Outfit-Makeshift-Warrior-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr>\r\n<td style=\"text-align: center; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Cave Explorer Outfit</strong></td>\r\n<td style=\"width: 12.9587%; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/MgcHRMg/Outfit-Cave-Explorer-Male-Addon-3.gif\" alt=\"Outfit-Cave-Explorer-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/yRTMrrw/Outfit-Cave-Explorer-Female-Addon-3.gif\" alt=\"Outfit-Cave-Explorer-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Battle Mage Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/3kv4Fgr/Outfit-Battle-Mage-Male-Addon-3.gif\" alt=\"Outfit-Battle-Mage-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/6PqfqLr/Outfit-Battle-Mage-Female-Addon-3.gif\" alt=\"Outfit-Battle-Mage-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Dream Warrior Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/ZXddzbt/Outfit-Dream-Warrior-Male-Addon-3.gif\" alt=\"Outfit-Dream-Warrior-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/KDJg6dr/Outfit-Dream-Warrior-Female-Addon-3.gif\" alt=\"Outfit-Dream-Warrior-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Percht Raider Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/wJqttVQ/Outfit-Percht-Raider-Male-Addon-3.gif\" alt=\"Outfit-Percht-Raider-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/TL2ys87/Outfit-Percht-Raider-Female-Addon-3.gif\" alt=\"Outfit-Percht-Raider-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Hand of the Inquisition</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/vPHgjKg/Outfit-Hand-of-the-Inquisition-Male-Addon-3.gif\" alt=\"Outfit-Hand-of-the-Inquisition-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/CWXFC6S/Outfit-Hand-of-the-Inquisition-Female-Addon-3.gif\" alt=\"Outfit-Hand-of-the-Inquisition-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Poltergeist Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/0ZrpZww/Outfit-Poltergeist-Male-Addon-3.gif\" alt=\"Outfit-Poltergeist-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/xjbN6M1/Outfit-Poltergeist-Female-Addon-3.gif\" alt=\"Outfit-Poltergeist-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Revenant Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>30</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/w0cP1VS/Outfit-Revenant-Male-Addon-3.gif\" alt=\"Outfit-Revenant-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/74SmW1H/Outfit-Revenant-Female-Addon-3.gif\" alt=\"Outfit-Revenant-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Rascoohan Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/n1GBM9T/Outfit-Rascoohan-Male-Addon-3.gif\" alt=\"Outfit-Rascoohan-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/yWTTG4W/Outfit-Rascoohan-Female-Addon-3.gif\" alt=\"Outfit-Rascoohan-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Citizen of Issavi Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>10</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/yS3gQGY/Outfit-Citizen-of-Issavi-Male-Addon-3.gif\" alt=\"Outfit-Citizen-of-Issavi-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/FV1bLgJ/Outfit-Citizen-of-Issavi-Female-Addon-3.gif\" alt=\"Outfit-Citizen-of-Issavi-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Fire-Fighter Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>20</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/wJykTK3/Outfit-Fire-Fighter-Male-Addon-3.gif\" alt=\"Outfit-Fire-Fighter-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/sR6vmgM/Outfit-Fire-Fighter-Female-Addon-3.gif\" alt=\"Outfit-Fire-Fighter-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>Ancient Aucar Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>15</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/2qFvywv/Outfit-Ancient-Aucar-Male-Addon-3.gif\" alt=\"Outfit-Ancient-Aucar-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/BBnwK2G/Outfit-Ancient-Aucar-Female-Addon-3.gif\" alt=\"Outfit-Ancient-Aucar-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; background-color: #d6c076; width: 38.0771%;\" colspan=\"2\"><strong>Decaying Defender Outfit</strong></td>\r\n<td style=\"width: 12.9587%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>30</strong></td>\r\n<td style=\"width: 11.4109%; height: 18px; text-align: center; background-color: #d6c076;\"><strong>30</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"><img src=\"https://i.ibb.co/jzNb9zw/Outfit-Decaying-Defender-Male-Addon-3.gif\" alt=\"Outfit-Decaying-Defender-Male-Addon-3\" border=\"0\" /><img src=\"https://i.ibb.co/jRDkLf8/Outfit-Decaying-Defender-Female-Addon-3.gif\" alt=\"Outfit-Decaying-Defender-Female-Addon-3\" border=\"0\" /></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; width: 38.0771%; background-color: #1800b5; height: 18px;\" colspan=\"2\"><span style=\"color: #ffff00;\"><strong>STORE OUTFITS</strong></span></td>\r\n<td style=\"width: 12.9587%; text-align: center; background-color: #1800b5; height: 18px;\"><strong> </strong></td>\r\n<td style=\"width: 11.4109%; text-align: center; background-color: #1800b5; height: 18px;\"><strong> </strong></td>\r\n<td style=\"width: 21.0634%; text-align: center; background-color: #1800b5; height: 18px;\"> </td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"text-align: center; height: 18px; width: 38.0771%; background-color: #d6c076;\" colspan=\"2\"><strong>All</strong></td>\r\n<td style=\"text-align: center; height: 18px; width: 24.3697%; background-color: #d6c076;\" colspan=\"2\"><strong>30</strong></td>\r\n<td style=\"width: 21.0634%; height: 18px; text-align: center; background-color: #d6c076;\"> </td>\r\n</tr>\r\n</tbody>\r\n</table>', 0, 1, 0, 1, 1, 0);
INSERT INTO `myaac_pages` (`id`, `name`, `title`, `body`, `date`, `player_id`, `php`, `enable_tinymce`, `access`, `hidden`) VALUES
(6, 'nivelesdeaddonbuff', 'Niveles de Addon Buff', '<table style=\"height: 987px; width: 98.1297%; border-collapse: collapse;\" border=\"4\">\r\n<tbody>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; border-style: none; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Nivel 1 - 30 puntos</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px; border-style: groove;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px; border-style: groove;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+30 Health, +180 Mana</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+30 Health, +180 Mana</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+60 Health, +90 Mana</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+90 Health, +30 Mana</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Nivel 2 - 80 puntos</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+45 Health, +270 Mana</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+45 Health, +270 Mana</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+90 Health, +135 Mana</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+135 Health, +45 Mana</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Nivel 3 - 160 puntos</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\">+45 Health, +270 Mana, <span style=\"color: #008000;\"><strong>+1 Magic</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\">+45 Health, +270 Mana, <strong><span style=\"color: #008000;\">+1 Magic</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\">+90 Health, +135 Mana, <span style=\"color: #008000;\"><strong>+1 Distance</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 86.6505%; height: 18px;\" colspan=\"3\">+135 Health, +45 Mana, <span style=\"color: #008000;\"><strong>+1 Sword/Axe/Club, +1 Shield</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong> Nivel 4 - 220 puntos</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+60 Health, +360 Mana</strong><strong>,</strong></span> +1 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+60 Health, +360 Mana</strong><strong>,</strong> </span>+1 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+120 Health, +180 Mana</strong><strong>,</strong> </span>+1 Distance</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+180 Health, +60 Mana,</span></strong> +1 Sword/Axe/Club, +1 Shield</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; background-color: #800909; text-align: center;\" colspan=\"4\"><strong> <span style=\"color: #ffffff;\">Nivel 5 - 320 puntos</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+60 Health, +360 Mana, <span style=\"color: #008000;\"><strong>+2 Magic</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+60 Health, +360 Mana, <span style=\"color: #008000;\"><strong>+2 Magic</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+120 Health, +180 Mana, <span style=\"color: #008000;\"><strong>+2 Distance, +1 Magic</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+180 Health, +60 Mana, <span style=\"color: #008000;\"><strong>+2 Sword/Axe/Club, +2 Shield</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Nivel 6 - 430 puntos</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+120 Health, +720 Mana,</span></strong> +2 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+120 Health, +720 Mana,</strong></span> +2 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+240 Health, +360 Mana,</strong></span> +2 Distance, +1 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+360 Health, +120 Mana</strong><strong>,</strong></span> +2 Sword/Axe/Club, +2 Shield</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Nivel 7 - 550 puntos</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+120 Health, +720 Mana, <span style=\"color: #008000;\"><strong>+3 Magic</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+120 Health, +720 Mana, <span style=\"color: #008000;\"><strong>+3 Magic</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+240 Health, +360 Mana, <span style=\"color: #008000;\"><strong>+3 Distance,</strong></span> +1 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+360 Health, +120 Mana, <span style=\"color: #008000;\"><strong>+3 Sword/Axe/Club, +3 Shield, +1 Magic</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Nivel 8 - 850 puntos</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+240 Health, +1440 Mana, </strong></span>+3 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+240 Health, +1440 Mana,</strong></span> +3 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+480 Health, +720 Mana</strong><strong>,</strong></span> +3 Distance, +1 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+720 Health, +240 Mana,</strong></span> +3 Sword/Axe/Club, +3 Shield, +1 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Nivel 9 - 1300 puntos</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+240 Health, +1440 Mana, <span style=\"color: #008000;\"><strong>+4 Magic, </strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 16px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 36.6505%; height: 16px;\" colspan=\"3\">+240 Health, +1440 Mana, <span style=\"color: #008000;\"><strong>+4 Magic, </strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+480 Health, +720 Mana, <span style=\"color: #008000;\"><strong>+4 Distance, +2 Magic</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+720 Health, +240 Mana, <span style=\"color: #008000;\"><strong>+4 Sword/Axe/Club, +4 Shield, </strong></span>+1 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong><span style=\"text-align: center;\">Nivel 10 - 1800 puntos</span></strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+480 Health, +2880 Mana, +5 Magic, </span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+480 Health, +2880 Mana, +5 Magic, </span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><strong><span style=\"color: #008000;\">+920 Health, +1440 Mana, +5 Distance, </span></strong>+2 Magic, </td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+1440 Health, +480 Mana,</strong></span> <span style=\"color: #008000;\"><strong>+5 Sword/Axe/Club, +5 Shield, </strong></span>+1 Magic,</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 100%; height: 18px; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Nivel 11 - 2500 puntos</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Sorcerers:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+480 Health, +2880 Mana,<strong><span style=\"color: #008000;\"> +7 Magic, </span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Druids:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+480 Health, +2880 Mana,<strong><span style=\"color: #008000;\"> +7 Magic</span></strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 18px;\"><strong>Paladins:</strong></td>\r\n<td style=\"width: 36.6505%; height: 18px;\" colspan=\"3\">+920 Health, +1440 Mana,<strong><span style=\"color: #008000;\"> +7 Distance, </span></strong>+2 Magic</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 13.3495%; height: 17px;\"><strong>Knights:</strong></td>\r\n<td style=\"height: 17px;\" colspan=\"3\">+1440 Health, +480 Mana, <span style=\"color: #008000;\"><strong>+7 Sword/Axe/Club, +7 Shield, </strong></span>+1 Magic</td>\r\n</tr>\r\n<tr>\r\n<td style=\"width: 13.3495%; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Nivel 12 - 3300 puntos</strong></span></td>\r\n</tr>\r\n<tr>\r\n<td style=\"width: 13.3495%;\"><strong>Sorcerers:</strong></td>\r\n<td colspan=\"3\"><span style=\"color: #008000;\"><strong>+600 Health, +4000 Mana, +10 Magic</strong></span></td>\r\n</tr>\r\n<tr>\r\n<td style=\"width: 13.3495%;\"><strong>Druids:</strong></td>\r\n<td colspan=\"3\"><span style=\"color: #008000;\"><strong>+600 Health, +4000 Mana, +10 Magic</strong></span></td>\r\n</tr>\r\n<tr>\r\n<td style=\"width: 13.3495%;\"><strong>Paladins:</strong></td>\r\n<td colspan=\"3\"><span style=\"color: #008000;\"><strong>+1200 Health, +2000 Mana, +10 Distance, +3 Magic</strong></span></td>\r\n</tr>\r\n<tr>\r\n<td style=\"width: 13.3495%;\"><strong>Knights:</strong></td>\r\n<td style=\"width: 36.6505%;\" colspan=\"3\"><span style=\"color: #008000;\"><strong>+2000 Health, +650 Mana, +10 Sword/Axe/Club, +10 Shield, +2 Magic</strong></span></td>\r\n</tr>\r\n</tbody>\r\n</table>', 0, 1, 0, 1, 1, 0),
(8, 'onlinetokens', 'Online Tokens', '<table style=\"border-collapse: collapse; width: 100%;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"border-style: solid; background-color: #800909; border-color: #000000;\">\r\n<td style=\"width: 25%; background-color: #800909; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Sistema de Online Tokens</strong></span></td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p>En Nebula tenemos un sistema de Tokens llamados \"<span style=\"color: #008000;\"><strong>Online</strong><strong> Tokens</strong></span>\" estos son obtenidos solamente con permanecer<strong><span style=\"color: #008000;\"> Online</span></strong> y automaticamente cada <strong>1 Hora</strong> se agregaran a tu Backpack (<strong>1 Online Token para Free players</strong>) y (<span style=\"color: #008000;\"><strong>2 Online Tokens para Vip players</strong></span>). Estos sirven dentro del juego para poder cambiarlos por <strong>Equipment</strong> y otros <strong>Accesorios de Utilidad</strong> con el <strong>Npc</strong> llamado \"<strong><span style=\"color: #008000;\">John Tokensforge</span></strong>\" o tambien podras cambiarlos por <strong>TibiaDrome Potions</strong> con el <strong>Npc</strong> llamado \"<span style=\"color: #008000;\"><strong>Jane TokensDrome</strong></span>\".</p>\r\n<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"https://i.ibb.co/ns1LCCj/online-token.gif\" alt=\"online-token\" width=\"104\" height=\"104\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\"><strong>Online Token</strong></p>\r\n<p style=\"text-align: center;\"><img src=\"https://i.ibb.co/tXNLk9m/john-tokensforge.png\" alt=\"john-tokensforge\" width=\"217\" height=\"263\" border=\"0\" /><img src=\"https://i.ibb.co/CK1yf41/jane-tokensdrome.png\" alt=\"jane-tokensdrome\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Puedes encontrarlos en el Templo de Thais.</span></p>', 0, 1, 0, 1, 1, 0),
(9, 'beneficiosvip', 'Beneficios Vip', '<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"https://i.ibb.co/XVsYN6m/Nebula-Logo-alargado.jpg\" alt=\"Nebula-Logo-alargado\" width=\"267\" height=\"150\" border=\"0\" /></p>\r\n<h1 style=\"text-align: center;\">VIP System Nebula</h1>\r\n<p> </p>\r\n<table style=\"border-collapse: collapse; width: 100%; height: 126px;\" border=\"1\">\r\n<thead>\r\n<tr style=\"height: 18px; border-style: double; border-color: #030000;\">\r\n<td style=\"width: 25%; height: 19px; background-color: #800909; border-style: double; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>Vip System Information</strong></span></td>\r\n</tr>\r\n</thead>\r\n<tbody>\r\n<tr style=\"height: 18px; border-style: double; border-color: #000000;\">\r\n<td style=\"width: 25%; height: 18px; text-align: center; background-color: #969393;\" colspan=\"2\"><span style=\"color: #000000;\"><strong>Benefit</strong></span></td>\r\n<td style=\"width: 25%; height: 18px; text-align: center; background-color: #969393;\"><span style=\"color: #000000;\"><strong>Free</strong></span></td>\r\n<td style=\"width: 25%; height: 18px; text-align: center; background-color: #969393;\"><span style=\"color: #000000;\"><strong>Vip</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 25%; height: 18px; text-align: center;\">Exp Rate</td>\r\n<td style=\"width: 25%; height: 18px; text-align: center;\"><img src=\"https://www.tibiawiki.com.br/images/f/f3/XP_Boost.gif\" /></td>\r\n<td style=\"width: 25%; height: 18px; text-align: center;\"><img style=\"color: #5a2800; font-family: Verdana, Arial, \'Times New Roman\', sans-serif; font-size: 13.3333px; text-align: -webkit-center; background-color: #d4c0a1;\" src=\"https://lumeriaot.com/images/premiumfeatures/icon_no.png\" /></td>\r\n<td style=\"width: 25%; height: 18px; text-align: center;\"><span style=\"color: #008000;\"><strong>+20%</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 25%; height: 18px; text-align: center;\">Loot Rate</td>\r\n<td style=\"width: 25%; height: 18px; text-align: center;\"><a style=\"font-family: Verdana, Arial, \'Times New Roman\', sans-serif; font-size: 13.3333px; text-align: -webkit-center;\" href=\"https://ibb.co/svJ1dWw\"><img src=\"https://i.ibb.co/DDgMHrC/Crystal-Coin.gif\" alt=\"Crystal-Coin\" border=\"0\" /></a></td>\r\n<td style=\"width: 25%; height: 18px; text-align: center;\"><img style=\"color: #5a2800; font-family: Verdana, Arial, \'Times New Roman\', sans-serif; font-size: 13.3333px; text-align: -webkit-center; background-color: #d4c0a1;\" src=\"https://lumeriaot.com/images/premiumfeatures/icon_no.png\" /></td>\r\n<td style=\"width: 25%; height: 18px; text-align: center;\"><span style=\"color: #008000;\"><strong>+15%</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 35px;\">\r\n<td style=\"width: 25%; text-align: center; height: 35px;\">Bonus Skill</td>\r\n<td style=\"width: 25%; text-align: center; height: 35px;\"><a style=\"font-family: Verdana, Arial, \'Times New Roman\', sans-serif; font-size: 13.3333px; text-align: -webkit-center;\" href=\"https://ibb.co/DWfcXJ2\"><img src=\"https://i.ibb.co/xLq9vkT/Lasting-Exercise-Sword.gif\" alt=\"Lasting-Exercise-Sword\" border=\"0\" /></a></td>\r\n<td style=\"width: 25%; text-align: center; height: 35px;\"><img style=\"color: #5a2800; font-family: Verdana, Arial, \'Times New Roman\', sans-serif; font-size: 13.3333px; text-align: -webkit-center; background-color: #d4c0a1;\" src=\"https://lumeriaot.com/images/premiumfeatures/icon_no.png\" /></td>\r\n<td style=\"width: 25%; text-align: center; height: 35px;\"><span style=\"color: #008000;\"><strong>+10%</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 25%; height: 18px; text-align: center;\">Latin Tokens</td>\r\n<td style=\"width: 25%; height: 18px; text-align: center;\"><img src=\"https://i.ibb.co/ns1LCCj/online-token.gif\" alt=\"online-token\" border=\"0\" /></td>\r\n<td style=\"width: 25%; height: 18px; text-align: center;\">1</td>\r\n<td style=\"width: 25%; height: 18px; text-align: center;\"><span style=\"color: #008000;\"><strong>2</strong></span></td>\r\n</tr>\r\n</tbody>\r\n</table>', 0, 1, 0, 1, 1, 0),
(11, 'donate', 'Buy Tibia Coins!!', '<h2 style=\"text-align: center;\"><img style=\"font-size: 14px; font-weight: 400; text-align: start;\" src=\"https://www.tibiabr.com/wp-content/uploads/2017/11/TibiaCoins.png\" alt=\" \" width=\"129\" height=\"129\" /></h2>\r\n<h2 style=\"text-align: center;\">Proceso para compra de Tibia Coins</h2>\r\n<p><strong><span style=\"color: #000000;\">1.</span>-</strong> Decide la cantidad de Tibia Coins que deseas obtener, en la parte inferior se muestra una tabla de precios/coins.</p>\r\n<table style=\"border-collapse: collapse; width: 100%; height: 144px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 18px; border-style: double; border-color: #050000; background-color: #800909;\">\r\n<td style=\"width: 50%; height: 18px; text-align: center;\"><span style=\"color: #ffffff;\"><strong>Precio en MXN</strong></span></td>\r\n<td style=\"width: 50%; height: 18px; background-color: #800909; border-color: #000000; border-style: double; text-align: center;\"><span style=\"color: #ffffff;\"><strong>Tibia Coins</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 50%; height: 18px; text-align: center;\"><strong>    $200 Pesos   </strong></td>\r\n<td style=\"width: 50%; text-align: center; height: 18px;\"><strong>  2,250 Tc</strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 50%; height: 18px; text-align: center;\"><strong>    $350 Pesos   </strong></td>\r\n<td style=\"width: 50%; text-align: center; height: 18px;\"><strong>  4,100 Tc</strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 50%; height: 18px; text-align: center;\"><strong>     $400 Pesos    </strong></td>\r\n<td style=\"width: 50%; text-align: center; height: 18px;\"><strong>  5,100 Tc</strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 50%; height: 18px; text-align: center;\"><strong> $700 Pesos</strong></td>\r\n<td style=\"width: 50%; text-align: center; height: 18px;\"><strong>  9,200 Tc</strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 50%; height: 18px; text-align: center;\"><strong> $800 Pesos</strong></td>\r\n<td style=\"width: 50%; text-align: center; height: 18px;\"><strong>11,310 Tc</strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 50%; height: 18px; text-align: center;\"><strong> $1400 Pesos</strong></td>\r\n<td style=\"width: 50%; text-align: center; height: 18px;\"><strong>21,600 Tc</strong></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 50%; height: 18px; text-align: center;\"><strong> $1600 Pesos</strong></td>\r\n<td style=\"width: 50%; text-align: center; height: 18px;\"><strong>26,200 Tc</strong></td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p><span style=\"color: #000000;\"><strong>2.-</strong> Transfiere la cantidad la <span style=\"color: #0000ff;\"><strong>Tarjeta BBVA</strong></span> que esta en la parte inferior de la pagina.</span></p>\r\n<p><span style=\"color: #000000;\"><strong>3.-</strong> </span>Escribe el <span style=\"text-decoration: underline;\"><strong><span style=\"color: #008000; text-decoration: underline;\">nombre de tu personaje principal</span></strong></span> en la casilla de \"<span style=\"text-decoration: underline;\"><span style=\"color: #008000;\"><strong>Concepto</strong></span></span>\".</p>\r\n<p><span style=\"color: #000000;\"><strong>4.-</strong></span>  Comparte tu comprobante de pago con algun <span style=\"color: #008000;\"><strong>Admin de Nebula</strong></span>, puedes ubicarlos Ingame, <span style=\"color: #0000ff;\"><a style=\"color: #0000ff;\" href=\"https://discord.com/invite/rQEM7TbtcW\" target=\"_blank\" rel=\"noopener\"><strong>Discord</strong></a></span> o en el grupo de <span style=\"color: #0000ff;\"><a style=\"color: #0000ff;\" href=\"https://chat.whatsapp.com/IGQpMT0nQLdJvXHSaIW1ll\" target=\"_blank\" rel=\"noopener\"><strong>Whatsapp Nebula</strong>.</a></span></p>\r\n<p><span style=\"color: #000000;\"><strong>5.-</strong></span> Tus<strong> <span style=\"color: #008000;\">Tibia Coins</span></strong> equivalentes a la cantidad de <span style=\"color: #008000;\"><strong>Donacion</strong></span> seran entregadas a la brevedad.       </p>\r\n<p style=\"text-align: center;\">                   <img src=\"https://i.ibb.co/R42QkwK/73bcbd74-a2fe-44fa-b3e2-7d64f4b7a5d8.jpg\" alt=\"73bcbd74-a2fe-44fa-b3e2-7d64f4b7a5d8\" width=\"249\" height=\"116\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\">4152 3141 8614 7719</p>\r\n<p style=\"text-align: center;\">BBVA</p>', 0, 1, 0, 1, 1, 0),
(13, 'tasksystem', 'Task System', '<table style=\"border-collapse: collapse; width: 100%;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"background-color: #800909; border-color: #000000; border-style: solid;\">\r\n<td style=\"width: 20%; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>TASK SYSTEM</strong></span></td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p>Nuestro <span style=\"color: #0000ff;\"><strong>Task System</strong></span> consiste en tasks individuales de creaturas, cada una con cierta cantidad a matar y diferentes rewards al terminar cada una, ya sea <strong><span style=\"color: #008000;\">Exp, Crystal Coins</span></strong> y lo mas importante <strong><span style=\"color: #008000;\">Task Points</span></strong>. Contamos con una muy amplia lista de creaturas a escoger que abarca<span style=\"text-decoration: underline;\"> la mayoria de las existentes en Tibia</span>, ordenadas Alfabeticamente para facilitar su ubicacion.</p>\r\n<p>Al acumular determinada cantidad de <span style=\"color: #008000;\"><strong>Task Points</strong></span>, podras usarlos en la <strong><span style=\"color: #ff6600;\">Shop</span></strong> dentro de la <span style=\"text-decoration: underline;\">ventana de Tasks</span> para comprar items variados, <span style=\"text-decoration: underline;\"><strong><span style=\"color: #008000; text-decoration: underline;\">Decoracion</span></strong></span>, algunos son necesarios para<span style=\"text-decoration: underline;\"><span style=\"color: #008000; text-decoration: underline;\"><strong> Addons</strong></span>, <span style=\"color: #008000; text-decoration: underline;\"><strong>Monturas</strong></span>,<strong><span style=\"color: #008000; text-decoration: underline;\"> Utilidad</span></strong></span>, etc.</p>\r\n<table style=\"border-collapse: collapse; width: 100%;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"border-style: hidden;\">\r\n<td style=\"width: 7.8125%;\"><img src=\"https://i.ibb.co/cLRjpNQ/Dream-Catcher-Pole.gif\" alt=\"Dream-Catcher-Pole\" border=\"0\" /></td>\r\n<td style=\"width: 92.1875%; border-style: hidden;\">Veras este \"<span style=\"color: #008000;\"><strong>Task Totem</strong></span>\" en los depots de las ciudades, al usarlo te abrira la ventana de <strong><span style=\"color: #008000;\">Tasks</span></strong> y ahi podras escoger entre la <span style=\"text-decoration: underline;\">larga lista de <span style=\"color: #008000; text-decoration: underline;\"><strong>+200</strong></span> creaturas</span>, algunas se pueden hacer diarias y otras una sola vez, <span style=\"text-decoration: underline;\">sin limite de Tasks simultaneamente</span>.</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p style=\"text-align: left;\"> </p>\r\n<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"https://i.ibb.co/Js259V9/tasksmodal.png\" alt=\"tasksmodal\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\"><span style=\"color: #0000ff;\"><strong>Puedes elegir tasks, cancelar o comprar en la<span style=\"color: #ff6600;\"> Shop</span> cuando quieras</strong></span></p>', 0, 1, 0, 1, 1, 0),
(14, 'koliseum', 'Koliseum', '<table style=\"border-collapse: collapse; width: 100%;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"background-color: #800909; border-style: solid; border-color: #000000;\">\r\n<td style=\"width: 25%; text-align: center;\" colspan=\"4\"><span style=\"color: #ffffff;\"><strong>K O L I S E U M</strong></span></td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p>El <strong><span style=\"color: #993300;\">Koliseum</span></strong> de Nebula consiste en una Arena a la que se puede ingresar desde la flama de color Azul que se encuentra en el Templo de Thais.</p>\r\n<p>El Maximo de players para hacer Koliseum es de <strong>5</strong> y solamente se puede accesar teniendo un<span style=\"text-decoration: underline;\"> \"<span style=\"color: #000080; text-decoration: underline;\"><strong>Koliseum Ticket</strong></span>\"</span>, el cual puedes comprar en el <span style=\"text-decoration: underline; color: #0000ff;\"><strong>Gamestore,</strong></span> al intentar pasar el Portal Negro solo entraran los players que tengan uno en su inventory, <span style=\"text-decoration: underline;\">los demas no podran entrar al Lever Room</span>.</p>\r\n<p>Esta consta de<span style=\"text-decoration: underline;\"> 7 Niveles</span> y <span style=\"text-decoration: underline;\">1 Boss por cada nivel</span> y cada Boss dará de Loot una variable cantidad de \"<strong><span style=\"color: #993300;\">Koliseum Tokens</span></strong>\" entre mas alto sea el nivel del Boss, mas Tokens dropearan y entre mas niveles avances, aumentará la <strong>fuerza</strong> del siguiente Boss. </p>\r\n<p>El Maximo de <strong><span style=\"color: #993300;\">Koliseum Tokens</span></strong> a conseguir por los 7 Niveles es dependiendo un poco de la suerte, estos Tokens podras cambiarlos con el Npc \"<strong>Koliseum Trader</strong>\" por <strong>Trofeos</strong> que te otorgaran <strong>Buff de Stats, </strong>y van equipados en el slot de la Torch.</p>\r\n<p> </p>\r\n<table style=\"border-collapse: collapse; width: 100%; height: 385px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"background-color: #800909; border-style: solid; border-color: #000000;\">\r\n<td style=\"width: 23.7768%; text-align: center; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Boss</strong></span></td>\r\n<td style=\"width: 4.31084%; text-align: center; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Niv</strong></span></td>\r\n<td style=\"width: 11.295%; text-align: center; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Atributos</strong></span></td>\r\n<td style=\"width: 60.6173%; text-align: center; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Recomendaciones</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 23.7768%; height: 18px; background-color: #e8d497;\">\r\n<p style=\"text-align: center;\"><img src=\"https://i.ibb.co/9TyQC9x/Misguided-Shadow.gif\" alt=\"Misguided-Shadow\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\"><strong>Razorbrood</strong></p>\r\n</td>\r\n<td style=\"width: 4.31084%; height: 18px; text-align: center;\">\r\n<p><strong>1</strong></p>\r\n<p style=\"text-align: left;\"> </p>\r\n</td>\r\n<td style=\"width: 11.295%; height: 18px;\">\r\n<p style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Damage:</strong></span></p>\r\n<p><span style=\"color: #cc99ff;\"><strong>Energy</strong></span></p>\r\n<p><span style=\"color: #b8b814;\"><strong>Holy</strong></span></p>\r\n</td>\r\n<td style=\"width: 60.6173%; height: 18px;\">\r\n<p><strong><span style=\"text-decoration: underline;\">Recomendado Nivel 300+</span></strong></p>\r\n<p>Razorbrood es un Boss que mayormente hace daño de Energy y Holy, no representa dificultad alguna para cualquier team.</p>\r\n<p> </p>\r\n</td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 23.7768%; height: 18px; background-color: #e8d497;\">\r\n<p style=\"text-align: center;\"><img src=\"https://i.ibb.co/TWQMDRk/Glooth-Horror.gif\" alt=\"Glooth-Horror\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\"><strong>Trancescreamer</strong></p>\r\n</td>\r\n<td style=\"width: 4.31084%; height: 18px; text-align: center;\"><strong>2</strong></td>\r\n<td style=\"width: 11.295%; height: 18px;\">\r\n<p style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Damage:</strong></span></p>\r\n<p><span style=\"color: #7ca600;\"><strong>Earth</strong></span></p>\r\n<p><span style=\"color: #b8b814;\"><strong>Holy</strong></span></p>\r\n</td>\r\n<td style=\"width: 60.6173%; height: 18px;\">\r\n<p><strong><span style=\"text-decoration: underline;\">Recomendado Nivel 350+</span></strong></p>\r\n<p>Trancescreamer es un Boss de daño de Earth,Holy y Paralyze bastante duro, no representa dificultad para cualquier team.</p>\r\n</td>\r\n</tr>\r\n<tr style=\"height: 127px;\">\r\n<td style=\"width: 23.7768%; height: 127px; background-color: #e8d497;\">\r\n<p style=\"text-align: center;\"><img src=\"https://i.ibb.co/pLGLDxX/The-Unarmored-Voidborn.gif\" alt=\"The-Unarmored-Voidborn\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\"><strong>Skalbagge</strong></p>\r\n</td>\r\n<td style=\"width: 4.31084%; height: 127px; text-align: center;\"><strong>3</strong></td>\r\n<td style=\"width: 11.295%; height: 127px;\">\r\n<p style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Damage:</strong></span></p>\r\n<p><span style=\"color: #30b0ff;\"><strong>Ice</strong></span></p>\r\n<p><span style=\"color: #b8b814;\"><strong>Holy</strong></span></p>\r\n<p><span style=\"color: #800080;\"><strong>ManaDrain</strong></span></p>\r\n</td>\r\n<td style=\"width: 60.6173%; height: 127px;\">\r\n<p><strong><span style=\"text-decoration: underline;\">Recomendado Nivel 450+</span></strong></p>\r\n<p>Skalbagge es un Boss que hace Mana Drain, y ataques de Ice y Holy, puede pegar combos fuertes, dificultad media.</p>\r\n</td>\r\n</tr>\r\n<tr style=\"height: 124px;\">\r\n<td style=\"width: 23.7768%; height: 124px; background-color: #e8d497;\">\r\n<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"https://i.ibb.co/MG4XNNM/The-Sandking.gif\" alt=\"The-Sandking\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\"><strong> Hollowsnake</strong></p>\r\n</td>\r\n<td style=\"width: 4.31084%; height: 124px; text-align: center;\"><strong>4</strong></td>\r\n<td style=\"width: 11.295%; height: 124px;\">\r\n<p style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Damage:</strong></span></p>\r\n<p><span style=\"color: #ff5100;\"><strong>Fire</strong></span></p>\r\n<p><span style=\"color: #b8b814;\"><strong>Holy</strong></span></p>\r\n</td>\r\n<td style=\"width: 60.6173%; height: 124px;\">\r\n<p><strong><span style=\"text-decoration: underline;\">Recomendado Nivel 550+</span></strong></p>\r\n<p>Hollowsnake es un Boss muy rapido y con retarget cada 3 turnos, ataca con Fire y Holy, da combos muy rapidos, se recomienda hacerle trap y usar rings o amulets de proteccion</p>\r\n</td>\r\n</tr>\r\n<tr style=\"height: 80px;\">\r\n<td style=\"width: 23.7768%; height: 80px; background-color: #e8d497;\">\r\n<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"https://i.ibb.co/fXF9QYV/Ugly-Monster.gif\" alt=\"Ugly-Monster\" width=\"90\" height=\"90\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\"><strong>        Abortion</strong></p>\r\n</td>\r\n<td style=\"width: 4.31084%; height: 80px; text-align: center;\"><strong>5</strong></td>\r\n<td style=\"width: 11.295%; height: 80px;\">\r\n<p style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Damage:</strong></span></p>\r\n<p><span style=\"color: #333333;\"><strong>Death</strong></span></p>\r\n<p><span style=\"color: #b8b814;\"><strong>Holy</strong></span></p>\r\n<p><span style=\"color: #ff5100;\"><strong>Fire</strong></span></p>\r\n</td>\r\n<td style=\"width: 60.6173%; height: 80px;\">\r\n<p><strong><span style=\"text-decoration: underline;\">Recomendado Nivel 600+</span></strong></p>\r\n<p>Ugly Abortion es un Boss muy rapido, se hace invisible, da combos muy fuertes basados en Death, Holy y Fire, recomendado usar siempre Amuletos y Anillos. Boss Dificil</p>\r\n</td>\r\n</tr>\r\n<tr>\r\n<td style=\"width: 23.7768%; background-color: #e8d497;\">\r\n<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"https://i.ibb.co/w4dJMFQ/The-Abomination.gif\" alt=\"The-Abomination\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\"><strong>Ritakondor</strong></p>\r\n</td>\r\n<td style=\"width: 4.31084%; text-align: center;\"><strong>6</strong></td>\r\n<td style=\"width: 11.295%;\">\r\n<p style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Damage:</strong></span></p>\r\n<p><strong><span style=\"color: #333333;\">Death</span>/<span style=\"color: #b8b814;\">Holy</span></strong></p>\r\n<p><span style=\"color: #800080;\"><strong>ManaDrain</strong></span></p>\r\n<p><span style=\"color: #ff9900;\"><strong>LifeDrain</strong></span></p>\r\n</td>\r\n<td style=\"width: 60.6173%;\">\r\n<p><strong><span style=\"text-decoration: underline;\">Recomendado Nivel 650+</span></strong></p>\r\n<p>Ritakondor es un Boss bastante dificil debido a los combos que puede tirar, usar siempre Amuletos y Anillos de proteccion, sus ataques son de Life Drain, Mana Drain, Death y Holy. Boss Dificil</p>\r\n</td>\r\n</tr>\r\n<tr>\r\n<td style=\"width: 23.7768%; background-color: #e8d497;\">\r\n<p style=\"text-align: center;\"><img src=\"https://i.ibb.co/Gx5PYW5/Outfit-Golden-Male-Addon-3.gif\" alt=\"Outfit-Golden-Male-Addon-3\" width=\"80\" height=\"80\" border=\"0\" /><img src=\"https://i.ibb.co/HFH05VB/Spirit-of-Purity.gif\" alt=\"Spirit-of-Purity\" width=\"65\" height=\"65\" border=\"0\" /></p>\r\n<p style=\"text-align: center;\"><strong>Thundrax</strong></p>\r\n</td>\r\n<td style=\"width: 4.31084%; text-align: center;\"><strong>7</strong></td>\r\n<td style=\"width: 11.295%;\">\r\n<p style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Damage:</strong></span></p>\r\n<p><strong><span style=\"color: #808080;\">Physical</span>/<span style=\"color: #b8b814;\">Holy</span></strong><strong>/</strong></p>\r\n<p><strong><span style=\"color: #30b0ff;\">Ice</span></strong><strong>/<span style=\"color: #cc99ff;\">Energy</span></strong></p>\r\n</td>\r\n<td style=\"width: 60.6173%;\">\r\n<p><strong><span style=\"text-decoration: underline;\">Recomendado Nivel 700+</span></strong></p>\r\n<p>Thundrax es el Boss final del Koliseum, sus ataques son basados en todos los elementos y muy repetitivos, puede pegar combos arriba de 6k por turno, siempre usar Anillos y Amuletos de resistencia y la mayor proteccion posible</p>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p> </p>', 0, 1, 0, 1, 1, 0),
(16, 'tibiacoinspromoss', 'Tibia Coins Promos', '<table style=\"border-collapse: collapse; width: 100%;\" border=\"1\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 16.6667%; border-style: double; border-color: #030303;\" colspan=\"6\" rowspan=\"2\">\r\n<h3>Aqui podras encontrar <span style=\"text-decoration: underline; color: #008000;\"><strong>Promociones de Tibia Coins</strong></span> que estaran disponibles por determinado tiempo, estas tendran una duracion predeterminada y podran estar disponibles despues, asi como otro tipo de diferentes promociones.</h3>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p>                                                                                                                                     </p>\r\n<table style=\"border-collapse: collapse; width: 79.28%; height: 176px;\" border=\"1\">\r\n<tbody>\r\n<tr style=\"height: 32px; border-color: #000000; background-color: #b3adad;\">\r\n<td style=\"width: 27.3273%; border-style: double; border-color: #000000; text-align: center; height: 32px;\" colspan=\"2\">\r\n<p><span style=\"color: #ffffff;\"><strong><span style=\"color: #000000;\">Duracion</span></strong></span><span style=\"color: #ffffff;\"><strong><span style=\"color: #000000;\"><br /></span></strong></span></p>\r\n</td>\r\n<td style=\"width: 17.6967%; border-style: double; border-color: #000000; text-align: center; height: 32px;\"><span style=\"color: #ffffff;\"><strong><span style=\"color: #000000;\">Promo:</span></strong><strong><span style=\"color: #000000;\"><br /></span></strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px; background-color: #800909; border-color: #0d0c0c;\">\r\n<td style=\"height: 18px; border-style: double; border-color: #000000; text-align: center;\" colspan=\"2\">\r\n<p><span style=\"color: #ffffff;\"><strong>Los primeros 3 dias de apertura</strong></span></p>\r\n</td>\r\n<td style=\"height: 18px; width: 17.6967%; border-style: double; border-color: #000000; text-align: center;\"><span style=\"color: #ffffff;\"><strong> 30% mas de Tcs</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"height: 18px; width: 11.1111%; text-align: center;\"><strong>$200</strong></td>\r\n<td style=\"width: 16.2162%; height: 18px; text-align: center;\"><span style=\"color: #ff0000;\"><strong><span style=\"text-decoration: line-through;\">2,250</span></strong></span></td>\r\n<td style=\"width: 17.6967%; height: 18px; text-align: center;\"><span style=\"color: #008000;\"><strong>2,925</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 11.1111%; height: 18px; text-align: center;\"><strong>$350</strong></td>\r\n<td style=\"width: 16.2162%; height: 18px; text-align: center;\"><span style=\"color: #ff0000;\"><strong><span style=\"text-decoration: line-through;\">4,100</span></strong></span></td>\r\n<td style=\"width: 17.6967%; height: 18px; text-align: center;\"><span style=\"color: #008000;\"><strong>5,330</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 11.1111%; height: 18px; text-align: center;\"><strong>$400</strong></td>\r\n<td style=\"width: 16.2162%; height: 18px; text-align: center;\"><span style=\"color: #ff0000;\"><strong><span style=\"text-decoration: line-through;\">5,100</span></strong></span></td>\r\n<td style=\"width: 17.6967%; height: 18px; text-align: center;\"><span style=\"color: #008000;\"><strong>6,630</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 11.1111%; height: 18px; text-align: center;\"><strong>$700</strong></td>\r\n<td style=\"width: 16.2162%; height: 18px; text-align: center;\"><span style=\"color: #ff0000;\"><strong><span style=\"text-decoration: line-through;\">9,200</span></strong></span></td>\r\n<td style=\"width: 17.6967%; height: 18px; text-align: center;\"><span style=\"color: #008000;\"><strong>11,960</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 11.1111%; height: 18px; text-align: center;\"><strong>$800</strong></td>\r\n<td style=\"width: 16.2162%; height: 18px; text-align: center;\"><span style=\"color: #ff0000;\"><strong><span style=\"text-decoration: line-through;\">11,310</span></strong></span></td>\r\n<td style=\"width: 17.6967%; height: 18px; text-align: center;\"><span style=\"color: #008000;\"><strong>14,703</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 11.1111%; height: 18px; text-align: center;\"><strong>$1400</strong></td>\r\n<td style=\"width: 16.2162%; height: 18px; text-align: center;\"><span style=\"color: #ff0000;\"><strong><span style=\"text-decoration: line-through;\">21,600</span></strong></span></td>\r\n<td style=\"width: 17.6967%; height: 18px; text-align: center;\"><span style=\"color: #008000;\"><strong>28,080</strong></span></td>\r\n</tr>\r\n<tr style=\"height: 18px;\">\r\n<td style=\"width: 11.1111%; height: 18px; text-align: center;\"><strong>$1600</strong></td>\r\n<td style=\"width: 16.2162%; height: 18px; text-align: center;\"><span style=\"color: #ff0000;\"><strong><span style=\"text-decoration: line-through;\">26,200</span></strong></span></td>\r\n<td style=\"width: 17.6967%; height: 18px; text-align: center;\"><span style=\"color: #008000;\"><strong>34,060</strong></span></td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p><img src=\"https://i.ibb.co/WzgB9wJ/header-spiele-tibia-DE.png\" alt=\"header-spiele-tibia-DE\" width=\"529\" height=\"165\" border=\"0\" /></p>', 0, 1, 0, 1, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `myaac_polls`
--

CREATE TABLE `myaac_polls` (
  `id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `end` int(11) NOT NULL,
  `start` int(11) NOT NULL,
  `answers` int(11) NOT NULL,
  `votes_all` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_polls_answers`
--

CREATE TABLE `myaac_polls_answers` (
  `poll_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `answer` varchar(255) NOT NULL,
  `votes` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_spells`
--

CREATE TABLE `myaac_spells` (
  `id` int(11) NOT NULL,
  `spell` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL,
  `words` varchar(255) NOT NULL DEFAULT '',
  `category` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 - attack, 2 - healing, 3 - summon, 4 - supply, 5 - support',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 - instant, 2 - conjure, 3 - rune',
  `level` int(11) NOT NULL DEFAULT 0,
  `maglevel` int(11) NOT NULL DEFAULT 0,
  `mana` int(11) NOT NULL DEFAULT 0,
  `soul` tinyint(3) NOT NULL DEFAULT 0,
  `conjure_id` int(11) NOT NULL DEFAULT 0,
  `conjure_count` tinyint(3) NOT NULL DEFAULT 0,
  `reagent` int(11) NOT NULL DEFAULT 0,
  `item_id` int(11) NOT NULL DEFAULT 0,
  `premium` tinyint(1) NOT NULL DEFAULT 0,
  `vocations` varchar(100) NOT NULL DEFAULT '',
  `hidden` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_videos`
--

CREATE TABLE `myaac_videos` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL DEFAULT '',
  `youtube_id` varchar(20) NOT NULL,
  `author` varchar(50) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT 0,
  `hidden` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_visitors`
--

CREATE TABLE `myaac_visitors` (
  `ip` varchar(45) NOT NULL,
  `lastvisit` int(11) NOT NULL DEFAULT 0,
  `page` varchar(2048) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myaac_weapons`
--

CREATE TABLE `myaac_weapons` (
  `id` int(11) NOT NULL,
  `level` int(11) NOT NULL DEFAULT 0,
  `maglevel` int(11) NOT NULL DEFAULT 0,
  `vocations` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `group_id` int(11) NOT NULL DEFAULT 1,
  `account_id` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `vocation` int(11) NOT NULL DEFAULT 0,
  `health` int(11) NOT NULL DEFAULT 150,
  `healthmax` int(11) NOT NULL DEFAULT 150,
  `experience` bigint(20) NOT NULL DEFAULT 0,
  `lookbody` int(11) NOT NULL DEFAULT 0,
  `lookfeet` int(11) NOT NULL DEFAULT 0,
  `lookhead` int(11) NOT NULL DEFAULT 0,
  `looklegs` int(11) NOT NULL DEFAULT 0,
  `looktype` int(11) NOT NULL DEFAULT 136,
  `lookaddons` int(11) NOT NULL DEFAULT 0,
  `maglevel` int(11) NOT NULL DEFAULT 0,
  `mana` int(11) NOT NULL DEFAULT 0,
  `manamax` int(11) NOT NULL DEFAULT 0,
  `manaspent` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `soul` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `town_id` int(11) NOT NULL DEFAULT 1,
  `posx` int(11) NOT NULL DEFAULT 0,
  `posy` int(11) NOT NULL DEFAULT 0,
  `posz` int(11) NOT NULL DEFAULT 0,
  `conditions` blob NOT NULL,
  `cap` int(11) NOT NULL DEFAULT 0,
  `sex` int(11) NOT NULL DEFAULT 0,
  `pronoun` int(11) NOT NULL DEFAULT 0,
  `lastlogin` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `lastip` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `save` tinyint(1) NOT NULL DEFAULT 1,
  `skull` tinyint(1) NOT NULL DEFAULT 0,
  `skulltime` bigint(20) NOT NULL DEFAULT 0,
  `lastlogout` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `blessings` tinyint(2) NOT NULL DEFAULT 0,
  `blessings1` tinyint(4) NOT NULL DEFAULT 0,
  `blessings2` tinyint(4) NOT NULL DEFAULT 0,
  `blessings3` tinyint(4) NOT NULL DEFAULT 0,
  `blessings4` tinyint(4) NOT NULL DEFAULT 0,
  `blessings5` tinyint(4) NOT NULL DEFAULT 0,
  `blessings6` tinyint(4) NOT NULL DEFAULT 0,
  `blessings7` tinyint(4) NOT NULL DEFAULT 0,
  `blessings8` tinyint(4) NOT NULL DEFAULT 0,
  `onlinetime` int(11) NOT NULL DEFAULT 0,
  `deletion` bigint(15) NOT NULL DEFAULT 0,
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `offlinetraining_time` smallint(5) UNSIGNED NOT NULL DEFAULT 43200,
  `offlinetraining_skill` tinyint(2) NOT NULL DEFAULT -1,
  `stamina` smallint(5) UNSIGNED NOT NULL DEFAULT 2520,
  `skill_fist` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_fist_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_club` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_club_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_sword` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_sword_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_axe` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_axe_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_dist` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_dist_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_shielding` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_shielding_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_fishing` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_fishing_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_critical_hit_chance` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `skill_critical_hit_chance_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_critical_hit_damage` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `skill_critical_hit_damage_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_life_leech_chance` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `skill_life_leech_chance_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_life_leech_amount` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `skill_life_leech_amount_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_mana_leech_chance` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `skill_mana_leech_chance_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_mana_leech_amount` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `skill_mana_leech_amount_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_criticalhit_chance` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_criticalhit_damage` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_lifeleech_chance` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_lifeleech_amount` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_manaleech_chance` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_manaleech_amount` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `manashield` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `max_manashield` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `xpboost_stamina` smallint(5) UNSIGNED DEFAULT NULL,
  `xpboost_value` tinyint(4) UNSIGNED DEFAULT NULL,
  `marriage_status` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `marriage_spouse` int(11) NOT NULL DEFAULT -1,
  `bonus_rerolls` bigint(21) NOT NULL DEFAULT 0,
  `prey_wildcard` bigint(21) NOT NULL DEFAULT 0,
  `task_points` bigint(21) NOT NULL DEFAULT 0,
  `quickloot_fallback` tinyint(1) DEFAULT 0,
  `lookmountbody` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `lookmountfeet` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `lookmounthead` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `lookmountlegs` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `lookfamiliarstype` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `isreward` tinyint(1) NOT NULL DEFAULT 1,
  `istutorial` tinyint(1) NOT NULL DEFAULT 0,
  `ismain` tinyint(1) NOT NULL DEFAULT 0,
  `forge_dusts` bigint(21) NOT NULL DEFAULT 0,
  `forge_dust_level` bigint(21) NOT NULL DEFAULT 100,
  `randomize_mount` tinyint(1) NOT NULL DEFAULT 0,
  `boss_points` int(11) NOT NULL DEFAULT 0,
  `created` int(11) NOT NULL DEFAULT 0,
  `hidden` tinyint(1) NOT NULL DEFAULT 0,
  `comment` text NOT NULL,
  `puntostask` int(11) DEFAULT 0,
  `buffpoints` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `maglevel`, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `pronoun`, `lastlogin`, `lastip`, `save`, `skull`, `skulltime`, `lastlogout`, `blessings`, `blessings1`, `blessings2`, `blessings3`, `blessings4`, `blessings5`, `blessings6`, `blessings7`, `blessings8`, `onlinetime`, `deletion`, `balance`, `offlinetraining_time`, `offlinetraining_skill`, `stamina`, `skill_fist`, `skill_fist_tries`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`, `skill_shielding`, `skill_shielding_tries`, `skill_fishing`, `skill_fishing_tries`, `skill_critical_hit_chance`, `skill_critical_hit_chance_tries`, `skill_critical_hit_damage`, `skill_critical_hit_damage_tries`, `skill_life_leech_chance`, `skill_life_leech_chance_tries`, `skill_life_leech_amount`, `skill_life_leech_amount_tries`, `skill_mana_leech_chance`, `skill_mana_leech_chance_tries`, `skill_mana_leech_amount`, `skill_mana_leech_amount_tries`, `skill_criticalhit_chance`, `skill_criticalhit_damage`, `skill_lifeleech_chance`, `skill_lifeleech_amount`, `skill_manaleech_chance`, `skill_manaleech_amount`, `manashield`, `max_manashield`, `xpboost_stamina`, `xpboost_value`, `marriage_status`, `marriage_spouse`, `bonus_rerolls`, `prey_wildcard`, `task_points`, `quickloot_fallback`, `lookmountbody`, `lookmountfeet`, `lookmounthead`, `lookmountlegs`, `lookfamiliarstype`, `isreward`, `istutorial`, `ismain`, `forge_dusts`, `forge_dust_level`, `randomize_mount`, `boss_points`, `created`, `hidden`, `comment`, `puntostask`, `buffpoints`) VALUES
(1, 'Rook Sample', 1, 1, 2, 0, 155, 155, 100, 113, 115, 95, 39, 129, 0, 2, 60, 60, 5936, 0, 1, 32068, 31900, 6, '', 410, 1, 0, 1716312082, 16777343, 1, 0, 0, 1716312101, 0, 1, 1, 1, 1, 1, 1, 1, 1, 40, 0, 0, 43200, -1, 2520, 10, 0, 12, 155, 12, 155, 12, 155, 12, 93, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 1, 0, 0, 0, '', 0, 0),
(2, 'Sorcerer Sample', 1, 1, 8, 1, 185, 185, 4200, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 0, 8, 32369, 32241, 7, '', 470, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 0, 0, 0, 0, '', 0, 0),
(3, 'Druid Sample', 1, 1, 8, 2, 185, 185, 4200, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 0, 8, 32369, 32241, 7, '', 470, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 0, 0, 0, 0, '', 0, 0),
(4, 'Paladin Sample', 1, 1, 8, 3, 185, 185, 4200, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 0, 8, 32369, 32241, 7, '', 470, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 0, 0, 0, 0, '', 0, 0),
(5, 'Knight Sample', 1, 1, 8, 4, 185, 185, 4200, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 0, 8, 32369, 32241, 7, '', 470, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 100, 0, 0, 0, 0, '', 0, 0),
(7, 'Admin', 6, 2, 600, 0, 100, 100, 3564169800, 10, 10, 10, 10, 136, 0, 800, 100, 100, 0, 100, 8, 34108, 32047, 13, '', 0, 0, 0, 1722788058, 4066901691, 1, 0, 0, 1722788327, 0, 1, 1, 1, 1, 1, 1, 1, 1, 488579, 0, 0, 43200, -1, 2520, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 82, 100, 0, 250, 1715919699, 0, '', 0, 25);

--
-- Triggers `players`
--
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

CREATE TABLE `players_online` (
  `player_id` int(11) NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_bonus_info`
--

CREATE TABLE `player_bonus_info` (
  `id` int(11) UNSIGNED NOT NULL,
  `player_id` int(11) UNSIGNED NOT NULL,
  `puntostask` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_bosstiary`
--

CREATE TABLE `player_bosstiary` (
  `player_id` int(11) NOT NULL,
  `bossIdSlotOne` int(11) NOT NULL DEFAULT 0,
  `bossIdSlotTwo` int(11) NOT NULL DEFAULT 0,
  `removeTimes` int(11) NOT NULL DEFAULT 1,
  `tracker` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `player_bosstiary`
--

INSERT INTO `player_bosstiary` (`player_id`, `bossIdSlotOne`, `bossIdSlotTwo`, `removeTimes`, `tracker`) VALUES
(2, 0, 0, 1, ''),
(3, 0, 0, 1, ''),
(4, 0, 0, 1, ''),
(5, 0, 0, 1, ''),
(12, 0, 0, 1, ''),
(13, 0, 0, 1, ''),
(1, 0, 0, 1, ''),
(6, 0, 0, 1, ''),
(16, 0, 0, 1, ''),
(14, 0, 0, 1, ''),
(15, 0, 0, 1, ''),
(20, 0, 0, 1, ''),
(19, 0, 0, 1, ''),
(8, 0, 0, 1, ''),
(9, 0, 0, 1, ''),
(18, 0, 0, 1, ''),
(17, 0, 0, 1, ''),
(7, 0, 0, 1, '');

-- --------------------------------------------------------

--
-- Table structure for table `player_charms`
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
  `tracker list` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `player_charms`
--

INSERT INTO `player_charms` (`player_guid`, `charm_points`, `charm_expansion`, `rune_wound`, `rune_enflame`, `rune_poison`, `rune_freeze`, `rune_zap`, `rune_curse`, `rune_cripple`, `rune_parry`, `rune_dodge`, `rune_adrenaline`, `rune_numb`, `rune_cleanse`, `rune_bless`, `rune_scavenge`, `rune_gut`, `rune_low_blow`, `rune_divine`, `rune_vamp`, `rune_void`, `UsedRunesBit`, `UnlockedRunesBit`, `tracker list`) VALUES
(1, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(2, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(3, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(4, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(5, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(6, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(7, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(9, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(8, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(12, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(13, '5', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(15, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(16, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(14, '15', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(17, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(18, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(19, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(20, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', '');

-- --------------------------------------------------------

--
-- Table structure for table `player_deaths`
--

CREATE TABLE `player_deaths` (
  `player_id` int(11) NOT NULL,
  `time` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `killed_by` varchar(255) NOT NULL,
  `is_player` tinyint(1) NOT NULL DEFAULT 1,
  `mostdamage_by` varchar(100) NOT NULL,
  `mostdamage_is_player` tinyint(1) NOT NULL DEFAULT 0,
  `unjustified` tinyint(1) NOT NULL DEFAULT 0,
  `mostdamage_unjustified` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_depotitems`
--

CREATE TABLE `player_depotitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL COMMENT 'any given range eg 0-100 will be reserved for depot lockers and all > 100 will be then normal items inside depots',
  `pid` int(11) NOT NULL DEFAULT 0,
  `itemtype` int(11) NOT NULL DEFAULT 0,
  `count` int(11) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `player_depotitems`
--

INSERT INTO `player_depotitems` (`player_id`, `sid`, `pid`, `itemtype`, `count`, `attributes`) VALUES
(7, 101, 1, 2854, 1, 0x2400),
(7, 102, 101, 9220, 1, ''),
(7, 103, 101, 9222, 1, ''),
(7, 104, 101, 9219, 1, ''),
(7, 105, 101, 9209, 1, ''),
(7, 106, 101, 9215, 1, ''),
(7, 107, 101, 9216, 1, ''),
(7, 108, 101, 9218, 1, ''),
(7, 109, 101, 5785, 1, ''),
(7, 110, 101, 9221, 1, ''),
(7, 111, 101, 9223, 1, '');

-- --------------------------------------------------------

--
-- Table structure for table `player_hirelings`
--

CREATE TABLE `player_hirelings` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `active` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `sex` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `posx` int(11) NOT NULL DEFAULT 0,
  `posy` int(11) NOT NULL DEFAULT 0,
  `posz` int(11) NOT NULL DEFAULT 0,
  `lookbody` int(11) NOT NULL DEFAULT 0,
  `lookfeet` int(11) NOT NULL DEFAULT 0,
  `lookhead` int(11) NOT NULL DEFAULT 0,
  `looklegs` int(11) NOT NULL DEFAULT 0,
  `looktype` int(11) NOT NULL DEFAULT 136
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_inboxitems`
--

CREATE TABLE `player_inboxitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT 0,
  `itemtype` int(11) NOT NULL DEFAULT 0,
  `count` int(11) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_items`
--

CREATE TABLE `player_items` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `pid` int(11) NOT NULL DEFAULT 0,
  `sid` int(11) NOT NULL DEFAULT 0,
  `itemtype` int(11) NOT NULL DEFAULT 0,
  `count` int(11) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `player_items`
--

INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES
(1, 3, 101, 2854, 1, 0x26000000802c00000080),
(1, 11, 102, 23396, 1, ''),
(1, 101, 103, 3457, 1, ''),
(1, 101, 104, 3003, 1, ''),
(2, 11, 101, 23396, 1, ''),
(3, 11, 101, 23396, 1, ''),
(4, 11, 101, 23396, 1, ''),
(5, 11, 101, 23396, 1, ''),
(7, 1, 101, 3407, 1, ''),
(7, 3, 102, 3253, 1, 0x240126000000802c00000080),
(7, 6, 103, 26016, 1, ''),
(7, 7, 104, 3389, 1, ''),
(7, 8, 105, 43884, 1, ''),
(7, 11, 106, 23396, 1, 0x2402),
(7, 102, 107, 3457, 1, ''),
(7, 102, 108, 3299, 1, ''),
(7, 102, 109, 3282, 1, ''),
(7, 102, 110, 3607, 1, 0x0f01),
(7, 102, 111, 3031, 58, 0x0f3a),
(7, 102, 112, 3031, 100, 0x0f64),
(7, 102, 113, 11466, 1, 0x0f01),
(7, 102, 114, 3045, 200, 0x16c800),
(7, 102, 115, 3740, 1, 0x0f01),
(7, 102, 116, 6526, 2, 0x0f02),
(7, 102, 117, 35289, 14400, 0x164038),
(7, 102, 118, 35289, 14399, 0x163f38),
(7, 102, 119, 35289, 14400, 0x164038),
(7, 102, 120, 35289, 1000, 0x16e803),
(7, 102, 121, 35289, 1, 0x160100),
(7, 106, 122, 37317, 48, 0x01142cc78e8f0100000f302b07000000),
(7, 106, 123, 37317, 100, 0x01142cc78e8f0100000f642b07000000),
(7, 106, 124, 23398, 1, 0x073b00556e7772617020697420696e20796f7572206f776e20686f75736520746f206372656174652061203c706f6469756d206f66207669676f75723e2e2901000000000000000800756e777261706964023397000000000000);

-- --------------------------------------------------------

--
-- Table structure for table `player_kills`
--

CREATE TABLE `player_kills` (
  `player_id` int(11) NOT NULL,
  `time` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `target` int(11) NOT NULL,
  `unavenged` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_namelocks`
--

CREATE TABLE `player_namelocks` (
  `player_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `namelocked_at` bigint(20) NOT NULL,
  `namelocked_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_prey`
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
  `monster_list` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `player_prey`
--

INSERT INTO `player_prey` (`player_id`, `slot`, `state`, `raceid`, `option`, `bonus_type`, `bonus_rarity`, `bonus_percentage`, `bonus_time`, `free_reroll`, `monster_list`) VALUES
(1, 0, 3, '0', 0, 0, 2, '16', '0', 1716384060260, 0x6f047604fb03dd0094077400e902e502e005),
(1, 1, 3, '0', 0, 3, 7, '31', '0', 1716384060260, 0x2a00f3008102fe034d04be012a017c009207),
(1, 2, 0, '0', 0, 0, 9, '37', '0', 1716384060260, ''),
(6, 0, 3, '0', 0, 0, 7, '31', '0', 1716384104632, 0xe30270034d0473010f0155090400be011501),
(6, 1, 3, '0', 0, 0, 5, '25', '0', 1716384104632, 0x770239009201d0019d030e010707b6071c02),
(6, 2, 0, '0', 0, 1, 9, '37', '0', 1716384104632, ''),
(7, 0, 3, '0', 0, 1, 9, '37', '0', 1715992104504, 0xce0338009c076f048907df00d001dc005300),
(7, 1, 3, '0', 0, 0, 4, '22', '0', 1715992104504, 0x21092b09fd01fb009f05be01e10049071500),
(7, 2, 0, '0', 0, 0, 9, '37', '0', 1715992104504, ''),
(8, 0, 2, '1939', 0, 1, 10, '30', '5280', 1715993792574, 0x0f010c008a04e4081e001a00c3023e01ab07),
(8, 1, 2, '1931', 0, 1, 10, '30', '5280', 1715993792574, 0xc80451046f0260046803f40303018406c701),
(8, 2, 2, '1945', 0, 1, 10, '30', '5280', 1715993792574, 0xcd01db0203028907aa07ad077a042f05d503),
(9, 0, 3, '0', 0, 0, 4, '22', '0', 1715992259543, 0xbe034602f403bc0210022500510024006c02),
(9, 1, 3, '0', 0, 3, 8, '34', '0', 1715992259543, 0xd10149044e01cc060002790164000b032d00),
(9, 2, 0, '0', 0, 1, 6, '28', '0', 1715992259543, ''),
(12, 0, 3, '0', 0, 2, 4, '22', '0', 1716076889184, 0x450068007400770415016a000a002c087301),
(12, 1, 3, '0', 0, 3, 10, '40', '0', 1716076889184, 0x0803cf01e00521061a004602e60871022c00),
(12, 2, 0, '0', 0, 3, 3, '19', '0', 1716076889184, ''),
(13, 0, 3, '0', 0, 2, 3, '19', '0', 1716158348377, 0xca017604ba066d02cf010803b4071d028907),
(13, 1, 3, '0', 0, 3, 5, '25', '0', 1716158348377, 0x72050a03c2034502020155092d02fc052400),
(13, 2, 0, '0', 0, 2, 3, '19', '0', 1716158348377, ''),
(14, 0, 3, '0', 0, 2, 10, '40', '0', 1716485481746, 0x58070b023d000601ec001d030e01fc001000),
(14, 1, 3, '0', 0, 3, 8, '34', '0', 1716485481746, 0x1e0709008101d3008f027700290034009907),
(14, 2, 0, '0', 0, 0, 8, '34', '0', 1716485481746, ''),
(15, 0, 3, '0', 0, 0, 9, '37', '0', 1716383975207, 0xdc08ed0066025709970306021a0053007802),
(15, 1, 3, '0', 0, 1, 10, '40', '0', 1716383975207, 0x8206f80008009203d3024d04530236011b00),
(15, 2, 0, '0', 0, 1, 5, '25', '0', 1716383975207, ''),
(16, 0, 3, '0', 0, 2, 10, '40', '0', 1716752761550, 0x10047700da08d7021a003000240935000a06),
(16, 1, 3, '0', 0, 3, 3, '19', '0', 1716752761550, 0x4401c90603032f02550636016702cd011a07),
(16, 2, 0, '0', 0, 3, 6, '28', '0', 1716752761550, ''),
(17, 0, 2, '1864', 0, 1, 10, '30', '6060', 1716850823243, 0x5b03da009803d6031504f004e9029b07b607),
(17, 1, 2, '1865', 0, 1, 10, '30', '6060', 1716850823243, 0xe208d800f60392034904a3025302fb008102),
(17, 2, 2, '465', 0, 1, 10, '30', '6060', 1716850823243, 0x5f00e605c70664008607fb057a041e010501),
(18, 0, 3, '0', 0, 3, 6, '28', '0', 1716918070683, 0x11006f06fc01980321066303a702fb037102),
(18, 1, 3, '0', 0, 2, 7, '31', '0', 1716918070683, 0x9c031c037c045d096d007d000c0622003400),
(18, 2, 0, '0', 0, 1, 4, '22', '0', 1716918070683, ''),
(19, 0, 3, '0', 0, 2, 4, '22', '0', 1716918233689, 0xe5080a00cd06dc0270001a01f20041010d01),
(19, 1, 3, '0', 0, 3, 9, '37', '0', 1716918233689, 0xbc062d0514036d00d00140000b03dc087b01),
(19, 2, 0, '0', 0, 1, 4, '22', '0', 1716918233689, ''),
(20, 0, 3, '0', 0, 3, 10, '40', '0', 1716919937537, 0x2409d70079042b024f0145004100de08b802),
(20, 1, 3, '0', 0, 3, 9, '37', '0', 1716919937537, 0xf4003e010d014d09220691032401b7014602),
(20, 2, 0, '0', 0, 3, 4, '22', '0', 1716919937537, '');

-- --------------------------------------------------------

--
-- Table structure for table `player_rewards`
--

CREATE TABLE `player_rewards` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT 0,
  `itemtype` int(11) NOT NULL DEFAULT 0,
  `count` int(11) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_spells`
--

CREATE TABLE `player_spells` (
  `player_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_stash`
--

CREATE TABLE `player_stash` (
  `player_id` int(16) NOT NULL,
  `item_id` int(16) NOT NULL,
  `item_count` int(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_storage`
--

CREATE TABLE `player_storage` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `key` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `value` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `player_storage`
--

INSERT INTO `player_storage` (`player_id`, `key`, `value`) VALUES
(1, 0, 1),
(1, 13413, 1),
(1, 13414, 5),
(1, 14903, 0),
(1, 42701, 29),
(1, 42703, 3),
(1, 42704, 4),
(1, 42708, 3),
(1, 42709, 2),
(1, 50080, 10),
(1, 50081, 10),
(1, 50090, 10),
(1, 50115, 10),
(1, 50139, 10),
(1, 50141, 10),
(1, 50143, 30),
(1, 50200, 7),
(1, 50201, 1),
(1, 50203, 1),
(1, 50205, 1),
(1, 50210, 1),
(1, 50225, 1),
(1, 50226, 4),
(1, 50227, 3),
(1, 50228, 3),
(1, 50230, 1),
(1, 50231, 1),
(1, 50240, 1),
(1, 50245, 7),
(1, 50250, 1),
(1, 50251, 1),
(1, 50252, 1),
(1, 50255, 1),
(1, 50256, 1),
(1, 50257, 1),
(1, 50258, 1),
(1, 50486, 1),
(1, 50488, 1),
(1, 50490, 1),
(1, 50492, 1),
(1, 50494, 1),
(1, 50496, 1),
(1, 50498, 1),
(1, 50501, 1),
(1, 50506, 1),
(1, 50530, 61),
(1, 50541, 2),
(1, 50620, 2),
(1, 50621, 2),
(1, 50622, 2),
(1, 50630, 1),
(1, 50631, 2),
(1, 50632, 2),
(1, 50633, 2),
(1, 50634, 3),
(1, 50640, 1),
(1, 50641, 3),
(1, 50642, 3),
(1, 50643, 3),
(1, 50660, 23),
(1, 50662, 5),
(1, 50663, 2),
(1, 50672, 1440),
(1, 50699, 2),
(1, 50700, 2),
(1, 50701, 2),
(1, 51110, 25),
(1, 51111, 7),
(1, 51112, 3),
(1, 51113, 6),
(1, 51114, 3),
(1, 51115, 3),
(1, 51116, 3),
(1, 51117, 1),
(1, 51120, 1),
(1, 51121, 1),
(1, 51123, 1),
(1, 51124, 1),
(1, 51125, 1),
(1, 51140, 8),
(1, 51141, 3),
(1, 51142, 3),
(1, 51143, 3),
(1, 51160, 40),
(1, 51161, 3),
(1, 51162, 5),
(1, 51163, 3),
(1, 51164, 2),
(1, 51165, 6),
(1, 51166, 8),
(1, 51167, 3),
(1, 51168, 4),
(1, 51169, 2),
(1, 51170, 2),
(1, 51171, 2),
(1, 51172, 6),
(1, 51185, 1),
(1, 51210, 51),
(1, 51211, 6),
(1, 51212, 8),
(1, 51213, 6),
(1, 51214, 6),
(1, 51215, 8),
(1, 51216, 5),
(1, 51217, 5),
(1, 51218, 4),
(1, 51219, 2),
(1, 51220, 1),
(1, 51221, 1),
(1, 51222, 1),
(1, 51223, 1),
(1, 51224, 1),
(1, 51225, 1),
(1, 51228, 1),
(1, 51229, 1),
(1, 51231, 1),
(1, 51232, 1),
(1, 51234, 1),
(1, 51235, 1),
(1, 51236, 1),
(1, 51237, 1),
(1, 51238, 1),
(1, 51239, 1),
(1, 51242, 1),
(1, 51243, 1),
(1, 51244, 1),
(1, 51247, 1),
(1, 51248, 1),
(1, 51262, 3),
(1, 51263, 5),
(1, 51264, 3),
(1, 51266, 3),
(1, 51267, 1),
(1, 51268, 1),
(1, 51269, 1),
(1, 51450, 1),
(1, 51451, 1),
(1, 51453, 1),
(1, 51590, 1),
(1, 51591, 1),
(1, 51592, 1),
(1, 51593, 1),
(1, 51594, 1),
(1, 51595, 1),
(1, 51596, 1),
(1, 51597, 1),
(1, 51598, 1),
(1, 55136, 1),
(1, 55137, 1),
(1, 55145, 21),
(1, 55146, 2),
(1, 55148, 6),
(1, 55154, 1),
(1, 55226, 1),
(1, 55227, 1),
(1, 55230, 1),
(1, 55233, 1),
(1, 10001001, 16449536),
(1, 10001002, 16515072),
(7, 0, 700),
(7, 205, 0),
(7, 9246, 1),
(7, 12330, 1),
(7, 12332, 13),
(7, 12333, 3),
(7, 12345, 1),
(7, 12450, 6),
(7, 13413, 1722776701),
(7, 13414, 8),
(7, 14320, 1),
(7, 14900, 1),
(7, 14903, 0),
(7, 20001, 1),
(7, 20002, 1),
(7, 30012, 2),
(7, 30020, 1),
(7, 30057, 1),
(7, 30060, 2),
(7, 41651, 5),
(7, 41652, 2),
(7, 41912, 1),
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
(7, 44956, 1),
(7, 44957, 1),
(7, 45751, 1),
(7, 45752, 16),
(7, 45764, 1),
(7, 46309, 1),
(7, 46402, 1),
(7, 46403, 1),
(7, 46404, 1),
(7, 46851, 14),
(7, 46875, 1),
(7, 47226, 1),
(7, 47227, 1),
(7, 47228, 1),
(7, 47229, 1),
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
(7, 50203, 1),
(7, 50205, 1),
(7, 50210, 1),
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
(7, 50243, 1),
(7, 50245, 7),
(7, 50250, 1),
(7, 50251, 1),
(7, 50252, 1),
(7, 50255, 1),
(7, 50256, 1),
(7, 50257, 1),
(7, 50258, 1),
(7, 50260, 1),
(7, 50263, 1),
(7, 50264, 1),
(7, 50355, 0),
(7, 50359, 1),
(7, 50403, 1),
(7, 50442, 1),
(7, 50443, 1),
(7, 50444, 1),
(7, 50445, 1),
(7, 50446, 1),
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
(7, 50506, 1),
(7, 50530, 61),
(7, 50541, 2),
(7, 50600, 2),
(7, 50601, 5),
(7, 50602, 3),
(7, 50603, 3),
(7, 50604, 3),
(7, 50605, 2),
(7, 50606, 1),
(7, 50620, 2),
(7, 50621, 2),
(7, 50622, 2),
(7, 50630, 1),
(7, 50631, 2),
(7, 50632, 2),
(7, 50633, 2),
(7, 50634, 3),
(7, 50635, 1),
(7, 50636, 1),
(7, 50640, 1),
(7, 50641, 3),
(7, 50642, 3),
(7, 50643, 3),
(7, 50644, 1),
(7, 50645, 1),
(7, 50660, 23),
(7, 50662, 5),
(7, 50663, 2),
(7, 50672, 1440),
(7, 50699, 2),
(7, 50700, 2),
(7, 50701, 2),
(7, 50850, 1),
(7, 50852, 3000),
(7, 50960, 1),
(7, 50984, 1),
(7, 50985, 1),
(7, 50986, 1),
(7, 50987, 1),
(7, 51004, 1),
(7, 51060, 1),
(7, 51061, 18),
(7, 51110, 25),
(7, 51111, 7),
(7, 51112, 3),
(7, 51113, 6),
(7, 51114, 3),
(7, 51115, 3),
(7, 51116, 3),
(7, 51117, 1),
(7, 51120, 1),
(7, 51121, 1),
(7, 51123, 1),
(7, 51124, 1),
(7, 51125, 1),
(7, 51126, 6),
(7, 51140, 8),
(7, 51141, 3),
(7, 51142, 3),
(7, 51143, 3),
(7, 51160, 40),
(7, 51161, 3),
(7, 51162, 5),
(7, 51163, 3),
(7, 51164, 2),
(7, 51165, 6),
(7, 51166, 8),
(7, 51167, 3),
(7, 51168, 4),
(7, 51169, 2),
(7, 51170, 2),
(7, 51171, 2),
(7, 51172, 6),
(7, 51185, 1),
(7, 51210, 51),
(7, 51211, 6),
(7, 51212, 8),
(7, 51213, 6),
(7, 51214, 6),
(7, 51215, 8),
(7, 51216, 5),
(7, 51217, 5),
(7, 51218, 4),
(7, 51219, 2),
(7, 51220, 1),
(7, 51221, 1),
(7, 51222, 1),
(7, 51223, 1),
(7, 51224, 1),
(7, 51225, 1),
(7, 51228, 1),
(7, 51229, 1),
(7, 51231, 1),
(7, 51232, 1),
(7, 51234, 1),
(7, 51235, 1),
(7, 51236, 1),
(7, 51237, 1),
(7, 51238, 1),
(7, 51239, 1),
(7, 51242, 1),
(7, 51243, 1),
(7, 51244, 1),
(7, 51247, 1),
(7, 51248, 1),
(7, 51262, 3),
(7, 51263, 5),
(7, 51264, 3),
(7, 51266, 3),
(7, 51267, 1),
(7, 51268, 1),
(7, 51269, 1),
(7, 51300, 29),
(7, 51301, 3),
(7, 51302, 3),
(7, 51303, 3),
(7, 51304, 3),
(7, 51305, 3),
(7, 51306, 4),
(7, 51307, 6),
(7, 51308, 2),
(7, 51309, 2),
(7, 51310, 1),
(7, 51325, 1),
(7, 51326, 1),
(7, 51327, 1),
(7, 51328, 2),
(7, 51329, 1),
(7, 51330, 1),
(7, 51331, 1),
(7, 51332, 1),
(7, 51340, 1),
(7, 51341, 2),
(7, 51342, 2),
(7, 51343, 12),
(7, 51394, 8),
(7, 51396, 4),
(7, 51397, 2),
(7, 51398, 1),
(7, 51450, 1),
(7, 51451, 1),
(7, 51453, 1),
(7, 51480, 1),
(7, 51486, 1),
(7, 51540, 3),
(7, 51541, 3),
(7, 51542, 2),
(7, 51543, 1),
(7, 51544, 3),
(7, 51545, 5),
(7, 51546, 1),
(7, 51547, 1),
(7, 51548, 2),
(7, 51549, 1),
(7, 51550, 4),
(7, 51590, 1),
(7, 51591, 1),
(7, 51592, 1),
(7, 51593, 1),
(7, 51594, 1),
(7, 51595, 1),
(7, 51596, 1),
(7, 51597, 1),
(7, 51598, 1),
(7, 51611, 0),
(7, 51680, 1),
(7, 51712, 1),
(7, 52146, 2),
(7, 52148, 1),
(7, 52149, 3),
(7, 52276, 0),
(7, 52277, 1),
(7, 55047, 1),
(7, 55136, 1),
(7, 55137, 1),
(7, 55145, 21),
(7, 55146, 2),
(7, 55148, 6),
(7, 55154, 1),
(7, 55226, 1),
(7, 55227, 1),
(7, 55230, 1),
(7, 55233, 1),
(7, 56395, 2),
(7, 65000, 1),
(7, 65531, 1),
(7, 65532, 1),
(7, 65533, 1),
(7, 65534, 1),
(7, 65535, 1),
(7, 67755, 1716343033),
(7, 100157, 1),
(7, 112550, 0),
(7, 190067, 0),
(7, 190068, 1),
(7, 190499, 0),
(7, 190500, 7),
(7, 300000, 1722874652),
(7, 515206, 1),
(7, 515207, 2),
(7, 515208, 3),
(7, 515209, 3),
(7, 710020, 1716919189),
(7, 710021, 1716524752),
(7, 7000000, 3498),
(7, 10001001, 16449536),
(7, 10001002, 16515072),
(7, 10002011, 58),
(7, 61305022, 44),
(7, 61305032, 24),
(7, 61305035, 204),
(7, 61305039, 8),
(7, 61305040, 16),
(7, 61305048, 8),
(7, 61305049, 24),
(7, 61305051, 4),
(7, 61305065, 8),
(7, 61305078, 40),
(7, 61305099, 36),
(7, 61305103, 8),
(7, 61305120, 4),
(7, 61305281, 20),
(7, 61305283, 8),
(7, 61305284, 28),
(7, 61305285, 16),
(7, 61305286, 12),
(7, 61305287, 28),
(7, 61305288, 24),
(7, 61305291, 32),
(7, 61305294, 8),
(7, 61305295, 16),
(7, 61305296, 16),
(7, 61305313, 8),
(7, 61305371, 4),
(7, 61305403, 3),
(7, 61305513, 12),
(7, 61305521, 36),
(7, 61305641, 4),
(7, 61306224, 4),
(7, 61306234, 16),
(7, 61306235, 24),
(7, 61306260, 12),
(7, 61306728, 4),
(7, 61306729, 4),
(7, 61306730, 4),
(7, 61306731, 4),
(7, 61306734, 4),
(7, 61306744, 9),
(7, 61306776, 8),
(7, 61306805, 12),
(7, 61306808, 8),
(7, 61306931, 8),
(7, 61306939, 24),
(7, 61306945, 24),
(7, 61307104, 3),
(7, 61307346, 15),
(7, 61307362, 3),
(7, 61307364, 3),
(7, 61307365, 3),
(7, 61307366, 3),
(7, 61307367, 3),
(7, 61307375, 4),
(7, 61307378, 4),
(7, 61307379, 4),
(7, 61307380, 4),
(7, 61307382, 4),
(7, 61307386, 40),
(7, 61307387, 20),
(7, 61307389, 24),
(7, 61307390, 44),
(7, 61307393, 12),
(7, 61307394, 28),
(7, 61307395, 16),
(7, 61307397, 8),
(7, 61307399, 4),
(7, 61307403, 84);

-- --------------------------------------------------------

--
-- Table structure for table `player_taskhunt`
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
  `monster_list` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `player_taskhunt`
--

INSERT INTO `player_taskhunt` (`player_id`, `slot`, `state`, `raceid`, `upgrade`, `rarity`, `kills`, `disabled_time`, `free_reroll`, `monster_list`) VALUES
(1, 0, 2, '0', 0, 1, '0', 0, 1716384060260, 0xe40869009f05c9067800c802450276021500),
(1, 1, 2, '0', 0, 1, '0', 0, 1716384060260, 0xd5088f02f90581023d00410081011b030903),
(1, 2, 2, '0', 0, 1, '0', 0, 1716384060260, 0x92032004ec045300e3057a034d000d020201),
(6, 0, 2, '0', 0, 1, '0', 0, 1716384104632, 0x6f03c802c40279013b00490794037002d608),
(6, 1, 2, '0', 0, 1, '0', 0, 1716384104632, 0x02004601be062a0053060c06db020900cf02),
(6, 2, 2, '0', 0, 1, '0', 0, 1716384104632, 0x8006fd0050004d011100e5083500ff006300),
(7, 0, 2, '0', 0, 1, '0', 0, 1715992104504, 0x2b09bd020d011d0142027303e100f900c302),
(7, 1, 2, '0', 0, 1, '0', 0, 1715992104504, 0x1e018a07ca011b03890177025c0416007602),
(7, 2, 2, '0', 0, 1, '0', 0, 1715992104504, 0x1303160303030e019207e902730052006900),
(8, 0, 2, '0', 0, 1, '0', 0, 1715993792574, 0xdd087301e305bd02c802e50253026a026303),
(8, 1, 2, '0', 0, 1, '0', 0, 1715993792574, 0x7b00150250004800c706fb03dc022409d108),
(8, 2, 2, '0', 0, 1, '0', 0, 1715993792574, 0x8303200106002701d808740052093f01c606),
(9, 0, 2, '0', 0, 1, '0', 0, 1715992259543, 0x1204680055093e0122061d0789013b007401),
(9, 1, 2, '0', 0, 1, '0', 0, 1715992259543, 0x220546000301d908350074004101fd000203),
(9, 2, 2, '0', 0, 1, '0', 0, 1715992259543, 0x7300f200d403c303e902bc02d20832084801),
(12, 0, 2, '0', 0, 1, '0', 0, 1716076889184, 0x74037602e0054800730058070f0046003500),
(12, 1, 2, '0', 0, 1, '0', 0, 1716076889184, 0x4907f2041d03a7021e0197033e00d6007401),
(12, 2, 2, '0', 0, 1, '0', 0, 1716076889184, 0x090149010a0368034a0409027c003600ff00),
(13, 0, 2, '0', 0, 1, '0', 0, 1716158348377, 0x94075c0301014d01f505d608db0003014900),
(13, 1, 2, '0', 0, 1, '0', 0, 1716158348377, 0xa2052c080e01410060056f027c04e308ba06),
(13, 2, 2, '0', 0, 1, '0', 0, 1716158348377, 0x14040c010a001002ec044f003f000d02de02),
(14, 0, 2, '0', 0, 1, '0', 0, 1716485481746, 0x530944017305220616039a07b5011e002300),
(14, 1, 2, '0', 0, 1, '0', 0, 1716485481746, 0x520088077102ce05d4037901c90683068801),
(14, 2, 2, '0', 0, 1, '0', 0, 1716485481746, 0x2401b601f505970394036a00bf035300d706),
(15, 0, 2, '0', 0, 1, '0', 0, 1716383975207, 0x9d071c010d0679047200d602b50248003d00),
(15, 1, 2, '0', 0, 1, '0', 0, 1716383975207, 0x7203a202c5023a02970357098306df022700),
(15, 2, 2, '0', 0, 1, '0', 0, 1716383975207, 0x89013e015f0476039307b60169000b020906),
(16, 0, 2, '0', 0, 1, '0', 0, 1716752761550, 0x1c0068000308000121019103680292032609),
(16, 1, 2, '0', 0, 1, '0', 0, 1716752761550, 0xdd003408f200be01c502d101ec00f9008303),
(16, 2, 2, '0', 0, 1, '0', 0, 1716752761550, 0x8d0702031c0209006f02150077021d00e905),
(17, 0, 2, '0', 0, 1, '0', 0, 1716850823243, 0x1900940379022b0173030a00e0008d063800),
(17, 1, 2, '0', 0, 1, '0', 0, 1716850823243, 0x5e00c801ad045b03d808de0091036d022d05),
(17, 2, 2, '0', 0, 1, '0', 0, 1716850823243, 0x5c03be010c060c02f70721092b0904015d09),
(18, 0, 2, '0', 0, 1, '0', 0, 1716918070683, 0xff00450019009907f3004a041b0109004a09),
(18, 1, 2, '0', 0, 1, '0', 0, 1716918070683, 0xd6087b04e2059d07d6021b003e004600f701),
(18, 2, 2, '0', 0, 1, '0', 0, 1716918070683, 0x78006005820106010f011d032d00c9051700),
(19, 0, 2, '0', 0, 1, '0', 0, 1716918233689, 0x7103ef000308ff00df0281060a031f049c07),
(19, 1, 2, '0', 0, 1, '0', 0, 1716918233689, 0x0c0030085e00fb00440252099b056900cc06),
(19, 2, 2, '0', 0, 1, '0', 0, 1716918233689, 0xd800a2054c094901ed0047005100ef067606),
(20, 0, 2, '0', 0, 1, '0', 0, 1716919937537, 0x220114047503dc02e105520052026a00f503),
(20, 1, 2, '0', 0, 1, '0', 0, 1716919937537, 0x0e07130428055104be0340001b001100ec03),
(20, 2, 2, '0', 0, 1, '0', 0, 1716919937537, 0xa302c0032f002908f60364003c08d300df00);

-- --------------------------------------------------------

--
-- Table structure for table `player_wheeldata`
--

CREATE TABLE `player_wheeldata` (
  `player_id` int(11) NOT NULL,
  `slot` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `server_config`
--

CREATE TABLE `server_config` (
  `config` varchar(50) NOT NULL,
  `value` varchar(256) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `server_config`
--

INSERT INTO `server_config` (`config`, `value`, `timestamp`) VALUES
('db_version', '46', '2024-05-18 02:12:54'),
('motd_hash', 'c4313aff9a162413b14ede503a56996e3fe22ce3', '2024-05-18 05:12:02'),
('motd_num', '2', '2024-05-18 05:12:02'),
('players_record', '7', '2024-05-27 22:12:17');

-- --------------------------------------------------------

--
-- Table structure for table `store_history`
--

CREATE TABLE `store_history` (
  `id` int(11) NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  `mode` smallint(2) NOT NULL DEFAULT 0,
  `description` varchar(3500) NOT NULL,
  `coin_type` tinyint(1) NOT NULL DEFAULT 0,
  `coin_amount` int(12) NOT NULL,
  `time` bigint(20) UNSIGNED NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0,
  `coins` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `store_history`
--

INSERT INTO `store_history` (`id`, `account_id`, `mode`, `description`, `coin_type`, `coin_amount`, `time`, `timestamp`, `coins`) VALUES
(1, 2, 0, '360 Days of VIP', 1, -3000, 1715920947, 0, 0),
(2, 2, 0, 'Cheesy Key', 1, -800, 1715921090, 0, 0),
(3, 2, 0, 'Squeezing Gear of Girlpower', 1, -150, 1715921180, 0, 0),
(4, 2, 0, 'Whacking Driller of Fate', 1, -150, 1715921185, 0, 0),
(5, 2, 0, 'Sneaky Stabber of Eliteness', 1, -150, 1715921188, 0, 0),
(6, 2, 0, 'Store Dust', 1, -30, 1715921193, 0, 0),
(7, 2, 0, 'Cheesy Key', 1, -800, 1716011433, 0, 0),
(8, 2, 0, 'Roulette Coin', 1, -800, 1716013743, 0, 0),
(9, 2, 0, 'Roulette Coin', 1, -800, 1716013753, 0, 0),
(10, 2, 0, 'Roulette Coin', 1, -800, 1716048888, 0, 0),
(11, 2, 0, 'Roulette Coin', 1, -800, 1716048892, 0, 0),
(12, 2, 0, 'Golden Outfit', 1, -5000, 1716059162, 0, 0),
(17, 2, 0, 'Roulette Coin', 1, -800, 1716063725, 0, 0),
(21, 2, 0, 'Roulette Coin', 1, -50, 1716087029, 0, 0),
(22, 2, 0, 'Roulette Coin', 1, -50, 1716087031, 0, 0),
(23, 2, 0, 'Roulette Coin', 1, -50, 1716087032, 0, 0),
(24, 2, 0, 'Roulette Coin', 1, -50, 1716087034, 0, 0),
(25, 2, 0, 'Roulette Coin', 1, -50, 1716087035, 0, 0),
(26, 2, 0, 'Roulette Coin', 1, -50, 1716087036, 0, 0),
(27, 2, 0, 'Roulette Coin', 1, -50, 1716087038, 0, 0),
(28, 2, 0, 'Roulette Coin', 1, -500, 1716087289, 0, 0),
(29, 2, 0, 'Roulette Coin', 1, -500, 1716087368, 0, 0),
(30, 2, 0, 'Roulette Coin', 1, -500, 1716087456, 0, 0),
(31, 2, 0, 'Roulette Coin', 1, -500, 1716087556, 0, 0),
(32, 2, 0, 'Roulette Coin', 1, -250, 1716087607, 0, 0),
(33, 2, 0, 'Roulette Coin', 1, -250, 1716087617, 0, 0),
(34, 2, 0, 'Roulette Coin', 1, -250, 1716087809, 0, 0),
(35, 2, 0, 'Roulette Coin', 1, -100, 1716087849, 0, 0),
(36, 2, 0, 'Roulette Coin', 1, -100, 1716087860, 0, 0),
(37, 2, 0, 'Roulette Coin', 1, -100, 1716087870, 0, 0),
(40, 2, 0, 'Nebula Cube', 1, -500, 1716255016, 0, 0),
(43, 2, 0, 'Koliseum Ticket', 1, -300, 1716529522, 0, 0),
(44, 2, 0, 'Koliseum Ticket', 1, -300, 1716529679, 0, 0),
(45, 2, 0, 'Koliseum Ticket', 1, -300, 1716529779, 0, 0),
(46, 2, 0, 'Koliseum Ticket', 1, -600, 1716610722, 0, 0),
(47, 2, 0, 'Koliseum Ticket', 1, -600, 1716610724, 0, 0),
(48, 2, 0, 'Thunderstorm Rune', 1, -9, 1716670446, 0, 0),
(49, 2, 0, 'Thunderstorm Rune', 1, -9, 1716670447, 0, 0),
(52, 2, 0, 'XP Boost', 1, -30, 1716672777, 0, 0),
(53, 2, 0, 'Prey Wildcard', 1, -50, 1716673661, 0, 0),
(54, 2, 0, 'Prey Wildcard', 1, -50, 1716673666, 0, 0),
(55, 2, 0, 'Permanent Prey Slot', 1, -900, 1716673717, 0, 0),
(62, 2, 0, 'Full Armoured Archer Outfit', 1, -600, 1716863522, 0, 0),
(63, 2, 0, 'Nebula Cube', 1, -500, 1716863580, 0, 0),
(64, 2, 0, 'Prey Wildcard', 1, -50, 1716916620, 0, 0),
(65, 2, 0, 'Prey Wildcard', 1, -50, 1716916622, 0, 0),
(66, 2, 0, 'Permanent Prey Slot', 1, -900, 1716916627, 0, 0),
(67, 2, 0, 'Corpsefire Skull', 1, -750, 1716917081, 0, 0),
(68, 2, 0, 'Roulette Coin', 1, -60, 1716917998, 0, 0),
(69, 2, 0, 'Koliseum Ticket', 1, -600, 1716918001, 0, 0),
(70, 2, 0, 'Cheesy Key', 1, -800, 1716918007, 0, 0),
(71, 2, 0, 'Nebula Cube', 1, -500, 1716918013, 0, 0),
(72, 2, 0, 'Roulette Coin', 1, -60, 1716918071, 0, 0),
(73, 2, 0, 'Roulette Coin', 1, -60, 1716918072, 0, 0),
(74, 2, 0, 'Roulette Coin', 1, -60, 1716918073, 0, 0),
(75, 2, 0, 'Roulette Coin', 1, -60, 1716918075, 0, 0),
(76, 2, 0, 'Lasting Exercise Sword', 1, -720, 1716922080, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tile_store`
--

CREATE TABLE `tile_store` (
  `house_id` int(11) NOT NULL,
  `data` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tile_store`
--

INSERT INTO `tile_store` (`house_id`, `data`) VALUES
(2629, 0xcb7fa77b0801000000351800),
(2629, 0xca7fa87b0801000000371800),
(2629, 0xc47f9f7b0701000000321900),
(2629, 0xc47fa27b0701000000321900),
(2629, 0xc77f9c7b0701000000311900),
(2629, 0xc87fa47b08010000005e0b00),
(2629, 0xc87fa87b08010000005e0b00),
(2629, 0xcc7fa87b08010000005e0b00),
(2629, 0xca7f9c7b0701000000371800),
(2629, 0xc97f9e7b0701000000351800),
(2630, 0xc87fb07b0701000000371800),
(2630, 0xcb7fae7b0701000000341900),
(2632, 0xb07f9b7b0701000000321900),
(2632, 0xb57f9b7b0701000000321900),
(2632, 0xb57f9d7b0701000000321900),
(2632, 0xb27f9e7b0701000000371800),
(2632, 0xb47f9e7b0701000000311900),
(2632, 0xb37f997b0701000000311900),
(2638, 0x937f997b0701000000351800),
(2640, 0x9c7f947b0701000000321900),
(2640, 0x987f997b0701000000351800),
(2640, 0x9c7f997b0701000000321900),
(2649, 0x8d7fa17b0701000000311900),
(2649, 0x917fa47b0701000000321900),
(2649, 0x8a7fa57b0701000000321900),
(2649, 0x8c7fa77b0701000000371800),
(2649, 0x8e7fa77b0701000000311900),
(2650, 0x827fa97b0701000000351800),
(2650, 0x7f7fa67b0701000000311900),
(2650, 0x827fac7b0701000000321900),
(2650, 0x807fae7b0701000000311900),
(2651, 0x8d7fad7b0701000000311900),
(2651, 0x907fb17b0701000000321900),
(2651, 0x8c7fb37b0701000000371800),
(2651, 0x8d7fb37b0701000000311900),
(2652, 0x827fb77b0701000000311900),
(2652, 0x7f7fba7b0701000000321900),
(2652, 0x857fba7b0701000000321900),
(2652, 0x857fbc7b0701000000351800),
(2652, 0x817fbe7b0701000000311900),
(2652, 0x837fbe7b0701000000311900),
(2653, 0x827fcb7b0701000000351800),
(2653, 0x7b7fcd7b0701000000341900),
(2653, 0x827fcd7b0701000000341900),
(2653, 0x7f7fcf7b0701000000311900),
(2653, 0x7f7fc97b0701000000331900),
(2654, 0xb07fc67b0701000000351800),
(2654, 0xb67fc87b0701000000371800),
(2654, 0xb77fc57b0701000000361800),
(2655, 0xa67fb77b0701000000311900),
(2655, 0xaa7fbb7b0701000000321900),
(2655, 0xa57fbd7b0701000000371800),
(2655, 0xa77fbd7b0701000000331900),
(2655, 0xa37fba7b0701000000321900),
(2656, 0x737fae7b0701000000311900),
(2656, 0x727faa7b0701000000371800),
(2657, 0x767fa57b0701000000341900),
(2657, 0x757fa77b0701000000311900),
(2657, 0x717fa07b0701000000331900),
(2657, 0x727fa77b0701000000371800),
(2687, 0x617e187c0701000000832400),
(2687, 0x637e177c07010000008d2400),
(2689, 0x517e137c07010000002c1900),
(2689, 0x4f7e167c0701000000522500),
(2691, 0x4f7e197c07010000008f2400),
(2691, 0x4e7e1e7c0701000000832400),
(2692, 0x5b7e207c07010000002b1900),
(2692, 0x5c7e237c07010000008f2400),
(2693, 0x5e7e237c07010000008f2400),
(2693, 0x627e227c07010000002c1900),
(2698, 0x7c7e1b7c07010000008f2400),
(2698, 0x7e7e177c0701000000832400),
(2698, 0x7f7e1b7c0701000000832400),
(2698, 0x817e197c0701000000842400),
(2699, 0x857e1d7c07010000008f2400),
(2699, 0x877e1d7c0701000000832400),
(2699, 0x897e1b7c0701000000862400),
(2700, 0x747e367c07010000002b1900),
(2701, 0x787e367c07010000002b1900),
(2702, 0x7b7e367c07010000002b1900),
(2703, 0x857e2c7c0701000000701800),
(2703, 0x857e2e7c06010000006f1800),
(2705, 0x947e347c0701000000832400),
(2705, 0x907e367c07010000008d2400),
(2705, 0x967e377c0701000000842400),
(2705, 0x907e387c0701000000842400),
(2705, 0x967e397c07010000008d2400),
(2705, 0x967e3b7c0701000000842400),
(2705, 0x927e3c7c0701000000832400),
(2705, 0x957e3c7c0701000000852400),
(2706, 0x7c7e407c0701000000902400),
(2706, 0x7b7e407c0701000000832400),
(2706, 0x7b7e3e7c0701000000240900),
(2706, 0x7b7e3b7c07010000008f2400),
(2707, 0x7f7e407c07010000008f2400),
(2707, 0x7f7e3e7c0701000000240900),
(2707, 0x7f7e3b7c07010000008f2400),
(2707, 0x817e3d7c0701000000842400),
(2733, 0x6d7e377c06010000008d2400),
(2733, 0x6b7e397c0601000000832400),
(2734, 0x747e367c06010000002d1900),
(2735, 0x787e367c06010000002b1900),
(2736, 0x7b7e367c06010000002b1900),
(2738, 0x737e197c06010000008d2400),
(2738, 0x767e1b7c0601000000832400),
(2738, 0x787e197c0601000000842400),
(2739, 0x607e127c0601000000832400),
(2739, 0x607e187c0601000000832400),
(2741, 0x5c7e237c06010000008f2400),
(2742, 0x5e7e237c06010000008f2400),
(2747, 0x687e257c06010000006e1800),
(2763, 0x507e137c06010000006e1800),
(2768, 0x937e197c0701000000842400),
(2768, 0x937e187c0601000000842400),
(2768, 0x967e287c0801000000701800),
(2792, 0x8b7e377c0601000000842400),
(2792, 0x8b7e397c06010000008d2400),
(2792, 0x8a7e3b7c0601000000832400),
(2793, 0x8b7e377c0701000000842400),
(2793, 0x897e3b7c0701000000832400),
(2793, 0x867e3b7c0701000000832400),
(2793, 0x877e377c0601000000842400),
(2793, 0x897e357c07010000008f2400),
(2856, 0x8a7fd47d0701000000012f00),
(2857, 0x857fd27d06010000005e0b00),
(2857, 0x887fd47d0601000000012f00),
(2858, 0x847fcc7d0701000000012f00),
(2881, 0x797e017e0701000000680600),
(2881, 0x7a7e017e07010000005d0b00),
(2881, 0x777e047e07010000005c0b00),
(2882, 0x7e7e017e0701000000680600),
(2882, 0x7e7e067e0701000000231900),
(2882, 0x7f7e017e07010000005d0b00),
(2882, 0x7c7e047e07010000005b0b00),
(2882, 0x817e047e07010000005b0b00),
(2883, 0x777e087e0701000000660600),
(2883, 0x7c7e097e0701000000241900),
(2883, 0x777e097e07010000005b0b00),
(2883, 0x7a7e067e07010000005d0b00),
(2884, 0x837e057e0701000000660600),
(2884, 0x867e017e0701000000231900),
(2884, 0x887e047e0701000000241900),
(2884, 0x877e017e07010000005d0b00),
(2884, 0x837e037e07010000005b0b00),
(2885, 0x837e087e0701000000241900),
(2885, 0x887e097e0701000000241900),
(2885, 0x837e0a7e0701000000241900),
(2885, 0x867e067e07010000005d0b00),
(2885, 0x837e097e07010000005b0b00),
(2890, 0x797e017e0601000000680600),
(2918, 0x7a7eeb7d0701000000231900),
(2918, 0x7b7ee87d0701000000220900),
(2918, 0x7d7ee87d0701000000660600),
(2918, 0x787eea7d07010000005b0b00),
(2918, 0x787ee97d07010000002d0a00),
(2918, 0x787ee87d07010000002d0a00),
(2918, 0x787ee77d07010000005b0b00),
(2919, 0x7b7ee87d0601000000220900),
(2919, 0x7d7ee97d0601000000660600),
(2919, 0x787eea7d06010000005b0b00),
(2919, 0x787ee97d06010000002d0a00),
(2919, 0x787ee87d06010000002d0a00),
(2919, 0x787ee77d06010000005b0b00),
(2919, 0x7d7ee87d06010000005c0b00),
(2920, 0x7b7ee87d0801000000220900),
(2920, 0x7d7ee77d08010000006e1800),
(2920, 0x787ee77d08010000005b0b00),
(2920, 0x787ee87d08010000002d0a00),
(2920, 0x787ee97d08010000002d0a00),
(2920, 0x787eea7d08010000005b0b00),
(2920, 0x7b7ee57d08010000005d0b00),
(2920, 0x7d7ee97d08010000005b0b00),
(2941, 0x4f7ede7d0701000000f51300),
(2941, 0x4e7ee17d0701000000271900),
(2941, 0x4d7edf7d0701000000220900),
(2941, 0x4d7ee17d0701000000271900),
(2941, 0x4b7ee07d0701000000f51300),
(2941, 0x4b7ede7d07010000002d0a00),
(2941, 0x4b7edf7d07010000002d0a00),
(2942, 0x517ed27d0701000000660600),
(2942, 0x537ed27d0701000000220900),
(2942, 0x527ed07d0701000000680600),
(2942, 0x557ed07d0701000000260a00),
(2942, 0x547ecc7d07010000005d0b00),
(2942, 0x547ed07d0701000000260a00),
(2942, 0x537ed07d07010000005d0b00),
(2942, 0x517ed37d07010000005b0b00),
(2943, 0x4a7ed07d0701000000660600),
(2943, 0x4d7ed07d0601000000660600),
(2943, 0x477ecf7d0701000000680600),
(2943, 0x447ed17d0701000000241900),
(2943, 0x477ed47d0601000000690600),
(2944, 0x4b7e017e0701000000660600),
(2944, 0x467e007e0701000000241900),
(2944, 0x467e017e07010000005b0b00),
(2945, 0x607e077e0701000000231900),
(2945, 0x657e097e0701000000660600),
(2945, 0x5d7e097e07010000005b0b00),
(2945, 0x637e077e07010000005d0b00),
(2945, 0x647e077e0701000000680600),
(2945, 0x627e097e0701000000660600),
(2945, 0x647e0a7e0701000000231900),
(2946, 0x707e077e0701000000680600),
(2946, 0x6c7e077e0701000000231900),
(2946, 0x6e7e097e0701000000660600),
(2946, 0x717e097e0701000000660600),
(2946, 0x707e0a7e0701000000231900),
(2946, 0x6e7e0c7e0701000000660600),
(2946, 0x6f7e077e07010000005d0b00),
(2946, 0x697e097e07010000005b0b00),
(2947, 0x7a7ee47d0701000000660600),
(2947, 0x7a7ee07d0701000000660600),
(2947, 0x7d7ee17d0701000000240900),
(2947, 0x7f7ee27d0701000000241900),
(2947, 0x777ee37d07010000005b0b00),
(2947, 0x7a7ee37d07010000002d0a00),
(2947, 0x7a7ee27d07010000002d0a00),
(2947, 0x7a7ee17d07010000005b0b00),
(2947, 0x7b7ee57d07010000005d0b00),
(2947, 0x7d7ede7d07010000005d0b00),
(2948, 0x7a7ede7d0601000000660600),
(2948, 0x7d7edd7d0601000000240900),
(2948, 0x7f7edc7d0601000000241900),
(2948, 0x7a7edd7d06010000005b0b00),
(2948, 0x7c7eda7d0601000000260a00),
(2948, 0x7d7eda7d0601000000260a00),
(2948, 0x7e7eda7d06010000005d0b00),
(2949, 0x7a7ee47d0601000000660600),
(2949, 0x7a7ee07d0601000000660600),
(2949, 0x7f7ee37d0601000000241900),
(2949, 0x7d7ee17d0601000000240900),
(2949, 0x7f7ee17d0601000000241900),
(2949, 0x7b7ee57d06010000005d0b00),
(2949, 0x777ee37d06010000005b0b00),
(2949, 0x7a7ee37d06010000002d0a00),
(2949, 0x7a7ee27d06010000002d0a00),
(2949, 0x7a7ee17d06010000005b0b00),
(2949, 0x7d7edf7d06010000005e0b00),
(2950, 0x8a7eb47d0701000000231900),
(2950, 0x8e7eb47d0701000000680600),
(2950, 0x8a7eaf7d0701000000231900),
(2950, 0x8e7eaf7d0701000000231900),
(2950, 0x8b7eb17d0701000000660600),
(2950, 0x887eb27d0701000000241900),
(2950, 0x8e7eb27d0701000000240900),
(2950, 0x907eb17d0701000000241900),
(2950, 0x8c7eaf7d0701000000260a00),
(2950, 0x8d7eaf7d0701000000260a00),
(2950, 0x8f7eaf7d07010000005d0b00),
(2950, 0x887eb17d07010000005b0b00),
(2950, 0x8b7eb27d07010000005b0b00),
(2951, 0x947eb47d0701000000ec1300),
(2951, 0x957eb47d0701000000271900),
(2951, 0x947eb27d0701000000240900),
(2951, 0x927eae7d0701000000281900),
(2951, 0x947eaf7d0701000000ec1300),
(2951, 0x927eb07d0701000000281900),
(2951, 0x937eaf7d0701000000260a00),
(2951, 0x957eaf7d0701000000260a00),
(2951, 0x927eb17d07010000005b0b00),
(2952, 0x967ebb7d0701000000241900),
(2952, 0x9c7ebb7d0701000000241900),
(2952, 0x9c7ebe7d0701000000241900),
(2952, 0x987ebf7d0701000000231900),
(2952, 0x9b7ebf7d0701000000231900),
(2952, 0x987eb97d0701000000231900),
(2952, 0x9a7eb97d0701000000680600),
(2952, 0x9b7eb97d07010000005d0b00),
(2952, 0x967ebc7d07010000005b0b00),
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
(2954, 0xa67eaa7d0701000000231900),
(2964, 0x4a7ee57d0701000000251900),
(2964, 0x4c7ee87d0701000000660600),
(2964, 0x487ee77d0701000000261900),
(2964, 0x4b7ee57d07010000005d0b00),
(2965, 0x4c7eed7d0701000000660600),
(2965, 0x487eed7d0701000000241900),
(2965, 0x4a7eea7d07010000005e0b00),
(2965, 0x4c7eea7d07010000005b0b00),
(2965, 0x4a7eef7d07010000005d0b00),
(2966, 0x4d7ef47d0701000000660600),
(2966, 0x497ef47d0701000000241900),
(2966, 0x4b7ef17d07010000005d0b00),
(2966, 0x4d7ef27d07010000005b0b00),
(2967, 0x4a7ee57d0601000000231900),
(2967, 0x4c7ee87d0601000000660600),
(2967, 0x487ee77d0601000000241900),
(2968, 0x4c7eed7d0601000000660600),
(2968, 0x487eec7d0601000000241900),
(2969, 0x4d7ef47d0601000000660600),
(2970, 0x4d7ef97d0601000000660600),
(2971, 0x4c7ee87d0501000000660600),
(2971, 0x4a7ee57d0501000000231900),
(2972, 0x4c7eea7d05010000005b0b00),
(2975, 0x4f7e037e0601000000241900),
(2975, 0x4f7e067e0601000000241900),
(2976, 0xa57ebe7d0701000000241900),
(2976, 0xa27ebf7d0701000000231900),
(2976, 0xa37ebf7d0701000000231900),
(2976, 0xa27eb97d0701000000231900),
(2976, 0xa57ebb7d0701000000241900),
(2976, 0x9f7ebc7d0701000000241900),
(2976, 0xa57ebd7d0701000000660600),
(2976, 0xa47eb97d07010000005d0b00),
(2977, 0xa47ebf7d0601000000231900),
(2977, 0xa57ebe7d0601000000241900),
(2977, 0xa57ebd7d0601000000660600),
(2977, 0xa57ebc7d0601000000241900),
(2977, 0xa17ebf7d0601000000231900),
(2978, 0xa67ecf7d0701000000241900),
(2978, 0xa67ed07d0701000000660600),
(2978, 0xa67ed17d0701000000241900),
(2979, 0xa67eca7d0701000000241900),
(2979, 0xa67ecb7d0701000000660600),
(2979, 0xa67ecc7d0701000000241900),
(2979, 0xa47ecd7d07010000005e0b00),
(2980, 0xa67ec57d0701000000241900),
(2980, 0xa67ec67d0701000000660600),
(2980, 0xa67ec77d0701000000241900),
(2980, 0xa47ec87d07010000005d0b00),
(2980, 0xa47ec37d07010000005d0b00),
(2981, 0xa67ed17d0601000000241900),
(2981, 0xa67ed07d0601000000660600),
(2981, 0xa67ecf7d0601000000241900),
(2982, 0xa67ecc7d0601000000241900),
(2982, 0xa67ecb7d0601000000660600),
(2982, 0xa67eca7d0601000000241900),
(2983, 0xa67ec77d0601000000241900),
(2983, 0xa67ec67d0601000000660600),
(2983, 0xa67ec57d0601000000241900),
(2984, 0x9f7e037e0701000000241900),
(2984, 0xa17e077e0701000000231900),
(2984, 0xa27e017e0701000000231900),
(2984, 0xa37e017e0701000000680600),
(2984, 0xa57e037e0701000000241900),
(2984, 0xa57e057e0701000000241900),
(2984, 0xa27e067e0701000000660600),
(2984, 0xa37e077e0701000000680600),
(2984, 0xa47e017e07010000005e0b00),
(2984, 0xa17e047e07010000005e0b00),
(2985, 0x9d7e037e0701000000241900),
(2985, 0x977e037e0701000000241900),
(2985, 0x9c7e017e0701000000680600),
(2985, 0x997e057e0701000000231900),
(2985, 0x9c7e057e0701000000231900),
(2985, 0x9a7e017e07010000005d0b00),
(2986, 0x8e7e017e0701000000680600),
(2986, 0x8f7e017e0701000000231900),
(2986, 0x937e017e0701000000231900),
(2986, 0x947e017e0701000000231900),
(2986, 0x957e037e0701000000241900),
(2986, 0x8c7e047e0701000000660600),
(2986, 0x907e047e0701000000660600),
(2986, 0x8e7e057e0701000000231900),
(2986, 0x8f7e057e0701000000231900),
(2986, 0x957e057e0701000000241900),
(2986, 0x907e077e0701000000241900),
(2986, 0x927e087e0701000000231900),
(2986, 0x8d7e027e07010000005b0b00),
(2986, 0x907e067e07010000005b0b00),
(2987, 0x647efd7d0701000000231900),
(2987, 0x687efd7d0701000000680600),
(2987, 0x697eff7d0701000000660600),
(2987, 0x687e007e0701000000231900),
(2987, 0x687e007e0601000000231900),
(2987, 0x667eff7d0701000000660600),
(2987, 0x667e027e0701000000660600),
(2987, 0x667eff7d0601000000660600),
(2987, 0x657efd7d0601000000231900),
(2987, 0x647e047e0701000000231900),
(2987, 0x647e037e0601000000660600),
(2987, 0x637e017e0601000000680600),
(2987, 0x637e047e0601000000231900),
(2987, 0x687efd7d06010000005d0b00),
(2987, 0x677efd7d07010000005d0b00),
(2987, 0x617eff7d07010000005b0b00),
(2987, 0x617e037e07010000005b0b00),
(2988, 0x5d7eff7d0701000000660600),
(2988, 0x5c7efd7d0701000000680600),
(2988, 0x5c7e007e0701000000231900),
(2988, 0x5c7e007e0601000000231900),
(2988, 0x5a7eff7d0701000000660600),
(2988, 0x5a7e027e0701000000660600),
(2988, 0x5a7eff7d0601000000660600),
(2988, 0x597efd7d0601000000231900),
(2988, 0x587efd7d0701000000231900),
(2988, 0x587e047e0701000000231900),
(2988, 0x587e037e0601000000660600),
(2988, 0x577e017e0601000000680600),
(2988, 0x577e047e0601000000231900),
(2988, 0x557eff7d07010000005b0b00),
(2988, 0x5b7efd7d07010000005d0b00),
(2988, 0x557e037e07010000005b0b00),
(2989, 0xa37ef87d0701000000680600),
(2989, 0xa57efa7d0701000000241900),
(2989, 0xa37efc7d0701000000231900),
(2989, 0xa17efb7d07010000005b0b00),
(2994, 0xa07ee97d0701000000241900),
(2994, 0x9e7ee77d0701000000231900),
(2994, 0xa07eeb7d0701000000241900),
(2994, 0x9b7ee97d0701000000241900),
(2994, 0x9b7eeb7d0701000000241900),
(2994, 0x9d7eec7d0701000000680600),
(2994, 0x9d7ee77d07010000005d0b00),
(2995, 0xa47ee77d0701000000231900),
(2995, 0xa17ee97d0701000000241900),
(2995, 0xa57ee97d0701000000241900),
(2995, 0xa17eeb7d0701000000241900),
(2995, 0xa57eeb7d0701000000241900),
(2995, 0xa37eec7d0701000000680600),
(2995, 0xa37ee77d07010000005d0b00),
(2996, 0xa37eef7d0701000000680600),
(2996, 0xa17ef17d0701000000241900),
(2996, 0xa57ef17d0701000000241900),
(2996, 0xa17ef37d0701000000241900),
(2996, 0xa57ef37d0701000000241900),
(2996, 0xa37ef47d0701000000231900),
(2996, 0xa17ef27d07010000005b0b00),
(2997, 0xa07ef17d0701000000241900),
(2997, 0xa07ef37d0701000000241900),
(2997, 0x9d7eef7d0701000000680600),
(2997, 0x9b7ef17d0701000000241900),
(2997, 0x9b7ef37d0701000000241900),
(2997, 0x9d7ef47d0701000000231900),
(2997, 0x9b7ef27d07010000005b0b00),
(2998, 0x9a7edc7d0601000000241900),
(2998, 0x9c7ed97d0601000000231900),
(2998, 0x9e7ed97d0601000000231900),
(2998, 0x9f7edb7d0601000000241900),
(2998, 0x9f7edc7d0601000000660600),
(2999, 0x9f7edf7d0601000000660600),
(3001, 0x9c7ed97d0701000000231900),
(3001, 0x9e7ed97d0701000000231900),
(3001, 0x9f7edb7d0701000000241900),
(3001, 0x9a7edc7d0701000000241900),
(3001, 0x9f7edc7d0701000000660600),
(3001, 0x9a7edb7d07010000005b0b00),
(3002, 0x9f7edf7d0701000000660600),
(3002, 0x9a7ee07d0701000000241900),
(3002, 0x9f7ee07d0701000000241900),
(3002, 0x9a7edf7d07010000005b0b00),
(3003, 0x9f7ee27d0701000000660600),
(3003, 0x9a7ee47d0701000000241900),
(3003, 0x9f7ee47d0701000000241900),
(3003, 0x9c7ee57d0701000000231900),
(3003, 0x9e7ee57d0701000000231900),
(3003, 0x9a7ee37d07010000005b0b00),
(3004, 0x5b7ed27d0601000000231900),
(3004, 0x5c7ed47d0701000000690600),
(3004, 0x5d7ed47d0701000000680600),
(3004, 0x5b7ecf7d08010000006e1800),
(3004, 0x5e7ed27d0601000000680600),
(3004, 0x577ec87d0701000000241900),
(3004, 0x597ecb7d0701000000680600),
(3004, 0x5a7ece7d0701000000230900),
(3004, 0x5c7ecb7d0701000000690600),
(3004, 0x577ec37d0701000000241900),
(3004, 0x5f7ec47d0701000000241900),
(3004, 0x5b7ec57d0701000000680600),
(3004, 0x5f7ec77d0701000000241900),
(3004, 0x5f7ec97d0701000000241900),
(3004, 0x5d7ed07d0601000000660600),
(3004, 0x5f7ecf7d0601000000241900),
(3004, 0x577ece7d0601000000231900),
(3004, 0x5d7ecd7d0601000000660600),
(3004, 0x5f7ecb7d0601000000241900),
(3004, 0x5a7ec97d0601000000660600),
(3004, 0x5e7ec97d0601000000680600),
(3004, 0x577ec87d0601000000241900),
(3004, 0x5f7ec77d0601000000241900),
(3004, 0x5f7ec47d0601000000241900),
(3004, 0x5d7ec17d0601000000231900),
(3004, 0x5b7ec57d0601000000680600),
(3004, 0x5a7ec17d0601000000231900),
(3004, 0x577ec37d0601000000241900),
(3004, 0x5b7ece7d08010000005c0b00),
(3004, 0x607ec17d08010000005d0b00),
(3004, 0x577ec37d08010000005b0b00),
(3004, 0x5b7ec47d08010000006e1800),
(3004, 0x5e7ec47d08010000006e1800),
(3004, 0x5b7ec57d08010000005b0b00),
(3004, 0x607ec57d08010000005d0b00),
(3004, 0x577ec77d08010000005b0b00),
(3004, 0x5b7ec77d08010000006e1800),
(3004, 0x5e7ec77d08010000006e1800),
(3004, 0x5a7ec97d0801000000260a00),
(3004, 0x5b7ec97d08010000005e0b00),
(3004, 0x5d7ec97d0801000000701800),
(3004, 0x5e7ec97d08010000005e0b00),
(3004, 0x5c7ec57d0701000000260a00),
(3004, 0x5d7ec57d07010000005d0b00),
(3004, 0x5d7ecb7d07010000005e0b00),
(3004, 0x5a7ec17d07010000005d0b00),
(3004, 0x587ece7d07010000005b0b00),
(3004, 0x5c7ed27d06010000005e0b00),
(3004, 0x5d7ecf7d06010000005c0b00),
(3004, 0x5a7ec77d06010000005b0b00),
(3004, 0x5a7ecb7d06010000005d0b00),
(3004, 0x5c7ec17d06010000005d0b00),
(3012, 0x897ef87d0701000000241900),
(3012, 0x917ef87d0701000000680600),
(3012, 0x957ef87d0701000000680600),
(3012, 0x897efa7d0701000000241900),
(3012, 0x8f7efb7d0701000000660600),
(3012, 0x937efb7d0701000000660600),
(3012, 0x967efb7d0701000000660600),
(3012, 0x8c7efd7d0701000000231900),
(3012, 0x8d7efd7d0701000000231900),
(3012, 0x917efd7d0701000000680600),
(3012, 0x957efd7d0701000000231900),
(3012, 0x997efd7d0701000000231900),
(3012, 0x9a7efb7d0701000000241900),
(3012, 0x9a7ef67d0701000000241900),
(3012, 0x8e7ef77d08010000005c0b00),
(3012, 0x897efc7d07010000005b0b00),
(3012, 0x897ef67d07010000005b0b00),
(3012, 0x8d7ef47d07010000005d0b00),
(3012, 0x917ef47d07010000005d0b00),
(3012, 0x8f7efa7d07010000005b0b00),
(3012, 0x967ef47d07010000005d0b00),
(3012, 0x967efa7d07010000005b0b00),
(3012, 0x927ef87d0701000000260a00),
(3012, 0x937efc7d07010000005b0b00),
(3133, 0xb681327c07010000006e1800),
(3133, 0xb981327c0701000000220900),
(3133, 0xbc81337c07010000006e1800),
(3133, 0xbf81337c07010000006e1800),
(3134, 0xbc813a7c07010000006e1800),
(3134, 0xb681397c07010000006e1800),
(3134, 0xb981397c0701000000220900),
(3134, 0xbf813a7c07010000006e1800),
(3135, 0xbc81417c07010000006e1800),
(3135, 0xbf81417c07010000006e1800),
(3135, 0xb981407c0701000000220900),
(3135, 0xb681407c07010000006e1800),
(3161, 0xca81497c0701000000660600),
(3161, 0xcd814c7c0701000000231900),
(3161, 0xcf814c7c0701000000231900),
(3161, 0xca814a7c07010000005b0b00),
(3162, 0xd5814c7c0701000000680600),
(3162, 0xd7814c7c0701000000231900),
(3162, 0xd881487c0701000000241900),
(3162, 0xd8814a7c0701000000241900),
(3163, 0xcd81427c0701000000660600),
(3163, 0xd481417c0701000000241900),
(3163, 0xd1813e7c0701000000231900),
(3164, 0xcc81387c0701000000231900),
(3164, 0xce81387c0701000000680600),
(3164, 0xca81357c0701000000241900),
(3164, 0xd181347c0701000000241900),
(3164, 0xd181367c0701000000241900),
(3165, 0xcd81427c0601000000261900),
(3165, 0xd481427c0601000000241900),
(3165, 0xd481437c0601000000660600),
(3165, 0xd1813e7c0601000000251900),
(3165, 0xd481417c0601000000241900),
(3166, 0xca81487c0601000000241900),
(3166, 0xcd814c7c0601000000231900),
(3166, 0xcf814c7c0601000000680600),
(3167, 0xd4814c7c0601000000680600),
(3167, 0xd5814c7c0601000000231900),
(3167, 0xd681457c0601000000231900),
(3167, 0xd881487c0601000000241900),
(3167, 0xd8814a7c0601000000241900),
(3190, 0xf07f127a0701000000fe1300),
(3190, 0xf17f0d7a0701000000071400),
(3190, 0xf17f157a0701000000071400),
(3206, 0x2880c4790701000000b61400),
(3208, 0x2980cd790602000000b71400b71400),
(3208, 0x2980ca790701000000b71400),
(3208, 0x2980ca790602000000b71400b71400),
(3208, 0x2a80cb7906010000008c1500),
(3217, 0x05801a7a07010000008a1500),
(3217, 0x0880187a0701000000b61400),
(3217, 0x0b801b7a06010000008a1500),
(3220, 0x637fd37f0701000000391900),
(3220, 0x607fd37f0701000000391900),
(3237, 0x357f138006010000003c1900),
(3237, 0x387f108006010000003b1900),
(3246, 0xa27f09800601000000391900),
(3246, 0xa27f0e800601000000950600),
(3246, 0xa47f0b8006010000003a1900),
(3246, 0xa47f0d8006010000003a1900),
(3248, 0xa07f05800601000000950600),
(3248, 0xa27f05800601000000391900),
(3248, 0xa37f048006010000003a1900),
(3263, 0x337f0a800601000000391900),
(3263, 0x357f0a8006010000003b1900),
(3263, 0x377f068006010000003a1900),
(3263, 0x377f078006010000009e0600),
(3263, 0x377f098006010000003a1900),
(3264, 0x267f038005010000009e0600),
(3264, 0x287f00800601000000950600),
(3264, 0x2b7fff7f06010000009e0600),
(3264, 0x257ffd7f0601000000950600),
(3264, 0x297ffd7f0601000000950600),
(3264, 0x267ffe7f05010000009e0600),
(3275, 0xea7d8d790601000000721b00),
(3275, 0xea7d8e790701000000f71a00),
(3275, 0xea7d8f790601000000721b00),
(3275, 0xe57d8e790701000000f71a00),
(3275, 0xe67d8b790601000000711b00),
(3275, 0xe27d8e790701000000741b00),
(3278, 0xf77da1790701000000731b00),
(3278, 0xf97d9d790701000000741b00),
(3278, 0xf97d9d790601000000741b00),
(3279, 0xff7d9e790701000000731b00),
(3279, 0x017e9c790701000000f71a00),
(3279, 0x047e9e790701000000731b00),
(3279, 0x077e9c790701000000f71a00),
(3279, 0xfe7d99790701000000731b00),
(3279, 0x047e99790701000000731b00),
(3280, 0xf77d92790701000000f71a00),
(3280, 0xf97d94790701000000731b00),
(3280, 0xfa7d92790701000000f71a00),
(3280, 0xfc7d94790701000000731b00),
(3280, 0xfe7d92790701000000741b00),
(3280, 0xf97d94790601000000731b00),
(3280, 0xfa7d93790501000000f71a00),
(3280, 0xfe7d93790501000000741b00),
(3280, 0xfa7d91790601000000f71a00),
(3280, 0xfe7d91790601000000741b00),
(3280, 0xf77d8b790701000000741b00),
(3280, 0xf77d8e790701000000f71a00),
(3280, 0xf97d8c790701000000ee1a00),
(3280, 0xfa7d8e790701000000f71a00),
(3280, 0xfe7d8c790701000000741b00),
(3280, 0xfe7d8d790601000000741b00),
(3280, 0xfa7d8b790501000000f71a00),
(3280, 0xfa7d8f790501000000f71a00),
(3280, 0xfe7d8b790501000000741b00),
(3280, 0xfe7d8f790501000000741b00),
(3280, 0xf77d8c790601000000741b00),
(3281, 0x077e94790701000000731b00),
(3281, 0x077e91790701000000ee1a00),
(3281, 0x047e8f790701000000f71a00),
(3281, 0x077e8d790701000000ee1a00),
(3281, 0x0a7e8c790701000000741b00),
(3281, 0x0a7e8f790701000000741b00),
(3282, 0x037e85790701000000ee1a00),
(3282, 0x097e85790701000000731b00),
(3282, 0x047e85790601000000731b00),
(3282, 0x077e85790601000000731b00),
(3282, 0x017e83790701000000741b00),
(3282, 0x057e83790701000000f71a00),
(3282, 0x087e83790601000000f71a00),
(3294, 0xfe7db3790701000000741b00),
(3294, 0x007eb5790701000000ee1a00),
(3294, 0x017eb0790701000000ee1a00),
(3294, 0x027eb5790701000000731b00),
(3294, 0x047eb3790701000000f71a00),
(3294, 0x077eb0790701000000731b00),
(3294, 0x087eb5790701000000731b00),
(3294, 0xfe7db3790601000000741b00),
(3294, 0x017eb5790601000000731b00),
(3294, 0x057eb5790601000000731b00),
(3294, 0x067eb3790601000000f71a00),
(3294, 0x017ead790701000000731b00),
(3294, 0x017ead790601000000731b00),
(3294, 0x017eb0790601000000ee1a00),
(3295, 0x027ebe790701000000741b00),
(3295, 0x047eba790701000000ee1a00),
(3295, 0x047ec1790701000000731b00),
(3295, 0x057ebf790701000000f71a00),
(3295, 0x077ec1790701000000731b00),
(3296, 0xfe7dbf790701000000731b00),
(3296, 0xf97dbe790701000000f71a00),
(3296, 0xfc7dbb790701000000f71a00),
(3296, 0xfc7dbe790701000000f71a00),
(3296, 0x007ebb790701000000741b00),
(3296, 0xfb7dbf790601000000731b00),
(3296, 0xfc7dbc790601000000f71a00),
(3296, 0xff7dbf790601000000731b00),
(3296, 0x007ebc790601000000741b00),
(3298, 0x057ec6790701000000f71a00),
(3298, 0x087ec6790701000000741b00),
(3298, 0x007ec5790701000000f71a00),
(3298, 0x037ec3790701000000731b00),
(3299, 0x007ec9790701000000f71a00),
(3299, 0x037ecb790701000000731b00),
(3299, 0x057eca790701000000f71a00),
(3299, 0x077ecb790701000000731b00),
(3300, 0x057ed6790701000000731b00),
(3300, 0x027ed5790701000000f71a00),
(3300, 0x077ed5790701000000741b00),
(3300, 0x057ed3790701000000ee1a00),
(3300, 0x067ed0790701000000731b00),
(3301, 0xf77dd5790701000000f71a00),
(3301, 0xf97dd5790701000000741b00),
(3301, 0xf97dd3790701000000f71a00),
(3301, 0xf77dd2790701000000f71a00),
(3309, 0xf77db0790701000000ee1a00),
(3309, 0xf87db4790701000000ee1a00),
(3309, 0xfb7db0790701000000ee1a00),
(3309, 0xfb7db4790701000000731b00),
(3309, 0xfc7db3790701000000741b00),
(3309, 0xfc7daf790701000000741b00),
(3314, 0xc581ba7e0701000000b71400),
(3316, 0xc581bf7e0701000000b71400),
(3316, 0xc581c07e07010000005c0b00),
(3316, 0xc581c57e0701000000b71400),
(3316, 0xc781c27e07010000005e0b00),
(3316, 0xc881c27e07010000008c1500),
(3316, 0xc881c77e0701000000b61400),
(3319, 0xc581bb7e06010000005b0b00),
(3319, 0xc581c17e06010000005c0b00),
(3319, 0xc581c57e0601000000b71400),
(3319, 0xc881c27e06010000008c1500),
(3319, 0xc881bc7e06010000008c1500),
(3339, 0xb181bd7e0701000000b61400),
(3339, 0xb381bd7e0701000000b61400),
(3339, 0xb181b87e07010000005d0b00),
(3339, 0xb581b87e07010000008c1500),
(3340, 0xb681bb7e07010000005c0b00),
(3340, 0xb881bd7e0701000000b61400),
(3340, 0xb881b87e07010000008c1500),
(3340, 0xb981b87e07010000005e0b00),
(3341, 0xba81ba7e07010000005c0b00),
(3341, 0xbd81bd7e0701000000b61400),
(3341, 0xbf81ba7e0701000000b71400),
(3344, 0xb181bd7e0601000000b61400),
(3345, 0xb681bd7e0601000000b61400),
(3345, 0xb581b87e06010000008c1500),
(3345, 0xb681b87e06010000005d0b00),
(3346, 0xbc81bd7e0601000000b61400),
(3346, 0xbf81bb7e0601000000b71400),
(3346, 0xb981b87e06010000008c1500),
(3347, 0xbd81b87e06010000005d0b00),
(3634, 0x91840c7b0701000000717800),
(3638, 0x7584307b0701000000067b00),
(3638, 0x7084347b0701000000077b00),
(3639, 0x4a841b7b0701000000067b00),
(3640, 0x5884257b0701000000737800),
(3640, 0x5c84247b0601000000067b00);

-- --------------------------------------------------------

--
-- Table structure for table `towns`
--

CREATE TABLE `towns` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `posx` int(11) NOT NULL DEFAULT 0,
  `posy` int(11) NOT NULL DEFAULT 0,
  `posz` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `towns`
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
(24, 'Cobra Bastion', 33397, 32651, 7),
(25, 'Bounac', 32424, 32445, 7),
(26, 'Feyrist', 33490, 32221, 7),
(27, 'Gnomprona', 33517, 32856, 14),
(28, 'Marapur', 33842, 32853, 7);

-- --------------------------------------------------------

--
-- Table structure for table `z_polls`
--

CREATE TABLE `z_polls` (
  `id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `end` int(11) NOT NULL DEFAULT 0,
  `start` int(11) NOT NULL DEFAULT 0,
  `answers` int(11) NOT NULL DEFAULT 0,
  `votes_all` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `z_polls_answers`
--

CREATE TABLE `z_polls_answers` (
  `poll_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `answer` varchar(255) NOT NULL,
  `votes` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `accounts_unique` (`name`);

--
-- Indexes for table `account_bans`
--
ALTER TABLE `account_bans`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Indexes for table `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Indexes for table `account_sessions`
--
ALTER TABLE `account_sessions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD UNIQUE KEY `account_viplist_unique` (`account_id`,`player_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `boosted_boss`
--
ALTER TABLE `boosted_boss`
  ADD PRIMARY KEY (`date`);

--
-- Indexes for table `boosted_creature`
--
ALTER TABLE `boosted_creature`
  ADD PRIMARY KEY (`date`);

--
-- Indexes for table `coins_transactions`
--
ALTER TABLE `coins_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `daily_reward_history`
--
ALTER TABLE `daily_reward_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `forge_history`
--
ALTER TABLE `forge_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `global_storage`
--
ALTER TABLE `global_storage`
  ADD UNIQUE KEY `global_storage_unique` (`key`);

--
-- Indexes for table `guilds`
--
ALTER TABLE `guilds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `guilds_name_unique` (`name`),
  ADD UNIQUE KEY `guilds_owner_unique` (`ownerid`);

--
-- Indexes for table `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `warid` (`warid`);

--
-- Indexes for table `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD PRIMARY KEY (`player_id`,`guild_id`),
  ADD KEY `guild_id` (`guild_id`);

--
-- Indexes for table `guild_membership`
--
ALTER TABLE `guild_membership`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `guild_id` (`guild_id`),
  ADD KEY `rank_id` (`rank_id`);

--
-- Indexes for table `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild_id` (`guild_id`);

--
-- Indexes for table `guild_wars`
--
ALTER TABLE `guild_wars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild1` (`guild1`),
  ADD KEY `guild2` (`guild2`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`),
  ADD KEY `town_id` (`town_id`);

--
-- Indexes for table `house_lists`
--
ALTER TABLE `house_lists`
  ADD PRIMARY KEY (`house_id`,`listid`),
  ADD KEY `house_id_index` (`house_id`),
  ADD KEY `version` (`version`);

--
-- Indexes for table `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD PRIMARY KEY (`ip`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Indexes for table `kv_store`
--
ALTER TABLE `kv_store`
  ADD PRIMARY KEY (`key_name`);

--
-- Indexes for table `market_history`
--
ALTER TABLE `market_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`,`sale`);

--
-- Indexes for table `market_offers`
--
ALTER TABLE `market_offers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale` (`sale`,`itemtype`),
  ADD KEY `created` (`created`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `myaac_account_actions`
--
ALTER TABLE `myaac_account_actions`
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `myaac_admin_menu`
--
ALTER TABLE `myaac_admin_menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_bugtracker`
--
ALTER TABLE `myaac_bugtracker`
  ADD PRIMARY KEY (`uid`);

--
-- Indexes for table `myaac_changelog`
--
ALTER TABLE `myaac_changelog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_charbazaar`
--
ALTER TABLE `myaac_charbazaar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_charbazaar_bid`
--
ALTER TABLE `myaac_charbazaar_bid`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_config`
--
ALTER TABLE `myaac_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `myaac_faq`
--
ALTER TABLE `myaac_faq`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_forum`
--
ALTER TABLE `myaac_forum`
  ADD PRIMARY KEY (`id`),
  ADD KEY `section` (`section`);

--
-- Indexes for table `myaac_forum_boards`
--
ALTER TABLE `myaac_forum_boards`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_gallery`
--
ALTER TABLE `myaac_gallery`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_menu`
--
ALTER TABLE `myaac_menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_monsters`
--
ALTER TABLE `myaac_monsters`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_news`
--
ALTER TABLE `myaac_news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_news_categories`
--
ALTER TABLE `myaac_news_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_notepad`
--
ALTER TABLE `myaac_notepad`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_pages`
--
ALTER TABLE `myaac_pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `myaac_polls`
--
ALTER TABLE `myaac_polls`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_spells`
--
ALTER TABLE `myaac_spells`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `myaac_videos`
--
ALTER TABLE `myaac_videos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myaac_visitors`
--
ALTER TABLE `myaac_visitors`
  ADD UNIQUE KEY `ip` (`ip`);

--
-- Indexes for table `myaac_weapons`
--
ALTER TABLE `myaac_weapons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `players_unique` (`name`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `vocation` (`vocation`);

--
-- Indexes for table `players_online`
--
ALTER TABLE `players_online`
  ADD PRIMARY KEY (`player_id`);

--
-- Indexes for table `player_bonus_info`
--
ALTER TABLE `player_bonus_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `player_id` (`player_id`);

--
-- Indexes for table `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `killed_by` (`killed_by`),
  ADD KEY `mostdamage_by` (`mostdamage_by`);

--
-- Indexes for table `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD UNIQUE KEY `player_depotitems_unique` (`player_id`,`sid`);

--
-- Indexes for table `player_hirelings`
--
ALTER TABLE `player_hirelings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD UNIQUE KEY `player_inboxitems_unique` (`player_id`,`sid`);

--
-- Indexes for table `player_items`
--
ALTER TABLE `player_items`
  ADD PRIMARY KEY (`player_id`,`pid`,`sid`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `sid` (`sid`);

--
-- Indexes for table `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD UNIQUE KEY `player_namelocks_unique` (`player_id`),
  ADD KEY `namelocked_by` (`namelocked_by`);

--
-- Indexes for table `player_prey`
--
ALTER TABLE `player_prey`
  ADD PRIMARY KEY (`player_id`,`slot`);

--
-- Indexes for table `player_rewards`
--
ALTER TABLE `player_rewards`
  ADD UNIQUE KEY `player_rewards_unique` (`player_id`,`sid`);

--
-- Indexes for table `player_spells`
--
ALTER TABLE `player_spells`
  ADD PRIMARY KEY (`player_id`,`name`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `player_stash`
--
ALTER TABLE `player_stash`
  ADD PRIMARY KEY (`player_id`,`item_id`);

--
-- Indexes for table `player_storage`
--
ALTER TABLE `player_storage`
  ADD PRIMARY KEY (`player_id`,`key`);

--
-- Indexes for table `player_taskhunt`
--
ALTER TABLE `player_taskhunt`
  ADD PRIMARY KEY (`player_id`,`slot`);

--
-- Indexes for table `player_wheeldata`
--
ALTER TABLE `player_wheeldata`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `server_config`
--
ALTER TABLE `server_config`
  ADD PRIMARY KEY (`config`);

--
-- Indexes for table `store_history`
--
ALTER TABLE `store_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `tile_store`
--
ALTER TABLE `tile_store`
  ADD KEY `house_id` (`house_id`);

--
-- Indexes for table `towns`
--
ALTER TABLE `towns`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `z_polls`
--
ALTER TABLE `z_polls`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `account_ban_history`
--
ALTER TABLE `account_ban_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `coins_transactions`
--
ALTER TABLE `coins_transactions`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT for table `daily_reward_history`
--
ALTER TABLE `daily_reward_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `forge_history`
--
ALTER TABLE `forge_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `guilds`
--
ALTER TABLE `guilds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guild_ranks`
--
ALTER TABLE `guild_ranks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guild_wars`
--
ALTER TABLE `guild_wars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3687;

--
-- AUTO_INCREMENT for table `market_history`
--
ALTER TABLE `market_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `market_offers`
--
ALTER TABLE `market_offers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myaac_admin_menu`
--
ALTER TABLE `myaac_admin_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myaac_bugtracker`
--
ALTER TABLE `myaac_bugtracker`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myaac_changelog`
--
ALTER TABLE `myaac_changelog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `myaac_charbazaar`
--
ALTER TABLE `myaac_charbazaar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myaac_charbazaar_bid`
--
ALTER TABLE `myaac_charbazaar_bid`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myaac_config`
--
ALTER TABLE `myaac_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `myaac_faq`
--
ALTER TABLE `myaac_faq`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myaac_forum`
--
ALTER TABLE `myaac_forum`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myaac_forum_boards`
--
ALTER TABLE `myaac_forum_boards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `myaac_gallery`
--
ALTER TABLE `myaac_gallery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `myaac_menu`
--
ALTER TABLE `myaac_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=467;

--
-- AUTO_INCREMENT for table `myaac_monsters`
--
ALTER TABLE `myaac_monsters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myaac_news`
--
ALTER TABLE `myaac_news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `myaac_news_categories`
--
ALTER TABLE `myaac_news_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `myaac_notepad`
--
ALTER TABLE `myaac_notepad`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myaac_pages`
--
ALTER TABLE `myaac_pages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `myaac_spells`
--
ALTER TABLE `myaac_spells`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `myaac_videos`
--
ALTER TABLE `myaac_videos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `player_bonus_info`
--
ALTER TABLE `player_bonus_info`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_hirelings`
--
ALTER TABLE `player_hirelings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `store_history`
--
ALTER TABLE `store_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `towns`
--
ALTER TABLE `towns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `z_polls`
--
ALTER TABLE `z_polls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
-- Constraints for table `player_wheeldata`
--
ALTER TABLE `player_wheeldata`
  ADD CONSTRAINT `player_wheeldata_players_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

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
