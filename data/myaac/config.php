<?php
/**
 * This is MyAAC's Main Configuration file
 *
 * All the default values are kept here, you should not modify it but use
 * a config.local.php file instead to override the settings from here.
 *
 * This is a piece of PHP code so PHP syntax applies!
 * For boolean values please use true/false.
 *
 * Minimally 'server_path' directive have to be filled, other options are optional.
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */

$config = array(
	// directories & files
	'server_path' => '', // path to the server directory (same directory where config file is located)

	/**
	 * Environment Setting
	 *
	 * if you use this script on your live server - set to 'prod' (production)
	 * if you want to test and debug the script locally, or develop plugins, set to 'dev' (development)
	 * WARNING: on 'dev' cache is disabled, so site will be significantly slower !!!
	 * WARNING2: on 'dev' all PHP errors/warnings are displayed
	 * Recommended: 'prod' cause of speed (page load time is better)
	 */
	'env' => 'prod', // 'prod' for production and 'dev' for development

	'template' => 'tibiacom', // template used by website (kathrine, tibiacom)
	'template_allow_change' => false, // allow users to choose their own template while browsing website?

	'vocations_amount' => 4, // how much basic vocations your server got (without promotion)

	// what client version are you using on this OT?
	// used for the Downloads page and some templates as well
    'client' => 1321, // 1321 = client 13.21

	'session_prefix' => 'myaac_', // must be unique for every site on your server
	'friendly_urls' => false, // mod_rewrite is required for this, it makes links looks more elegant to eye, and also are SEO friendly (example: https://localhost/guilds/Testing instead of https://localhost?subtopic=guilds&name=Testing). Remember to rename .htaccess.dist to .htaccess
	'gzip_output' => false, // gzip page content before sending it to the browser, uses less bandwidth but more cpu cycles

	// gesior backward support (templates & pages)
	// allows using gesior templates and pages with myaac
	// might bring some performance when disabled
	'backward_support' => true,

	// head options (html)
	'meta_description' => 'Tibia is a free massive multiplayer online role playing game (MMORPG).', // description of the site
	'meta_keywords' => 'free online game, free multiplayer game, ots, open tibia server', // keywords list separated by commas
	'title_separator' => ' - ',

	// footer
	'footer' => ''/*'<br/>Your Server &copy; 2016. All rights reserved.'*/,

	'language' => 'en', // default language (currently only 'en' available)
	'language_allow_change' => false,

	'visitors_counter' => true,
	'visitors_counter_ttl' => 10, // how long visitor will be marked as online (in minutes)
	'views_counter' => true,

	// cache system. by default file cache is used
	'cache_engine' => 'auto', // apc, apcu, eaccelerator, xcache, file, auto, or blank to disable.
	'cache_prefix' => 'myaac_', // have to be unique if running more MyAAC instances on the same server (except file system cache)

	// database details (leave blank for auto detect from config.lua)
	'database_host' => '',
	'database_port' => '', // leave blank to default 3306
	'database_user' => '',
	'database_password' => '',
	'database_name' => '',
	'database_log' => false, // should database queries be logged and and saved into system/logs/database.log?
	'database_socket' => '', // set if you want to connect to database through socket (example: /var/run/mysqld/mysqld.sock)
	'database_persistent' => false, // use database permanent connection (like server), may speed up your site
	'database_encryption' => 'sha1',

	// multiworld system (only TFS 0.3)
	'multiworld' => false, // use multiworld system?
	'worlds' => array( // list of worlds
		//'1' => 'Your World Name',
		//'2' => 'Your Second World Name'
	),

	// images
	'outfit_images_url' => './outfit/animoutfit.php', // set to animoutfit.php for animated outfit
	'item_images_url' => 'images/items/', // set to images/items if you host your own items in images folder

	// account
	'account_management' => true, // disable if you're using other method to manage users (fe. tfs account manager)
	'account_login_by_email' => true, // use email instead of Account Name like in latest Tibia
	'account_login_by_email_fallback' => false, // allow also additionally login by Account Name/Number (for users that might forget their email)
	'account_create_auto_login' => false, // auto login after creating account?
	'account_create_character_create' => true, // allow directly to create character on create account page?
	'account_mail_verify' => false, // force users to confirm their email addresses when registering account
  'account_verified_only' => false, // force users to confirm their email to login in game
  'account_mail_confirmed_reward' => [ // reward users for confirming their E-Mails
      // account_mail_verify needs to be enabled too
      'premium_days' => 0,
      'coins_transferable' => 0,
      'coins' => 0,
      'message' => 'You received %d %s for confirming your E-Mail address.' // example: You received 20 coins for confirming your E-Mail address.
  ],
	'account_mail_unique' => true, // email addresses cannot be duplicated? (one account = one email)
	'account_premium_days' => 0, // default premium days on new account
	'account_welcome_coins' => 0, // default coins on new account
	'account_welcome_mail' => false, // send welcome email when user registers
    'account_welcome_mail_show_pass' => false, // send password in welcome email
	'account_mail_change' => 2, // how many days user need to change email to account - block hackers
	'account_country' => true, // user will be able to set country of origin when registering account, this information will be viewable in others places aswell
	'account_country_recognize' => true, // should country of user be automatically recognized by his IP? This makes an external API call to http://ipinfo.io

    'account_coin_type_usage' => 'coins_transferable', // which coin you want to use, coins or coins_transferable to buy changes at site
    'account_change_character_name' => false, // can user change their character name for coins?
	'account_change_character_name_coins' => 250, // cost of name change
	'account_change_character_sex' => false, // can user change their character sex for coins?
	'account_change_character_sex_coins' => 150, // cost of sex change
    'account_change_character_main' => true, // can user change their main character for coins?
    'account_change_character_main_coins' => 250, // cost of main change
	'characters_per_account' => 10,	// max. number of characters per account
    'account_update_info_on_register' => true, // let player update your 'Public Information' when register at first time only

    // recovery key
    'recovery_key_length' => 15,                // length of recovery key code
    'account_show_rk' => false,
    'generate_new_reckey' => true,				// let player generate new recovery key, he will receive e-mail with new rec key (not display on page, hacker can't generate rec key)
    'generate_new_reckey_price' => 250,			// coins price for new recovery key

	// mail
	'mail_enabled' => false, // is aac maker configured to send e-mails?
	'mail_address' => 'no-reply@your-server.org', // server e-mail address (from:)
	'mail_admin' => 'your-address@your-server.org', // admin email address, where mails from contact form will be sent
	'mail_signature' => array( // signature that will be included at the end of every message sent using _mail function
		'plain' => ""/*"--\nMy Server,\nhttp://www.myserver.com"*/,
		'html' => ''/*'<br/>My Server,\n<a href="http://www.myserver.com">myserver.com</a>'*/
	),
	'smtp_enabled' => false, // send by smtp or mail function (set false if use mail function, set to true if you use GMail or Microsoft Outlook)
	'smtp_host' => '', // mail host. smtp.gmail.com for GMail / smtp-mail.outlook.com for Microsoft Outlook
	'smtp_port' => 25, // 25 (default) / 465 (ssl, GMail) / 587 (tls, Microsoft Outlook)
	'smtp_auth' => true, // need authorization?
	'smtp_user' => 'admin@example.org', // here your email username
	'smtp_pass' => '',
	'smtp_secure' => '', // What kind of encryption to use on the SMTP connection. Options: '', 'ssl' (GMail) or 'tls' (Microsoft Outlook)
	'smtp_debug' => false, // set true to debug (you will see more info in error.log)

	// reCAPTCHA (prevent spam bots)
	'recaptcha_enabled' => false, // enable recaptcha verification code
	'recaptcha_site_key' => '', // get your own site and secret keys at https://www.google.com/recaptcha
	'recaptcha_secret_key' => '',
	'recaptcha_theme' => 'light', // light, dark

	// e-mail senders
	'send_mail_when_change_password' => true,	// send e-mail with new password when change password to account
	'send_mail_when_generate_reckey' => true,	// send e-mail with rec key (key is displayed on page anyway when generate)

	// genders (aka sex)
	'genders' => array(
		0 => 'Female',
		1 => 'Male'
	),

	// vocations
	'vocations' => array(
		0 => 'None',
		1 => 'Sorcerer',
		2 => 'Druid',
		3 => 'Paladin',
		4 => 'Knight',
		5 => 'Master Sorcerer',
		6 => 'Elder Druid',
		7 => 'Royal Paladin',
		8 => 'Elite Knight',
	),

	// new character config
	'character_samples' => array( // vocations, format: ID_of_vocation => 'Name of Character to copy'
		//0 => 'Rook Sample',
		1 => 'Sorcerer Sample',
		2 => 'Druid Sample',
		3 => 'Paladin Sample',
		4 => 'Knight Sample'
	),

    'use_character_sample_skills' => false,

	// it must show limited number of players after using search in character page
	'characters_search_limit' => 15,

	// town list used when creating character
	// won't be displayed if there is only one item (rookgaard for example)
	'character_towns' => array(1),

	// characters length
	// This is the minimum and the maximum length that a player can create a character. It is highly recommend the maximum length to be 21.
	'character_name_min_length' => 4,
	'character_name_max_length' => 21,

	// list of towns
	// if you use TFS 1.3 with support for 'towns' table in database, then you can ignore this - it will be configured automatically (generated from your .OTBM map)
	'towns' => array(
		0 => 'No Town',
		1 => 'Tutorial City',
		5 => 'AbDendriel',
		6 => 'Carlin',
		8 => 'Thais',
		9 => 'Venore',
		10 => 'Ankrahmun',
		11 => 'Edron',
		12 => 'Farmine',
		13 => 'Darashia',
		14 => 'Liberty Bay',
		15 => 'Port Hope',
		16 => 'Svargrond',
		17 => 'Yalahar',
		20 => 'Rathleton'
	),

	// guilds
	'guild_management' => true, // enable guild management system on the site?
	'guild_need_level' => 100, // min. level to form a guild
	'guild_need_premium' => true, // require premium account to form a guild?
	'guild_image_size_kb' => 80, // maximum size of the guild logo image in KB (kilobytes)
	'guild_description_chars_limit' => 1000, // limit of guild description
	'guild_description_lines_limit' => 6, // limit of lines, if description has more lines it will be showed as long text, without 'enters'
	'guild_motd_chars_limit' => 150, // limit of MOTD (message of the day) that is shown later in the game on the guild channel

	// online page
	'online_record' => true, // display players record?
	'online_vocations' => false, // display vocation statistics?
	'online_vocations_images' => false, // display vocation images?
	'online_skulls' => true, // display skull images
	'online_outfit' => true,
	'online_afk' => false,

	// support list page
	'team_style' => 2, // 1/2 (1 - normal table, 2 - in boxes, grouped by group id)
	'team_display_status' => true,
	'team_display_lastlogin' => true,
	'team_display_world' => false,
	'team_display_outfit' => true,

	// bans page
	'bans_limit' => 50,
	'bans_display_all' => true, // should all bans be displayed? (sorted page by page)

	// highscores page
	'highscores_vocation_box' => true, // show 'Choose a vocation' box on the highscores (allowing peoples to sort highscores by vocation)?
	'highscores_vocation' => true, // show player vocation under his nickname?
	'highscores_frags' => false, // show 'Frags' tab (best fraggers on the server)? Only 0.3
	'highscores_balance' => false, // show 'Balance' tab (richest players on the server)
	'highscores_outfit' => true, // show player outfit?
	'highscores_country_box' => false, // doesnt work yet! (not implemented)
	'highscores_groups_hidden' => 3, // this group id and higher won't be shown on the highscores
	'highscores_ids_hidden' => array(0), // this ids of players will be hidden on the highscores (should be ids of samples)
	'highscores_length' => 100, // how many records per page on highscores

	// characters page
	'characters' => array( // what things to display on character view page (true/false in each option)
		'level' => true,
		'experience' => true,
		'magic_level' => true,
		'balance' => true,
		'marriage_info' => true, // only 0.3
		'outfit' => true,
		'creation_date' => true,
		'quests' => true,
		'skills' => true,
		'equipment' => true,
		'frags' => true,
		'deleted' => false, // should deleted characters from same account be still listed on the list of characters? When enabled it will show that character is "[DELETED]"
	),
	'quests' => array( // Canary Storages
		'Demon Helmet' => 40077, // Storage.Quest.U6_4.DemonHelmet.Rewards.DemonHelmet
		'Annihilator' => 10102,
		'Pits Of Inferno' => 52003, // Storage.PitsOfInferno.WeaponReward
		'Inquisition' => 51127, // Storage.TheInquisition.Reward
		'Demon Oak' => 51700,// Maybe 51700
		'SoulWar Quest' => 47223, // Storage.Quest.U12_40.SoulWar.QuestReward
		'Yalahar Quest' => 51249, // Storage.InServiceofYalahar.DoorToReward
		//'Some Quest' => 123,
		//'Some Quest Two' => 456,
	), // quests list (displayed in character view), name => storage

	'achievements_base' => 300000,

	'signature_enabled' => false,
	'signature_type' => 'tibian', // signature engine to use: tibian, mango, gesior
	'signature_cache_time' => 5, // how long to store cached file (in minutes), default 5 minutes
	'signature_browser_cache' => 60, // how long to cache by browser (in minutes), default 1 hour

    'allow_menu_animated' => true, // allow menu with animated gifs

	// news page
	'news_limit' => 5, // limit of news on the latest news page
	'news_ticker_limit' => 5, // limit of news in tickers (mini news) (0 to disable)
	'news_date_format' => 'j.n.Y', // check php manual date() function for more info about this
	'news_author' => false, // show author of the news

	// banner home
	'banner_status' => false,
	'banner_image' => '500x660.png', // templates->tibiacom->images->carousel
	'banner_link' => 'www.instagram.com',

	// status bar
	'status_bar' => true,
	'client_link' => 'https://github.com/dudantas/tibia-client/releases/tag/13.21.13839', // link to download tibia client
	'discord_link' => 'https://discord.com/invite/gvTj5sh9Mp', // link to join discord channel
	'whatsapp_link' => '5511912345678', // wa.me/5511912345678
	'instagram_link' => 'profile', // www.instagram.com/profile
	'facebook_link' => 'page', // www.facebook.com/page
	'collapse_status' => true,

	// events
	'events_xml' => 'data/xml/events.xml',

	// slide
	'carousel_status' => true,
	'carousel' => array(
		'carousel_1' => 'runemaster_small.jpg',
		'carousel_2' => 'merrygarb_small.jpg',
		'carousel_3' => 'mothcape_small.jpg',
	),

	// load page
	'pace_load' => true, // load page top bar
	'pace_theme' => 'flat-top', // big-counter, bounce, center-atom, center-circle, center-radar, center-simple, corner-indicator, fill-left, flash, flat-top, loading-bar, max-osx, material, minimal
	'pace_color' => 'white', // black, blue, green, orange, pink, purple, red, silver, white, yellow

	// char bazaar
	'bazaar_create' => 50, // price to create auction
	'bazaar_tax' => 12, // tax to bid
	'bazaar_bid' => 50, // price to bid
	'bazaar_accountid' => 1, // account id to move auction character

	// gifts/shop system
	'gifts_system' => true,

	// support/system
	'bug_report' => true, // this configurable has no effect, its always enabled

	// forum
	'forum' => 'site', // link to the server forum, set to "site" if you want to use build in forum system, otherwise leave empty if you aren't going to use any forum
	'forum_level_required' => 0, // level required to post, 0 to disable
	'forum_post_interval' => 30, // in seconds
	'forum_posts_per_page' => 20,
	'forum_threads_per_page' => 20,
	// uncomment to force use table for forum
	//'forum_table_prefix' => 'z_', // what forum mysql table to use, z_ (for gesior old forum) or myaac_ (for myaac)

	// last kills
	'last_kills_limit' => 50, // max. number of deaths shown on the last kills page

	// status, took automatically from config file if empty
    'status_enabled' => true, // you can disable status checking by settings this to "false"
	'status_ip' => '',
	'status_port' => '',
	'status_timeout' => 2, // how long to wait for the initial response from the server (default: 2 seconds)

	// how often to connect to server and update status (default: every minute)
	// if your status timeout in config.lua is bigger, that it will be used instead
	// when server is offline, it will be checked every time web refreshes, ignoring this variable
	'status_interval' => 60,

	// admin panel
	'admin_panel_modules' => 'lastlogin,coinstransferable,coins,donates',

	// other
	'email_lai_sec_interval' => 60, // time in seconds between e-mails to one account from lost account interface, block spam
	'google_analytics_id' => '', // e.g.: UA-XXXXXXX-X
	'experiencetable_columns' => 4, // how many columns to display in experience table page. * experiencetable_rows, 5 = 500 (will show up to 500 level)
	'experiencetable_rows' => 500, // till how many levels in one column
	'date_timezone' => 'America/Sao_Paulo', // more info at http://php.net/manual/en/timezones.php
	'footer_show_load_time' => true, // display load time of the page in the footer

	'npc' => [],

    // character name blocked
    'character_name_blocked' => [
        'prefix' => [],
        'names' => [],
        'words' => [],
    ],

    'enablePagseguroLocal' => false, // set true to enable donate and boxes page on localhost.
);
