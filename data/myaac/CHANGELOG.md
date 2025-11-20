# Changelog

## [0.8.16 - 14.02.2024]

### Fixed
* database and finish step warnings/errors
* silently ignore if the hook does not exist

## [0.8.15 - 09.12.2023]

More security fixes, especially in bugtracker.

## [0-8.14 - 29.11.2023]
Security fixes.

### Fixed
* XSS vulnerability in bugtracker and  forum
* Session Fixation
* displaying ban info on account page

### Changed
* Clear some additional cache keys - like database cache

## [0.8.13 - 29.11.2023]

### Added
* Add further new clients versions.
* patching from develop - twig context for hooks

### Fixed
* fixed XSS vulnerability in some pages

## [0.8.12 - 07.08.2023]
I've moved the repository back to my personal account. (Just so you know!)

I will also try to add git commits pointed to each change, lets see if you like it or not - you can comment in discussion, that will be created just after releasing this version :)

### Added
* forum: better error messages (Suggested by @anyeor)
* more support for GesiorAAC classes, so some of them will work with MyAAC
* word-break on forum thread & reply (Suggested by @anyeor)

### Fixed
* not working pages/links from database, introduced in 0.8.10 (Thanks to OtLand user - https://otland.net/members/0lo.99657/ for report)
* it was possible to create topic in board that was closed, ommiting the error check (Thanks to @anyeor for report)
* PHP 8.2 compatibility - removed deprecated functions utf8_encode & utf8_decode
* guild description not being correctly shown (Reported by @anyeor)

### Removed
* Some old code for verifying messages length (Reported by @anyeor)
* some info about config failed to load, was never working

## [0.8.11 - 30.06.2023]

### Added
* new function from 0.9 - Cache::remember($key, $ttl, $callback)
* new characters page hooks
* line number & file to exception handler, to easier localize exceptions

### Changed
* rename to .htaccess.dist, causes some problems on default setup
* removing unneccessary PHP closing tags to prevent potential issues (by @SRNT-GG)
* display warning if hook file does not exist

### Fixed
* important: Not allow to create char if limit is exceeded (by @anyeor) could have been used to spam database
* deleted chars: cannot change comment, name, gender, cannot create guild, cannot be invited, cannot accept invite, cannot be passed leadership to
* forum: quote and edit post buttons not being shown
* twig exception thrown when player does not exist, on character change comment (thanks @anyeor)
* BASE_DIR when accessing /tools
* do not display warning if HTTP_ACCEPT_LANGUAGE is not set

## [0.8.10 - 18.05.2023]

### Changed
* PHP 7.2.5 is now required, cause of Twig 2.x
* allow pages to be placed in templates folder, under pages/ subfolder

### Fixed
* Twig error with global variable on create account
* links/redirects from facebook, etc. like ?fbclid=x
* do not allow to continue install when there is no server database imported
* cannot go forward when config.local.php cannot be saved
* when server uses another items serializer
* small bug on install

## [0.8.9 - 16.03.2023]

### Added
* You can now disable server status checking for testing purposes, useful for local testing when there is no server running
    * with this, the page won't need 2 seconds to load
    * set status_enabled to false in config.php
* new buttons code for tibiacom template, can create button with any text
* patched some small changes from develop branch

### Changed
* add .git to denied folders in nginx-sample.conf
* plugins folder is now accessible from outside
* add plugins folder to twig search paths

### Fixed
* player save with new ipv6
* more php 8.x compatibility
* rel path for exception message, causing message to be not in red background

## [0.8.8 - 18.02.2023]

### Added
* mail confirmed reward
* support for latest group changes in TFS
* new function: escapeHtml

### Updated
* TinyMCE to v4.9.1 (latest release in 4.x series)
* Twig to v2.15.4

### Changed
* you can now place custom pages in your template directory under pages/ folder
* HOOK_LOGOUT parameters, now only account_id is passed

### Fixed
* ipv6 introduced in latest TFS
* config.account_premium_days
* better compatibility with GesiorAAC
* PHP 8.1 compatibility
* myaac_ db table detection failure
* reload creatures error, when items cache has been cleared

### Removed
* accounts.blocked column, which is not used by AAC

## [0.8.7 - 31.08.2022]
### Added
* login.php for client 12.x is now part of official repo
* browsehappy code
* config use character sample skill (#201, @gpedro)
* custom words blocked (#190, @gpedro)

### Changed
* save php sessions in myaac dir
* don't count deleted players when creating new character

### Fixed
* patch vulnerability in change_rank.php (#194, @gesior, @thatmichaelguy)
* fix guild invite page (#196, @worthdavi)
* players not showing on highscores page (#195)
* highscores page bug with high pages
* $player->getStorage() does not work at all (#169, @gesior)
* copying sample character when it have items with quotes (#200, @gpedro)
* IPv6 issue when env is set to dev (#171)
* admin page changed feet to match body colour (#174, @silic0nalph4)
* exception being thrown when creating duplicated character name (#191)
* rules page formatting (#177, @silic0nalph4)
* account character create if auto_login is enabled
* undefined variable notice on database_log enabled
* removed VERSION file

## [0.8.6 - 10.07.2021]
This update contains very important security fix.

Please update your MyAAC instances to this version.

## [0.8.5 - 08.06.2021]

### Changed
* bcmath module is not required anymore
* Gratis premium account fixes (#156, by @czbadaro)
* Update 404 response (#163, by @anyeor)

### Fixed
* compatibility with PHP 7.0 and lower
* deleting ranks in guilds (#158, by @Misztrz)
* guild back buttons (change logo & motd)
* forum table style (boards & thread view)
* guild list description new lines `<br>` being ignored (Thanks @anyeor for reporting)


## [0.8.4 - 18.02.2021]

### Added
* support for accounts.premium_ends_at (Latest TFS 1.x)
* more clients to clients.conf.php

### Changed
* minimum PHP 5.6 is now required
* password can now contain any characters
* add SSL on external image requests of items and outfits (@fernandomatos)
* Use local storage for saving menu items (tibiacom template) - fixes bug with some websites like wykop.pl (browser freeze)
* increase size of myaac_visitors.page column to 2048 (Thanks to OtLand user kaleuui)

### Fixed
* compatibility with PHP 8.0 (latest XAMPP)
* displaying PHP errors on env = "prod"
* the Guildnick not showing in the guild pages (@leesneaks)
* you cannot delete character more than twice (Thanks Okke)
* ignore arrays in config.lua (fixes experienceStages loading)
* parsing empty strings in config.lua (with comments)
* headling.php cannot find font

## [0.8.3 - 27.10.2020]

### Added
* pdo_mysql as required extension
* some notice about Email validation in create account

### Changed
* Move register DATABASE_VERSION into schema.sql
    * Caused migrations being fired when user manually imported database

### Fixed
* creating very uncommon (bugged) account names
* XSS in character search
* Admin menu news editing warning when leaving page without touching the inputs
* Guild Invite not working on otservbr-global
* two boxes being show on email_change_cancel
* when adding poll = template tibiacom broken
* houses: Unknown column 'guild' in 'where clause
* account create when account_mail_verify is enabled
* CloudFlare IP detection
* network_twitter link in tibiacom template

## [0.8.2 - 03.06.2020]

### Added
* Log query time in database_log (can be used for benchmarking)
* new PHP constant: IS_CLI
* $_SERVER['REQUEST_URI'] to database.log
* outfit to highscores box in tibiacom template
* system/data to .gitignore
* error_reporting in admin panel (when in dev mode), so it shows php notices and warnings
* example quests in config.php

### Changed
* account_login input type from password to text

### Fixed
* Guild Invite not working on otservbr-global (#123)
* news not updating after adding in admin panel
* wrong mana of character samples (#125)
* missing rules page on clean install
* double space character name creation (@Lee, #121)
* creatures page: Max count and chance not shown on hovered items
* exception being thrown when characters.frags enabled on TFS 1.x
* TFS 0.4 guilds creation (Where guilds.checkdata and motd doesn't have default value)
* ERR_TOO_MANY_REDIRECTS browser error on template change
* updating template menus on template change
* Account change info when config.account_country is disabled
* cancel change email request
* config.character_name_min/max_length being ignored in change_name.php
* some rare bugs when database is no up-to-date and someone enters admin panel
* extra line that is added when using a newer version than official release (@Lee)
* admin links in featured article
* some PHP Notice when HTTP_HOST is not set (Can happen on some old versions of HTTP protocol)
* Show character indicator in check_name.js
* Houses list View button was wrong (was from bootstrap)
* OTS_House __construct - not loading by houseid parameter
* message() function when executed in CLI

### Removed
* unused myaac_commands table from schema
* MyISAM engine from migration scripts (#128)

## [0.8.1 - 10.03.2020]

### Added
* Support for Nostalrius OTS

### Changed
* Move TODO to wiki
* .tooltip css class to .item_image (bootstrap conflict)

### Fixed
* Reloading of creatures/monsters throwing an exception
* Loading custom pages with old Gesior variables
* Some weird behaviour with installation of plugins
* CHANGELOG.md loading in Admin Panel
* spells displaying when level = 0
* Some PHP warnings and notices

## [0.8.0 - 19.02.2020]

### Added:
* new Awesome Bootstrap Admin Panel by Lee (@Leesneaks)
	* using Bootstrap 3
	* all existing pages were adjusted 
	* new editor: Accounts
	* improved editor: Players
	* new Reports View page
	* Modules directory, which can be added using Plugins (@Leesneaks, @whiteblXK)
	* move News Management here (@whiteblXK)
	* interactive player outfit chooser (@tobi132)
* added Highscores by balance
* possibility to define colors and "Open in New Tab" on Template Menus (needs to be supported by Template)
* support for database persistent and socket connections (performance boost)
* Team page - display outfits of the players (configurable)
* added clear_cache.php, send_email.php bin commands (@slawkens, @tobi132)
* added locale pt_br (@ivenspontes)
* added load time into items & weapons loading admin page
* new, beautiful exception handler
* added travisci to prevent mistype (@gpedro, #89)
* added showing database name into installation script (@tobi132)
* compatibility with old z_ gesior table (@tobi132, #46)
* added nginx-sample.conf, .editorconfig, VERSION
* database towns table support for TFS 1.3 (@tobi132)
* added enable_tinymce option to Pages editor

### Fixed:
* account login redirect with special chars (like '&' and '?')
* black skull info at serverInfo (@tornadia)
* set correct limit at lastkills page from config (anyeor from OtLand)
* myaac_monsters table column loot problem (#79)
* players column deleted install description (@gpedro, #91)
* experience table being to wide and buggy on some templates (@tobi132, #90)
* fix errors with .htaccess files
* added index.html to prevent indexing the folder by mod_index

### Changed:
* Environment is now configurable by env setting (Significantly better load times with 'prod')
* replace spells, monsters tables with JavaScript Sortable Tables - DataTables (@Leesneaks)
* change default MySQL Storage Engine to InnoDB and Default Character Set to utf8
* updated OTS_House class to support latest TFS 1.x (new columns)
* updated monster images to the original ones from tibia.com
* increased the minimum length (3 -> 4) and decreased the maximum length (25 -> 21) of the New Character Name (by @vankk)
* use $db->exec instead of $db->query optimisation
* move items from database to Cache_PHP (Much more faster load time)
* allow simultaneous loading of config.ini and config.php in templates
* updated copyright year and SSL link (@EPuncker, #88)
* move commands, rules and downloads pages into database (@tobi132)
* better view of guilds (new buttons, table look and feel) (@tobi132)
* remove stupid alerts on account create
* remove .dist extension from .htaccess

### New Configurables (config.php)
* env (Environment)
* account_create_auto_login (Auto Login after Create Account - Registration)
* account_create_character_create (Create Character directly on Create Account page) (@tobi132)
* footer_show_load_time (display load time of the page in the footer)
* database_socket (Connection via Unix Socket)
* database_persistent (Database Persistent Connection)
* database_log (Logging of Database Queries)
* admin_panel_modules (Modules displayed in Admin Panel Dashboard)
* status_timeout, status_interval
* smtp_debug (More info about SMTP errors in error.log)
* team_display_outfit (Display outfit of the team members on teams page)
* highscores_balance (Display highscores by balance)
* character_name_min/max_length (Minimum and maximum length of character name)
* characters.deleted (display deleted characters on characters page)

### Forum:
* show image in full screen on click
* show user avatar (outfit) in posts
* replaced forum actions links (move, remove, edit, quote) with images
* redirect directly to the thread on user login (on new reply)

### Installer:
* AJAX loader for the important stuff
* create admin account: ask for e-mail + character name
* load items & weapons
* check user IP on install to prevent install by random user
* remember status of the installation
* remember language on first step (welcome)
* ask user for timezone
* auto detected browser language in select language

### Plugins
* sandbox for plugins, don't install when requirements are not satisfied
* allow comments inside plugin json file (php style)
* new require options for plugins: (look into example.json)
	* require database version, table or column of the MyAAC schema
	* require php-extension
	* require semantic-version (like in composer.json)
* new hooks: LOGIN, LOGIN_ATTEMPT, LOGOUT, HOOK_ACCOUNT_CREATE_*

### Cache
* php 7.x APCu cache support (faster cache engine)
* new cache engine: plain PHP (is good with pure php 7.0+ and opcache)
* cache lastkills.php, $db->hasTable, $db->hasColumn, hooks and template menus
* stop using global $cache variable, use Singleton pattern instead

### Twig
* move pages to Twig templates: team, lastkills, serverinfo, houses, guilds.list, guild.view, admin.logs, admin.reports (@whiteblXK, @tobi132)
* replace "$twig->render()" with "$this->display"
* move Twig functions to separate file
* move tibiacom boxes to Twig templates
* allow Pages to be loaded as Twig template (this allows using Twig variables in Pages) (@tobi132)
* allow string to be passed to hook twig function

### Functions
* config($key), configLua($key)
* clearCache()
* OTS_Account:
	* getCountry()
	* setLastLogin($lastlogin) (@Leesneaks)
	* setWebFlags(webflags) (@Leesneaks)
* OTS_Player:
	* getAccountId()
	* countBlessings() (@Leesneaks)
	* checkBlessings($count) (@Leesneaks)
* is_sub_dir (in system/libs/plugins.php)
* Twig:
	* getPlayerLink($name, $generate = true)
* removed SQLquote and SQLquery from OTS_Base_DB
* Add optional $params param into log_append (will log arrays) (@tobi132)

### Internal
* moved clients list to the new file (clients.conf.php)
* changed tableExist and fieldExist to $db->hasTable(table) + $db->hasColumn(table, column)
* changed deprecated $ots->createObject() functions with their OTS_ equivalents
* add global helper config($key) function + twig binding
	* use config() instead of global $config
* remove unnecessary parentheses in include/require PHP functions
* use __DIR__ instead of dirname(__FILE__) - since PHP 5.3.0
* change intval() function to (int) casting (up to 6x faster)
* add release.sh script (for GitHub releases)
* use curl as alternative option for reporting install

### Libraries
* updated Twig to version v1.35.0
* updated TinyMCE to version v4.7.4

### Deprecations
* change deprecated HTML <center> tag to <div style="text-align:center">
* replace deprecated HTML <font> tag with <span>

## [0.7.11 - 04.05.2019]
### Added:
* support for some old servers, where arrays are used in config.lua
* an additional text to the install page informing that user can reinstall MyAAC by deleting config.local.php

### Fixed:
* XSS in forum show_thread
* guilds - "Add new rank" function
* multiple mail recipients when using admin mailer function
* Admin Panel - MyAAC logs not shown if servers logs directory doesn't exist (#47)
* missing prefix for cache get() and delete() functions
* add fatal error message when myaac tables in database do not exist
* the mystical defect where "Create Account" button was not highlighted (on the account/manage page)
* bug where server_config table does not exist (OTHire as an example)
* database_name in Usage_Statistics
* forgot to open <head> in install template

### Changed:
* do not display software version

## [0.7.10 - 03.03.2018]
### Added:
* new configurable: smtp_secure
* robots.txt

### Fixed:
* editing an existing page that had php enabled
* chrome bug on save (when editing page) ERR_BLOCKED_BY_XSS_AUDITOR
* showing IP and Port in admin panel (#44, by miqueiaspenha)
* deleting plugin showing "You don't have rights to delete"
* some bug with PHPMailer not finding its language file
* default accounts.vote value
* saving some really high long ip addresses

### Changed:
* update config.highscores_ids_hidden on install when there are samples already in database
* auto add z_polls table on install

### Internal:
* changed mb_strtolower functions to strtolower()
* added new function: $hooks->exist($type)

## [0.7.9 - 13.01.2018]
	* removed 6mb of trash (some useless things)
	* (fix) TFS 1.x not showing promoted vocations in highscores
	* otserv 0.6.x: fixed some warning (on the characters page) and fatal mysql error (on the mango signature)
	* fixed default stamina on otserv 0.6.x engine (and some others perhaps)
	* install: change permission check to is_writable
	* changed highscores_groups_hidden to 3 (for TFS 1.x)
	* updated background-artwork (tibiacom template) to the latest version, removed other ones

## [0.7.8 - 12.01.2018]
	* fixed installation error " call to undefined method OTS_DB_MySQL::hasColumn()"
	* updated tinymce to the latest (4.7.4) version
	* enabled emoticons plugin in tinymce :)
	* some security fixes

## [0.7.7 - 08.01.2018]
	* important fix for servers with promotion column (caused player.vocation to be resetted when saving player, for example: on change name, accept invite to guild, leave guild)
	* immediately reload config.lua when there's change in config.server_path detected
	* added new forum option: "Enable HTML" (only for moderators)
	* fixed othire default column value (#26)
	* fixed saving custom vocations in admin panel (#36)
	* fixed warning in highscores when vocation doesn't exist
	* fixed characters page - config.characters.frags "Notice: Use of undefined constant"
	* fixed getBoolean function when boolean is passed
	* fixed empty success message on leave guild
	* fixed displaying premium account days
	* function OTS_Account:getPremDays will now return -1 if there's freePremium configurable enabled on the server
	* fixed tr bgcolor in characters view (Frags) (#38)
	* fixed some warning in guild show
	* fixed PHP warning about country not existing on online and characters pages
	* fixed forum bbcode parsing
	* don't add extra <br/> to the TinyMCE news forum posts
	* (internal) using $player->getVocationName() where possible instead of older method

## [0.7.6 - 05.01.2017]
	* fixed othire account creating/installation
	* fixed table name players -> players_online
	* fixed unexpected error logging about email fail
	* added max_execution_time to the install finish step
	* some small fix regarding highscores vocation box

## [0.7.5 - 04.01.2017]
	* fixed bug on othire with config.account_premium_days
	* fixed bug on TFS 1.x when online_afk is enabled
	* warning about leaving news page with changes
	* added player status to tibiacom top 5 highscores box
	* save detected country on create account in session
	* fixed getPremDays and isPremium functions (newest 11.x engines are bugged when it comes to PACC, its not fault of MyAAC)
	* fix when there are no changelogs or highscores yet
	* small fix regarding getTopPlayers function which was ignoring $limit variable
	* fixed news adding when type != ARTICLE
	* fixed template path finding
	* fixed displaying article_text when it was empty saved

## [0.7.4 - 24.12.2017]
	* fixed mysql fatal error on tibiacom template - top 5 box
	* fixed displaying of level percent bar on tibian signature
	* inform user about Twig cache failure on installation, instead of http 500 error
	* when dir system/cache is not writable by the webserver, then show some nice notice to the user about it instead of http 500 error
	* remember client version select and usage stats checkbox in session on install
	* automatically update highscores_ids_hidden for users who installed myaac before (migration)

## [0.7.3 - 18.12.2017]
	* auto generate myaac cache & session prefix on install to be unique across installations
	* fixed hiding shop system menu on tibiacom template when disabled in config
	* prevent adding duplicated newses with installation
	* some changes to sample characters: chanced town_id to 1, posx: 1000, posy: 1000, posz: 1000 and default group_id to 1 so you can change in-game outfits and they will be used
	* added version 772 constant to install client choose (OTHire)
	* better solution for hidding samples (configurable) - highscores_ids_hidden
	* fixed account.login redirect not working on tibiacom template
	* installation: warn about wrong admin account name/id and password
	* fixed last menu closing in tibiacom template
	* updated polish locale (translation) on install
	* (internal) removed some duplicated code on install finish
	* (internal) renamed installation step files to be in correct order
	* added TODO file

## [0.7.1 - 13.12.2017]
	* added changelog menu item to kathrine template
	* fixed some php short tag in changelogs page
	* fixed guild change description back button
	* removed duplicated "Support List" menu item from tibiacom template
	* changed some notice when version check is failed
	* (internal) moved changelog to twig

## [0.7.0 - 20.11.2017]
	* moved template menus to database, they're now dynamically loaded
	* added anonymous usage statistics reporting (only if user agrees, first usage report will be send after 7 days)
	* you can edit them in Admin Panel under 'Menus' option
	* you can also add custom links, like http://google.pl
	* added networks (facebook and twitter) and highscores (top 5) boxes to tibiacom template, configurable in templates/tibiacom/config.php
	* added news ticker for kathrine template
	* added featured article to tibiacom template (you can add them with add news button)
	* added tinymce editor to 'Pages' in admin panel
	* added links to edit/delete/hide custom page directly from page
	* update forum post after editing news (when forum post has been created)
	* enabled code plugin for tinymce which enabled raw html code editing
	* removed videos pages, as it can be easily added using custom Menus and Pages with insert Media
	* removed bug_report configurable, its now enabled by default
	* log some error info when mail cannot be send on account create
	* twig getLink function will now return with full url (BASE_URL included)
	* verify install post values directly on config page and display error
	* updated tinymce to version 4.7.2 (from 4.7.0)
	* updated phpmailer to version 5.2.26 (from 5.2.23)
	* (#30) (fix) recovering account on servers that doesn't support salts
	* (fix) account email confirm function
	* (fix) showing changelog with urls in Admin Panel
	* (fix) uninstalling plugin
	* (fix) polls box in tibiacom template
	* (fix) remove hooks from db on plugin deinstall
	* (fix) some weird include possibilities with forum and account actions (verify action name)
	* (fix) loading hooks from plugin installed from command line
	* (fix) some changelog PHP Notice warning
	* (internal) moved uninstall logic to Plugins class
	* (internal) moved tibiacom boxes to separate directory
	* (internal) moved news tickers to twig template
	* (internal) moved Forum class to separate file
	* (internal) moved deprecated functions to compat.php
	* (internal) added some compat functions that are used by shop system
	* (internal) renamed constant TICKET -> TICKER
	* (internal) shortened message functions

## [0.6.6 - 22.10.2017]
	* fixed some php fatal error on spells page
	* changed spells.vocations field in db size to 300
	* please reload your spells after this update!

## [0.6.5 - 21.10.2017]
	* fixed displaying custom pages
	* fixed adding new group forum board

## [0.6.4 - 20.10.2017]
	* reverted OTS_Account::getLastLogin() cause its used by tibia11-login plugin

## [0.6.3 - 20.10.2017]
	* fixed creating account
	* fixed viewing thread without being logged
	* fixed showing premium account status

## [0.6.2 - 20.10.2017]
	* added forums for guilds and groups
	* added nice looking menu for my account page in default template
	* new command line tool: install_plugin.php - can be used to install plugins from command line. Usage: "php install_plugin.php path_to_file"
	* added new tooltip to view characters equipment item name and monster loot
	* added items.xml loader class and weapons.xml loader class
	* minimum PHP version to install AAC is now 5.3.0 cause of Anonymous functions used by Twig
	* Added 'Are you sure?' popup when uninstalling plugin
	* added some warnings when plugin json file is incomplete
	* fixed showing in characters ban expires when is unlimited
	* fixed displaying monster loot when item.name in loot is used instead of item.id
	* load also runes into spells table
	* display plugin uninstall option only if its possible
	* after changing template you will be redirected to latest viewed page
	* display gallery add image form only on main gallery page
	* (internal) moved most of guilds html-in-php code to twig
	* (internal) moved spells page to twig template
	* (internal) removed useless spells.spell column that was duplicate of spells.words
	* (internal) save monster loot in database in json format instead loading it every time from xml file
	* (internal) store monster voices and immunities in json format
	* (internal) moved buttons to separate template
	* (internal) moved online search form to twig
	* (internal) added new function getItemNameById($id)
	* (internal) Moved plugin install logic to a new class: Plugins
	* (internal) changed spells.vocations database field to store json data instead of comma separated
	* (internal) removed $hook_types array, using defined() and constant() functions now
	* (internal) removed useless monsters.gfx_name field from database
	* (internal) renamed database field monsters.hide_creature to hidden
	* (internal) renamed existing Items class to Items_Images
	* (internal) optimized Spells class
	* (internal) new function: OTS_Guild::hasMember(OTS_Player $player)
	* (internal) new function: Forum::hasAccess($board_id)

## [0.6.1 - 17.10.2017]
	* fixed signatures loading
	* new configurable: session_prefix, to allow more websites on one machine (must be unique for every website on your dedicated server!)
	* better error handling for monsters and spells loader (save errors to system/logs/error.log)
	* check if file exist before loading (monsters and spells)
	* (internal) Account::getAccess() = Account::getGroupId()
	* (internal) moved account actions (pages) to account/ directory
	* (internal) moved forum actions (pages) to forum/ directory
	* (internal) moved forum.edit_post to twig templates

## [0.6.0 - 16.10.2017]
	* added faq management - add/edit/move/hide/delete from website
	* new account.login view for tibiacom template
	* monsters and spells are now being loaded at the installation of the AAC
	* fix for php versions under 5.5 where empty() function supported only variables
	* added missing change email and change info buttons to account.management default template
	* added new indicator icons for create account, create character and change character name
	* fixed config loader when some inline comments are present
	* fixed editing page in admin panel that contains some html code
	* fixed forum new post on mac os and some specific mysql versions
	* attempt to fix incorrect views counter behavior (its resetting to 0 in some cases)
	* enabled cache http headers for signatures
	* check if monster file exist before loading it
	* fixed if plugin zip file name contains dot (.)
	* renamed screenshots to gallery and movies to videos
	* moved install pages to twig
	* fixed Account::getGuildAccess function
	* removed never used library from sources - dwoo
	* moved check_* functions to class Validator
	* from now all validators ajax requests will fire onblur instead of onkeyup
	* ajax requests returns now json instead of xml
	* added 404 response when file is not found

## [0.5.1 - 11.10.2017]
	* fixed forum add/edit board
	* new configurable: highscores_length, how much highscores to display
	* fixed highscores links (ALL, previous and next page)
	* update templates cache when installing/uninstalling plugin
	* moved character deaths and frags table generation to twig
	* fixed some bug when you uninstall plugin and then try to install again on the same page
	* check if plugin exist before uninstalling
	* fixed some warning in OTS_Base_DB

## [0.5.0 - 10.10.2017]
	* moved .htaccess rules to plain php (index.php)
	* updated tinymce to the latest (4.7.0) version, you can now embed code, for example youtube videos
	* added option to uninstall plugin
	* added option to require specified myaac, php or database version for plugins, without that plugin won't be installed
	* change accountmanagement links to use friendly_urls
	* fixed creating new forum thread
	* sample characters are now assigned to admin account and have group_id 4 to not be shown on highscores
	* added links loaded from database to admin panel - for future plugins
	* print some info to error.log when can't find config.lua
	* some fixes in account changecomment action
	* show info when account name/number or password is empty on login
	* fixed showing account login errors
	* added few characters hooks
	* fixed some kathrine template js bug when shop is disabled
	* you can now use slash '/' in custom pages loaded from database
	* added new twig function getLink that convert link taking into account config.friendly_urls
	* internalLayoutLink -> getLink

## [0.4.3 - 05.10.2017]
	* better config loader taken from latest gesior, you can now include files in your config by doing dofile('config.local.lua')
	* fixed country detection in create account
	* fixed showing of character deaths and frags
	* fixed https://otland.net/threads/myaac-v0-0-1.251454/page-13#post-2466303
	* fixed https://otland.net/threads/myaac-v0-0-1.251454/page-13#post-2466313
	* fixed rook sample, which will now have level 1, 150 health, 0 mana, and 400 cap.
	* fixed samples being deleted by tfs 1.0+ cause of 'deletion' field set to 1
	* pages loaded from database have higher priority than normal .php pages, so they will be loaded first if they exist
	* moved many pages to twig templates
	* change download client links from clients.halfaway.net to tibia-clients.com
	* added bugtracker to kathrine template
	* added CREDITS file

## [0.4.2 - 14.09.2017]
	* updated version number

## [0.4.1 - 13.09.2017]
	* fixed log in to admin panel
	* fixed File is not .zip plugin upload error

## [0.4.0 - 13.09.2017
	* added option to add/edit/delete/hide/move forum boards
	* moved some of HTML-in-PHP code to Twig templates
	* added bug_report configurable which can enable/disable bug tracker
	* log errors instead of showing them to users with system directories
	* fix when $_SERVER['HTTP_ACCEPT_ENCODING'] is not set
	* when it fails to load config.lua it will output error also to error.log
	* automatically detect json file in .zip instead of basing on filename (admin panel - plugins)
	* hopefully fixed the error with "The file you are trying to upload is not a .zip file. Please try again."
	* fixed wrong name of table in bugtracker
	* fixed some bugs in bugtracker
	* added report bug link in templates
	* fixed some rare error when user is logged in for longer than 15 minutes and tries to login again
	* fixed some grammar errors
	* some small improvements
	* fixed some separators in kathrine template

## [0.3.0 - 28.08.2017]
	* added administration panel for screenshots management with auto thumbnail generator and image auto-resizing
	* added Twig template engine and moved some html-in-php code to it
	* automatically detect player country based on user location (IP) on create account
	* player sex (gender) is now configurable at $config['genders']
	* fixed recovering account and changing password when salt is enabled
	* fixed installing samples when for example Rook Sample already exist and other samples not
	* fixed some mysql error when character you trying to create already exist
	* fixed some warning when you select nonexistent country
	* password change minimal/maximal length notice is now more precise
	* added 'enabled' field in myaac_hooks table, which can enable or disable specified hook
	* removed DEFAULT '' for TEXT field. It didn't worked under some systems like MAC OS X.
	* minimum PHP version to install the MyAAC is now 5.2.0 cause of pathinfo (extension) function
	* removed unused admin stylish template
	* removed some unused cities field from myaac_spells table
	* moved news adding at installation from schema.sql to finish.php
	* some optimizations

## [0.2.4 - 09.06.2017]
	* fixed invite to guild
	* added id field on monsters, so you can delete them in phpmyadmin
	* fixed adding some creatures with ' and "
	* fixed when there are spaces at beginning of the file (creatures)
	* fixed when file is unable to parse (creatures)
	* fixed typo loss_items => loss_containers
	* more elegant way of showing message on reload creatures and spells

## [0.2.3 - 31.05.2017]
	* fixed guild management on OTHire 0.0.3
	* set default skills to 10 when creating new character
	* fixed displaying of "Create forum thread" in newses
	* fixed deleting guild on servers that use players.rank_id field
	* fixed phpmailer class loading (https://otland.net/threads/myaac-v0-0-1.251454/page-8#post-2445222)
	* fixed displaying vocation amount on online page
	* better support for custom vocations, you just need to set in config vocations_amount to yours.
	* fixed huge space in player name (https://otland.net/threads/myaac-v0-0-1.251454/page-7#post-2444328)
	* fixed Undefined variable (https://otland.net/threads/myaac-v0-0-1.251454/page-7#post-2444034)
	* fixed Undefined offset (https://otland.net/threads/myaac-v0-0-1.251454/page-7#post-2444035)

## [0.2.2 - 22.05.2017]
	* added missing cache/signature directory
	* fixed https://otland.net/threads/myaac-v0-0-1.251454/page-7#post-2443868

## [0.2.1 - 21.05.2017]
	* added Swedish translation by Sizaro
	* fixed some bugs with installlation & characters & houses

## [0.2.0 - 21.05.2017]
	* added option to change character sex for premium points
	* moved site_closed to database, now you can close your site through admin panel
	* added option to admin panel: clear cache
	* added experiencetable_rows configurable
	* optimized OTS_Account->getGroupId(), now its using like 20 queries less
	* optimized OTS_Player->load($id) function, should be much faster now
	* fixed displaying on highscores special outfits
	* fixed skull images displaying
	* fixed displaying unlimited premium account
	* fixed bug where players.lookaddons doesn't exist (OTHire etc.) (https://otland.net/threads/myaac-v0-0-1.251454/page-6#post-2442407)
	* fixed signature tibian for OTHire and other servers that doesnt use accounts.premdays field
	* fixed when player name in signature containst space
	* don't show "Create forum thread" when editing
	* fixed red color table after create account
	* updated download links, as clients.halfaway.net isn't working anymore
	* fixed some bugs while installing when field `email_next` or `hidden` already exist
	* fixed movies unexpected comment
	* added template_place_holder('center_top') to kathrine template

## [0.1.5 - 13.05.2017]
	* fixed bug with "Integrity constraint violation: 1048 Column 'ip' cannot be null"

## [0.1.4 - 13.05.2017]
	* added outfit shower, in characters, online, and highscores
	* updated database to version 2
	* fixed item images (now using item-images.ots.me host by default)
	* fixed news ticket and posting long newses (https://otland.net/threads/myaac-v0-0-1.251454/page-5#post-2442026)
	* news body limit increased to 65535 (mysql text field)
	* removed some unused code from my old server
	* added spells & monsters to kathrine template

## [0.1.3 - 11.05.2017]
	* this is just release to update version number

## [0.1.2 - 11.05.2017]
	* forgot to update CHANGELOG and MYAAC_VERSION

## [0.1.1 - 11.05.2017]
	* fixed updating myaac_config with database_version to 1
	* fixed database updater

## [0.1.0 - 11.05.2017]
	* added new feature: change character name for premium points (disabled by default, you can enable it in config under account_change_character_name in config.php)
	* added automatic database updater (data migrations)
	* renamed events to hooks
	* moved hooks to database
	* now you can use hooks in plugins
	* set account.type field to 5 on install, if TFS 1.0+
	* added example plugin
	* new, latest google analytics code
	* fixed bug with loading account.name that has numbers in it
	* fixed many bugs in player editor in admin panel
	* added error handling to plugin manager and some more verification in
	* file has been correctly unpacked/uploaded
	* fixed Statistics page in admin panel when using account.number
	* fixed bug when creating/recovering account on servers with
	* account.salt field (TFS 0.3 for example)
	* fixed forum showing thread with html tags (added from news manager)
	* new, latest code for youtube videos in movies page
	* fixed showing vocation images when using $config['online_vocations_images']
	* many fixes in polls (also importing proper schema)
	* fixed hovering on buttons in kathrine template (on accountmanagement page)
	* fixed signatures (many fixes)
	* added missing gesior signature system

## [0.0.6 - 06.05.2017]
	* fixed bug while installing (https://otland.net/threads/myaac-v0-0-1.251454/page-3#post-2440543)
	* fixed bug when creating character (not showing errors) (one more time)
	* fixed support for TFS 0.2 series
	* added FAQ link

## [0.0.5 - 05.05.2017]
	* fixed bug when creating character (not showing errors)
	* Fixed characters loading with names that has been created with other AAC
	* fixed links to shop in default template
	* fixed some weird PHP 7.1 warnings/notices
	* Fixed config loading with some weird comments
	* fixed bug with status info utf8 encoding (https://otland.net/threads/myaac-v0-0-1.251454/page-2#post-2440259)
	* fixed when ip in log_action is NULL (https://otland.net/threads/myaac-v0-0-1.251454/page-2#post-2440357)
	* fixed bug when guild doesn't exist on characters page (https://otland.net/threads/myaac-v0-0-1.251454/page-2#post-2440320)
	* disabled friendly_urls by default
	* fixes when $config['database_*'] is set
	* added CHANGELOG

## [0.0.3 - 03.05.2017]
	* Full support for OTHire 0.0.3
	* added support for otservers that doesn't use account.name field, instead just account number will be used
	* fixed encryption detection on TFS 0.3
	* fixed bug when server_config table doesn't exist
	* (install) moved admin account creation to new step
	* fixed news comment link
	* by default, the installer creates now the Admin player, for admin account
	* fixed installation errors
	* fixed config.lua loading with some weird comments

## [0.0.2 - 02.05.2017]
	* updated forum links to use friendly_urls
	* some more info will be shown when cannot connect to database
	* show more error infos when creating character
	* fixed forum link on newses
	* fixed spells loading when there's vocation name instead of id
	* fixed bug when you have changed template but it doesn't exist anymore
	* fixed vocations with promotion loading
	* fixed support for gesior pages and templates
	* added function OTS_Acount:getGroupId()

## [0.0.1 - 01.05.2017]
	This is first official release of MyAAC.
	Features are listed here

	For more information, see the release announcement on OTLand: https://otland.net/threads/myaac-v0-0-1.251454/
