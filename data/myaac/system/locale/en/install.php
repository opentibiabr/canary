<?php
/**
 * english language file
 * install.php
 *
 * @author Slawkens <slawkens@gmail.com>
 */
$locale['installation'] = 'Installation';
$locale['steps'] = 'Steps';

$locale['previous'] = 'Previous';
$locale['next'] = 'Next';

$locale['on'] = 'On';
$locale['off'] = 'Off';

$locale['loaded'] = 'Loaded';
$locale['not_loaded'] = 'Not loaded';

$locale['loading_spinner'] = 'Please wait, installing...';
$locale['importing_spinner'] = 'Please wait, importing data...';
$locale['please_fill_all'] = 'Please fill all inputs!';
$locale['already_installed'] = 'MyAAC has been already installed. Please delete <b>install/</b> directory. If you want to reinstall MyAAC - please delete <strong>config.local.php</strong> file from the main directory and refresh the page.';

// welcome
$locale['step_welcome'] = 'Welcome';
$locale['step_welcome_title'] = 'Welcome to the installer';
$locale['step_welcome_desc'] = 'Choose the language you would like to view the installer with';

// license
$locale['step_license'] = 'License';
$locale['step_license_title'] = 'GNU/GPL License';

// requirements
$locale['step_requirements'] = 'Requirements';
$locale['step_requirements_title'] = 'Requirements check';
$locale['step_requirements_php_version'] = 'PHP Version';
$locale['step_requirements_write_perms'] = 'Write permissions';
$locale['step_requirements_failed'] = 'Installation will be disabled until these requirements will be passed.</b><br/>For more informations see <b>README</b> file.';
$locale['step_requirements_extension'] = '$EXTENSION$ PHP extension';

// config
$locale['step_config'] = 'Configuration';
$locale['step_config_title'] = 'Basic configuration';
$locale['step_config_server_path'] = 'Server path';
$locale['step_config_server_path_desc'] = 'Path to your Canary main directory, where you have config.lua located.';
$locale['step_config_mail_admin'] = 'Admin Email';
$locale['step_config_mail_admin_desc'] = 'Address where emails from contact form will be delivered, for example admin@gmail.com';
$locale['step_config_mail_admin_error'] = 'Admin Email is not correct.';
$locale['step_config_mail_address'] = 'Server Email';
$locale['step_config_mail_address_desc'] = 'Address which will be used for outgoing emails (from:), for example no-reply@your-server.org';
$locale['step_config_mail_address_error'] = 'Server Email is not correct.';
$locale['step_config_timezone'] = 'Timezone';
$locale['step_config_timezone_desc'] = 'Used for date functions';
$locale['step_config_timezone_error'] = 'Timezone is not correct.';
$locale['step_config_client'] = 'Client version';
$locale['step_config_client_desc'] = 'Used for download page and some templates';
$locale['step_config_client_error'] = 'Client is not correct.';

