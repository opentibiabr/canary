<?php
/**
 * german language file
 * install.php
 *
 * @author Slawkens <slawkens@gmail.com>
 */
$locale['installation'] = 'Installation';
$locale['steps'] = 'Schritte';

$locale['previous'] = 'Zurück';
$locale['next'] = 'Weiter';

$locale['on'] = 'Ein';
$locale['off'] = 'Aus';

$locale['loaded'] = 'Geladen';
$locale['not_loaded'] = 'Nicht geladen';

$locale['loading_spinner'] = 'Bitte warten, installieren...';
$locale['importing_spinner'] = 'Bitte warte, Daten werden importiert...';
$locale['please_fill_all'] = 'Bitte füllen Sie alle Felder aus!';
$locale['already_installed'] = 'MyAAC wurde bereits installiert. Bitte löschen <b>install/</b> Verzeichnis. Wenn Sie MyAAC neu installieren möchten, löschen Sie die Datei <strong>config.local.php</strong> aus dem Hauptverzeichnis und aktualisieren Sie die Seite.';

// welcome
$locale['step_welcome'] = 'Willkommen';
$locale['step_welcome_title'] = 'Willkommen beim Installer';
$locale['step_welcome_desc'] = 'Wählen Sie die Sprache, mit der Sie das Installationsprogramm anzeigen möchten';

// license
$locale['step_license'] = 'Lizenz';
$locale['step_license_title'] = 'GNU/GPL Lizenz';

// requirements
$locale['step_requirements'] = 'Anforderungen';
$locale['step_requirements_title'] = 'Anforderungen überprüfen';
$locale['step_requirements_php_version'] = 'PHP Version';
$locale['step_requirements_write_perms'] = 'Schreibberechtigungen';
$locale['step_requirements_failed'] = 'Die Installation wird deaktiviert, bis diese Anforderungen erfüllt sind.</b><br/>Für weitere Informationen siehe <b>README</b> Datei.';
$locale['step_requirements_extension'] = '$EXTENSION$ PHP Erweiterung';

// config
$locale['step_config'] = 'Konfiguration';
$locale['step_config_title'] = 'Grundkonfiguration';
$locale['step_config_server_path'] = 'Serverpfad';
$locale['step_config_server_path_desc'] = 'Pfad zu Ihrem Canary-Hauptverzeichnis, in dem sich die config.lua befinden.';
$locale['step_config_mail_admin'] = 'Admin E-Mail';
$locale['step_config_mail_admin_desc'] = 'Adresse, an die E-Mails aus dem Kontaktformular gesendet werden, z. B. admin@gmail.com';
$locale['step_config_mail_admin_error'] = 'Admin E-Mail ist nicht korrekt.';
$locale['step_config_mail_address'] = 'Server E-Mail';
$locale['step_config_mail_address_desc'] = 'Adresse, die für ausgehende E-Mails (von :) verwendet wird, zB no-reply@your-server.org';
$locale['step_config_mail_address_error'] = 'Server E-Mail ist nicht korrekt.';
$locale['step_config_timezone'] = 'Zeitzone';
$locale['step_config_timezone_desc'] = 'Wird für Datumsfunktionen verwendet';
$locale['step_config_timezone_error'] = 'Zeitzone ist nicht korrekt.';
$locale['step_config_client'] = 'Client Version';
$locale['step_config_client_desc'] = 'Wird für die Downloadseite und einige Vorlagen verwendet';
$locale['step_config_client_error'] = 'Client ist nicht korrekt.';

