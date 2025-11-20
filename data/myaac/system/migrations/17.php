<?php

if(!$db->hasTable('myaac_menu')) {
	$db->query("
CREATE TABLE `myaac_menu`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`template` VARCHAR(255) NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`link` VARCHAR(255) NOT NULL,
	`category` INT(11) NOT NULL DEFAULT 1,
	`ordering` INT(11) NOT NULL DEFAULT 0,
	`enabled` INT(1) NOT NULL DEFAULT 1,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;
");

	$db->query("
/* MENU_CATEGORY_NEWS kathrine */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Latest News', 'news', 1, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'News Archive', 'news/archive', 1, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Changelog', 'changelog', 1, 2);
/* MENU_CATEGORY_ACCOUNT kathrine */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Account Management', 'account/manage', 2, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Create Account', 'account/create', 2, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Lost Account?', 'account/lost', 2, 2);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Server Rules', 'rules', 2, 3);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Downloads', 'downloads', 5, 4);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Report Bug', 'bugtracker', 2, 5);
/* MENU_CATEGORY_COMMUNITY kathrine */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Who is Online?', 'online', 3, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Characters', 'characters', 3, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Guilds', 'guilds', 3, 2);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Highscores', 'highscores', 3, 3);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Last Deaths', 'lastkills', 3, 4);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Houses', 'houses', 3, 5);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Bans', 'bans', 3, 6);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Forum', 'forum', 3, 7);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Team', 'team', 3, 8);
/* MENU_CATEGORY_LIBRARY kathrine */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Monsters', 'creatures', 5, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Spells', 'spells', 5, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Server Info', 'serverInfo', 5, 2);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Commands', 'commands', 5, 3);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Gallery', 'gallery', 5, 4);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Experience Table', 'experienceTable', 5, 5);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'FAQ', 'faq', 5, 6);
/* MENU_CATEGORY_SHOP kathrine */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Donate', 'donate', 6, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Boxes', 'boxes', 6, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Shop Offer', 'gifts', 6, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('kathrine', 'Shop History', 'gifts/history', 6, 2);
/* MENU_CATEGORY_NEWS tibiacom */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Latest News', 'news', 1, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'News Archive', 'news/archive', 1, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Changelog', 'changelog', 1, 2);
/* MENU_CATEGORY_ACCOUNT tibiacom */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Account Management', 'account/manage', 2, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Create Account', 'account/create', 2, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Lost Account?', 'account/lost', 2, 2);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Server Rules', 'rules', 2, 3);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Downloads', 'downloads', 2, 4);
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
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Exp Stages', 'experienceStages', 5, 3);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Gallery', 'gallery', 5, 4);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Server Info', 'serverInfo', 5, 5);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Experience Table', 'experienceTable', 5, 6);
/* MENU_CATEGORY_SHOP tibiacom */
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Buy Points', 'points', 6, 0);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Shop Offer', 'gifts', 6, 1);
INSERT INTO `myaac_menu` (`template`, `name`, `link`, `category`, `ordering`) VALUES ('tibiacom', 'Shop History', 'gifts/history', 6, 2);
	");
}
?>
