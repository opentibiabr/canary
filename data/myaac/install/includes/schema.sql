SET @myaac_database_version = 34;

CREATE TABLE `myaac_account_actions`
(
	`account_id` INT(11) NOT NULL,
	`ip` VARCHAR(16) NOT NULL default '0.0.0.0',
	`ipv6` BINARY(16) NOT NULL DEFAULT 0,
	`date` INT(11) NOT NULL DEFAULT 0,
	`action` VARCHAR(255) NOT NULL DEFAULT '',
	KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_admin_menu`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL DEFAULT '',
	`page` VARCHAR(255) NOT NULL DEFAULT '',
	`ordering` INT(11) NOT NULL DEFAULT 0,
	`flags` INT(11) NOT NULL DEFAULT 0,
	`enabled` INT(1) NOT NULL DEFAULT 1,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_bugtracker`
(
	`account` VARCHAR(255) NOT NULL,
	`type` INT(11) NOT NULL DEFAULT 0,
	`status` INT(11) NOT NULL DEFAULT 0,
	`text` text NOT NULL,
	`id` INT(11) NOT NULL DEFAULT 0,
	`subject` VARCHAR(255) NOT NULL DEFAULT '',
	`reply` INT(11) NOT NULL DEFAULT 0,
	`who` INT(11) NOT NULL DEFAULT 0,
	`uid` INT(11) NOT NULL AUTO_INCREMENT,
	`tag` INT(11) NOT NULL DEFAULT 0,
	PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_changelog`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`body` VARCHAR(500) NOT NULL DEFAULT '',
	`type` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 - added, 2 - removed, 3 - changed, 4 - fixed',
	`where` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 - server, 2 - site',
	`date` INT(11) NOT NULL DEFAULT 0,
	`player_id` INT(11) NOT NULL DEFAULT 0,
	`hidden` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO `myaac_changelog` (`id`, `type`, `where`, `date`, `body`, `hidden`) VALUES (1, 3, 2, UNIX_TIMESTAMP(), 'MyAAC installed. (:', 0);

CREATE TABLE `myaac_charbazaar` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `account_old` int(11) NOT NULL,
  `account_new` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `date_end` datetime NOT NULL,
  `date_start` datetime NOT NULL,
  `bid_account` int(11) NOT NULL,
  `bid_price` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_charbazaar_bid` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `auction_id` int(11) NOT NULL,
  `bid` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_config`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(30) NOT NULL,
	`value` VARCHAR(1000) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE (`name`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO `myaac_config` (`name`, `value`) VALUES ('database_version', @myaac_database_version);

CREATE TABLE `myaac_faq`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`question` VARCHAR(255) NOT NULL DEFAULT '',
	`answer` VARCHAR(1020) NOT NULL DEFAULT '',
	`ordering` INT(11) NOT NULL DEFAULT 0,
	`hidden` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_forum_boards`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(32) NOT NULL,
	`description` VARCHAR(255) NOT NULL DEFAULT '',
	`ordering` INT(11) NOT NULL DEFAULT 0,
	`guild` INT(11) NOT NULL DEFAULT 0,
	`access` INT(11) NOT NULL DEFAULT 0,
	`closed` TINYINT(1) NOT NULL DEFAULT 0,
	`hidden` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;
INSERT INTO `myaac_forum_boards` (`id`, `name`, `description`, `ordering`, `closed`) VALUES (NULL, 'News', 'News commenting', 0, 1);
INSERT INTO `myaac_forum_boards` (`id`, `name`, `description`, `ordering`) VALUES (NULL, 'Trade', 'Trade offers.', 1);
INSERT INTO `myaac_forum_boards` (`id`, `name`, `description`, `ordering`) VALUES (NULL, 'Quests', 'Quest making.', 2);
INSERT INTO `myaac_forum_boards` (`id`, `name`, `description`, `ordering`) VALUES (NULL, 'Pictures', 'Your pictures.', 3);
INSERT INTO `myaac_forum_boards` (`id`, `name`, `description`, `ordering`) VALUES (NULL, 'Bug Report', 'Report bugs there.', 4);

CREATE TABLE `myaac_forum`
(
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`first_post` int(11) NOT NULL default '0',
	`last_post` int(11) NOT NULL default '0',
	`section` int(3) NOT NULL default '0',
	`replies` int(20) NOT NULL default '0',
	`views` int(20) NOT NULL default '0',
	`author_aid` int(20) NOT NULL default '0',
	`author_guid` int(20) NOT NULL default '0',
	`post_text` text NOT NULL,
	`post_topic` varchar(255) NOT NULL DEFAULT '',
	`post_smile` tinyint(1) NOT NULL default '0',
	`post_html` tinyint(1) NOT NULL default '0',
	`post_date` int(20) NOT NULL default '0',
	`last_edit_aid` int(20) NOT NULL default '0',
	`edit_date` int(20) NOT NULL default '0',
	`post_ip` varchar(32) NOT NULL default '0.0.0.0',
	`sticked` tinyint(1) NOT NULL DEFAULT '0',
	`closed` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	KEY `section` (`section`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_menu`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`template` VARCHAR(255) NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`link` VARCHAR(255) NOT NULL,
	`blank` TINYINT(1) NOT NULL DEFAULT 0,
	`color` VARCHAR(6) NOT NULL DEFAULT '',
	`category` INT(11) NOT NULL DEFAULT 1,
	`ordering` INT(11) NOT NULL DEFAULT 0,
	`enabled` INT(1) NOT NULL DEFAULT 1,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

/* MENU_CATEGORY_NEWS tibiacom */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Latest News', 'news', 1, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'News Archive', 'news/archive', 1, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Event Schedule', 'eventcalendar', 1, 2);
/* MENU_CATEGORY_ACCOUNT tibiacom */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Account Management', 'account/manage', 2, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Create Account', 'account/create', 2, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Lost Account?', 'account/lost', 2, 2);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Server Rules', 'rules', 2, 3);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Downloads', 'downloadclient', 2, 4);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Report Bug', 'bugtracker', 2, 5);
/* MENU_CATEGORY_COMMUNITY tibiacom */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Characters', 'characters', 3, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Who Is Online?', 'online', 3, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Highscores', 'highscores', 3, 2);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Last Kills', 'lastkills', 3, 3);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Houses', 'houses', 3, 4);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Guilds', 'guilds', 3, 5);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Polls', 'polls', 3, 6);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Bans', 'bans', 3, 7);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Support List', 'team', 3, 8);
/* MENU_CATEGORY_FORUM tibiacom */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Forum', 'forum', 4, 0);
/* MENU_CATEGORY_LIBRARY tibiacom */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Creatures', 'creatures', 5, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Spells', 'spells', 5, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Commands', 'commands', 5, 2);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Gallery', 'gallery', 5, 3);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Server Info', 'serverInfo', 5, 4);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Experience Table', 'experienceTable', 5, 5);
/* MENU_CATEGORY_CHARBAZAAR tibiacom */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Current Auctions', 'currentcharactertrades', 7, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Auction History', 'pastcharactertrades', 7, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'My Bids', 'ownbids', 7, 2);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'My Auctions', 'owncharactertrades', 7, 3);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Create Auction', 'createcharacterauction', 7, 4);
/* MENU_CATEGORY_SHOP tibiacom */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Donate', 'donate', 6, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Boxes', 'boxes', 6, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Shop Offer', 'gifts', 6, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Shop History', 'gifts/history', 6, 2);

CREATE TABLE `myaac_monsters` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`hidden` tinyint(1) NOT NULL default 0,
	`name` varchar(255) NOT NULL,
	`mana` int(11) NOT NULL DEFAULT 0,
	`exp` int(11) NOT NULL,
	`health` int(11) NOT NULL,
	`speed_lvl` int(11) NOT NULL default 1,
	`use_haste` tinyint(1) NOT NULL,
	`voices` text NOT NULL,
	`immunities` varchar(255) NOT NULL,
	`elements` TEXT NOT NULL,
	`summonable` tinyint(1) NOT NULL,
	`convinceable` tinyint(1) NOT NULL,
	`pushable` TINYINT(1) NOT NULL DEFAULT '0',
	`canpushitems` TINYINT(1) NOT NULL DEFAULT '0',
	`canwalkonenergy` TINYINT(1) NOT NULL DEFAULT '0',
	`canwalkonpoison` TINYINT(1) NOT NULL DEFAULT '0',
	`canwalkonfire` TINYINT(1) NOT NULL DEFAULT '0',
	`runonhealth` TINYINT(1) NOT NULL DEFAULT '0',
	`hostile` TINYINT(1) NOT NULL DEFAULT '0',
	`attackable` TINYINT(1) NOT NULL DEFAULT '0',
	`rewardboss` TINYINT(1) NOT NULL DEFAULT '0',
	`defense` INT(11) NOT NULL DEFAULT '0',
	`armor` INT(11) NOT NULL DEFAULT '0',
	`canpushcreatures` TINYINT(1) NOT NULL DEFAULT '0',
	`race` varchar(255) NOT NULL,
	`loot` text NOT NULL,
	`summons` TEXT NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_videos`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(100) NOT NULL DEFAULT '',
	`youtube_id` VARCHAR(20) NOT NULL,
	`author` VARCHAR(50) NOT NULL DEFAULT '',
	`ordering` INT(11) NOT NULL DEFAULT 0,
	`hidden` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_news`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(100) NOT NULL,
	`body` TEXT NOT NULL,
	`type` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 - news, 2 - ticker, 3 - article',
	`date` INT(11) NOT NULL DEFAULT 0,
	`category` TINYINT(1) NOT NULL DEFAULT 0,
	`player_id` INT(11) NOT NULL DEFAULT 0,
	`last_modified_by` INT(11) NOT NULL DEFAULT 0,
	`last_modified_date` INT(11) NOT NULL DEFAULT 0,
	`comments` VARCHAR(50) NOT NULL DEFAULT '',
	`article_text` VARCHAR(300) NOT NULL DEFAULT '',
	`article_image` VARCHAR(100) NOT NULL DEFAULT '',
	`hidden` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_news_categories`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL DEFAULT "",
	`description` VARCHAR(50) NOT NULL DEFAULT "",
	`icon_id` INT(2) NOT NULL DEFAULT 0,
	`hidden` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO `myaac_news_categories` (`id`, `icon_id`) VALUES (NULL, 0);
INSERT INTO `myaac_news_categories` (`id`, `icon_id`) VALUES (NULL, 1);
INSERT INTO `myaac_news_categories` (`id`, `icon_id`) VALUES (NULL, 2);
INSERT INTO `myaac_news_categories` (`id`, `icon_id`) VALUES (NULL, 3);
INSERT INTO `myaac_news_categories` (`id`, `icon_id`) VALUES (NULL, 4);

CREATE TABLE `myaac_notepad`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`account_id` INT(11) NOT NULL,
	/*`name` VARCHAR(30) NOT NULL,*/
	`content` TEXT NOT NULL,
	/*`public` TINYINT(1) NOT NULL DEFAULT 0*/
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_pages`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(30) NOT NULL,
	`title` VARCHAR(30) NOT NULL,
	`body` LONGTEXT NOT NULL,
	`date` INT(11) NOT NULL DEFAULT 0,
	`player_id` INT(11) NOT NULL DEFAULT 0,
	`php` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0 - plain html, 1 - php',
	`enable_tinymce` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 - enabled, 0 - disabled',
	`access` TINYINT(2) NOT NULL DEFAULT 0,
	`hidden` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE (`name`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_polls` (
  `id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `end` int(11) NOT NULL,
  `start` int(11) NOT NULL,
  `answers` int(11) NOT NULL,
  `votes_all` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_polls_answers` (
  `poll_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `answer` varchar(255) NOT NULL,
  `votes` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_gallery`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`comment` VARCHAR(255) NOT NULL DEFAULT '',
	`image` VARCHAR(255) NOT NULL,
	`thumb` VARCHAR(255) NOT NULL,
	`author` VARCHAR(50) NOT NULL DEFAULT '',
	`ordering` INT(11) NOT NULL DEFAULT 0,
	`hidden` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO `myaac_gallery` (`id`, `ordering`, `comment`, `image`, `thumb`, `author`) VALUES (NULL, 1, 'Demon', 'images/gallery/demon.jpg', 'images/gallery/demon_thumb.gif', 'MyAAC');

CREATE TABLE `myaac_spells`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`spell` VARCHAR(255) NOT NULL DEFAULT '',
	`name` VARCHAR(255) NOT NULL,
	`words` VARCHAR(255) NOT NULL DEFAULT '',
	`category` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 - attack, 2 - healing, 3 - summon, 4 - supply, 5 - support',
	`type` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 - instant, 2 - conjure, 3 - rune',
	`level` INT(11) NOT NULL DEFAULT 0,
	`maglevel` INT(11) NOT NULL DEFAULT 0,
	`mana` INT(11) NOT NULL DEFAULT 0,
	`soul` TINYINT(3) NOT NULL DEFAULT 0,
	`conjure_id` INT(11) NOT NULL DEFAULT 0,
	`conjure_count` TINYINT(3) NOT NULL DEFAULT 0,
	`reagent` INT(11) NOT NULL DEFAULT 0,
	`item_id` INT(11) NOT NULL DEFAULT 0,
	`premium` TINYINT(1) NOT NULL DEFAULT 0,
	`vocations` VARCHAR(100) NOT NULL DEFAULT '',
	`hidden` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE (`name`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_visitors`
(
	`ip` VARCHAR(45) NOT NULL,
	`lastvisit` INT(11) NOT NULL DEFAULT 0,
	`page` VARCHAR(2048) NOT NULL,
	UNIQUE (`ip`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE `myaac_weapons`
(
	`id` INT(11) NOT NULL,
	`level` INT(11) NOT NULL DEFAULT 0,
	`maglevel` INT(11) NOT NULL DEFAULT 0,
	`vocations` VARCHAR(100) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

ALTER TABLE `server_config` ADD `timestamp` TIMESTAMP on update CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `value`;

ALTER TABLE `accounts` CHANGE `name` `name` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL;
