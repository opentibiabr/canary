<?php
/**
 * polish language file
 * install.php
 *
 * @author Slawkens <slawkens@gmail.com>
 */
$locale['installation'] = 'Instalacja';
$locale['steps'] = 'Kroki';

$locale['previous'] = 'Poprzedni';
$locale['next'] = 'Następny';

$locale['on'] = 'Włączone';
$locale['off'] = 'Wyłączone';

$locale['loaded'] = 'Załadowane';
$locale['not_loaded'] = 'Nie załadowane';

$locale['loading_spinner'] = 'Proszę czekać, trwa instalacja...';
$locale['importing_spinner'] = 'Proszę czekać, trwa importowanie danych...';
$locale['please_fill_all'] = 'Proszę wypełnić wszystkie pola!';
$locale['already_installed'] = 'MyAAC został już zainstalowany. Proszę usunąć katalog <b>install/</b>. Jeśli chcesz zainstalować MyAAC od nowa - proszę usuń plik <strong>config.local.php</strong> z katalogu głównego i odśwież stronę.';

// welcome
$locale['step_welcome'] = 'Witamy';
$locale['step_welcome_title'] = 'Witamy w instalatorze';
$locale['step_welcome_desc'] = 'Wybierz język w którym chciałbyś przeprowadzić instalację';

// license
$locale['step_license'] = 'Licencja';
$locale['step_license_title'] = 'Licencja GNU/GPL';

// requirements
$locale['step_requirements'] = 'Wymagania';
$locale['step_requirements_title'] = 'Sprawdzanie wymagań';
$locale['step_requirements_php_version'] = 'Wersja PHP';
$locale['step_requirements_write_perms'] = 'Uprawnienia do zapisu';
$locale['step_requirements_failed'] = 'Instalacja zostanie zablokowana dopóki te wymagania nie zostaną spełnione.</b><br/>Po więcej informacji zasięgnij do pliku <b>README</b>.';
$locale['step_requirements_extension'] = 'Rozszerzenie PHP - $EXTENSION$';

// config
$locale['step_config'] = 'Konfiguracja';
$locale['step_config_title'] = 'Podstawowa konfiguracja';
$locale['step_config_server_path'] = 'Ścieżka do serwera';
$locale['step_config_server_path_desc'] = 'Ścieżka do Twojego folderu z Canary, gdzie znajduje się plik config.lua.';
$locale['step_config_mail_admin'] = 'E-Mail admina';
$locale['step_config_mail_admin_desc'] = 'Na ten adres będą dostarczane E-Maile z formularza kontaktowego , przykładowo admin@gmail.com';
$locale['step_config_mail_admin_error'] = 'E-Mail admina jest niepoprawny.';
$locale['step_config_mail_address'] = 'E-Mail serwera';
$locale['step_config_mail_address_desc'] = 'Ten adres będzie używany do wysyłanych wiadomości z serwera (from:), przykładowo no-reply@twój-serwer.org';
$locale['step_config_mail_address_error'] = 'E-Mail serwera jest niepoprawny.';
$locale['step_config_client'] = 'Wersja klienta';
$locale['step_config_client_desc'] = 'Używana do strony pobieranie klienta oraz kilku szablonów';

// database
$locale['step_database'] = 'Baza Danych';
$locale['step_database_title'] = 'Baza MySQL';
$locale['step_database_importing'] = 'Twoja baza to MySQL. Nazwa bazy danych to: "$DATABASE_NAME$". Importowanie schematu...';
$locale['step_database_config_saved'] = 'Lokalna konfiguracja została zapisana do pliku: config.local.php';
$locale['step_database_error_path'] = 'Proszę podać ścieżkę do serwera.';
$locale['step_database_error_config'] = 'Nie można znaleźć pliku config.lua. Czy ścieżka do katalogu serwera jest poprawna? Wróć się i sprawdź ponownie.';
$locale['step_database_error_database_empty'] = 'Nie można wykryć typu bazy danych z pliku config.lua. Prawdopodobnie Twój OTS nie jest wspierany przez ten AAC.';
$locale['step_database_error_only_mysql'] = 'Ten AAC wspiera tylko bazy danych MySQL. Z Twojego pliku config wynika, że Twój serwera używa bazy: $DATABASE_TYPE$. Proszę zmienić typ bazy na MySQL i ponownie przystąpić do instalacji.';
$locale['step_database_error_table'] = 'Tabela $TABLE$ nie istnieje. Proszę najpierw zaimportować schemat bazy danych serwera OTS.';
$locale['step_database_error_table_exist'] = 'Tabela $TABLE$ już istnieje. Wygląda na to, że AAC został już zainstalowany. Schemat MySQL nie zostanie zaimportowany..';
$locale['step_database_error_mysql_connect'] = 'Nie udało się połączyć z bazą danych MySQL.';
$locale['step_database_error_mysql_connect_2'] = 'Możliwe przyczyny:';
$locale['step_database_error_mysql_connect_3'] = 'MySQL nie jest poprawnie skonfigurowane w <i>config.lua</i>.';
$locale['step_database_error_mysql_connect_4'] = 'Serwer MySQL nie jest uruchomiony.';
$locale['step_database_error_schema'] = 'Błąd podczas importowania struktury bazy danych:';
$locale['step_database_success_schema'] = 'Pomyślnie zainstalowano tabele $PREFIX$.';
$locale['step_database_error_file'] = '$FILE$ nie mógł zostać otwarty. Proszę skopiować zawartość pola tekstowego i wkleić do tego pliku:';
$locale['step_database_adding_field'] = 'Dodawanie pola';
$locale['step_database_modifying_field'] = 'Modyfikacja pola';
$locale['step_database_changing_field'] = 'Zmiana $FIELD$ na $FIELD_NEW$...';
$locale['step_database_imported_players'] = 'Importowanie schematów graczy...';
$locale['step_database_loaded_items'] = 'Załadowano przedmioty (items)...';
$locale['step_database_loaded_weapons'] = 'Załadowano bronie (weapons)...';
$locale['step_database_loaded_monsters'] = 'Załadowano potworki (monsters)...';
$locale['step_database_error_monsters'] = 'Wystąpiły problemy podczas ładowania pliku monsters.xml. Zobacz $LOG$ po więcej informacji.';
$locale['step_database_loaded_spells'] = 'Załadowano czary (spells)...';
$locale['step_database_created_account'] = 'Utworzono konto admina...';
$locale['step_database_created_news'] = 'Utworzono newsy...';

