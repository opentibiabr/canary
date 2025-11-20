<?php
/**
 * swedish language file
 * install.php
 *
 * @author Sizaro <sizaro@live.se>
 */
$locale['installation'] = 'Installation';
$locale['steps'] = 'Steg';

$locale['previous'] = 'Föregående';
$locale['next'] = 'Nästa';

$locale['on'] = 'På';
$locale['off'] = 'Av';

$locale['loaded'] = 'Laddad';
$locale['not_loaded'] = 'Inte Laddad';

$locale['please_fill_all'] = 'Vänligen fyll i allt!';
$locale['already_installed'] = 'MyAAC är redan installerat. Vänligen ta bort <b>install/</b> mappen. Om du vill installera MyAAC igen - ta bort filen <strong>config.local.php</strong> från huvudkatalogen och uppdatera sidan.';

// welcome
$locale['step_welcome'] = 'Välkommen';
$locale['step_welcome_title'] = 'Välkommen till installatören';
$locale['step_welcome_desc'] = 'Välj det språk du vill se installatören med';

// license
$locale['step_license'] = 'Licens';
$locale['step_license_title'] = 'GNU/GPL Licens';

// requirements
$locale['step_requirements'] = 'Krav';
$locale['step_requirements_title'] = 'Kravskontroll';
$locale['step_requirements_php_version'] = 'PHP Version';
$locale['step_requirements_write_perms'] = 'Skriv behörigheter';
$locale['step_requirements_failed'] = 'Installation kommer att inaktiveras tills dessa krav följts. </ B> <br/> Mer information finns i filen <b>README</b>.';
$locale['step_requirements_extension'] = '$EXTENSION$ PHP extension';

// config
$locale['step_config'] = 'Konfiguration';
$locale['step_config_title'] = 'Grundläggande konfiguration';
$locale['step_config_server_path'] = 'Server mapp';
$locale['step_config_server_path_desc'] = 'Mappen som innhåller exe filen till Canary, där du har din config.lua.';
$locale['step_config_mail_admin'] = 'Admin E-Post';
$locale['step_config_mail_admin_desc'] = 'Adress där E-Post från kontaktförmolär kommer att leveraras, till exempel admin@gmail.com';

$locale['step_config_mail_admin_error'] = 'Admin E-Post är inte korrekt.';
$locale['step_config_mail_address'] = 'Server E-Post';
$locale['step_config_mail_address_desc'] = 'Adress som kommer att användas för utgående email (från:), till exempel no-reply@your-server.org';

$locale['step_config_mail_address_error'] = 'Server E-Post är inte korrekt.';
$locale['step_config_client'] = 'Klientversion';
$locale['step_config_client_desc'] = 'Används för nerladdningssidan och teman.';

// database
$locale['step_database'] = 'Importera schema';
$locale['step_database_title'] = 'Importera MySQL schema';
$locale['step_database_importing'] = 'Din databas är MySQL. Databasnamnet är: "$DATABASE_NAME$". Importerar schema nu...';
$locale['step_database_config_saved'] = 'Lokal konfiguration har sparats i filen: config.local.php';
$locale['step_database_error_path'] = 'Ange server mapp.';
$locale['step_database_error_config'] = 'Kan inte hitta konfigurations fil. Är din server mapp korrekt? Gå tillbaka och kolla igen.';
$locale['step_database_error_database_empty'] = 'Kan inte bestämma databas typ från config.lua. Din OTS stöds inte av MyAAC.';
$locale['step_database_error_only_mysql'] = 'Denna AAC stöder endast MySQL. Från din konfigurationsfil verkar det som att din OTS använder: $DATABASE_TYPE$ databastypen. Var vänligen ändra din databas till MySQL och följ instruktionerna i installationen igen.';
$locale['step_database_error_table'] = 'Tabell $TABLE$ finns inte. Importera din OTS databas schema först.';
$locale['step_database_error_table_exist'] = 'Tabell $TABLE$ finns redan. Ser ut som att din AAC redan är installerad. Hoppar över importering av MySQL schema.';
$locale['step_database_error_schema'] = 'Fel vid import av schema:';
$locale['step_database_success_schema'] = 'Lyckades installera $PREFIX$ tabeller.';
$locale['step_database_error_file'] = '$FILE$ kunde inte öppnas. Kopiera innehållet och klistra in här:';
$locale['step_database_adding_field'] = 'Lägger till fält';
$locale['step_database_modifying_field'] = 'Ändrar fält';
$locale['step_database_changing_field'] = 'Ändrar $FIELD$ till $FIELD_NEW$...';
$locale['step_database_imported_players'] = 'Importerar spelarprover...';
$locale['step_database_created_account'] = 'Skapade admin konto...';

// admin account
$locale['step_admin'] = 'Admin Konto';
$locale['step_admin_title'] = 'Skapa Admin Konto';
$locale['step_admin_account'] = 'Admin konto namn';
$locale['step_admin_account_desc'] = 'Namn på ditt admin konto som kommer att användas för att logga in på hemsidan och servern.';
$locale['step_admin_account_id'] = 'Admin konto ID';
$locale['step_admin_account_id_desc'] = 'ID på ditt admin konto som kommer att användas för att logga in på hemsidan och servern.';
$locale['step_admin_password'] = 'Admin konto lösenord';
$locale['step_admin_password_desc'] = 'Lösenordet till ditt admin konto.';

// finish
$locale['step_finish_admin_panel'] = 'Admin Panelen';
$locale['step_finish_homepage'] = 'hemsida';
$locale['step_finish'] = 'Klar';
$locale['step_finish_title'] = 'Installationen klar!';
$locale['step_finish_desc'] = 'Grattis! <b>MyAAC</b> är redo att användas!<br/>Du kan logga in på $ADMIN_PANEL$, eller titta till $HOMEPAGE$.<br/><br/>
<span style="color: red">Var vänligen ta bort installations mappen.</span><br/><br/>
Var vänligen rapportera buggar och förslag på $LINK$, tack!';
?>
