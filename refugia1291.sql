-- phpMyAdmin SQL Dump
-- version 4.6.6deb5ubuntu0.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: 25-Set-2022 às 16:05
-- Versão do servidor: 5.7.39-0ubuntu0.18.04.2
-- PHP Version: 7.3.33-6+ubuntu18.04.1+deb.sury.org+1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `refugia1291`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `password` char(40) NOT NULL,
  `secret` char(16) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '1',
  `premdays` int(11) NOT NULL DEFAULT '0',
  `coins` int(12) NOT NULL DEFAULT '0',
  `coins_tournaments` int(12) NOT NULL DEFAULT '0',
  `lastday` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `proxy_id` int(11) NOT NULL DEFAULT '0',
  `email` varchar(255) NOT NULL DEFAULT '',
  `creation` bigint(20) NOT NULL DEFAULT '0',
  `recruiter` int(6) DEFAULT '0',
  `vote` int(11) NOT NULL DEFAULT '0',
  `key` varchar(64) NOT NULL DEFAULT '',
  `blocked` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'internal usage',
  `created` int(11) NOT NULL DEFAULT '0',
  `email_new` varchar(255) NOT NULL DEFAULT '',
  `email_new_time` int(11) NOT NULL DEFAULT '0',
  `rlname` varchar(255) NOT NULL DEFAULT '',
  `location` varchar(255) NOT NULL DEFAULT '',
  `country` varchar(3) NOT NULL DEFAULT '',
  `web_lastlogin` int(11) NOT NULL DEFAULT '0',
  `web_flags` int(11) NOT NULL DEFAULT '0',
  `email_hash` varchar(32) NOT NULL DEFAULT '',
  `email_verified` tinyint(1) NOT NULL DEFAULT '0',
  `page_access` int(11) NOT NULL DEFAULT '0',
  `email_code` varchar(255) NOT NULL DEFAULT '',
  `email_next` int(11) NOT NULL DEFAULT '0',
  `premium_points` int(11) NOT NULL DEFAULT '0',
  `create_date` bigint(20) NOT NULL DEFAULT '0',
  `create_ip` bigint(20) NOT NULL DEFAULT '0',
  `last_post` int(11) NOT NULL DEFAULT '0',
  `flag` varchar(80) NOT NULL DEFAULT '',
  `vip_time` int(11) NOT NULL DEFAULT '0',
  `guild_points` int(11) NOT NULL DEFAULT '0',
  `guild_points_stats` int(11) NOT NULL DEFAULT '0',
  `passed` int(11) NOT NULL DEFAULT '0',
  `block` int(11) NOT NULL DEFAULT '0',
  `refresh` int(11) NOT NULL DEFAULT '0',
  `birth_date` varchar(50) NOT NULL DEFAULT '',
  `gender` varchar(20) NOT NULL DEFAULT '',
  `loyalty_points` bigint(20) NOT NULL DEFAULT '0',
  `authToken` varchar(100) NOT NULL DEFAULT '',
  `player_sell_bank` int(11) DEFAULT '0',
  `secret_status` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `secret`, `type`, `premdays`, `coins`, `coins_tournaments`, `lastday`, `proxy_id`, `email`, `creation`, `recruiter`, `vote`, `key`, `blocked`, `created`, `email_new`, `email_new_time`, `rlname`, `location`, `country`, `web_lastlogin`, `web_flags`, `email_hash`, `email_verified`, `page_access`, `email_code`, `email_next`, `premium_points`, `create_date`, `create_ip`, `last_post`, `flag`, `vip_time`, `guild_points`, `guild_points_stats`, `passed`, `block`, `refresh`, `birth_date`, `gender`, `loyalty_points`, `authToken`, `player_sell_bank`, `secret_status`) VALUES