// database
$locale['step_database'] = 'Schema importieren';
$locale['step_database_title'] = 'MySQL schema importieren';
$locale['step_database_importing'] = 'Ihre Datenbank ist MySQL. Datenbankname ist: "$DATABASE_NAME$". Schema wird jetzt importiert...';
$locale['step_database_config_saved'] = 'Die lokale Konfiguration wurde in einer Datei gespeichert: config.local.php';
$locale['step_database_error_path'] = 'Bitte geben Sie den Serverpfad an.';
$locale['step_database_error_config'] = 'Datei config.lua kann nicht gefunden werden. Ist der Serverpfad korrekt? Gehen Sie zurück und überprüfen Sie noch einmal.';
$locale['step_database_error_database_empty'] = 'Der Datenbanktyp kann nicht aus config.lua ermittelt werden. Ihr OTS wird von diesem AAC nicht unterstützt.';
$locale['step_database_error_only_mysql'] = 'Dieser AAC unterstützt nur MySQL. Aus Ihrer Konfigurationsdatei scheint Ihr OTS die Datenbank $DATABASE_TYPE$ zu verwenden. Bitte ändern Sie Ihre Datenbank in MySQL und folgen Sie dann der Installation erneut.';
$locale['step_database_error_table'] = 'Die Tabelle $TABLE$ existiert nicht. Bitte importieren Sie zuerst Ihr OTS-Datenbankschema.';
$locale['step_database_error_table_exist'] = 'Die Tabelle $TABLE$ existiert bereits. Scheint, dass AAC bereits installiert ist. Das Importieren des MySQL-Schemas wird übersprungen..';
$locale['step_database_error_mysql_connect'] = 'Verbindung zur MySQL-Datenbank nicht möglich.';
$locale['step_database_error_mysql_connect_2'] = 'Mögliche Gründe:';
$locale['step_database_error_mysql_connect_3'] = 'MySQL ist nicht richtig konfiguriert in <i>config.lua</i>.';
$locale['step_database_error_mysql_connect_4'] = 'MySQL-Server läuft nicht.';
$locale['step_database_error_schema'] = 'Fehler beim Importieren des Schemas:';
$locale['step_database_success_schema'] = '$PREFIX$ Tabellen wurden erfolgreich installiert.';
$locale['step_database_error_file'] = '$FILE$ konnte nicht geöffnet werden. Bitte kopieren Sie diesen Inhalt und fügen Sie ihn dort ein:';
$locale['step_database_adding_field'] = 'Folgendes Feld wurde hinzugefügt: ';
$locale['step_database_modifying_field'] = 'Folgendes Feld wurde geändert: ';
$locale['step_database_changing_field'] = 'Änderung von $FIELD$ zu $FIELD_NEW$...';
$locale['step_database_imported_players'] = 'Spielerproben wurden importiert...';
$locale['step_database_loaded_items'] = 'Items wurden geladen...';
$locale['step_database_loaded_weapons'] = 'Weapons wurden geladen...';
$locale['step_database_loaded_monsters'] = 'Monster wurden geladen...';
$locale['step_database_error_monsters'] = 'Beim Laden der Datei monsters.xml sind einige Probleme aufgetreten. Bitte überprüfen Sie $LOG$ für weitere Informationen.';
$locale['step_database_loaded_spells'] = 'Zauber wurden geladen...';
$locale['step_database_created_account'] = 'Administratorkonto wurde erstellt...';
$locale['step_database_created_news'] = 'Neuigkeiten wurden erstellt...';

// admin account
$locale['step_admin'] = 'Administratorkonto';
$locale['step_admin_title'] = 'Administratorkonto erstellen';
$locale['step_admin_account'] = 'Name des Administratorkontos';
$locale['step_admin_account_desc'] = 'Name Ihres Admin-Accounts, der für die Anmeldung an der Website und dem Server verwendet wird.';
$locale['step_admin_account_error_format'] = 'Ungültiges Kontonamensformat. Verwenden Sie nur a-Z und Ziffern 0-9. Mindestens 3, maximal 32 Zeichen.';
$locale['step_admin_account_error_same'] = 'Das Passwort darf nicht mit dem Kontonamen übereinstimmen.';
$locale['step_admin_account_id'] = 'Administrator Kontonummer';
$locale['step_admin_account_id_desc'] = 'Nummer Ihres Admin-Accounts, der für die Anmeldung bei der Website und dem Server verwendet wird.';
$locale['step_admin_account_id_error_format'] = 'Ungültiges Kontonummernformat. Bitte benutzen Sie nur die Nummern 0-9. Mindestens 6, maximal 10 Zeichen.';
$locale['step_admin_account_id_error_same'] = 'Das Passwort darf nicht mit der Kontonummer übereinstimmen';
$locale['step_admin_password'] = 'Administrator Konto Passwort';
$locale['step_admin_password_desc'] = 'Passwort für Ihr Administratorkonto.';
$locale['step_admin_password_error_empty'] = 'Bitte geben Sie das Passwort für Ihr neues Konto ein.';
$locale['step_admin_password_error_format'] = 'Ungültiges Passwortformat. Verwenden Sie nur a-Z und Ziffern 0-9. Mindestens 8, maximal 30 Zeichen.';

// finish
$locale['step_finish_admin_panel'] = 'Admin Bereich';
$locale['step_finish_homepage'] = 'Startseite';
$locale['step_finish'] = 'Fertig';
$locale['step_finish_title'] = 'Installation beendet!';
$locale['step_finish_desc'] = 'Herzlichen Glückwunsch! <b>MyAAC</b> ist bereit zu verwenden!<br/>Sie können sich jetzt im $ADMIN_PANEL$ anmelden, oder die $HOMEPAGE$ besuchen.<br/><br/>
<span style="color: red">Bitte lösche install/ Verzeichnis.</span><br/><br/>
Bitte senden Sie Fehler und Vorschläge zu $LINK$, Vielen Dank!';
?>