// database
$locale['step_database'] = 'Import schema';
$locale['step_database_title'] = 'Import MySQL schema';
$locale['step_database_importing'] = 'Your database is MySQL. Database name is: "$DATABASE_NAME$". Importing schema now...';
$locale['step_database_config_saved'] = 'Local configuration has been saved into file: config.local.php';
$locale['step_database_error_path'] = 'Please specify server path.';
$locale['step_database_error_config'] = 'Cannot find config.lua file. Is your server path correct? Go back and check again.';
$locale['step_database_error_database_empty'] = 'Cannot determine database type from config.lua. Your OTS is unsupported by this AAC.';
$locale['step_database_error_only_mysql'] = 'This AAC supports only MySQL. From your config file it seems that your OTS is using: $DATABASE_TYPE$ database. Please change your database to MySQL and then follow the installation again.';
$locale['step_database_error_table'] = 'Table $TABLE$ doesn\'t exist. Please import your OTS database schema first.';
$locale['step_database_error_table_exist'] = 'Table $TABLE$ already exist. Seems AAC is already installed. Skipping importing MySQL schema..';
$locale['step_database_error_mysql_connect'] = 'Cannot connect to the MySQL database.';
$locale['step_database_error_mysql_connect_2'] = 'Possible reasons:';
$locale['step_database_error_mysql_connect_3'] = 'MySQL is not configured propertly in <i>config.lua</i>.';
$locale['step_database_error_mysql_connect_4'] = 'MySQL server is not running.';
$locale['step_database_error_schema'] = 'Error while importing schema:';
$locale['step_database_success_schema'] = 'Successfully installed $PREFIX$ tables.';
$locale['step_database_error_file'] = '$FILE$ couldn\'t be opened. Please copy this content and paste there:';
$locale['step_database_adding_field'] = 'Adding field';
$locale['step_database_modifying_field'] = 'Modifying field';
$locale['step_database_changing_field'] = 'Changing $FIELD$ to $FIELD_NEW$...';
$locale['step_database_imported_players'] = 'Player samples has been imported...';
$locale['step_database_loaded_items'] = 'Items has been loaded...';
$locale['step_database_loaded_weapons'] = 'Weapons has been loaded...';
$locale['step_database_loaded_monsters'] = 'Monsters has been loaded...';
$locale['step_database_error_monsters'] = 'There were some problems loading your monsters.xml file. Please check $LOG$ for more info.';
$locale['step_database_loaded_spells'] = 'Spells has been loaded...';
$locale['step_database_created_account'] = 'Created admin account...';
$locale['step_database_created_news'] = 'Newses has been created...';

// admin account
$locale['step_admin'] = 'Admin Account';
$locale['step_admin_title'] = 'Create Admin Account';
$locale['step_admin_email'] = 'Admin E-Mail address';
$locale['step_admin_email_desc'] = 'E-Mail of your admin account, which can be used to reset the password.';
$locale['step_admin_email_error_empty'] = 'Please enter the E-Mail address for your new account.';
$locale['step_admin_email_error_format'] = 'Invalid E-Mail format.';
$locale['step_admin_account'] = 'Admin account name';
$locale['step_admin_account_desc'] = 'Name of your admin account, which will be used to login to website and server.';
$locale['step_admin_account_error_empty'] = 'Please enter the account name.';
$locale['step_admin_account_error_format'] = 'Invalid account name format. Use only a-Z and numbers 0-9. Minimum 3, maximum 32 characters.';
$locale['step_admin_account_error_same'] = 'Password may not be the same as account name.';
$locale['step_admin_account_id'] = 'Admin account number';
$locale['step_admin_account_id_desc'] = 'Number of your admin account, which will be used to login to website and server.';
$locale['step_admin_account_id_error_empty'] = 'Please enter the account number.';
$locale['step_admin_account_id_error_format'] = 'Invalid account number format. Please use only numbers 0-9. Minimum 6, maximum 10 characters.';
$locale['step_admin_account_id_error_same'] = 'Password may not be the same as account number.';
$locale['step_admin_password'] = 'Admin account password';
$locale['step_admin_password_desc'] = 'Password to your admin account.';
$locale['step_admin_password_error_empty'] = 'Please enter the password for your new account.';
$locale['step_admin_password_error_format'] = 'Invalid password format. Use only a-Z and numbers 0-9. Minimum 8, maximum 30 characters.';
$locale['step_admin_player_name'] = 'Admin player name';
$locale['step_admin_player_name_desc'] = 'Name of your admin character.';
$locale['step_admin_player_name_error_empty'] = 'Please enter the name of your character.';
$locale['step_admin_player_name_error_format'] = 'Invalid player name format. Use only A-Z, spaces and \'. Minimum 3, maximum 25 characters.';

// finish
$locale['step_finish_admin_panel'] = 'Admin Panel';
$locale['step_finish_homepage'] = 'homepage';
$locale['step_finish'] = 'Finish';
$locale['step_finish_title'] = 'Installation finished!';
$locale['step_finish_desc'] = 'Congratulations! <b>MyAAC</b> is ready to use!<br/>You can now login to $ADMIN_PANEL$, or visit $HOMEPAGE$.<br/><br/>
<span style="color: red">Please delete install/ directory.</span><br/><br/>
Post bugs and suggestions at $LINK$, thanks!';
?>