(1, 'CharBazarOficial', 'e247251862624aa67f728619a8b7253f9bd67f02', NULL, 1, 7, 0, 0, 1662578634, 0, 'charbazar@realsoft.com', 0, 0, 0, '3XUVEVC2FH', 0, 1662578634, '', 0, '', '', 'br', 0, 0, '', 0, 0, '', 0, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, '', '', 0, '', 0, 0),
(2, 'Gu985423', 'e247251862624aa67f728619a8b7253f9bd67f02', '1', 5, 346, 11890, 6899, 1664114349, 0, 'almeidaliber@gmail.com', 0, 0, 0, '3XUVEVC2FH', 0, 1662576813, '', 0, '', '', 'us', 1663853820, 3, '', 0, 0, '', 0, 0, 0, 0, 0, '', 1663522350, 0, 0, 0, 0, 0, '', '', 0, '222', 0, 1),
(3, '9854232', 'e247251862624aa67f728619a8b7253f9bd67f02', NULL, 1, 355, 7250, 0, 1663982545, 0, 'almeidaliber2@gmail.com', 0, 0, 0, '3XUVEVC2FH', 0, 1662945745, '', 0, '', '', 'br', 1664053742, 0, '', 0, 0, '', 0, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, '', '', 0, '', 0, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `accounts_storage`
--

CREATE TABLE `accounts_storage` (
  `account_id` int(11) NOT NULL DEFAULT '0',
  `key` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `account_bans`
--

CREATE TABLE `account_bans` (
  `account_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `account_ban_history`
--

CREATE TABLE `account_ban_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `account_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expired_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `account_character_sale`
--

CREATE TABLE `account_character_sale` (
  `id` int(11) NOT NULL,
  `id_account` int(11) NOT NULL,
  `id_player` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `price_type` tinyint(4) NOT NULL,
  `price_coins` int(11) DEFAULT NULL,
  `price_gold` int(11) DEFAULT NULL,
  `dta_insert` datetime NOT NULL,
  `dta_valid` datetime NOT NULL,
  `dta_sale` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `account_viplist`
--

CREATE TABLE `account_viplist` (
  `account_id` int(11) NOT NULL COMMENT 'id of account whose viplist entry it is',
  `player_id` int(11) NOT NULL COMMENT 'id of target player of viplist entry',
  `description` varchar(128) NOT NULL DEFAULT '',
  `icon` tinyint(2) UNSIGNED NOT NULL DEFAULT '0',
  `notify` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `announcements`
--

CREATE TABLE `announcements` (
  `id` int(10) NOT NULL,
  `title` varchar(50) NOT NULL,
  `text` varchar(255) NOT NULL,
  `date` varchar(20) NOT NULL,
  `author` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `blessings_history`
--

CREATE TABLE `blessings_history` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `blessing` tinyint(4) NOT NULL,
  `loss` tinyint(1) NOT NULL,
  `timestamp` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `boosted_creature`
--

CREATE TABLE `boosted_creature` (
  `looktype` int(11) NOT NULL DEFAULT '136',
  `lookfeet` int(11) NOT NULL DEFAULT '0',
  `looklegs` int(11) NOT NULL DEFAULT '0',
  `lookhead` int(11) NOT NULL DEFAULT '0',
  `lookbody` int(11) NOT NULL DEFAULT '0',
  `lookaddons` int(11) NOT NULL DEFAULT '0',
  `lookmount` int(11) DEFAULT '0',
  `date` varchar(250) NOT NULL DEFAULT '',
  `boostname` text,
  `raceid` varchar(250) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `boosted_creature`
--

INSERT INTO `boosted_creature` (`looktype`, `lookfeet`, `looklegs`, `lookhead`, `lookbody`, `lookaddons`, `lookmount`, `date`, `boostname`, `raceid`) VALUES
(721, 0, 0, 0, 0, 0, 0, '25', 'Wereboar', '1143');

-- --------------------------------------------------------

--
-- Estrutura da tabela `coins_transactions`
--

CREATE TABLE `coins_transactions` (
  `id` int(11) NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  `type` tinyint(1) UNSIGNED NOT NULL,
  `amount` int(12) UNSIGNED NOT NULL,
  `description` varchar(3500) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `coins_transactions`
--

INSERT INTO `coins_transactions` (`id`, `account_id`, `type`, `amount`, `description`, `timestamp`) VALUES
(1, 3, 1, 25, 'Purchased on Market', '2022-09-13 17:52:38'),
(2, 2, 2, 25, 'Sold on Market', '2022-09-13 17:52:38'),
(3, 3, 1, 25, 'Purchased on Market', '2022-09-13 17:52:45'),
(4, 2, 2, 25, 'Sold on Market', '2022-09-13 17:52:45'),
(5, 3, 1, 10450, 'Purchased on Market', '2022-09-13 17:53:06'),
(6, 2, 2, 10450, 'Sold on Market', '2022-09-13 17:53:06'),
(7, 2, 2, 250, 'Sold on Market', '2022-09-13 17:54:29'),
(8, 3, 1, 250, 'Purchased on Market', '2022-09-13 17:54:29'),
(9, 2, 1, 500, 'Purchased on Market', '2022-09-13 17:54:55'),
(10, 3, 2, 500, 'Sold on Market', '2022-09-13 17:54:55');

-- --------------------------------------------------------

--
-- Estrutura da tabela `crypto_payments`
--

CREATE TABLE `crypto_payments` (
  `paymentID` int(11) UNSIGNED NOT NULL,
  `boxID` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `boxType` enum('paymentbox','captchabox') NOT NULL,
  `orderID` varchar(50) NOT NULL DEFAULT '',
  `userID` varchar(50) NOT NULL DEFAULT '',
  `countryID` varchar(3) NOT NULL DEFAULT '',
  `coinLabel` varchar(6) NOT NULL DEFAULT '',
  `amount` double(20,8) NOT NULL DEFAULT '0.00000000',
  `amountUSD` double(20,8) NOT NULL DEFAULT '0.00000000',
  `unrecognised` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `addr` varchar(34) NOT NULL DEFAULT '',
  `txID` char(64) NOT NULL DEFAULT '',
  `txDate` datetime DEFAULT NULL,
  `txConfirmed` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `txCheckDate` datetime DEFAULT NULL,
  `processed` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `processedDate` datetime DEFAULT NULL,
  `recordCreated` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura da tabela `daily_reward_history`
--

CREATE TABLE `daily_reward_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `daystreak` smallint(2) NOT NULL DEFAULT '0',
  `player_id` int(11) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `daily_reward_history`
--

INSERT INTO `daily_reward_history` (`id`, `daystreak`, `player_id`, `timestamp`, `description`) VALUES
(1, 0, 8, 1662904688, 'Claimed reward no. 1. Picked items: 5x mana potion.'),
(2, 0, 7, 1662904766, 'Claimed reward no. 1. Picked items: 10x mana potion.'),
(3, 1, 8, 1663161377, 'Claimed reward no. 2. Picked items: 10x mana potion.'),
(4, 1, 7, 1663161968, 'Claimed reward no. 2. Picked items: 10x mana potion.'),
(5, 2, 7, 1663167960, 'Claimed reward no. 3. Picked reward: 2x Prey bonus reroll(s)'),
(6, 3, 7, 1663846786, 'Claimed reward no. 4. Picked items: 20x supreme health potion.'),
(7, 4, 7, 1663852263, 'Claimed reward no. 5. Picked reward: 2x Prey bonus reroll(s)');

-- --------------------------------------------------------

--
-- Estrutura da tabela `free_pass`
--

CREATE TABLE `free_pass` (
  `player_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `global_storage`
--

CREATE TABLE `global_storage` (
  `key` varchar(32) NOT NULL,
  `value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `global_storage`
--

INSERT INTO `global_storage` (`key`, `value`) VALUES
('14110', '1664031300'),
('40000', '4'),
('48503', '2');

-- --------------------------------------------------------

--
-- Estrutura da tabela `guilds`
--

CREATE TABLE `guilds` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `creationdata` bigint(20) NOT NULL,
  `motd` varchar(255) NOT NULL DEFAULT '',
  `residence` int(11) NOT NULL DEFAULT '1',
  `description` text NOT NULL,
  `guild_logo` mediumblob,
  `create_ip` bigint(20) NOT NULL DEFAULT '0',
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `last_execute_points` bigint(20) NOT NULL DEFAULT '0',
  `logo_name` varchar(255) NOT NULL DEFAULT 'default.gif',
  `level` int(11) NOT NULL DEFAULT '1',
  `points` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `guilds`
--

INSERT INTO `guilds` (`id`, `name`, `ownerid`, `creationdata`, `motd`, `residence`, `description`, `guild_logo`, `create_ip`, `balance`, `last_execute_points`, `logo_name`, `level`, `points`) VALUES
(2, 'pbOT ReborN', 7, 1641901064, '', 0, 'New guild. Leader must edit this text :)', 0x313634313930313036343b646174613a696d6167652f6769663b6261736536342c52306c474f446c68514142414150634141414141414167414142414141426741414267494143454941436b494144454941446b4941446b514145495141456f514146495141466f5141466f5941474d5941474e6a556d73594147744b4147746a556d746a576d7472576e4d5941484e5341484e72576e4e72593373594148736841487453414874614148747a5933747a6134516841495261414952614349526a4349523761345237633477684149786a434979456334794565355168414a5272434a534d65357770414a7872434a787a434a794d6535794d684a7955684b5570414b567a434b5637434b5755684b57636a4b3070414b3137434b32636a4c5570414c5637434c5745434c576c6c4c57746c4c3078414c3245434c324d434c32316e4d5978414d614d434d6155434d613170633478414d3655434d363972645978414e5935414e6155434e6163434e3435414f2f657876666e7a762f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f79483542414541414645414c414141414142414145414141416a2b414b4e4543514367494d454143424d614e4b6a774945494143523832584168526f734f43416a4e7144494345434a4b50486b4d7943596c6b704567695445717137496753704d6d534b564e2b424e6b785a514162476a554347466d795a63715750556b7947597079364a4f6951486c366a456c7a4a70475141456a677a446c514a644759517a753672506b7861396169566e334b354e6e314b63696f55334d475942717a3645696c4d4a64794e5174544a6b69554872757964456b4567496359564b75614841757a37744359543868364e566f54373958446b4c4d69415a4342525741414d346d7566496c334a52496749427759534a444167516f634d7a305870706c334a6d584c5644482f334e454368496b574c585a6b3172736a41634944466d3672734a424167414146514754694a644969416f4d45437851343244446a4b5a4d416c533854595641516749414443784c2b474341674945414243302b424741415141516752484245576a485a674167675142774149754e39517675427842632b743939414f324d4757303034426e4a424545556b306d4951525267685278417348454151414345793051414242423051414167675062426a41427570565a454551437a375949494d4e42684641424156656c6d45424434366741476b5858464144697755454145514c454946515630307041516c52424431495749515251627777516764516a6c4145677744733846706761303357517848486d61444341777751304a304354437751514163416243415a5351514738494345456c37775541476c4d6141414141636b55634e615638615730674d4a4f464744624a6b5a344141537667584234414836465561454351416b30454f456778365558463432695a4445416739636c78315657524952774b5146624a425a4241596755594143437844775942482b4b775267416c356d4b696745445155416f4943504368786746334d4154426b41536a474343744a7a547651416746764450724157456230426b494f4542546841684a67354a424845726970305a4d4777736e34567741704a4d4c4341545a3865364251414c7851686751456a4b624242437a36715249514b4144516f78486f4353446a6f41756c35564a715653346c57684c4974466175755376516d4b59414451484145774b78443968564145454c514b63514a41594241524849647565646a41685a6b43454151526e53386c4d493639545153615577574641472b4c6d7631314b364b356864416456725a2b3441434f46514a41413146524b41415633327136785954424851675951414f455042415479795a42536b4151675278595770504c53633041437641796c4856536266383030635232316f65616e6c5a39786b4133795a51524137444f70575a714276594b55542b724343666c65354776336f5573616237476f42443132574e31304d5043536278674146306d51567441515759454d41494146545847684e6c5a3751543155516346664544443536416d585650425a3244455865654c4951414d365132457043354267324143707131314c6c416d4b56476b374d4739494379413141443052486c526777365177494b4643464333552f4e414941424b7942634a56746d73657a35556b546c746344304147697137613553427a427474522b6258775141755431515541634d756944415a46687078766e666e6e2f464642494f4641426a414161676752416b4e49494148454149644a7542416774676743496b4a41453779747175647249736c78786d4d766754534a597959784956794b6f41524141425175416e4241433449416c30497739434b4865434771424d4344333458674677344b4e6c59636f3948646c64464862696b5365774a43582b45597459567a62676e32414a5956525453704b454d4559445a786c514e797049414c3161307a4d4d476b676e5a6c6e5453495a56706377416759467a4330434f4c694343437a43675277525267417263746f41494f4941425a45456345725448753851677759655355785549456843426c6a7846616b5777674147494978344437476f466739494c536741514d5a37465a535a303347486b674149457930305264514b676752454b344b69524145423477364b4c42794f47756a6836366f716549354a71356a6944414a53736136344c35534d4c4d49496b464541334c4e6c5a4168696746636241524965396f31705969436739397a776c5830666b79646c6f756138574c4d55434d78795763694a6a52537a31386965646d654d4469476566566a5a6f4c5639425351474d554951446d43416c725153434145716d484c64395249636349556c5a56424b304670514843506a2b61684142756b615763526242415267436b676f59634143364b4b55316b6253682f727a794759486d4b674c42536f493073556d45635a5a724178343067625069346a596677695368636c466b46596b49417535674c5a6c5753596b2f665a4f3537786e76626b785a436a7a74395a4b7274415249426d68426a7867774e73574d4d77674530413842447443567439776c6d7a506c7a503532383858623351636942466a5665416f4349664f6f7a4334586c4d785051496f7059626154595242355147356134494146744c4668367a4f41653743796c634b38425a3559736335536c374b554135545651674567674145535567535552693473512f6f4956307543522b57416a69576f4d6b494f436c436244637a4c41766e71774c6d415971386668724f61666a724b543635694c7a2b2b6255474d564934424c6d444c47627a454b596954584662676d553348644d576a7167332b514c735530456367427141494c68714c5a4f7a326c74346d315732516f577732475743416d49586b63556b514151502b537357694a6957536f5451713934424c555341594d56787a66427262376c6931754a416c4e5343747246587531726152464f424e4c786957644a4b77676752383569324f79654e6a33706e4248536f46767463384446412b64744c79584f78314f78694b38654a344e77344b747236395178316656684936716a48426b4e6f53514e6a736c4a53754f63596b46393569666366576b614e4d6c79316e49347130466d5345463152517158495662336354366a764e37455a794b456e4d6f774a67684353556349337a50416c58636b7866565049756342656379335342306a2b674c74646c2b6c506b56316547344b2b6f3248647553773451453643724b7562596a2b46306d366732544b547039704a37527430746a724d595a674f7a465373363347482b5948736231386a6f5679357370534a6b65676d3641464441417a49496a4833745674546473466b7839514f4c522b66363353315367415133304c4d6b6434766b42644f454a35716c4d354b7a367061455461432b47564843546e436f573077742b596339477a4347645473586d3041414134685774454347554a436c787457796b705a6e46532f59747134555a414b6f7a724f71567932445545355356424b70794c496b45784749474b544459706b6a4243695141524c6f65746572766b477847554942436d416741396a4f64743275732b774b5a44766233566b495169685167512b6b494e4851316f675366434344456e6a6732786e7741416c5177494a363235734645694f33422b68393733716a674154762f72594853694144483651374d45505167517a364c514e30553855484151413443525474677873732f4e3479304d48424e773774496477414d4277507563674c566533774b45426835496f4f434141414f773d3d, 2130706433, 0, 0, '', 1, 0),
(3, 'Teste pra Td', 12, 1664053863, '', 1, 'New guild. Leader must edit this text :)', NULL, 0, 0, 0, 'default.gif', 1, 0);

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
-- Estrutura da tabela `guildwar_kills`
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
-- Estrutura da tabela `guild_actions_h`
--

CREATE TABLE `guild_actions_h` (
  `id` int(6) UNSIGNED NOT NULL,
  `guild_id` int(11) DEFAULT NULL,
  `player_id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  `date` bigint(20) DEFAULT NULL,
  `type` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_invites`
--

CREATE TABLE `guild_invites` (
  `player_id` int(11) NOT NULL DEFAULT '0',
  `guild_id` int(11) NOT NULL DEFAULT '0',
  `date` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_membership`
--

CREATE TABLE `guild_membership` (
  `player_id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL,
  `rank_id` int(11) NOT NULL,
  `nick` varchar(15) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `guild_membership`
--

INSERT INTO `guild_membership` (`player_id`, `guild_id`, `rank_id`, `nick`) VALUES
(7, 2, 4, ''),
(8, 2, 6, ''),
(12, 3, 7, '');

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_ranks`
--

CREATE TABLE `guild_ranks` (
  `id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL COMMENT 'guild',
  `name` varchar(255) NOT NULL COMMENT 'rank name',
  `level` int(11) NOT NULL COMMENT 'rank level - leader, vice, member, maybe something else'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `guild_ranks`
--

INSERT INTO `guild_ranks` (`id`, `guild_id`, `name`, `level`) VALUES
(4, 2, 'The Leader', 3),
(5, 2, 'Vice-Leader', 2),
(6, 2, 'Member', 1),
(7, 3, 'The Leader', 3),
(8, 3, 'Vice-Leader', 2),
(9, 3, 'Member', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_transfer_h`
--

CREATE TABLE `guild_transfer_h` (
  `id` int(6) UNSIGNED NOT NULL,
  `player_id` int(11) NOT NULL,
  `from_guild_id` int(6) NOT NULL,
  `to_guild_id` int(6) NOT NULL,
  `value` int(11) NOT NULL,
  `date` bigint(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_wars`
--

CREATE TABLE `guild_wars` (
  `id` int(11) NOT NULL,
  `guild1` int(11) NOT NULL DEFAULT '0',
  `guild2` int(11) NOT NULL DEFAULT '0',
  `name1` varchar(255) NOT NULL,
  `name2` varchar(255) NOT NULL,
  `status` tinyint(2) NOT NULL DEFAULT '0',
  `started` bigint(15) NOT NULL DEFAULT '0',
  `ended` bigint(15) NOT NULL DEFAULT '0',
  `frags_limit` int(10) DEFAULT '20'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `houses`
--

CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
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
-- Extraindo dados da tabela `houses`
--

INSERT INTO `houses` (`id`, `owner`, `paid`, `warnings`, `name`, `rent`, `town_id`, `bid`, `bid_end`, `last_bid`, `highest_bidder`, `size`, `guildid`, `beds`) VALUES
(1, 0, 0, 0, 'NPC', 0, 3, 0, 0, 0, 0, 143, NULL, 4),
(2, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 80, NULL, 4),
(3, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 84, NULL, 2),
(4, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 2),
(5, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 132, NULL, 2),
(6, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 113, NULL, 2),
(7, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 129, NULL, 2),
(8, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 44, NULL, 2),
(9, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 134, NULL, 2),
(10, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 58, NULL, 2),
(11, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 91, NULL, 2),
(12, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 102, NULL, 4),
(13, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 103, NULL, 4),
(14, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 84, NULL, 2),
(15, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 61, NULL, 2),
(16, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 4),
(17, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 61, NULL, 2),
(18, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 95, NULL, 4),
(19, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, NULL, 2),
(20, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 88, NULL, 2),
(21, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 2),
(22, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 93, NULL, 2),
(23, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 24, NULL, 2),
(24, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 653, NULL, 8),
(25, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 367, NULL, 24),
(26, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 492, NULL, 30),
(27, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, NULL, 4),
(28, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 2),
(29, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 29, NULL, 2),
(30, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 2),
(31, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 71, NULL, 2),
(32, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 2),
(33, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, NULL, 2),
(34, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 62, NULL, 2),
(35, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 105, NULL, 4),
(36, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, NULL, 2),
(37, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 55, NULL, 2),
(38, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 65, NULL, 2),
(39, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 45, NULL, 2),
(40, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, NULL, 2),
(41, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 28, NULL, 2),
(42, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 2),
(43, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 4),
(44, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 20, NULL, 2),
(45, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, NULL, 2),
(46, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 43, NULL, 2),
(47, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, NULL, 2),
(48, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 46, NULL, 2),
(49, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 66, NULL, 2),
(50, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 2),
(51, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 26, NULL, 2),
(52, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 32, NULL, 2),
(53, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 271, NULL, 16),
(54, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 82, NULL, 4),
(55, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 2),
(56, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 98, NULL, 4),
(57, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 50, NULL, 2),
(58, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, NULL, 2),
(59, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 63, NULL, 2),
(60, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 2),
(61, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, NULL, 2),
(62, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 96, NULL, 4),
(63, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 132, NULL, 4),
(64, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 98, NULL, 2),
(65, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, NULL, 2),
(66, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 43, NULL, 2),
(67, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 65, NULL, 2),
(68, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, NULL, 2),
(69, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 80, NULL, 4),
(70, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 64, NULL, 2),
(71, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 54, NULL, 2),
(72, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 93, NULL, 2),
(73, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 80, NULL, 2),
(74, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 81, NULL, 2),
(75, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 54, NULL, 2),
(76, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 2),
(77, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 53, NULL, 2),
(78, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 77, NULL, 2),
(79, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 45, NULL, 2),
(80, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 50, NULL, 2),
(81, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 2),
(82, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 49, NULL, 2),
(83, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 2),
(84, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 2),
(85, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 106, NULL, 4),
(86, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 35, NULL, 2),
(87, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 146, NULL, 4),
(88, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 354, NULL, 6),
(89, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 346, NULL, 20),
(90, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, NULL, 4),
(91, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 108, NULL, 4),
(92, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 120, NULL, 4),
(93, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 124, NULL, 2),
(94, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 65, NULL, 0),
(95, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 198, NULL, 4),
(96, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 133, NULL, 4),
(97, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 183, NULL, 4),
(98, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 192, NULL, 4),
(99, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 147, NULL, 4),
(100, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 65, NULL, 2),
(101, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 81, NULL, 2),
(102, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 63, NULL, 2),
(103, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 32, NULL, 2),
(104, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 2),
(105, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 32, NULL, 2),
(106, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 106, NULL, 2),
(107, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 70, NULL, 2),
(108, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 205, NULL, 2),
(109, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 182, NULL, 4),
(110, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 78, NULL, 2),
(111, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 117, NULL, 2),
(112, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 87, NULL, 2),
(113, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 75, NULL, 2),
(114, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 116, NULL, 2),
(115, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 89, NULL, 2),
(116, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 83, NULL, 4),
(117, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 66, NULL, 2),
(118, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 62, NULL, 2),
(119, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 94, NULL, 4),
(120, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 66, NULL, 2),
(121, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 49, NULL, 2),
(122, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 171, NULL, 4),
(123, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 120, NULL, 2),
(124, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 116, NULL, 2),
(125, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 106, NULL, 6),
(126, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 50, NULL, 2),
(127, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 68, NULL, 2),
(128, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 42, NULL, 2),
(129, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 42, NULL, 2),
(130, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 2),
(131, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 53, NULL, 2),
(132, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 2),
(133, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 52, NULL, 2),
(134, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 173, NULL, 4),
(135, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 72, NULL, 4),
(136, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 140, NULL, 4),
(137, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 111, NULL, 2),
(138, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 118, NULL, 4),
(139, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 43, NULL, 2),
(140, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 35, NULL, 2),
(141, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 345, NULL, 4),
(142, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 113, NULL, 2),
(143, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 179, NULL, 2),
(144, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 42, NULL, 2),
(145, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 96, NULL, 2),
(146, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 339, NULL, 12),
(147, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 681, NULL, 18),
(148, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 192, NULL, 4),
(149, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 128, NULL, 0),
(150, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 133, NULL, 4),
(151, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 128, NULL, 2),
(152, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 100, NULL, 0),
(153, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 358, NULL, 12),
(154, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 91, NULL, 2),
(155, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 132, NULL, 2),
(156, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 147, NULL, 4),
(157, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 182, NULL, 4),
(158, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 225, NULL, 4),
(159, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 215, NULL, 4),
(160, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 614, NULL, 12),
(161, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 172, NULL, 4),
(162, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 165, NULL, 4),
(163, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 198, NULL, 4),
(164, 0, 1644432459, 0, '', 0, 0, 0, 0, 0, 0, 215, NULL, 6),
(165, 0, 1644432459, 0, 'Kypros Left 26', 0, 8, 0, 0, 0, 0, 223, NULL, 0),
(166, 0, 1644432459, 0, 'Kypros Left 27', 0, 8, 0, 0, 0, 0, 45, NULL, 0),
(167, 0, 1644432459, 0, 'Kypros Left 28', 0, 8, 0, 0, 0, 0, 49, NULL, 0),
(168, 0, 1644432459, 0, 'Kypros Left 29', 0, 8, 0, 0, 0, 0, 567, NULL, 0),
(169, 0, 0, 0, 'Pancada 41', 0, 1, 0, 0, 0, 0, 127, NULL, 0),
(170, 0, 0, 0, 'Orn 01', 0, 4, 0, 0, 0, 0, 49, NULL, 0),
(171, 0, 0, 0, 'Orn 02', 0, 4, 0, 0, 0, 0, 165, NULL, 0),
(172, 0, 0, 0, 'Orn 03', 0, 4, 0, 0, 0, 0, 149, NULL, 0),
(173, 0, 0, 0, 'Orn 04', 0, 4, 0, 0, 0, 0, 255, NULL, 0),
(174, 0, 0, 0, 'Orn 05', 0, 4, 0, 0, 0, 0, 96, NULL, 0),
(175, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 94, NULL, 2),
(176, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 214, NULL, 4),
(177, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 137, NULL, 4),
(178, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 193, NULL, 4),
(179, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 257, NULL, 4),
(180, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 168, NULL, 2),
(181, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 298, NULL, 4),
(182, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 291, NULL, 8),
(183, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 237, NULL, 6),
(184, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 209, NULL, 8),
(185, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 756, NULL, 12),
(186, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 412, NULL, 6),
(187, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 454, NULL, 8),
(188, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 251, NULL, 4),
(189, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 495, NULL, 8),
(190, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 227, NULL, 4),
(191, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 170, NULL, 4),
(192, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 110, NULL, 4),
(193, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 174, NULL, 4),
(194, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 49, NULL, 2),
(195, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 64, NULL, 2),
(196, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 2),
(197, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 247, NULL, 4),
(198, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 130, NULL, 4),
(199, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 143, NULL, 2),
(200, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 128, NULL, 2),
(201, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 302, NULL, 4),
(202, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, NULL, 4),
(203, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 110, NULL, 4),
(204, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 84, NULL, 0),
(205, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 420, NULL, 8),
(206, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 357, NULL, 6),
(207, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 2),
(208, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 160, NULL, 2),
(209, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 104, NULL, 2),
(210, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 225, NULL, 4),
(211, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 170, NULL, 4),
(212, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 81, NULL, 4),
(213, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 128, NULL, 8),
(214, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 128, NULL, 4),
(215, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 140, NULL, 2),
(216, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 162, NULL, 6),
(217, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 72, NULL, 4),
(218, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 81, NULL, 4),
(219, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, NULL, 2),
(220, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 177, NULL, 4),
(221, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 84, NULL, 2),
(222, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 84, NULL, 2),
(223, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, NULL, 2),
(224, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, NULL, 2),
(225, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, NULL, 2),
(226, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 2),
(227, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 2),
(228, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 55, NULL, 2),
(229, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 80, NULL, 2),
(230, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 2),
(231, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 80, NULL, 2),
(232, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, NULL, 2),
(233, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, NULL, 4),
(234, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 105, NULL, 4),
(235, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 113, NULL, 4),
(236, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 49, NULL, 4),
(237, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 4),
(238, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 64, NULL, 4),
(239, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 142, NULL, 6),
(240, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 142, NULL, 6),
(241, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 264, NULL, 12),
(242, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 4),
(243, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 4),
(244, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 6),
(245, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 98, NULL, 6),
(246, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 98, NULL, 6),
(247, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, NULL, 6),
(248, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 128, NULL, 4),
(249, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, NULL, 4),
(250, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, NULL, 4),
(251, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 42, NULL, 4),
(252, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 42, NULL, 4),
(253, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 553, NULL, 18),
(254, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 553, NULL, 16),
(255, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 432, NULL, 36),
(256, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 723, NULL, 42),
(257, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, NULL, 6),
(258, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 64, NULL, 4),
(259, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 4),
(260, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 64, NULL, 4),
(261, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 61, NULL, 4),
(263, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 191, NULL, 0),
(264, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 122, NULL, 0),
(265, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 231, NULL, 0),
(266, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 98, NULL, 2),
(267, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, NULL, 2),
(268, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 146, NULL, 2),
(269, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 153, NULL, 2),
(270, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, NULL, 4),
(271, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 64, NULL, 2),
(272, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 104, NULL, 8),
(273, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 453, NULL, 10),
(274, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 169, NULL, 2),
(275, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 98, NULL, 2),
(276, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 4),
(277, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 4),
(278, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 4),
(279, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 4),
(280, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 4),
(281, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 4),
(282, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 64, NULL, 4),
(283, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 64, NULL, 4),
(284, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 18, NULL, 0),
(285, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 20, NULL, 0),
(286, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 2),
(287, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 25, NULL, 2),
(288, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 25, NULL, 2),
(289, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 2),
(290, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 69, NULL, 2),
(291, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 2),
(292, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, NULL, 2),
(293, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, NULL, 2),
(294, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, NULL, 2),
(295, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, NULL, 2),
(296, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, NULL, 0),
(297, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 20, NULL, 0),
(298, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, NULL, 0),
(299, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, NULL, 0),
(300, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, NULL, 0),
(301, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 0),
(302, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 45, NULL, 0),
(303, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 84, NULL, 2),
(304, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, NULL, 0),
(305, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 2),
(306, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 81, NULL, 2),
(307, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 25, NULL, 0),
(308, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 78, NULL, 2),
(309, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 25, NULL, 0),
(310, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 0),
(311, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 2),
(312, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 35, NULL, 2),
(313, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 42, NULL, 2),
(314, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 20, NULL, 2),
(315, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 20, NULL, 2),
(316, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, NULL, 2),
(317, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 44, NULL, 4),
(318, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 25, NULL, 2),
(319, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 45, NULL, 2),
(320, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 66, NULL, 2),
(321, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 2),
(322, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 128, NULL, 2),
(323, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 2),
(324, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, NULL, 2),
(325, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, NULL, 2),
(326, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 63, NULL, 0),
(327, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 0),
(328, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 57, NULL, 0),
(329, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 150, NULL, 2),
(330, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, NULL, 2),
(331, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 0),
(332, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 55, NULL, 4),
(333, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 2),
(334, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 25, NULL, 2),
(335, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 25, NULL, 2),
(336, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, NULL, 4),
(337, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, NULL, 0),
(338, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 96, NULL, 0),
(339, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, NULL, 2),
(340, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, NULL, 2),
(341, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 72, NULL, 2),
(342, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 33, NULL, 2),
(343, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 33, NULL, 2),
(344, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 52, NULL, 2),
(345, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 2),
(346, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 2),
(347, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 53, NULL, 2),
(348, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 0),
(349, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, NULL, 0),
(350, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, NULL, 2),
(351, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 42, NULL, 2),
(352, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, NULL, 2),
(353, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 87, NULL, 2),
(354, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 167, NULL, 2),
(355, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 34, NULL, 2),
(356, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 238, NULL, 6),
(465, 0, 1644432459, 0, 'Egeu 85', 0, 2, 0, 0, 0, 0, 23, NULL, 0),
(466, 0, 1644432459, 0, 'Egeu 86', 0, 2, 0, 0, 0, 0, 23, NULL, 0),
(467, 0, 1644432459, 0, 'Unnamed House #467', 0, 7, 0, 0, 0, 0, 108, NULL, 0),
(468, 0, 1644432459, 0, 'Unnamed House #468', 0, 7, 0, 0, 0, 0, 144, NULL, 0),
(469, 0, 1644432459, 0, 'Unnamed House #469', 0, 7, 0, 0, 0, 0, 66, NULL, 0),
(470, 0, 1644432459, 0, 'Unnamed House #470', 0, 7, 0, 0, 0, 0, 127, NULL, 0),
(472, 0, 1644432459, 0, 'Unnamed House #472', 0, 7, 0, 0, 0, 0, 97, NULL, 0),
(473, 0, 1644432459, 0, 'Unnamed House #473', 0, 7, 0, 0, 0, 0, 110, NULL, 0),
(474, 0, 1644432459, 0, 'Unnamed House #474', 0, 7, 0, 0, 0, 0, 122, NULL, 0),
(476, 0, 1644432459, 0, 'Unnamed House #476', 0, 7, 0, 0, 0, 0, 52, NULL, 0),
(477, 0, 1644432459, 0, 'Unnamed House #477', 0, 7, 0, 0, 0, 0, 176, NULL, 0),
(478, 0, 1644432459, 0, 'Unnamed House #478', 0, 7, 0, 0, 0, 0, 78, NULL, 0),
(479, 0, 1644432459, 0, 'Unnamed House #479', 0, 7, 0, 0, 0, 0, 126, NULL, 0),
(480, 0, 1644432459, 0, 'Unnamed House #480', 0, 7, 0, 0, 0, 0, 108, NULL, 0),
(481, 0, 1644432459, 0, 'Unnamed House #481', 0, 7, 0, 0, 0, 0, 39, NULL, 0),
(482, 0, 1644432459, 0, 'Unnamed House #482', 0, 7, 0, 0, 0, 0, 50, NULL, 0),
(483, 0, 1644432459, 0, 'Unnamed House #483', 0, 7, 0, 0, 0, 0, 42, NULL, 0),
(484, 0, 1644432459, 0, 'Unnamed House #484', 0, 7, 0, 0, 0, 0, 14, NULL, 0),
(485, 0, 1644432459, 0, 'Unnamed House #485', 0, 7, 0, 0, 0, 0, 72, NULL, 0),
(486, 0, 1644432459, 0, 'Unnamed House #486', 0, 7, 0, 0, 0, 0, 371, NULL, 0),
(487, 0, 1644432459, 0, 'Unnamed House #487', 0, 7, 0, 0, 0, 0, 169, NULL, 0),
(488, 0, 1644432459, 0, 'Unnamed House #488', 0, 7, 0, 0, 0, 0, 252, NULL, 0),
(489, 0, 1644432459, 0, 'Unnamed House #489', 0, 7, 0, 0, 0, 0, 138, NULL, 0),
(490, 0, 1644432459, 0, 'Unnamed House #490', 0, 7, 0, 0, 0, 0, 263, NULL, 0),
(491, 0, 1644432459, 0, 'Unnamed House #491', 0, 7, 0, 0, 0, 0, 127, NULL, 0),
(492, 0, 1644432459, 0, 'Unnamed House #492', 0, 7, 0, 0, 0, 0, 161, NULL, 0),
(493, 0, 1644432459, 0, 'Unnamed House #493', 0, 7, 0, 0, 0, 0, 388, NULL, 0),
(494, 0, 1644432459, 0, 'Unnamed House #494', 0, 7, 0, 0, 0, 0, 153, NULL, 0),
(495, 0, 1644432459, 0, 'Unnamed House #495', 0, 7, 0, 0, 0, 0, 72, NULL, 0),
(496, 0, 1644432459, 0, 'Unnamed House #496', 0, 7, 0, 0, 0, 0, 60, NULL, 0),
(497, 0, 1644432459, 0, 'Unnamed House #497', 0, 7, 0, 0, 0, 0, 42, NULL, 0),
(498, 0, 1644432459, 0, 'Unnamed House #498', 0, 7, 0, 0, 0, 0, 215, NULL, 0),
(499, 0, 1644432459, 0, 'Unnamed House #499', 0, 7, 0, 0, 0, 0, 62, NULL, 0),
(500, 0, 1644432459, 0, 'Unnamed House #500', 0, 7, 0, 0, 0, 0, 88, NULL, 0),
(501, 0, 1644432459, 0, 'Unnamed House #501', 0, 7, 0, 0, 0, 0, 45, NULL, 0),
(502, 0, 1644432459, 0, 'Unnamed House #502', 0, 7, 0, 0, 0, 0, 125, NULL, 0),
(503, 0, 1644432459, 0, 'Unnamed House #503', 0, 7, 0, 0, 0, 0, 14, NULL, 0),
(504, 0, 1644432459, 0, 'Unnamed House #504', 0, 7, 0, 0, 0, 0, 31, NULL, 0),
(505, 0, 1644432459, 0, 'Unnamed House #505', 0, 7, 0, 0, 0, 0, 57, NULL, 0),
(506, 0, 1644432459, 0, 'Unnamed House #506', 0, 7, 0, 0, 0, 0, 83, NULL, 0),
(507, 0, 1644432459, 0, 'Unnamed House #507', 0, 7, 0, 0, 0, 0, 49, NULL, 0),
(508, 0, 1644432459, 0, 'Unnamed House #508', 0, 7, 0, 0, 0, 0, 70, NULL, 0),
(509, 0, 1644432459, 0, 'Unnamed House #509', 0, 7, 0, 0, 0, 0, 41, NULL, 0),
(510, 0, 1644432459, 0, 'Unnamed House #510', 0, 5, 0, 0, 0, 0, 95, NULL, 0),
(511, 0, 1644432459, 0, 'Unnamed House #511', 0, 5, 0, 0, 0, 0, 55, NULL, 0),
(512, 0, 1644432459, 0, 'Unnamed House #512', 0, 5, 0, 0, 0, 0, 77, NULL, 0),
(513, 0, 1644432459, 0, 'Unnamed House #513', 0, 5, 0, 0, 0, 0, 51, NULL, 0),
(514, 0, 1644432459, 0, 'Unnamed House #514', 0, 5, 0, 0, 0, 0, 80, NULL, 0),
(515, 0, 1644432459, 0, 'Unnamed House #515', 0, 5, 0, 0, 0, 0, 210, NULL, 0),
(516, 0, 1644432459, 0, 'Unnamed House #516', 0, 5, 0, 0, 0, 0, 280, NULL, 0),
(517, 0, 1644432459, 0, 'Unnamed House #517', 0, 5, 0, 0, 0, 0, 85, NULL, 0),
(518, 0, 1644432459, 0, 'Unnamed House #518', 0, 5, 0, 0, 0, 0, 105, NULL, 0),
(519, 0, 1644432459, 0, 'Unnamed House #519', 0, 5, 0, 0, 0, 0, 74, NULL, 0),
(520, 0, 1644432459, 0, 'Unnamed House #520', 0, 5, 0, 0, 0, 0, 74, NULL, 0),
(521, 0, 1644432459, 0, 'Unnamed House #521', 0, 5, 0, 0, 0, 0, 56, NULL, 0),
(522, 0, 1644432459, 0, 'Unnamed House #522', 0, 5, 0, 0, 0, 0, 176, NULL, 0),
(523, 0, 1644432459, 0, 'Unnamed House #523', 0, 5, 0, 0, 0, 0, 108, NULL, 0),
(524, 0, 1644432459, 0, 'Unnamed House #524', 0, 5, 0, 0, 0, 0, 55, NULL, 0),
(525, 0, 1644432459, 0, 'Unnamed House #525', 0, 5, 0, 0, 0, 0, 228, NULL, 0),
(526, 0, 1644432459, 0, 'Unnamed House #526', 0, 5, 0, 0, 0, 0, 52, NULL, 0),
(527, 0, 1644432459, 0, 'Unnamed House #527', 0, 5, 0, 0, 0, 0, 40, NULL, 0),
(528, 0, 1644432459, 0, 'Unnamed House #528', 0, 5, 0, 0, 0, 0, 90, NULL, 0),
(529, 0, 1644432459, 0, 'Unnamed House #529', 0, 5, 0, 0, 0, 0, 86, NULL, 0),
(530, 0, 1644432459, 0, 'Unnamed House #530', 0, 5, 0, 0, 0, 0, 39, NULL, 0),
(531, 0, 1644432459, 0, 'Unnamed House #531', 0, 5, 0, 0, 0, 0, 100, NULL, 0),
(532, 0, 1644432459, 0, 'Unnamed House #532', 0, 5, 0, 0, 0, 0, 78, NULL, 0),
(533, 0, 1644432459, 0, 'Unnamed House #533', 0, 5, 0, 0, 0, 0, 47, NULL, 0),
(534, 0, 1644432459, 0, 'Unnamed House #534', 0, 5, 0, 0, 0, 0, 40, NULL, 0),
(535, 0, 1644432459, 0, 'Unnamed House #535', 0, 5, 0, 0, 0, 0, 98, NULL, 0),
(536, 0, 1644432459, 0, 'Unnamed House #536', 0, 5, 0, 0, 0, 0, 45, NULL, 0),
(537, 0, 1644432459, 0, 'Unnamed House #537', 0, 5, 0, 0, 0, 0, 58, NULL, 0),
(538, 0, 1644432459, 0, 'Unnamed House #538', 0, 5, 0, 0, 0, 0, 65, NULL, 0),
(539, 0, 1644432459, 0, 'Unnamed House #539', 0, 5, 0, 0, 0, 0, 31, NULL, 0),
(540, 0, 1644432459, 0, 'Unnamed House #540', 0, 5, 0, 0, 0, 0, 138, NULL, 0),
(541, 0, 1644432459, 0, 'Unnamed House #541', 0, 5, 0, 0, 0, 0, 47, NULL, 0),
(542, 0, 1644432459, 0, 'Unnamed House #542', 0, 5, 0, 0, 0, 0, 51, NULL, 0),
(543, 0, 1644432459, 0, 'Unnamed House #543', 0, 5, 0, 0, 0, 0, 87, NULL, 0),
(544, 0, 1644432459, 0, 'Unnamed House #544', 0, 5, 0, 0, 0, 0, 49, NULL, 0),
(545, 0, 1644432459, 0, 'Unnamed House #545', 0, 5, 0, 0, 0, 0, 95, NULL, 0),
(546, 0, 1644432459, 0, 'Unnamed House #546', 0, 5, 0, 0, 0, 0, 127, NULL, 0),
(547, 0, 1644432459, 0, 'Unnamed House #547', 0, 5, 0, 0, 0, 0, 81, NULL, 0),
(548, 0, 1644432459, 0, 'Unnamed House #548', 0, 5, 0, 0, 0, 0, 51, NULL, 0),
(549, 0, 1644432459, 0, 'Unnamed House #549', 0, 5, 0, 0, 0, 0, 80, NULL, 0),
(550, 0, 1644432459, 0, 'Unnamed House #550', 0, 5, 0, 0, 0, 0, 80, NULL, 0),
(551, 0, 1644432459, 0, 'Unnamed House #551', 0, 5, 0, 0, 0, 0, 91, NULL, 0),
(552, 0, 1644432459, 0, 'Unnamed House #552', 0, 5, 0, 0, 0, 0, 77, NULL, 0),
(553, 0, 1644432459, 0, 'Unnamed House #553', 0, 5, 0, 0, 0, 0, 66, NULL, 0),
(554, 0, 1644432459, 0, 'Unnamed House #554', 0, 5, 0, 0, 0, 0, 46, NULL, 0),
(555, 0, 1644432459, 0, 'Unnamed House #555', 0, 5, 0, 0, 0, 0, 67, NULL, 0),
(556, 0, 1644432459, 0, 'Unnamed House #556', 0, 5, 0, 0, 0, 0, 152, NULL, 0),
(557, 0, 1644432459, 0, 'Unnamed House #557', 0, 5, 0, 0, 0, 0, 60, NULL, 0),
(558, 0, 1644432459, 0, 'Unnamed House #558', 0, 5, 0, 0, 0, 0, 73, NULL, 0),
(559, 0, 1644432459, 0, 'Unnamed House #559', 0, 5, 0, 0, 0, 0, 64, NULL, 2),
(560, 0, 1644432459, 0, 'Unnamed House #560', 0, 5, 0, 0, 0, 0, 139, NULL, 0),
(561, 0, 1644432459, 0, 'Unnamed House #561', 0, 5, 0, 0, 0, 0, 209, NULL, 0),
(562, 0, 1644432459, 0, 'Unnamed House #562', 0, 5, 0, 0, 0, 0, 39, NULL, 0),
(563, 0, 1644432459, 0, 'Unnamed House #563', 0, 5, 0, 0, 0, 0, 51, NULL, 0),
(564, 0, 1644432459, 0, 'Unnamed House #564', 0, 5, 0, 0, 0, 0, 44, NULL, 0),
(565, 0, 1644432459, 0, 'Unnamed House #565', 0, 5, 0, 0, 0, 0, 42, NULL, 0),
(566, 0, 1644432459, 0, 'Unnamed House #566', 0, 5, 0, 0, 0, 0, 48, NULL, 0),
(567, 0, 1644432459, 0, 'Unnamed House #567', 0, 5, 0, 0, 0, 0, 48, NULL, 0),
(568, 0, 1644432459, 0, 'Unnamed House #568', 0, 5, 0, 0, 0, 0, 91, NULL, 0),
(569, 0, 1644432459, 0, 'Unnamed House #569', 0, 5, 0, 0, 0, 0, 75, NULL, 0),
(570, 0, 1644432459, 0, 'Unnamed House #570', 0, 5, 0, 0, 0, 0, 52, NULL, 0),
(571, 0, 1644432459, 0, 'Unnamed House #571', 0, 5, 0, 0, 0, 0, 62, NULL, 0),
(572, 0, 1644432459, 0, 'Unnamed House #572', 0, 5, 0, 0, 0, 0, 75, NULL, 0),
(573, 0, 1644432459, 0, 'Unnamed House #573', 0, 5, 0, 0, 0, 0, 94, NULL, 0),
(574, 0, 1644432459, 0, 'Unnamed House #574', 0, 5, 0, 0, 0, 0, 185, NULL, 0),
(575, 0, 1644432459, 0, 'Unnamed House #575', 0, 5, 0, 0, 0, 0, 57, NULL, 0),
(576, 0, 1644432459, 0, 'Unnamed House #576', 0, 5, 0, 0, 0, 0, 93, NULL, 0),
(577, 0, 1644432459, 0, 'Unnamed House #577', 0, 5, 0, 0, 0, 0, 41, NULL, 0),
(578, 0, 1644432459, 0, 'Unnamed House #578', 0, 5, 0, 0, 0, 0, 74, NULL, 0),
(579, 0, 1644432459, 0, 'Unnamed House #579', 0, 5, 0, 0, 0, 0, 89, NULL, 0),
(580, 0, 1644432459, 0, 'Unnamed House #580', 0, 5, 0, 0, 0, 0, 43, NULL, 0),
(581, 0, 1644432459, 0, 'Unnamed House #581', 0, 5, 0, 0, 0, 0, 108, NULL, 0),
(582, 0, 1644432459, 0, 'Unnamed House #582', 0, 5, 0, 0, 0, 0, 59, NULL, 0),
(583, 0, 1644432459, 0, 'Unnamed House #583', 0, 5, 0, 0, 0, 0, 98, NULL, 0),
(584, 0, 1644432459, 0, 'Unnamed House #584', 0, 5, 0, 0, 0, 0, 158, NULL, 0),
(585, 0, 1644432459, 0, 'Unnamed House #585', 0, 5, 0, 0, 0, 0, 60, NULL, 0),
(586, 0, 1644432459, 0, 'Unnamed House #586', 0, 5, 0, 0, 0, 0, 111, NULL, 0),
(587, 0, 1644432459, 0, 'Unnamed House #587', 0, 5, 0, 0, 0, 0, 48, NULL, 0),
(588, 0, 1644432459, 0, 'Unnamed House #588', 0, 5, 0, 0, 0, 0, 40, NULL, 2),
(589, 0, 1644432459, 0, 'Unnamed House #589', 0, 5, 0, 0, 0, 0, 80, NULL, 0),
(590, 0, 1644432459, 0, 'Unnamed House #590', 0, 5, 0, 0, 0, 0, 48, NULL, 0),
(591, 0, 1644432459, 0, 'Unnamed House #591', 0, 5, 0, 0, 0, 0, 65, NULL, 0),
(592, 0, 1644432459, 0, 'Unnamed House #592', 0, 5, 0, 0, 0, 0, 25, NULL, 0),
(593, 0, 1644432459, 0, 'Unnamed House #593', 0, 6, 0, 0, 0, 0, 75, NULL, 0),
(594, 0, 1644432459, 0, 'Unnamed House #594', 0, 6, 0, 0, 0, 0, 69, NULL, 0),
(595, 0, 1644432459, 0, 'Unnamed House #595', 0, 6, 0, 0, 0, 0, 70, NULL, 0),
(596, 0, 1644432459, 0, 'Unnamed House #596', 0, 6, 0, 0, 0, 0, 82, NULL, 0),
(597, 0, 1644432459, 0, 'Unnamed House #597', 0, 6, 0, 0, 0, 0, 78, NULL, 0),
(598, 0, 1644432459, 0, 'Unnamed House #598', 0, 6, 0, 0, 0, 0, 91, NULL, 0),
(599, 0, 1644432459, 0, 'Unnamed House #599', 0, 6, 0, 0, 0, 0, 85, NULL, 0),
(600, 0, 1644432459, 0, 'Unnamed House #600', 0, 6, 0, 0, 0, 0, 293, NULL, 0),
(601, 0, 1644432459, 0, 'Unnamed House #601', 0, 6, 0, 0, 0, 0, 99, NULL, 0),
(602, 0, 1644432459, 0, 'Unnamed House #602', 0, 6, 0, 0, 0, 0, 131, NULL, 0),
(603, 0, 1644432459, 0, 'Unnamed House #603', 0, 6, 0, 0, 0, 0, 89, NULL, 0),
(604, 0, 1644432459, 0, 'Unnamed House #604', 0, 6, 0, 0, 0, 0, 212, NULL, 0),
(605, 0, 1644432459, 0, 'Unnamed House #605', 0, 6, 0, 0, 0, 0, 204, NULL, 0),
(606, 0, 1644432459, 0, 'Unnamed House #606', 0, 6, 0, 0, 0, 0, 104, NULL, 0),
(607, 0, 1644432459, 0, 'Unnamed House #607', 0, 6, 0, 0, 0, 0, 69, NULL, 0),
(608, 0, 1644432459, 0, 'Unnamed House #608', 0, 6, 0, 0, 0, 0, 70, NULL, 0),
(609, 0, 1644432459, 0, 'Unnamed House #609', 0, 6, 0, 0, 0, 0, 96, NULL, 0),
(610, 0, 1644432459, 0, 'Unnamed House #610', 0, 6, 0, 0, 0, 0, 73, NULL, 0),
(611, 0, 1644432459, 0, 'Unnamed House #611', 0, 6, 0, 0, 0, 0, 62, NULL, 0),
(612, 0, 1644432459, 0, 'Unnamed House #612', 0, 6, 0, 0, 0, 0, 70, NULL, 0),
(613, 0, 1644432459, 0, 'Unnamed House #613', 0, 6, 0, 0, 0, 0, 79, NULL, 0),
(614, 0, 1644432459, 0, 'Unnamed House #614', 0, 6, 0, 0, 0, 0, 112, NULL, 0),
(615, 0, 1644432459, 0, 'Unnamed House #615', 0, 6, 0, 0, 0, 0, 58, NULL, 0),
(616, 0, 1644432459, 0, 'Unnamed House #616', 0, 6, 0, 0, 0, 0, 40, NULL, 0),
(617, 0, 1644432459, 0, 'Unnamed House #617', 0, 6, 0, 0, 0, 0, 87, NULL, 0),
(618, 0, 1644432459, 0, 'Unnamed House #618', 0, 6, 0, 0, 0, 0, 65, NULL, 0),
(619, 0, 1644432459, 0, 'Unnamed House #619', 0, 6, 0, 0, 0, 0, 21, NULL, 0),
(620, 0, 1644432459, 0, 'Unnamed House #620', 0, 6, 0, 0, 0, 0, 56, NULL, 0),
(621, 0, 1644432459, 0, 'Unnamed House #621', 0, 6, 0, 0, 0, 0, 127, NULL, 0),
(622, 0, 1644432459, 0, 'Unnamed House #622', 0, 6, 0, 0, 0, 0, 57, NULL, 0),
(623, 0, 1644432459, 0, 'Unnamed House #623', 0, 6, 0, 0, 0, 0, 42, NULL, 0),
(624, 0, 1644432459, 0, 'Unnamed House #624', 0, 6, 0, 0, 0, 0, 92, NULL, 0),
(625, 0, 1644432459, 0, 'Unnamed House #625', 0, 6, 0, 0, 0, 0, 113, NULL, 0),
(626, 0, 1644432459, 0, 'Unnamed House #626', 0, 6, 0, 0, 0, 0, 117, NULL, 0),
(627, 0, 1644432459, 0, 'Unnamed House #627', 0, 6, 0, 0, 0, 0, 183, NULL, 0),
(628, 0, 1644432459, 0, 'Unnamed House #628', 0, 6, 0, 0, 0, 0, 186, NULL, 0),
(629, 0, 1644432459, 0, 'Unnamed House #629', 0, 6, 0, 0, 0, 0, 89, NULL, 0),
(630, 0, 1644432459, 0, 'Unnamed House #630', 0, 6, 0, 0, 0, 0, 61, NULL, 0),
(631, 0, 1644432459, 0, 'Unnamed House #631', 0, 6, 0, 0, 0, 0, 63, NULL, 0),
(632, 0, 1644432459, 0, 'Unnamed House #632', 0, 6, 0, 0, 0, 0, 103, NULL, 0),
(633, 0, 1644432459, 0, 'Unnamed House #633', 0, 6, 0, 0, 0, 0, 78, NULL, 0),
(634, 0, 1644432459, 0, 'Unnamed House #634', 0, 6, 0, 0, 0, 0, 77, NULL, 0),
(635, 0, 1644432459, 0, 'Unnamed House #635', 0, 6, 0, 0, 0, 0, 132, NULL, 0),
(636, 0, 1644432459, 0, 'Unnamed House #636', 0, 6, 0, 0, 0, 0, 78, NULL, 0),
(637, 0, 1644432459, 0, 'Unnamed House #637', 0, 6, 0, 0, 0, 0, 83, NULL, 0),
(638, 0, 1644432459, 0, 'Unnamed House #638', 0, 6, 0, 0, 0, 0, 98, NULL, 0),
(639, 0, 1644432459, 0, 'Unnamed House #639', 0, 6, 0, 0, 0, 0, 48, NULL, 0),
(640, 0, 1644432459, 0, 'Unnamed House #640', 0, 6, 0, 0, 0, 0, 42, NULL, 0),
(641, 0, 1644432459, 0, 'Unnamed House #641', 0, 6, 0, 0, 0, 0, 35, NULL, 0),
(642, 0, 1644432459, 0, 'Unnamed House #642', 0, 6, 0, 0, 0, 0, 50, NULL, 0),
(643, 0, 1644432459, 0, 'Unnamed House #643', 0, 6, 0, 0, 0, 0, 42, NULL, 0),
(644, 0, 1644432459, 0, 'Unnamed House #644', 0, 6, 0, 0, 0, 0, 103, NULL, 0),
(645, 0, 1644432459, 0, 'Unnamed House #645', 0, 6, 0, 0, 0, 0, 36, NULL, 0),
(646, 0, 1644432459, 0, 'Unnamed House #646', 0, 6, 0, 0, 0, 0, 105, NULL, 0),
(647, 0, 1644432459, 0, 'Unnamed House #647', 0, 6, 0, 0, 0, 0, 59, NULL, 0),
(648, 0, 1644432459, 0, 'Unnamed House #648', 0, 6, 0, 0, 0, 0, 61, NULL, 0),
(649, 0, 1644432459, 0, 'Unnamed House #649', 0, 6, 0, 0, 0, 0, 51, NULL, 0),
(650, 0, 1644432459, 0, 'Unnamed House #650', 0, 6, 0, 0, 0, 0, 69, NULL, 0),
(651, 0, 1644432459, 0, 'Unnamed House #651', 0, 6, 0, 0, 0, 0, 26, NULL, 0),
(652, 0, 1644432459, 0, 'Unnamed House #652', 0, 6, 0, 0, 0, 0, 25, NULL, 0),
(653, 0, 1644432459, 0, 'Unnamed House #653', 0, 6, 0, 0, 0, 0, 140, NULL, 0),
(655, 0, 1644432459, 0, 'Unnamed House #655', 0, 6, 0, 0, 0, 0, 90, NULL, 0),
(656, 0, 1644432459, 0, 'Unnamed House #656', 0, 6, 0, 0, 0, 0, 72, NULL, 0),
(657, 0, 1644432459, 0, 'Unnamed House #657', 0, 6, 0, 0, 0, 0, 75, NULL, 0),
(658, 0, 1644432459, 0, 'Unnamed House #658', 0, 6, 0, 0, 0, 0, 38, NULL, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `house_lists`
--

CREATE TABLE `house_lists` (
  `house_id` int(11) NOT NULL,
  `listid` int(11) NOT NULL,
  `list` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ip_bans`
--

CREATE TABLE `ip_bans` (
  `ip` int(10) UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `links`
--

CREATE TABLE `links` (
  `account_id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `code_date` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `live_casts`
--

CREATE TABLE `live_casts` (
  `player_id` int(11) NOT NULL,
  `cast_name` varchar(255) NOT NULL,
  `password` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(255) DEFAULT NULL,
  `spectators` smallint(5) DEFAULT '0',
  `version` int(10) DEFAULT '1220'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `market_history`
--

CREATE TABLE `market_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `player_id` int(11) NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT '0',
  `itemtype` int(10) UNSIGNED NOT NULL,
  `amount` smallint(5) UNSIGNED NOT NULL,
  `price` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `expires_at` bigint(20) UNSIGNED NOT NULL,
  `inserted` bigint(20) UNSIGNED NOT NULL,
  `state` tinyint(1) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `market_history`
--

INSERT INTO `market_history` (`id`, `player_id`, `sale`, `itemtype`, `amount`, `price`, `expires_at`, `inserted`, `state`) VALUES
(1, 12, 0, 22118, 25, 11, 1663091558, 1663091558, 255),
(2, 7, 1, 22118, 25, 11, 1663091558, 1663091558, 3),
(3, 12, 0, 22118, 25, 11, 1663091565, 1663091565, 255),
(4, 7, 1, 22118, 25, 11, 1663091565, 1663091565, 3),
(5, 12, 0, 22118, 10450, 11, 1663091586, 1663091586, 255),
(6, 7, 1, 22118, 10450, 11, 1663091586, 1663091586, 3),
(7, 7, 1, 22118, 250, 33, 1663091669, 1663091669, 255),
(8, 12, 0, 22118, 250, 33, 1663091669, 1663091669, 3),
(9, 7, 0, 22118, 500, 500, 1663091695, 1663091695, 255),
(10, 12, 1, 22118, 500, 500, 1663091695, 1663091695, 3);

-- --------------------------------------------------------

--
-- Estrutura da tabela `market_offers`
--

CREATE TABLE `market_offers` (
  `id` int(10) UNSIGNED NOT NULL,
  `player_id` int(11) NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT '0',
  `itemtype` int(10) UNSIGNED NOT NULL,
  `amount` smallint(5) UNSIGNED NOT NULL,
  `created` bigint(20) UNSIGNED NOT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `price` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_account_actions`
--

CREATE TABLE `myaac_account_actions` (
  `account_id` int(11) NOT NULL,
  `ip` varchar(16) NOT NULL DEFAULT '0.0.0.0',
  `ipv6` binary(16) NOT NULL DEFAULT '0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `date` int(11) NOT NULL DEFAULT '0',
  `action` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `myaac_account_actions`
--

INSERT INTO `myaac_account_actions` (`account_id`, `ip`, `ipv6`, `date`, `action`) VALUES
(2, '2130706433', 0x00000000000000000000000000000000, 1662576813, 'Account created.'),
(3, '2130706433', 0x00000000000000000000000000000000, 1662578634, 'Account created.'),
(3, '2130706433', 0x00000000000000000000000000000000, 1662578634, 'Created character <b>Char Bazar</b>.'),
(3, '3232247553', 0x00000000000000000000000000000000, 1662945745, 'Account created.'),
(3, '3232247553', 0x00000000000000000000000000000000, 1662946003, 'Created character <b>Teste Doms</b>.'),
(3, '3232247553', 0x00000000000000000000000000000000, 1663084299, 'Created character <b>Test Itnss</b>.'),
(3, '3232247553', 0x00000000000000000000000000000000, 1663084351, 'Created character <b>Teste Ms Itns</b>.'),
(3, '3232247553', 0x00000000000000000000000000000000, 1663084382, 'Created character <b>Teste Rp Itenss</b>.'),
(3, '3232247553', 0x00000000000000000000000000000000, 1663084425, 'Created character <b>Teste Kina Itsns</b>.'),
(3, '3232247553', 0x00000000000000000000000000000000, 1663084684, 'Generated recovery key.');

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_admin_menu`
--

CREATE TABLE `myaac_admin_menu` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `page` varchar(255) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `flags` int(11) NOT NULL DEFAULT '0',
  `enabled` int(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `myaac_admin_menu`
--

INSERT INTO `myaac_admin_menu` (`id`, `name`, `page`, `ordering`, `flags`, `enabled`) VALUES
(1, 'Gifts', 'gifts', 0, 0, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_bugtracker`
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
-- Estrutura da tabela `myaac_changelog`
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
-- Extraindo dados da tabela `myaac_changelog`
--

INSERT INTO `myaac_changelog` (`id`, `body`, `type`, `where`, `date`, `player_id`, `hidden`) VALUES
(1, 'MyAAC installed. (:', 3, 2, 1662576791, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_charbazaar`
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
-- Estrutura da tabela `myaac_charbazaar_bid`
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
-- Estrutura da tabela `myaac_config`
--

CREATE TABLE `myaac_config` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `value` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `myaac_config`
--

INSERT INTO `myaac_config` (`id`, `name`, `value`) VALUES
(1, 'database_version', '32'),
(2, 'status_online', '1'),
(3, 'status_players', '0'),
(4, 'status_playersMax', '999'),
(5, 'status_lastCheck', '1664129053'),
(6, 'status_uptime', '83'),
(7, 'status_monsters', '82'),
(8, 'last_usage_report', '1663260734'),
(9, 'views_counter', '328'),
(11, 'status_uptimeReadable', '0h 1m'),
(12, 'status_motd', 'Welcome to the Canary!'),
(13, 'status_mapAuthor', 'OpenTibiaBR'),
(14, 'status_mapName', 'Refugia'),
(15, 'status_mapWidth', '2048'),
(16, 'status_mapHeight', '2048'),
(17, 'status_server', 'Canary'),
(18, 'status_serverVersion', '1.5.0'),
(19, 'status_clientVersion', '12.91');

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_faq`
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
-- Estrutura da tabela `myaac_forum`
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
-- Estrutura da tabela `myaac_forum_boards`
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
-- Extraindo dados da tabela `myaac_forum_boards`
--

INSERT INTO `myaac_forum_boards` (`id`, `name`, `description`, `ordering`, `guild`, `access`, `closed`, `hidden`) VALUES
(1, 'News', 'News commenting', 0, 0, 0, 1, 0),
(2, 'Trade', 'Trade offers.', 1, 0, 0, 0, 0),
(3, 'Quests', 'Quest making.', 2, 0, 0, 0, 0),
(4, 'Pictures', 'Your pictures.', 3, 0, 0, 0, 0),
(5, 'Bug Report', 'Report bugs there.', 4, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_gallery`
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
-- Extraindo dados da tabela `myaac_gallery`
--

INSERT INTO `myaac_gallery` (`id`, `comment`, `image`, `thumb`, `author`, `ordering`, `hidden`) VALUES
(1, 'Demon', 'images/gallery/demon.jpg', 'images/gallery/demon_thumb.gif', 'MyAAC', 1, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_menu`
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
-- Extraindo dados da tabela `myaac_menu`
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
(31, 'tibiacom', 'Buy Points', 'points', 0, '', 6, 0, 1),
(32, 'tibiacom', 'Shop Offer', 'gifts', 0, '', 6, 1, 1),
(33, 'tibiacom', 'Shop History', 'gifts/history', 0, '', 6, 2, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_monsters`
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
-- Estrutura da tabela `myaac_news`
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
  `article_text` varchar(300) NOT NULL DEFAULT '',
  `article_image` varchar(100) NOT NULL DEFAULT '',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `myaac_news`
--

INSERT INTO `myaac_news` (`id`, `title`, `body`, `type`, `date`, `category`, `player_id`, `last_modified_by`, `last_modified_date`, `comments`, `article_text`, `article_image`, `hidden`) VALUES
(1, 'Hello!', 'MyAAC is just READY to use!', 1, 1662576813, 2, 7, 0, 0, 'https://my-aac.org', '', '', 0),
(2, 'Hello tickets!', 'https://my-aac.org', 2, 1662576813, 4, 7, 0, 0, '', '', '', 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_news_categories`
--

CREATE TABLE `myaac_news_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `description` varchar(50) NOT NULL DEFAULT '',
  `icon_id` int(2) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `myaac_news_categories`
--

INSERT INTO `myaac_news_categories` (`id`, `name`, `description`, `icon_id`, `hidden`) VALUES
(1, '', '', 0, 0),
(2, '', '', 1, 0),
(3, '', '', 2, 0),
(4, '', '', 3, 0),
(5, '', '', 4, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_notepad`
--

CREATE TABLE `myaac_notepad` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `content` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_pages`
--

CREATE TABLE `myaac_pages` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `title` varchar(30) NOT NULL,
  `body` text NOT NULL,
  `date` int(11) NOT NULL DEFAULT '0',
  `player_id` int(11) NOT NULL DEFAULT '0',
  `php` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 - plain html, 1 - php',
  `enable_tinymce` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 - enabled, 0 - disabled',
  `access` tinyint(2) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `myaac_pages`
--

INSERT INTO `myaac_pages` (`id`, `name`, `title`, `body`, `date`, `player_id`, `php`, `enable_tinymce`, `access`, `hidden`) VALUES
(1, 'downloads', 'Downloads', '<p>&nbsp;</p>\n<p>&nbsp;</p>\n<div style=\"text-align: center;\">We\'re using official Tibia Client <strong>{{ config.client / 100 }}</strong><br />\n<p>Download Tibia Client <strong>{{ config.client / 100 }}</strong>&nbsp;for Windows <a href=\"https://drive.google.com/drive/folders/0B2-sMQkWYzhGSFhGVlY2WGk5czQ\" target=\"_blank\" rel=\"noopener\">HERE</a>.</p>\n<h2>IP Changer:</h2>\n<a href=\"https://static.otland.net/ipchanger.exe\" target=\"_blank\" rel=\"noopener\">HERE</a></div>', 0, 1, 0, 1, 1, 0),
(2, 'commands', 'Commands', '<table style=\"border-collapse: collapse; width: 87.8471%; height: 57px;\" border=\"1\">\n<tbody>\n<tr style=\"height: 18px;\">\n<td style=\"width: 33.3333%; background-color: #505050; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Words</strong></span></td>\n<td style=\"width: 33.3333%; background-color: #505050; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Description</strong></span></td>\n</tr>\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\n<td style=\"width: 33.3333%; height: 18px;\"><em>!example</em></td>\n<td style=\"width: 33.3333%; height: 18px;\">This is just an example</td>\n</tr>\n<tr style=\"height: 18px; background-color: #d4c0a1;\">\n<td style=\"width: 33.3333%; height: 18px;\"><em>!buyhouse</em></td>\n<td style=\"width: 33.3333%; height: 18px;\">Buy house you are looking at</td>\n</tr>\n<tr style=\"height: 18px; background-color: #f1e0c6;\">\n<td style=\"width: 33.3333%; height: 18px;\"><em>!aol</em></td>\n<td style=\"width: 33.3333%; height: 18px;\">Buy AoL</td>\n</tr>\n</tbody>\n</table>', 0, 1, 0, 1, 1, 0),
(3, 'rules_on_the_page', 'Rules', '1. Names\na) Names which contain insulting (e.g. \"Bastard\"), racist (e.g. \"Nigger\"), extremely right-wing (e.g. \"Hitler\"), sexist (e.g. \"Bitch\") or offensive (e.g. \"Copkiller\") language.\nb) Names containing parts of sentences (e.g. \"Mike returns\"), nonsensical combinations of letters (e.g. \"Fgfshdsfg\") or invalid formattings (e.g. \"Thegreatknight\").\nc) Names that obviously do not describe a person (e.g. \"Christmastree\", \"Matrix\"), names of real life celebrities (e.g. \"Britney Spears\"), names that refer to real countries (e.g. \"Swedish Druid\"), names which were created to fake other players\' identities (e.g. \"Arieswer\" instead of \"Arieswar\") or official positions (e.g. \"System Admin\").\n\n2. Cheating\na) Exploiting obvious errors of the game (\"bugs\"), for instance to duplicate items. If you find an error you must report it to CipSoft immediately.\nb) Intentional abuse of weaknesses in the gameplay, for example arranging objects or players in a way that other players cannot move them.\nc) Using tools to automatically perform or repeat certain actions without any interaction by the player (\"macros\").\nd) Manipulating the client program or using additional software to play the game.\ne) Trying to steal other players\' account data (\"hacking\").\nf) Playing on more than one account at the same time (\"multi-clienting\").\ng) Offering account data to other players or accepting other players\' account data (\"account-trading/sharing\").\n\n3. Gamemasters\na) Threatening a gamemaster because of his or her actions or position as a gamemaster.\nb) Pretending to be a gamemaster or to have influence on the decisions of a gamemaster.\nc) Intentionally giving wrong or misleading information to a gamemaster concerning his or her investigations or making false reports about rule violations.\n\n4. Player Killing\na) Excessive killing of characters who are not marked with a \"skull\" on worlds which are not PvP-enforced. Please note that killing marked characters is not a reason for a banishment.\n\nA violation of the Tibia Rules may lead to temporary banishment of characters and accounts. In severe cases removal or modification of character skills, attributes and belongings, as well as the permanent removal of accounts without any compensation may be considered. The sanction is based on the seriousness of the rule violation and the previous record of the player. It is determined by the gamemaster imposing the banishment.\n\nThese rules may be changed at any time. All changes will be announced on the official website.', 0, 1, 0, 0, 1, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_polls`
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
-- Estrutura da tabela `myaac_polls_answers`
--

CREATE TABLE `myaac_polls_answers` (
  `poll_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `answer` varchar(255) NOT NULL,
  `votes` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_spells`
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
-- Estrutura da tabela `myaac_videos`
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
-- Estrutura da tabela `myaac_visitors`
--

CREATE TABLE `myaac_visitors` (
  `ip` varchar(16) NOT NULL,
  `lastvisit` int(11) NOT NULL DEFAULT '0',
  `page` varchar(2048) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `myaac_visitors`
--

INSERT INTO `myaac_visitors` (`ip`, `lastvisit`, `page`) VALUES
('192.168.47.1', 1664053888, '/tools/fonts/webfonts/fa-regular-400.woff2');

-- --------------------------------------------------------

--
-- Estrutura da tabela `myaac_weapons`
--

CREATE TABLE `myaac_weapons` (
  `id` int(11) NOT NULL,
  `level` int(11) NOT NULL DEFAULT '0',
  `maglevel` int(11) NOT NULL DEFAULT '0',
  `vocations` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `newsticker`
--

CREATE TABLE `newsticker` (
  `id` int(10) UNSIGNED NOT NULL,
  `date` int(11) NOT NULL,
  `text` mediumtext NOT NULL,
  `icon` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pagseguro`
--

CREATE TABLE `pagseguro` (
  `date` datetime NOT NULL,
  `code` varchar(50) NOT NULL,
  `reference` varchar(200) NOT NULL,
  `type` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `lastEventDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pagseguro_transactions`
--

CREATE TABLE `pagseguro_transactions` (
  `transaction_code` varchar(36) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `payment_method` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL,
  `item_count` int(11) NOT NULL,
  `data` datetime NOT NULL,
  `payment_amount` float DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `paypal_transactions`
--

CREATE TABLE `paypal_transactions` (
  `id` int(11) NOT NULL,
  `payment_status` varchar(70) NOT NULL DEFAULT '',
  `date` datetime NOT NULL,
  `payer_email` varchar(255) NOT NULL DEFAULT '',
  `payer_id` varchar(255) NOT NULL DEFAULT '',
  `item_number1` varchar(255) NOT NULL DEFAULT '',
  `mc_gross` float NOT NULL,
  `mc_currency` varchar(5) NOT NULL DEFAULT '',
  `txn_id` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `group_id` int(11) NOT NULL DEFAULT '1',
  `account_id` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `vocation` int(11) NOT NULL DEFAULT '0',
  `health` int(11) NOT NULL DEFAULT '150',
  `healthmax` int(11) NOT NULL DEFAULT '150',
  `experience` bigint(20) NOT NULL DEFAULT '0',
  `exptoday` int(11) DEFAULT NULL,
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
  `town_id` int(11) NOT NULL DEFAULT '0',
  `posx` int(11) NOT NULL DEFAULT '0',
  `posy` int(11) NOT NULL DEFAULT '0',
  `posz` int(11) NOT NULL DEFAULT '0',
  `conditions` blob NOT NULL,
  `cap` int(11) NOT NULL DEFAULT '0',
  `sex` int(11) NOT NULL DEFAULT '0',
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
  `onlinetime` bigint(20) NOT NULL DEFAULT '0',
  `deletion` bigint(15) NOT NULL DEFAULT '0',
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `bonusrerollcount` bigint(20) DEFAULT '0',
  `quickloot_fallback` tinyint(1) DEFAULT '0',
  `lookmountbody` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `lookmountfeet` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `lookmounthead` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `lookmountlegs` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `lookfamiliarstype` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `isreward` tinyint(1) NOT NULL DEFAULT '1',
  `istutorial` tinyint(1) NOT NULL DEFAULT '0',
  `offlinetraining_time` smallint(5) UNSIGNED NOT NULL DEFAULT '43200',
  `offlinetraining_skill` int(11) NOT NULL DEFAULT '-1',
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
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `comment` text NOT NULL,
  `create_ip` bigint(20) NOT NULL DEFAULT '0',
  `create_date` bigint(20) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
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
  `manashield` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `max_manashield` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `xpboost_stamina` int(11) DEFAULT NULL,
  `xpboost_value` int(10) DEFAULT NULL,
  `marriage_status` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `hide_skills` int(11) DEFAULT NULL,
  `hide_set` int(11) DEFAULT NULL,
  `former` varchar(255) NOT NULL DEFAULT '-',
  `signature` varchar(255) NOT NULL DEFAULT '',
  `marriage_spouse` int(11) NOT NULL DEFAULT '-1',
  `loyalty_ranking` tinyint(1) NOT NULL DEFAULT '0',
  `bonus_rerolls` bigint(21) NOT NULL DEFAULT '0',
  `critical` int(20) DEFAULT '0',
  `bonus_reroll` int(11) NOT NULL DEFAULT '0',
  `sbw_points` int(11) NOT NULL DEFAULT '0',
  `instantrewardtokens` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `charmpoints` int(11) DEFAULT '0',
  `direction` tinyint(1) DEFAULT '0',
  `lookmount` int(11) DEFAULT '0',
  `version` int(11) DEFAULT '1000',
  `lootaction` tinyint(2) DEFAULT '0',
  `spells` blob,
  `storages` mediumblob,
  `items` longblob,
  `depotitems` longblob,
  `inboxitems` longblob,
  `rewards` longblob,
  `varcap` int(11) NOT NULL DEFAULT '0',
  `charmExpansion` tinyint(2) DEFAULT '0',
  `bestiarykills` longblob,
  `charms` longblob,
  `bestiaryTracker` longblob,
  `autoloot` blob,
  `lastday` bigint(22) DEFAULT '0',
  `cast` tinyint(1) NOT NULL DEFAULT '0',
  `online_time` int(11) NOT NULL DEFAULT '0',
  `online_time_month` int(11) NOT NULL DEFAULT '0',
  `prey_wildcard` bigint(21) NOT NULL DEFAULT '0',
  `task_points` bigint(21) NOT NULL DEFAULT '0',
  `created` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `players`
--

INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `exptoday`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `maglevel`, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `lastlogin`, `lastip`, `save`, `skull`, `skulltime`, `lastlogout`, `blessings`, `blessings1`, `blessings2`, `blessings3`, `blessings4`, `blessings5`, `blessings6`, `blessings7`, `blessings8`, `onlinetime`, `deletion`, `balance`, `bonusrerollcount`, `quickloot_fallback`, `lookmountbody`, `lookmountfeet`, `lookmounthead`, `lookmountlegs`, `lookfamiliarstype`, `isreward`, `istutorial`, `offlinetraining_time`, `offlinetraining_skill`, `stamina`, `skill_fist`, `skill_fist_tries`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`, `skill_shielding`, `skill_shielding_tries`, `skill_fishing`, `skill_fishing_tries`, `deleted`, `description`, `comment`, `create_ip`, `create_date`, `hidden`, `skill_critical_hit_chance`, `skill_critical_hit_chance_tries`, `skill_critical_hit_damage`, `skill_critical_hit_damage_tries`, `skill_life_leech_chance`, `skill_life_leech_chance_tries`, `skill_life_leech_amount`, `skill_life_leech_amount_tries`, `skill_mana_leech_chance`, `skill_mana_leech_chance_tries`, `skill_mana_leech_amount`, `skill_mana_leech_amount_tries`, `skill_criticalhit_chance`, `skill_criticalhit_damage`, `skill_lifeleech_chance`, `skill_lifeleech_amount`, `skill_manaleech_chance`, `skill_manaleech_amount`, `manashield`, `max_manashield`, `xpboost_stamina`, `xpboost_value`, `marriage_status`, `hide_skills`, `hide_set`, `former`, `signature`, `marriage_spouse`, `loyalty_ranking`, `bonus_rerolls`, `critical`, `bonus_reroll`, `sbw_points`, `instantrewardtokens`, `charmpoints`, `direction`, `lookmount`, `version`, `lootaction`, `spells`, `storages`, `items`, `depotitems`, `inboxitems`, `rewards`, `varcap`, `charmExpansion`, `bestiarykills`, `charms`, `bestiaryTracker`, `autoloot`, `lastday`, `cast`, `online_time`, `online_time_month`, `prey_wildcard`, `task_points`, `created`) VALUES
(1, 'Rook Sample', 1, 2, 2, 0, 155, 155, 100, NULL, 113, 115, 95, 39, 129, 0, 2, 60, 60, 5936, 0, 1, 98, 101, 6, '', 410, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 43200, -1, 2520, 10, 0, 12, 155, 12, 155, 12, 155, 12, 93, 10, 0, 10, 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0),
(2, 'Sorcerer Sample', 1, 2, 8, 1, 185, 185, 4200, NULL, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 100, 1, 98, 101, 6, '', 470, 1, 1641867717, 16777343, 1, 0, 0, 1641867741, 0, 1, 1, 1, 1, 1, 1, 1, 1, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 43200, -1, 2520, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0),
(3, 'Druid Sample', 1, 2, 8, 2, 185, 185, 4200, NULL, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 100, 1, 98, 101, 6, '', 470, 1, 1641867749, 16777343, 1, 0, 0, 1641867754, 0, 1, 1, 1, 1, 1, 1, 1, 1, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 43200, -1, 2520, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0),
(4, 'Paladin Sample', 1, 2, 8, 3, 185, 185, 4200, NULL, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 100, 1, 98, 101, 6, '', 470, 1, 1663084231, 19900608, 1, 0, 0, 1663084233, 0, 1, 1, 1, 1, 1, 1, 1, 1, 176, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 43200, -1, 2520, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0),
(5, 'Knight Sample', 1, 2, 8, 4, 185, 185, 4200, NULL, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 100, 1, 98, 101, 6, '', 470, 1, 1663084223, 19900608, 1, 0, 0, 1663084230, 0, 1, 1, 1, 1, 1, 1, 1, 1, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 43200, -1, 2520, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0),
(7, 'Administrator', 6, 2, 1000, 4, 15065, 15065, 16566950242, NULL, 113, 115, 114, 39, 1094, 3, 110, 5050, 5050, 0, 100, 1, 112, 98, 7, '', 25270, 1, 1664055648, 19900608, 1, 0, 0, 1664056343, 0, 1, 1, 1, 1, 1, 1, 1, 1, 10290115, 0, 0, 0, 0, 0, 0, 0, 0, 991, 1, 0, 43200, -1, 2520, 110, 0, 110, 0, 110, 0, 110, 0, 110, 0, 110, 0, 110, 0, 0, '[Reset: 0]', '', 2130706433, 1641862573, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3600, 50, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 2412, 0, 4, 0, 0),
(8, 'Teste Sorc', 1, 2, 127, 5, 536, 780, 33092312, NULL, 113, 115, 95, 39, 128, 0, 51, 3497, 3660, 109577, 200, 1, 97, 106, 7, '', 1660, 1, 1663945276, 19900608, 1, 0, 0, 1663945432, 0, 0, 0, 0, 0, 0, 0, 0, 0, 289857, 0, 0, 0, 1, 0, 0, 0, 0, 994, 1, 0, 43200, -1, 2516, 10, 0, 10, 0, 16, 435, 10, 0, 10, 0, 10, 0, 10, 0, 0, '', '', 2130706433, 1641866983, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 120, 50, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 270, 0, 0, 0, 0),
(9, 'Teste Doms', 1, 3, 97, 5, 630, 630, 14724425, NULL, 113, 115, 95, 39, 145, 0, 35, 116, 2760, 18299, 100, 1, 97, 107, 7, '', 1360, 1, 1663876897, 19900608, 1, 0, 0, 1663877401, 0, 0, 1, 1, 1, 1, 1, 0, 0, 31136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 43200, -1, 2518, 28, 8903, 10, 0, 10, 0, 10, 0, 10, 0, 28, 28629, 10, 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 7, 0, 0, 0, 1662946003),
(10, 'Test Itnss', 1, 3, 8, 2, 185, 185, 4200, NULL, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 100, 1, 98, 100, 6, '', 470, 1, 1663084340, 19900608, 1, 0, 0, 1663084355, 0, 0, 1, 1, 1, 1, 1, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 1663084299),
(11, 'Teste Ms Itns', 1, 3, 128, 1, 605, 785, 33727300, NULL, 113, 115, 95, 39, 146, 0, 2, 3165, 3690, 1890, 100, 1, 97, 106, 7, 0x010004000002ffffffff03187900001b001c00000000fe, 1670, 1, 1663885497, 19900608, 1, 0, 0, 1663885728, 0, 0, 1, 1, 1, 1, 1, 0, 0, 289, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 43200, -1, 2518, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 2, 0, 0, 0, 1663084351),
(12, 'Teste Rp Itenss', 1, 3, 514, 3, 5245, 5245, 2240248520, NULL, 113, 115, 95, 39, 129, 0, 17, 7680, 7680, 402653, 100, 1, 109, 97, 7, '', 10590, 1, 1664054614, 19900608, 1, 0, 0, 1664056343, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10248, 0, 250000, 0, 0, 0, 0, 0, 0, 992, 1, 0, 43200, -1, 2520, 17, 149, 10, 0, 10, 0, 10, 0, 121, 433908, 17, 71, 10, 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 100, 0, 0, 0, 1663084382),
(13, 'Teste Kina Itsns', 1, 3, 8, 4, 185, 185, 4200, NULL, 113, 115, 95, 39, 129, 0, 0, 90, 90, 0, 100, 1, 98, 101, 6, 0x010000000202ffffffff03e80300001b001c00000000fe, 470, 1, 1663084441, 19900608, 1, 0, 0, 1663084462, 0, 0, 1, 1, 1, 1, 1, 0, 0, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '-', '', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 1663084425);

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
-- Estrutura da tabela `players_online`
--

CREATE TABLE `players_online` (
  `player_id` int(11) NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `players_online`
--

INSERT INTO `players_online` (`player_id`) VALUES
(7);

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_binary_items`
--

CREATE TABLE `player_binary_items` (
  `player_id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `items` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_charms`
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
-- Extraindo dados da tabela `player_charms`
--

INSERT INTO `player_charms` (`player_guid`, `charm_points`, `charm_expansion`, `rune_wound`, `rune_enflame`, `rune_poison`, `rune_freeze`, `rune_zap`, `rune_curse`, `rune_cripple`, `rune_parry`, `rune_dodge`, `rune_adrenaline`, `rune_numb`, `rune_cleanse`, `rune_bless`, `rune_scavenge`, `rune_gut`, `rune_low_blow`, `rune_divine`, `rune_vamp`, `rune_void`, `UsedRunesBit`, `UnlockedRunesBit`, `tracker list`) VALUES
(6, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(3, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(5, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(7, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(4, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(2, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(8, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(9, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(10, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(11, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(12, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', ''),
(13, '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', '');

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_deaths`
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

--
-- Extraindo dados da tabela `player_deaths`
--

INSERT INTO `player_deaths` (`player_id`, `time`, `level`, `killed_by`, `is_player`, `mostdamage_by`, `mostdamage_is_player`, `unjustified`, `mostdamage_unjustified`) VALUES
(8, 1642001804, 57, 'a nightstalker', 0, 'a nightstalker', 0, 0, 0),
(8, 1642100593, 58, 'a demon', 0, 'a demon', 0, 0, 0),
(8, 1642100687, 57, 'a demon', 0, 'a demon', 0, 0, 0),
(8, 1642100796, 56, 'a demon', 0, 'a demon', 0, 0, 0),
(8, 1642101100, 56, 'a demon', 0, 'a demon', 0, 0, 0),
(8, 1642101178, 55, 'a demon', 0, 'a demon', 0, 0, 0),
(8, 1642101896, 54, 'a demon', 0, 'a demon', 0, 0, 0),
(8, 1642373391, 64, 'a dragon', 0, 'a dragon', 0, 0, 0),
(12, 1664054102, 121, 'a pre empe', 0, 'a pre empe', 0, 0, 0),
(12, 1664055188, 520, 'an emperium tower', 0, 'an emperium tower', 0, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_depotitems`
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
-- Estrutura da tabela `player_former_names`
--

CREATE TABLE `player_former_names` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `former_name` varchar(35) NOT NULL,
  `date` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_hirelings`
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
-- Estrutura da tabela `player_inboxitems`
--

CREATE TABLE `player_inboxitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT '0',
  `itemtype` int(11) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_items`
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
-- Extraindo dados da tabela `player_items`
--

INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES
(5, 11, 101, 23396, 1, ''),
(4, 11, 101, 23396, 1, ''),
(10, 1, 101, 7992, 1, ''),
(10, 2, 102, 3572, 1, ''),
(10, 3, 103, 2854, 1, 0x24012600000080),
(10, 4, 104, 7991, 1, ''),
(10, 5, 105, 3059, 1, ''),
(10, 6, 106, 3066, 1, ''),
(10, 7, 107, 3362, 1, ''),
(10, 8, 108, 3552, 1, ''),
(10, 11, 109, 23396, 1, ''),
(10, 103, 110, 268, 10, 0x0f0a),
(10, 103, 111, 5710, 1, ''),
(10, 103, 112, 3003, 1, ''),
(13, 1, 101, 3354, 1, ''),
(13, 2, 102, 3572, 1, ''),
(13, 3, 103, 2854, 1, 0x2401),
(13, 4, 104, 3359, 1, ''),
(13, 5, 105, 3425, 1, ''),
(13, 6, 106, 7773, 1, ''),
(13, 7, 107, 3372, 1, ''),
(13, 8, 108, 3552, 1, ''),
(13, 11, 109, 23396, 1, ''),
(13, 103, 110, 266, 10, 0x0f0a),
(13, 103, 111, 5710, 1, ''),
(13, 103, 112, 3003, 1, ''),
(13, 103, 113, 3327, 1, ''),
(13, 103, 114, 7774, 1, ''),
(9, 1, 101, 3354, 1, ''),
(9, 3, 102, 2854, 1, 0x24012600000080),
(9, 4, 103, 3359, 1, ''),
(9, 7, 104, 3372, 1, ''),
(9, 10, 105, 2920, 1, ''),
(9, 11, 106, 23396, 1, ''),
(9, 102, 107, 3074, 1, ''),
(9, 102, 108, 3031, 13, 0x0f0d),
(9, 102, 109, 3043, 98, 0x0f62),
(9, 102, 110, 16277, 1, ''),
(9, 102, 111, 3003, 1, ''),
(11, 1, 101, 7992, 1, ''),
(11, 2, 102, 3572, 1, ''),
(11, 3, 103, 2854, 1, 0x24012600000080),
(11, 4, 104, 7991, 1, ''),
(11, 5, 105, 3059, 1, ''),
(11, 6, 106, 3074, 1, ''),
(11, 7, 107, 3362, 1, ''),
(11, 8, 108, 3552, 1, ''),
(11, 11, 109, 23396, 1, ''),
(11, 103, 110, 268, 10, 0x0f0a),
(11, 103, 111, 5710, 1, ''),
(11, 103, 112, 3003, 1, ''),
(8, 3, 101, 2854, 1, 0x240126000000c0),
(8, 6, 102, 3271, 1, ''),
(8, 11, 103, 23396, 1, ''),
(8, 101, 104, 3031, 100, 0x0f64),
(8, 101, 105, 3031, 100, 0x0f64),
(8, 101, 106, 3031, 100, 0x0f64),
(8, 101, 107, 3031, 100, 0x0f64),
(8, 101, 108, 3031, 100, 0x0f64),
(8, 101, 109, 3031, 100, 0x0f64),
(8, 101, 110, 3031, 100, 0x0f64),
(8, 101, 111, 3031, 100, 0x0f64),
(8, 101, 112, 3031, 100, 0x0f64),
(8, 101, 113, 3031, 100, 0x0f64),
(8, 101, 114, 284, 17, 0x0f11),
(8, 101, 115, 3031, 100, 0x0f64),
(8, 101, 116, 8102, 1, ''),
(8, 101, 117, 37317, 5, 0x0f05),
(8, 101, 118, 3043, 100, 0x0f64),
(8, 101, 119, 3161, 98, 0x0f62),
(8, 101, 120, 238, 83, 0x0f53),
(8, 101, 121, 3035, 5, 0x0f05),
(8, 101, 122, 238, 100, 0x0f64),
(8, 101, 123, 238, 100, 0x0f64),
(8, 103, 124, 268, 15, 0x0f0f),
(7, 1, 101, 39149, 1, ''),
(7, 3, 102, 2854, 1, 0x24012600000080),
(7, 4, 103, 3386, 1, ''),
(7, 6, 104, 3296, 1, 0x1cf4010000),
(7, 7, 105, 16106, 1, ''),
(7, 11, 106, 23396, 1, 0x2400),
(7, 102, 107, 284, 6, 0x0f06),
(7, 102, 108, 23373, 94, 0x0f5e),
(7, 102, 109, 23373, 100, 0x0f64),
(7, 102, 110, 35902, 1, 0x0f01),
(7, 102, 111, 39151, 1, ''),
(7, 102, 112, 39153, 1, ''),
(7, 102, 113, 39149, 1, ''),
(7, 102, 114, 39152, 1, ''),
(7, 102, 115, 39154, 1, ''),
(7, 102, 116, 39162, 1, ''),
(7, 102, 117, 39163, 1, ''),
(7, 102, 118, 39155, 1, ''),
(7, 102, 119, 39157, 1, ''),
(7, 102, 120, 39156, 1, ''),
(7, 102, 121, 39177, 1, 0x105c6ea400),
(7, 102, 122, 2854, 1, 0x2400),
(7, 106, 123, 23398, 1, 0x076500596f7520626f756768742074686973206974656d20696e207468652053746f72652e0a556e7772617020697420696e20796f7572206f776e20686f75736520746f206372656174652061203c6365726265727573206368616d70696f6e2070757070793e2e2501000000000000000800756e77726170696402e87a000000000000),
(7, 106, 124, 23398, 1, 0x076500596f7520626f756768742074686973206974656d20696e207468652053746f72652e0a556e7772617020697420696e20796f7572206f776e20686f75736520746f206372656174652061203c6365726265727573206368616d70696f6e2070757070793e2e2501000000000000000800756e77726170696402e87a000000000000),
(7, 106, 125, 23375, 20, 0x0f14),
(7, 106, 126, 268, 20, 0x0f14),
(7, 106, 127, 23398, 1, 0x075e00596f7520626f756768742074686973206974656d20696e207468652053746f72652e0a556e7772617020697420696e20796f7572206f776e20686f75736520746f206372656174652061203c4261627920427261696e2053717569643e2e2501000000000000000800756e777261706964028d80000000000000),
(7, 106, 128, 23398, 1, 0x076900596f7520626f756768742074686973206974656d20696e207468652053746f72652e0a556e7772617020697420696e20796f7572206f776e20686f75736520746f206372656174652061203c7375626c696d6520746f75726e616d656e74206163636f6c6164653e2e2501000000000000000800756e77726170696402f07a000000000000),
(7, 106, 129, 23398, 1, 0x076100596f7520626f756768742074686973206974656d20696e207468652053746f72652e0a556e7772617020697420696e20796f7572206f776e20686f75736520746f206372656174652061203c746f75726e616d656e74206163636f6c6164653e2e2501000000000000000800756e77726170696402ee7a000000000000),
(7, 106, 130, 23398, 1, 0x076100596f7520626f756768742074686973206974656d20696e207468652053746f72652e0a556e7772617020697420696e20796f7572206f776e20686f75736520746f206372656174652061203c746f75726e616d656e74206163636f6c6164653e2e2501000000000000000800756e77726170696402ee7a000000000000),
(7, 106, 131, 23398, 1, 0x076100596f7520626f756768742074686973206974656d20696e207468652053746f72652e0a556e7772617020697420696e20796f7572206f776e20686f75736520746f206372656174652061203c746f75726e616d656e74206163636f6c6164653e2e2501000000000000000800756e77726170696402ee7a000000000000),
(7, 106, 132, 23398, 1, 0x076100596f7520626f756768742074686973206974656d20696e207468652053746f72652e0a556e7772617020697420696e20796f7572206f776e20686f75736520746f206372656174652061203c6a6f757374696e67206561676c6520626162793e2e2501000000000000000800756e77726170696402e67a000000000000),
(7, 106, 133, 23398, 1, 0x076100596f7520626f756768742074686973206974656d20696e207468652053746f72652e0a556e7772617020697420696e20796f7572206f776e20686f75736520746f206372656174652061203c746f75726e616d656e74206163636f6c6164653e2e2501000000000000000800756e77726170696402ee7a000000000000),
(7, 122, 134, 39418, 2, 0x0f02),
(7, 122, 135, 3324, 1, ''),
(7, 122, 136, 7643, 3, 0x0f03),
(7, 122, 137, 3324, 1, ''),
(7, 122, 138, 3326, 1, ''),
(7, 122, 139, 3392, 1, ''),
(7, 122, 140, 3031, 5, 0x0f05),
(7, 122, 141, 3031, 100, 0x0f64),
(7, 122, 142, 3031, 100, 0x0f64),
(7, 122, 143, 3031, 100, 0x0f64),
(7, 122, 144, 3031, 100, 0x0f64),
(7, 122, 145, 3031, 100, 0x0f64),
(7, 122, 146, 3031, 100, 0x0f64),
(7, 122, 147, 3031, 100, 0x0f64),
(7, 122, 148, 3031, 100, 0x0f64),
(7, 122, 149, 16124, 6, 0x0f06),
(7, 122, 150, 37110, 100, 0x0f64),
(7, 122, 151, 37109, 100, 0x0f64),
(7, 122, 152, 16277, 1, ''),
(7, 122, 153, 2854, 1, ''),
(7, 153, 154, 7385, 1, ''),
(7, 153, 155, 860, 1, ''),
(7, 153, 156, 3446, 100, 0x0f64),
(7, 153, 157, 3446, 100, 0x0f64),
(7, 153, 158, 3446, 100, 0x0f64),
(7, 153, 159, 3446, 100, 0x0f64),
(7, 153, 160, 3035, 17, 0x0f11),
(7, 153, 161, 3031, 100, 0x0f64),
(7, 153, 162, 16123, 53, 0x0f35),
(7, 153, 163, 16124, 59, 0x0f3b),
(7, 153, 164, 16122, 35, 0x0f23),
(7, 153, 165, 3457, 1, ''),
(7, 153, 166, 3003, 1, ''),
(7, 153, 167, 3456, 1, ''),
(7, 153, 168, 3308, 1, ''),
(7, 153, 169, 28557, 20, 0x161400),
(7, 153, 170, 28553, 20, 0x161400),
(7, 153, 171, 28555, 20, 0x161400),
(7, 153, 172, 28552, 20, 0x161400),
(7, 153, 173, 28554, 20, 0x161400),
(12, 2, 101, 3572, 1, ''),
(12, 3, 102, 2853, 1, 0x2600000080),
(12, 4, 103, 3571, 1, ''),
(12, 6, 104, 39159, 1, ''),
(12, 7, 105, 8095, 1, ''),
(12, 8, 106, 3552, 1, ''),
(12, 11, 107, 23396, 1, '');

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_kills`
--

CREATE TABLE `player_kills` (
  `player_id` int(11) NOT NULL,
  `time` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `target` int(11) NOT NULL,
  `unavenged` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_misc`
--

CREATE TABLE `player_misc` (
  `player_id` int(11) NOT NULL,
  `info` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `player_misc`
--

INSERT INTO `player_misc` (`player_id`, `info`) VALUES
(6, 0x7b7d),
(2, 0x7b7d),
(3, 0x7b7d),
(5, 0x7b7d),
(4, 0x7b7d),
(10, 0x7b7d),
(13, 0x7b7d),
(9, 0x7b7d),
(11, 0x7b7d),
(8, 0x7b7d),
(7, 0x7b7d),
(12, 0x7b7d);

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_namelocks`
--

CREATE TABLE `player_namelocks` (
  `player_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `namelocked_at` bigint(20) NOT NULL,
  `namelocked_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_prey`
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
-- Extraindo dados da tabela `player_prey`
--

INSERT INTO `player_prey` (`player_id`, `slot`, `state`, `raceid`, `option`, `bonus_type`, `bonus_rarity`, `bonus_percentage`, `bonus_time`, `free_reroll`, `monster_list`) VALUES
(7, 0, 3, '0', 0, 1, 6, '24', '0', 1664111330334, 0x1d072a08b7026800c1021e0715048707c203),
(7, 1, 3, '0', 0, 3, 4, '16', '0', 1664111330335, 0xf6014f011403190131004c04d40899077706),
(7, 2, 0, '0', 0, 1, 10, '40', '0', 1664111330336, ''),
(12, 0, 3, '0', 0, 1, 9, '36', '0', 1664125161602, 0x2805d204c90115009a07dc00100013005e00),
(12, 1, 3, '0', 0, 3, 4, '16', '0', 1664125161603, 0x8b064a0238002b00630328006f0342002205),
(12, 2, 0, '0', 0, 1, 4, '16', '0', 1664125161603, '');

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_preydata`
--

CREATE TABLE `player_preydata` (
  `player_id` int(11) NOT NULL,
  `data` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_preytimes`
--

CREATE TABLE `player_preytimes` (
  `player_id` int(11) NOT NULL,
  `bonus_type1` int(11) NOT NULL,
  `bonus_value1` int(11) NOT NULL,
  `bonus_name1` varchar(50) NOT NULL,
  `bonus_type2` int(11) NOT NULL,
  `bonus_value2` int(11) NOT NULL,
  `bonus_name2` varchar(50) NOT NULL,
  `bonus_type3` int(11) NOT NULL,
  `bonus_value3` int(11) NOT NULL,
  `bonus_name3` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `player_preytimes`
--

INSERT INTO `player_preytimes` (`player_id`, `bonus_type1`, `bonus_value1`, `bonus_name1`, `bonus_type2`, `bonus_value2`, `bonus_name2`, `bonus_type3`, `bonus_value3`, `bonus_name3`) VALUES
(6, 0, 0, '', 0, 0, '', 0, 0, ''),
(3, 0, 0, '', 0, 0, '', 0, 0, ''),
(5, 0, 0, '', 0, 0, '', 0, 0, ''),
(7, 0, 0, '', 0, 0, '', 0, 0, ''),
(4, 0, 0, '', 0, 0, '', 0, 0, ''),
(2, 0, 0, '', 0, 0, '', 0, 0, ''),
(8, 0, 0, '', 0, 0, '', 0, 0, '');

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_rewards`
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
-- Estrutura da tabela `player_spells`
--

CREATE TABLE `player_spells` (
  `player_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_stash`
--

CREATE TABLE `player_stash` (
  `player_id` int(16) NOT NULL,
  `item_id` int(16) NOT NULL,
  `item_count` int(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_storage`
--

CREATE TABLE `player_storage` (
  `player_id` int(11) NOT NULL DEFAULT '0',
  `key` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `player_storage`
--

INSERT INTO `player_storage` (`player_id`, `key`, `value`) VALUES
(2, 13413, 1),
(2, 13414, 1),
(2, 14903, 0),
(2, 17101, 0),
(2, 30023, 0),
(2, 30029, 0),
(2, 998899, 1),
(3, 13413, 1),
(3, 13414, 1),
(3, 14903, 0),
(3, 17101, 0),
(3, 30023, 1),
(3, 30029, 0),
(3, 998899, 1),
(4, 13413, 1),
(4, 13414, 9),
(4, 14903, 1),
(4, 17101, 0),
(4, 30023, 1),
(4, 30029, 0),
(4, 30058, 1),
(4, 998899, 1),
(5, 13413, 1),
(5, 13414, 9),
(5, 14903, 1),
(5, 17101, 0),
(5, 30023, 1),
(5, 30029, 0),
(5, 30058, 1),
(5, 998899, 1),
(7, 0, 1663106579),
(7, 2001, 1),
(7, 2032, 1),
(7, 8589, 1),
(7, 10000, 0),
(7, 10001, 0),
(7, 10002, 0),
(7, 10003, 0),
(7, 10004, 0),
(7, 10005, 0),
(7, 13412, 1663847700),
(7, 13413, 1664031300),
(7, 13414, 9),
(7, 14897, 5),
(7, 14898, 0),
(7, 14899, 1663934100),
(7, 14903, 0),
(7, 17101, 0),
(7, 20000, 0),
(7, 20001, 0),
(7, 20002, 2),
(7, 20067, 16),
(7, 20108, 9),
(7, 30000, 1662990881),
(7, 30001, 1658941440),
(7, 30005, 1658942407),
(7, 30018, 2),
(7, 30023, 1),
(7, 30026, 1658955461),
(7, 30029, 0),
(7, 30051, 1664039710),
(7, 30058, 1),
(7, 30060, 1663100777),
(7, 38412, 14),
(7, 50001, 0),
(7, 50002, 809),
(7, 51052, 0),
(7, 52130, 1),
(7, 52131, 1),
(7, 65000, 1),
(7, 190006, 0),
(7, 190007, 0),
(7, 998899, 1),
(7, 10002011, 204),
(7, 10003001, 65142784),
(7, 61305022, 2),
(7, 61305026, 79),
(7, 61305034, 110),
(7, 61305035, 42),
(7, 61305039, 5),
(7, 61305125, 41),
(7, 61305317, 1),
(7, 61305912, 1),
(7, 61306135, 3),
(7, 61306930, 1),
(7, 61307100, 1),
(7, 61307101, 1),
(7, 61307107, 1),
(7, 61307108, 1),
(7, 61307109, 1),
(7, 61307260, 1),
(7, 61308333, 1),
(7, 61308334, 1),
(7, 61308335, 1),
(7, 61308336, 1),
(7, 4294967295, 0),
(8, 0, 0),
(8, 8589, 1),
(8, 10000, 3420),
(8, 10001, 3031),
(8, 10002, 0),
(8, 10003, 0),
(8, 10004, 0),
(8, 10005, 0),
(8, 13412, 1663161300),
(8, 13413, 1663858500),
(8, 13414, 9),
(8, 14897, 2),
(8, 14898, 0),
(8, 14899, 1663247700),
(8, 14903, 0),
(8, 17101, 0),
(8, 20000, 0),
(8, 20001, 0),
(8, 20067, 224),
(8, 20108, 2),
(8, 30002, 1641948671),
(8, 30018, 2),
(8, 30023, 1),
(8, 30029, 0),
(8, 30051, 1663871121),
(8, 30058, 1),
(8, 38412, 222),
(8, 50001, 0),
(8, 50002, 0),
(8, 50003, 0),
(8, 51052, 0),
(8, 65000, 1),
(8, 998899, 1),
(8, 61305022, 218),
(8, 61305026, 225),
(8, 61305034, 111),
(8, 61305039, 6),
(8, 61305045, 45),
(8, 61305077, 10),
(8, 61305125, 3),
(8, 61305385, 6),
(8, 61305389, 1),
(8, 61305391, 2),
(8, 61305520, 2),
(8, 61306135, 5),
(9, 13413, 1663858500),
(9, 13414, 9),
(9, 14898, 0),
(9, 14903, 0),
(9, 17101, 0),
(9, 20000, 0),
(9, 20001, 0),
(9, 30018, 1),
(9, 30023, 1),
(9, 30029, 0),
(9, 30051, 1662998235),
(9, 30058, 1),
(9, 52130, 1),
(9, 61305022, 4),
(9, 61305026, 4),
(10, 13413, 1),
(10, 13414, 9),
(10, 14903, 0),
(10, 17101, 0),
(10, 30023, 1),
(10, 30029, 0),
(10, 30058, 1),
(11, 13413, 1663858500),
(11, 13414, 9),
(11, 14898, 0),
(11, 14903, 0),
(11, 17101, 0),
(11, 20000, 0),
(11, 20001, 0),
(11, 30023, 1),
(11, 30029, 0),
(11, 30058, 1),
(11, 61305034, 2),
(12, 8589, 1),
(12, 13413, 1664031300),
(12, 13414, 9),
(12, 14898, 0),
(12, 14903, 0),
(12, 17101, 0),
(12, 20000, 0),
(12, 20001, 0),
(12, 30000, 1663878619),
(12, 30023, 1),
(12, 30029, 0),
(12, 30051, 1663091602),
(12, 30058, 1),
(12, 10003001, 65011712),
(12, 61305026, 12),
(12, 61305034, 7),
(12, 61305035, 3),
(12, 61305045, 1),
(12, 61308333, 1),
(12, 61308335, 1),
(12, 61308336, 1),
(13, 13413, 1),
(13, 13414, 9),
(13, 14903, 0),
(13, 17101, 0),
(13, 30023, 0),
(13, 30029, 0),
(13, 30058, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_taskhunt`
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
-- Extraindo dados da tabela `player_taskhunt`
--

INSERT INTO `player_taskhunt` (`player_id`, `slot`, `state`, `raceid`, `upgrade`, `rarity`, `kills`, `disabled_time`, `free_reroll`, `monster_list`) VALUES
(5, 0, 2, '0', 0, 1, '0', 0, 1663156223849, 0x8f028907b501cf01710043014a043b004801),
(5, 1, 2, '0', 0, 1, '0', 0, 1663156223852, 0x4e01bf03360046028b070e033200cd038302),
(5, 2, 0, '0', 0, 1, '0', 0, 1663156223855, ''),
(4, 0, 2, '0', 0, 1, '0', 0, 1663156231697, 0x0300430009017800150276009a07df000c06),
(4, 1, 2, '0', 0, 1, '0', 0, 1663156231701, 0x78046f066c027c005202f1041c03d7004807),
(4, 2, 0, '0', 0, 1, '0', 0, 1663156231705, ''),
(10, 0, 2, '0', 0, 1, '0', 0, 1663156308322, 0x24005504700013047305b50144017503aa07),
(10, 1, 2, '0', 0, 1, '0', 0, 1663156308323, 0x4202d50388010a036e04f40727018a074101),
(10, 2, 0, '0', 0, 1, '0', 0, 1663156308327, ''),
(13, 0, 2, '0', 0, 1, '0', 0, 1663156441084, 0xd60043001d012c0253003300cd01ba022d00),
(13, 1, 2, '0', 0, 1, '0', 0, 1663156441087, 0xf703d3037600890485017400090026006900),
(13, 2, 0, '0', 0, 1, '0', 0, 1663156441090, ''),
(9, 0, 2, '0', 0, 1, '0', 0, 1663018013415, 0xe302be01d602db02d304440120078405d805),
(9, 1, 2, '0', 0, 1, '0', 0, 1663018013418, 0xa3050c029f0508038103d800df022b002b01),
(9, 2, 0, '0', 0, 1, '0', 0, 1663018013421, ''),
(11, 0, 2, '0', 0, 1, '0', 0, 1663156361517, 0x2f05910330003d089b052f00ab0789040d02),
(11, 1, 2, '0', 0, 1, '0', 0, 1663156361521, 0x2b080002c7020b0035002600470010001100),
(11, 2, 0, '0', 0, 1, '0', 0, 1663156361523, ''),
(8, 0, 2, '0', 0, 1, '0', 0, 1662648975264, 0x04011204e2051c0290033800ad0461049703),
(8, 1, 2, '0', 0, 1, '0', 0, 1662648975265, 0x2e0209060001e1053b000b02540622062d00),
(8, 2, 0, '0', 0, 1, '0', 0, 1662648975267, ''),
(7, 0, 2, '0', 0, 1, '0', 0, 1659011024580, 0xdf0035008701ad046a02a002a10206016902),
(7, 1, 2, '0', 0, 1, '0', 0, 1659011024580, 0xc303cd01230127000f0164050f0021011c00),
(7, 2, 0, '0', 0, 1, '0', 0, 1659011024580, ''),
(12, 0, 2, '0', 0, 1, '0', 0, 1663156389090, 0x7205230178005504420248017e037d003d00),
(12, 1, 2, '0', 0, 1, '0', 0, 1663156389092, 0x1b009203640017004d04cd03180723002400),
(12, 2, 0, '0', 0, 1, '0', 0, 1663156389094, '');

-- --------------------------------------------------------

--
-- Estrutura da tabela `quickloot_containers`
--

CREATE TABLE `quickloot_containers` (
  `player_id` int(11) NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `cid` int(10) UNSIGNED NOT NULL,
  `sid` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `sellchar`
--

CREATE TABLE `sellchar` (
  `id` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `vocation` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `status` varchar(40) NOT NULL,
  `oldid` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `sell_players`
--

CREATE TABLE `sell_players` (
  `player_id` int(11) NOT NULL,
  `account` int(11) NOT NULL,
  `create` bigint(20) NOT NULL,
  `createip` bigint(20) NOT NULL,
  `coin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `sell_players_history`
--

CREATE TABLE `sell_players_history` (
  `player_id` int(11) NOT NULL,
  `accountold` int(11) NOT NULL,
  `accountnew` int(11) NOT NULL,
  `create` bigint(20) NOT NULL,
  `createip` bigint(20) NOT NULL,
  `buytime` bigint(20) NOT NULL,
  `buyip` bigint(20) NOT NULL,
  `coin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `server_config`
--

CREATE TABLE `server_config` (
  `config` varchar(50) NOT NULL,
  `value` varchar(256) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `server_config`
--

INSERT INTO `server_config` (`config`, `value`, `timestamp`) VALUES
('db_version', '20', '2022-09-24 16:48:19'),
('double', 'desactived', '2022-09-07 18:53:11'),
('motd_hash', '125ab277e842c29437dd25428f4ec3d6ddd2b21f', '2022-09-07 18:53:11'),
('motd_num', '3', '2022-09-07 18:53:11'),
('players_record', '2', '2022-09-07 18:53:11');

-- --------------------------------------------------------

--
-- Estrutura da tabela `snowballwar`
--

CREATE TABLE `snowballwar` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `score` int(11) NOT NULL,
  `data` varchar(255) NOT NULL,
  `hora` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `store_history`
--

CREATE TABLE `store_history` (
  `id` int(11) NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  `mode` smallint(2) NOT NULL DEFAULT '0',
  `description` varchar(3500) NOT NULL,
  `coin_type` tinyint(1) NOT NULL DEFAULT '0',
  `coin_amount` int(12) NOT NULL,
  `time` bigint(20) UNSIGNED NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `store_history`
--

INSERT INTO `store_history` (`id`, `account_id`, `mode`, `description`, `coin_type`, `coin_amount`, `time`, `timestamp`) VALUES
(1, 1, 0, 'All Regular Blessings', 0, -650, 1641852798, 0),
(2, 1, 0, 'Permanent Prey Slot', 0, -900, 1658939207, 0),
(3, 1, 0, 'XP Boost', 0, -30, 1658941442, 0),
(4, 2, 0, 'Lasting Exercise Wand', 0, -720, 1662744118, 0),
(5, 2, 0, 'All Regular Blessings', 0, -130, 1662745892, 0),
(6, 2, 0, 'Tournament Accolade', 0, -500, 1662752660, 0),
(7, 2, 0, 'Jousting Eagle Baby', 0, -800, 1662754572, 0),
(8, 2, 0, 'Tournament Accolade', 0, -500, 1662756374, 0),
(9, 2, 0, 'Tournament Accolade', 2, -500, 1662757343, 0),
(10, 2, 0, 'Tournament Accolade', 2, -500, 1662757362, 0),
(11, 2, 0, 'Sublime Tournament Accolade', 2, -500, 1662757489, 0),
(12, 2, 0, 'Baby Brain Squid', 0, -800, 1662757501, 0),
(13, 2, 0, '360 Days of Premium Time', 0, -3000, 1662904710, 0),
(14, 3, 0, '360 Days of Premium Time', 0, -3000, 1663091610, 0),
(15, 2, 0, 'Cerberus Champion Puppy', 2, -800, 1663847394, 0),
(16, 2, 0, 'XP Boost', 0, -30, 1663871115, 0),
(17, 2, 0, 'Cerberus Champion Puppy', 2, -800, 1664039700, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tickets`
--

CREATE TABLE `tickets` (
  `ticket_id` int(11) NOT NULL,
  `ticket_subject` varchar(255) DEFAULT NULL,
  `ticket_author` varchar(255) DEFAULT NULL,
  `ticket_author_acc_id` int(11) NOT NULL,
  `ticket_last_reply` varchar(11) DEFAULT NULL,
  `ticket_admin_reply` int(11) DEFAULT NULL,
  `ticket_date` varchar(255) DEFAULT NULL,
  `ticket_ended` varchar(255) DEFAULT NULL,
  `ticket_status` varchar(255) DEFAULT NULL,
  `ticket_category` varchar(255) DEFAULT NULL,
  `ticket_description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tickets_reply`
--

CREATE TABLE `tickets_reply` (
  `reply_id` int(11) NOT NULL,
  `ticket_id` int(11) DEFAULT NULL,
  `reply_author` varchar(255) DEFAULT NULL,
  `reply_message` varchar(255) DEFAULT NULL,
  `reply_date` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tile_store`
--

CREATE TABLE `tile_store` (
  `house_id` int(11) NOT NULL,
  `data` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tmpwoe`
--

CREATE TABLE `tmpwoe` (
  `started` int(11) NOT NULL,
  `guild` int(11) NOT NULL,
  `breaker` int(111) NOT NULL,
  `time` int(1) NOT NULL,
  `indexer` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `tmpwoe`
--

INSERT INTO `tmpwoe` (`started`, `guild`, `breaker`, `time`, `indexer`) VALUES
(1664056498, 2, 268435463, 1664056622, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `towns`
--

CREATE TABLE `towns` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `posx` int(11) NOT NULL DEFAULT '0',
  `posy` int(11) NOT NULL DEFAULT '0',
  `posz` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `towns`
--

INSERT INTO `towns` (`id`, `name`, `posx`, `posy`, `posz`) VALUES
(1, 'Refugia', 98, 101, 6),
(2, 'Florest', 484, 448, 7),
(3, 'Kalte', 1428, 291, 6),
(4, 'Orn City', 262, 851, 10),
(5, 'Terona City', 387, 550, 7),
(6, 'Vip city', 264, 50, 7);

-- --------------------------------------------------------

--
-- Estrutura da tabela `woe`
--

CREATE TABLE `woe` (
  `id` int(11) NOT NULL,
  `started` int(11) NOT NULL,
  `guild` int(11) NOT NULL,
  `breaker` int(11) NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `woe`
--

INSERT INTO `woe` (`id`, `started`, `guild`, `breaker`, `time`) VALUES
(1, 1642715788, 2, 268435463, 1642716291),
(2, 1664052354, 2, 268435463, 1664052456),
(3, 1664054637, 3, 268435468, 1664055173),
(4, 1664056498, 2, 268435463, 1664056622);

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_forum`
--

CREATE TABLE `z_forum` (
  `id` int(11) NOT NULL,
  `first_post` int(11) NOT NULL DEFAULT '0',
  `last_post` int(11) NOT NULL DEFAULT '0',
  `section` int(3) NOT NULL DEFAULT '0',
  `replies` int(20) NOT NULL DEFAULT '0',
  `views` int(20) NOT NULL DEFAULT '0',
  `author_aid` int(20) NOT NULL DEFAULT '0',
  `author_guid` int(20) NOT NULL DEFAULT '0',
  `post_text` text NOT NULL,
  `post_topic` varchar(255) NOT NULL,
  `post_smile` tinyint(1) NOT NULL DEFAULT '0',
  `post_html` tinyint(1) NOT NULL DEFAULT '0',
  `post_date` int(20) NOT NULL DEFAULT '0',
  `last_edit_aid` int(20) NOT NULL DEFAULT '0',
  `edit_date` int(20) NOT NULL DEFAULT '0',
  `post_ip` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `icon_id` int(11) NOT NULL,
  `news_icon` varchar(50) NOT NULL,
  `sticked` tinyint(1) NOT NULL DEFAULT '0',
  `closed` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `z_forum`
--

INSERT INTO `z_forum` (`id`, `first_post`, `last_post`, `section`, `replies`, `views`, `author_aid`, `author_guid`, `post_text`, `post_topic`, `post_smile`, `post_html`, `post_date`, `last_edit_aid`, `edit_date`, `post_ip`, `icon_id`, `news_icon`, `sticked`, `closed`) VALUES
(1, 1, 1642011224, 3, 0, 2, 1, 7, '<p>adasdasdasdasdasdsa</p>', 'Teste', 0, 0, 1642011224, 0, 0, '127.0.0.1', 27, '', 0, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_hunt_wiki`
--

CREATE TABLE `z_hunt_wiki` (
  `id` int(11) NOT NULL,
  `city` int(2) NOT NULL DEFAULT '0',
  `monster` varchar(50) NOT NULL DEFAULT '0',
  `level` int(5) NOT NULL DEFAULT '0',
  `type` int(2) NOT NULL DEFAULT '0',
  `image_url` varchar(255) NOT NULL DEFAULT '0',
  `video_url` varchar(500) NOT NULL DEFAULT '0',
  `id_user` int(11) NOT NULL DEFAULT '1',
  `active` int(2) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `z_hunt_wiki`
--

INSERT INTO `z_hunt_wiki` (`id`, `city`, `monster`, `level`, `type`, `image_url`, `video_url`, `id_user`, `active`) VALUES
(1, 1, 'Dragon Lord', 50, 5, 'http://127.0.0.1/layouts/realsoft/images/wiki/hunts/artemisias-hunts.png', 'https://www.youtube-nocookie.com/embed/g9Wu0FMP68A', 1, 1),
(2, 6, 'Dragon Lair', 30, 2, 'http://127.0.0.1/layouts/realsoft/images/wiki/hunts/Nissea-hunts.png', 'https://www.youtube-nocookie.com/embed/g9Wu0FMP68A', 1, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_network_box`
--

CREATE TABLE `z_network_box` (
  `id` int(11) NOT NULL,
  `network_name` varchar(10) NOT NULL,
  `network_link` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_news_tickers`
--

CREATE TABLE `z_news_tickers` (
  `date` int(11) NOT NULL DEFAULT '1',
  `author` int(11) NOT NULL,
  `image_id` int(3) NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  `hide_ticker` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_ots_comunication`
--

CREATE TABLE `z_ots_comunication` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `param1` int(11) NOT NULL,
  `param2` int(11) NOT NULL,
  `param3` int(11) NOT NULL,
  `param4` int(11) NOT NULL,
  `param5` varchar(255) NOT NULL,
  `param6` varchar(255) NOT NULL,
  `param7` int(11) NOT NULL,
  `param8` int(11) NOT NULL,
  `param9` varchar(255) NOT NULL,
  `delete_it` int(2) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_ots_guildcomunication`
--

CREATE TABLE `z_ots_guildcomunication` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `param1` varchar(255) NOT NULL,
  `param2` varchar(255) NOT NULL,
  `param3` varchar(255) NOT NULL,
  `param4` varchar(255) NOT NULL,
  `param5` varchar(255) NOT NULL,
  `param6` varchar(255) NOT NULL,
  `param7` varchar(255) NOT NULL,
  `delete_it` int(2) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_polls`
--

CREATE TABLE `z_polls` (
  `id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `end` int(11) NOT NULL,
  `start` int(11) NOT NULL,
  `answers` int(11) NOT NULL,
  `votes_all` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_polls_answers`
--

CREATE TABLE `z_polls_answers` (
  `poll_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `answer` varchar(255) NOT NULL,
  `votes` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_replay`
--

CREATE TABLE `z_replay` (
  `title` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_shop_categories`
--

CREATE TABLE `z_shop_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `z_shop_categories`
--

INSERT INTO `z_shop_categories` (`id`, `name`, `description`, `hidden`) VALUES
(1, 'item', 'Items', 0),
(2, 'addon', 'Addons', 0),
(3, 'mount', 'Mounts', 0),
(4, 'pacc', 'Premium Account', 0),
(5, 'container', 'Containers', 0),
(6, 'other', 'Other', 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_shop_category`
--

CREATE TABLE `z_shop_category` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `desc` varchar(255) NOT NULL,
  `button` varchar(50) NOT NULL,
  `hide` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `z_shop_category`
--

INSERT INTO `z_shop_category` (`id`, `name`, `desc`, `button`, `hide`) VALUES
(2, 'Extra Services', 'Buy an extra service to transfer a character to another game world, to change your character name or sex, to change your account name, or to get a new recovery key.', '_sbutton_getextraservice.gif', 0),
(3, 'Mounts', 'Buy your characters one or more of the fabulous mounts offered here.', '_sbutton_getmount.gif', 0),
(4, 'Outfits', 'Buy your characters one or more of the fancy outfits offered here.', '_sbutton_getoutfit.gif', 0),
(5, 'Items', 'Buy items for your character be more stronger in the game.', '_sbutton_getitem.gif', 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_shop_donates`
--

CREATE TABLE `z_shop_donates` (
  `id` int(11) NOT NULL,
  `date` bigint(20) NOT NULL,
  `reference` varchar(50) NOT NULL,
  `account_name` varchar(50) NOT NULL,
  `method` varchar(50) NOT NULL,
  `price` varchar(20) NOT NULL,
  `coins` int(11) NOT NULL,
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_shop_donate_confirm`
--

CREATE TABLE `z_shop_donate_confirm` (
  `id` int(11) NOT NULL,
  `date` bigint(20) NOT NULL,
  `account_name` varchar(50) NOT NULL,
  `donate_id` int(11) NOT NULL,
  `msg` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_shop_history`
--

CREATE TABLE `z_shop_history` (
  `id` int(11) NOT NULL,
  `comunication_id` int(11) NOT NULL DEFAULT '0',
  `to_name` varchar(255) NOT NULL DEFAULT '0',
  `to_account` int(11) NOT NULL DEFAULT '0',
  `from_nick` varchar(255) NOT NULL DEFAULT '',
  `from_account` int(11) NOT NULL DEFAULT '0',
  `price` int(11) NOT NULL DEFAULT '0',
  `offer_id` int(11) NOT NULL DEFAULT '0',
  `trans_state` varchar(255) NOT NULL,
  `trans_start` int(11) NOT NULL DEFAULT '0',
  `trans_real` int(11) NOT NULL DEFAULT '0',
  `is_pacc` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_shop_history_item`
--

CREATE TABLE `z_shop_history_item` (
  `id` int(11) NOT NULL,
  `to_name` varchar(255) NOT NULL DEFAULT '0',
  `to_account` int(11) NOT NULL DEFAULT '0',
  `from_nick` varchar(255) NOT NULL,
  `from_account` int(11) NOT NULL DEFAULT '0',
  `price` int(11) NOT NULL DEFAULT '0',
  `offer_id` varchar(255) NOT NULL DEFAULT '',
  `trans_state` varchar(255) NOT NULL,
  `trans_start` int(11) NOT NULL DEFAULT '0',
  `trans_real` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_shop_offer`
--

CREATE TABLE `z_shop_offer` (
  `id` int(11) NOT NULL,
  `category` int(11) NOT NULL,
  `coins` int(11) NOT NULL DEFAULT '0',
  `price` varchar(50) NOT NULL,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `mount_id` varchar(100) NOT NULL,
  `addon_name` varchar(100) NOT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  `offer_type` varchar(255) DEFAULT NULL,
  `offer_description` text NOT NULL,
  `offer_name` varchar(255) NOT NULL,
  `offer_date` int(11) NOT NULL,
  `default_image` varchar(50) NOT NULL,
  `hide` int(11) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `z_shop_offer`
--

INSERT INTO `z_shop_offer` (`id`, `category`, `coins`, `price`, `itemid`, `mount_id`, `addon_name`, `count`, `offer_type`, `offer_description`, `offer_name`, `offer_date`, `default_image`, `hide`, `hidden`) VALUES
(1, 2, 250, '0', 0, '0', '', 1, 'changename', 'Buy a character name change to rename one of your characters.', 'Character Change Name', 1637974191, 'changename.png', 0, 1),
(2, 2, 250, '0', 0, '0', '', 1, 'changesex', 'Buy a character sex change to turn your male character into a female one, or your female character into a male one.', 'Character Change Sex', 1637974191, 'changesex.png', 1, 1),
(3, 2, 250, '0', 0, '0', '', 1, 'changeaccountname', 'Buy an account name change to select a different name for your account.', 'Account Name Change', 1637974191, 'changeaccountname.png', 0, 1),
(4, 2, 250, '0', 0, '0', '', 1, 'newrk', 'If you need a new recovery key, you can order it here. Note that the letter for the new recovery key can only be sent to the address in the account registration.', 'Recovery Key', 1637974191, 'newrk.png', 0, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_shop_payment`
--

CREATE TABLE `z_shop_payment` (
  `id` int(11) NOT NULL,
  `ref` varchar(10) NOT NULL,
  `account_name` varchar(50) NOT NULL,
  `service_id` int(11) NOT NULL,
  `service_category_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `price` varchar(50) NOT NULL,
  `coins` int(11) UNSIGNED NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'waiting',
  `date` int(11) NOT NULL,
  `gift` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `name_2` (`name`),
  ADD UNIQUE KEY `name_3` (`name`);

--
-- Indexes for table `accounts_storage`
--
ALTER TABLE `accounts_storage`
  ADD PRIMARY KEY (`account_id`,`key`);

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
  ADD KEY `banned_by` (`banned_by`),
  ADD KEY `account_id_2` (`account_id`),
  ADD KEY `account_id_3` (`account_id`),
  ADD KEY `account_id_4` (`account_id`),
  ADD KEY `account_id_5` (`account_id`);

--
-- Indexes for table `account_character_sale`
--
ALTER TABLE `account_character_sale`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_player_UNIQUE` (`id_player`),
  ADD KEY `account_character_sale_ibfk_2` (`id_account`);

--
-- Indexes for table `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD UNIQUE KEY `account_player_index` (`account_id`,`player_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `blessings_history`
--
ALTER TABLE `blessings_history`
  ADD KEY `blessings_history_ibfk_1` (`player_id`);

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
  ADD KEY `account_id` (`account_id`),
  ADD KEY `coins_transactions_pk` (`account_id`);

--
-- Indexes for table `crypto_payments`
--
ALTER TABLE `crypto_payments`
  ADD PRIMARY KEY (`paymentID`),
  ADD UNIQUE KEY `key3` (`boxID`,`orderID`,`userID`,`txID`,`amount`,`addr`),
  ADD KEY `boxID` (`boxID`),
  ADD KEY `boxType` (`boxType`),
  ADD KEY `userID` (`userID`),
  ADD KEY `countryID` (`countryID`),
  ADD KEY `orderID` (`orderID`),
  ADD KEY `amount` (`amount`),
  ADD KEY `amountUSD` (`amountUSD`),
  ADD KEY `coinLabel` (`coinLabel`),
  ADD KEY `unrecognised` (`unrecognised`),
  ADD KEY `addr` (`addr`),
  ADD KEY `txID` (`txID`),
  ADD KEY `txDate` (`txDate`),
  ADD KEY `txConfirmed` (`txConfirmed`),
  ADD KEY `txCheckDate` (`txCheckDate`),
  ADD KEY `processed` (`processed`),
  ADD KEY `processedDate` (`processedDate`),
  ADD KEY `recordCreated` (`recordCreated`),
  ADD KEY `key1` (`boxID`,`orderID`),
  ADD KEY `key2` (`boxID`,`orderID`,`userID`);

--
-- Indexes for table `daily_reward_history`
--
ALTER TABLE `daily_reward_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `free_pass`
--
ALTER TABLE `free_pass`
  ADD KEY `free_pass_ibfk_1` (`player_id`);

--
-- Indexes for table `global_storage`
--
ALTER TABLE `global_storage`
  ADD UNIQUE KEY `key` (`key`);

--
-- Indexes for table `guilds`
--
ALTER TABLE `guilds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `ownerid` (`ownerid`);

--
-- Indexes for table `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `warid` (`warid`);

--
-- Indexes for table `guild_actions_h`
--
ALTER TABLE `guild_actions_h`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `guild_transfer_h`
--
ALTER TABLE `guild_transfer_h`
  ADD PRIMARY KEY (`id`);

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
  ADD KEY `house_id` (`house_id`);

--
-- Indexes for table `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD PRIMARY KEY (`ip`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Indexes for table `live_casts`
--
ALTER TABLE `live_casts`
  ADD UNIQUE KEY `player_id_2` (`player_id`);

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
-- Indexes for table `newsticker`
--
ALTER TABLE `newsticker`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pagseguro_transactions`
--
ALTER TABLE `pagseguro_transactions`
  ADD UNIQUE KEY `transaction_code` (`transaction_code`,`status`),
  ADD KEY `name` (`name`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `vocation` (`vocation`);

--
-- Indexes for table `players_online`
--
ALTER TABLE `players_online`
  ADD PRIMARY KEY (`player_id`);

--
-- Indexes for table `player_binary_items`
--
ALTER TABLE `player_binary_items`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`type`);

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
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`);

--
-- Indexes for table `player_former_names`
--
ALTER TABLE `player_former_names`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

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
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`);

--
-- Indexes for table `player_items`
--
ALTER TABLE `player_items`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `sid` (`sid`);

--
-- Indexes for table `player_kills`
--
ALTER TABLE `player_kills`
  ADD KEY `player_kills_ibfk_1` (`player_id`),
  ADD KEY `player_kills_ibfk_2` (`target`);

--
-- Indexes for table `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `namelocked_by` (`namelocked_by`);

--
-- Indexes for table `player_preydata`
--
ALTER TABLE `player_preydata`
  ADD PRIMARY KEY (`player_id`);

--
-- Indexes for table `player_rewards`
--
ALTER TABLE `player_rewards`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`);

--
-- Indexes for table `player_spells`
--
ALTER TABLE `player_spells`
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `player_storage`
--
ALTER TABLE `player_storage`
  ADD PRIMARY KEY (`player_id`,`key`);

--
-- Indexes for table `quickloot_containers`
--
ALTER TABLE `quickloot_containers`
  ADD KEY `fk_quickloot_containers_player_id` (`player_id`);

--
-- Indexes for table `sellchar`
--
ALTER TABLE `sellchar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sell_players`
--
ALTER TABLE `sell_players`
  ADD PRIMARY KEY (`player_id`);

--
-- Indexes for table `sell_players_history`
--
ALTER TABLE `sell_players_history`
  ADD PRIMARY KEY (`player_id`,`buytime`) USING BTREE;

--
-- Indexes for table `server_config`
--
ALTER TABLE `server_config`
  ADD PRIMARY KEY (`config`);

--
-- Indexes for table `snowballwar`
--
ALTER TABLE `snowballwar`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `store_history`
--
ALTER TABLE `store_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `store_history_pk` (`account_id`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `tickets_ibfk_1` (`ticket_author_acc_id`);

--
-- Indexes for table `tickets_reply`
--
ALTER TABLE `tickets_reply`
  ADD PRIMARY KEY (`reply_id`),
  ADD KEY `tickets_reply_ibfk_1` (`ticket_id`);

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
-- Indexes for table `woe`
--
ALTER TABLE `woe`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `z_forum`
--
ALTER TABLE `z_forum`
  ADD PRIMARY KEY (`id`),
  ADD KEY `section` (`section`);

--
-- Indexes for table `z_hunt_wiki`
--
ALTER TABLE `z_hunt_wiki`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `z_ots_comunication`
--
ALTER TABLE `z_ots_comunication`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `z_ots_guildcomunication`
--
ALTER TABLE `z_ots_guildcomunication`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `z_shop_categories`
--
ALTER TABLE `z_shop_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `z_shop_category`
--
ALTER TABLE `z_shop_category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `z_shop_donates`
--
ALTER TABLE `z_shop_donates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `z_shop_donate_confirm`
--
ALTER TABLE `z_shop_donate_confirm`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `z_shop_history`
--
ALTER TABLE `z_shop_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `z_shop_offer`
--
ALTER TABLE `z_shop_offer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `z_shop_payment`
--
ALTER TABLE `z_shop_payment`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `account_ban_history`
--
ALTER TABLE `account_ban_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `account_character_sale`
--
ALTER TABLE `account_character_sale`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `coins_transactions`
--
ALTER TABLE `coins_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `crypto_payments`
--
ALTER TABLE `crypto_payments`
  MODIFY `paymentID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `daily_reward_history`
--
ALTER TABLE `daily_reward_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `guilds`
--
ALTER TABLE `guilds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `guild_actions_h`
--
ALTER TABLE `guild_actions_h`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `guild_ranks`
--
ALTER TABLE `guild_ranks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `guild_transfer_h`
--
ALTER TABLE `guild_transfer_h`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `guild_wars`
--
ALTER TABLE `guild_wars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=659;
--
-- AUTO_INCREMENT for table `market_history`
--
ALTER TABLE `market_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `market_offers`
--
ALTER TABLE `market_offers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `myaac_admin_menu`
--
ALTER TABLE `myaac_admin_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;
--
-- AUTO_INCREMENT for table `myaac_monsters`
--
ALTER TABLE `myaac_monsters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `myaac_news`
--
ALTER TABLE `myaac_news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
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
-- AUTO_INCREMENT for table `newsticker`
--
ALTER TABLE `newsticker`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `player_former_names`
--
ALTER TABLE `player_former_names`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `player_hirelings`
--
ALTER TABLE `player_hirelings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `sellchar`
--
ALTER TABLE `sellchar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `snowballwar`
--
ALTER TABLE `snowballwar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `store_history`
--
ALTER TABLE `store_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `ticket_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tickets_reply`
--
ALTER TABLE `tickets_reply`
  MODIFY `reply_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `towns`
--
ALTER TABLE `towns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `woe`
--
ALTER TABLE `woe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `z_forum`
--
ALTER TABLE `z_forum`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `z_hunt_wiki`
--
ALTER TABLE `z_hunt_wiki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `z_ots_comunication`
--
ALTER TABLE `z_ots_comunication`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `z_ots_guildcomunication`
--
ALTER TABLE `z_ots_guildcomunication`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `z_shop_categories`
--
ALTER TABLE `z_shop_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `z_shop_category`
--
ALTER TABLE `z_shop_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `z_shop_donates`
--
ALTER TABLE `z_shop_donates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `z_shop_donate_confirm`
--
ALTER TABLE `z_shop_donate_confirm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `z_shop_history`
--
ALTER TABLE `z_shop_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `z_shop_offer`
--
ALTER TABLE `z_shop_offer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `z_shop_payment`
--
ALTER TABLE `z_shop_payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `accounts_storage`
--
ALTER TABLE `accounts_storage`
  ADD CONSTRAINT `accounts_storage_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `account_bans`
--
ALTER TABLE `account_bans`
  ADD CONSTRAINT `account_bans_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_bans_ibfk_2` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD CONSTRAINT `account_ban_history_ibfk_2` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_ban_history_ibfk_3` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_ban_history_ibfk_4` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_ban_history_ibfk_5` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_ban_history_ibfk_6` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `account_character_sale`
--
ALTER TABLE `account_character_sale`
  ADD CONSTRAINT `account_character_sale_ibfk_1` FOREIGN KEY (`id_player`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_character_sale_ibfk_2` FOREIGN KEY (`id_account`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD CONSTRAINT `account_viplist_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_viplist_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `blessings_history`
--
ALTER TABLE `blessings_history`
  ADD CONSTRAINT `blessings_history_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `free_pass`
--
ALTER TABLE `free_pass`
  ADD CONSTRAINT `free_pass_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guilds`
--
ALTER TABLE `guilds`
  ADD CONSTRAINT `guilds_ibfk_1` FOREIGN KEY (`ownerid`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD CONSTRAINT `guildwar_kills_ibfk_1` FOREIGN KEY (`warid`) REFERENCES `guild_wars` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD CONSTRAINT `guild_invites_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guild_invites_ibfk_2` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guild_membership`
--
ALTER TABLE `guild_membership`
  ADD CONSTRAINT `guild_membership_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_membership_ibfk_2` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_membership_ibfk_3` FOREIGN KEY (`rank_id`) REFERENCES `guild_ranks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD CONSTRAINT `guild_ranks_ibfk_1` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `house_lists`
--
ALTER TABLE `house_lists`
  ADD CONSTRAINT `house_lists_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD CONSTRAINT `ip_bans_ibfk_1` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `live_casts`
--
ALTER TABLE `live_casts`
  ADD CONSTRAINT `live_casts_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `market_history`
--
ALTER TABLE `market_history`
  ADD CONSTRAINT `market_history_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `market_offers`
--
ALTER TABLE `market_offers`
  ADD CONSTRAINT `market_offers_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD CONSTRAINT `player_deaths_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD CONSTRAINT `player_depotitems_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_hirelings`
--
ALTER TABLE `player_hirelings`
  ADD CONSTRAINT `player_hirelings_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD CONSTRAINT `player_inboxitems_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_items`
--
ALTER TABLE `player_items`
  ADD CONSTRAINT `player_items_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_kills`
--
ALTER TABLE `player_kills`
  ADD CONSTRAINT `player_kills_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `player_kills_ibfk_2` FOREIGN KEY (`target`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD CONSTRAINT `player_namelocks_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `player_namelocks_ibfk_2` FOREIGN KEY (`namelocked_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `player_preydata`
--
ALTER TABLE `player_preydata`
  ADD CONSTRAINT `player_preydata_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `player_rewards`
--
ALTER TABLE `player_rewards`
  ADD CONSTRAINT `player_rewards_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_spells`
--
ALTER TABLE `player_spells`
  ADD CONSTRAINT `player_spells_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_storage`
--
ALTER TABLE `player_storage`
  ADD CONSTRAINT `player_storage_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `quickloot_containers`
--
ALTER TABLE `quickloot_containers`
  ADD CONSTRAINT `fk_quickloot_containers_player_id` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`);

--
-- Limitadores para a tabela `sellchar`
--
ALTER TABLE `sellchar`
  ADD CONSTRAINT `sellchar_ibfk_1` FOREIGN KEY (`id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `sell_players`
--
ALTER TABLE `sell_players`
  ADD CONSTRAINT `sell_players_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `sell_players_history`
--
ALTER TABLE `sell_players_history`
  ADD CONSTRAINT `sell_players_history_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`ticket_author_acc_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `tickets_reply`
--
ALTER TABLE `tickets_reply`
  ADD CONSTRAINT `tickets_reply_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`ticket_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `tile_store`
--
ALTER TABLE `tile_store`
  ADD CONSTRAINT `tile_store_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