// admin account
$locale['step_admin'] = 'Konto Admina';
$locale['step_admin_title'] = 'Tworzenie Konta Admina';
$locale['step_admin_email'] = 'Adres E-Mail Admina';
$locale['step_admin_email_desc'] = 'E-Mail do Twojego konta admina, który może zostać użyty do przypomnienia hasła.';
$locale['step_admin_email_error_empty'] = 'Proszę podać adres E-Mail do nowego konta.';
$locale['step_admin_email_error_format'] = 'Niepoprawny format adresu E-Mail.';
$locale['step_admin_account'] = 'Nazwa Konta Admina';
$locale['step_admin_account_desc'] = 'Nazwa Twojego konta admina, która będzie używana do logowania na stronę i do serwera.';
$locale['step_admin_account_error_empty'] = 'Proszę podać nazwę konta.';
$locale['step_admin_account_error_format'] = 'Nieprawidłowy format nazwy konta. Używaj tylko znaków a-Z oraz liczb 0-9. Minimum 3, maksimum 32 znaków.';
$locale['step_admin_account_error_same'] = 'Hasło nie może być takie same jak nazwa konta.';
$locale['step_admin_account_id'] = 'Numer Konta Admina';
$locale['step_admin_account_id_desc'] = 'Numer Twojego Konta Admina, który będzie używany do logowania do strony i na serwer.';
$locale['step_admin_account_id_error_empty'] = 'Proszę podać numer konta.';
$locale['step_admin_account_id_error_format'] = 'Nieprawidłowy format numeru konta. Używaj tylko liczb 0-9. Minimum 6, maksimum 10 znaków.';
$locale['step_admin_account_id_error_same'] = 'Hasło nie może być takie same jak numer konta.';
$locale['step_admin_password'] = 'Hasło Konta Admina';
$locale['step_admin_password_desc'] = 'Hasło do Twojego Konta Admina.';
$locale['step_admin_password_error_empty'] = 'Proszę podać hasło do Twojego nowego konta.';
$locale['step_admin_password_error_format'] = 'Nieprawidłowy format hasła. Używaj tylko znaków a-Z oraz liczb 0-9. Minimum 8, maksimum 30 znaków.';
$locale['step_admin_player_name'] = 'Nazwa postaci';
$locale['step_admin_player_name_desc'] = 'Nazwa postaci Konta Admina.';
$locale['step_admin_player_name_error_empty'] = 'Proszę podać nazwę postaci.';
$locale['step_admin_player_name_error_format'] = 'Niepoprawny format nazwy postaci. Używaj tylko znaków A-Z, spacji oraz \'. Minimum 3, maksimum 25 znaków.';

// finish
$locale['step_finish_admin_panel'] = 'Panelu Admina';
$locale['step_finish_homepage'] = 'stronę główną';
$locale['step_finish'] = 'Koniec';
$locale['step_finish_title'] = 'Instalacja zakończona!';
$locale['step_finish_desc'] = 'Gratulacje! <b>MyAAC</b> jest gotowy do użycia!<br/>Możesz się teraz zalogować do $ADMIN_PANEL$, albo odwiedzić $HOMEPAGE$.<br/><br/>
<span style="color: red">Proszę usunąć katalog <b>install/</b>.</span><br/><br/>
Wrzuć błędy i sugestie na $LINK$, dzięki!';
?>
