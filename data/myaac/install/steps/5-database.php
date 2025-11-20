<?php
defined('MYAAC') or die('Direct access not allowed!');

//ini_set('display_errors', false);
ini_set('max_execution_time', 300);
$error = false;

if (!isset($_SESSION['var_server_path'])) {
    error($locale['step_database_error_path']);
    $error = true;
}

if (!$error) {
    $content = "<?php";
    $content .= PHP_EOL;
    $content .= '// place for your configuration directives, so you can later easily update myaac';
    $content .= PHP_EOL;
    $content .= '$config[\'installed\'] = true;';
    $content .= PHP_EOL;
    // by default, set env to prod
    // user can disable when he wants
    $content .= '$config[\'env\'] = \'prod\'; // dev or prod';
    $content .= PHP_EOL;
    $content .= '$config[\'mail_enabled\'] = true;';
    $content .= PHP_EOL;
    foreach ($_SESSION as $key => $value) {
        if (strpos($key, 'var_') !== false) {
            if ($key === 'var_server_path') {
                $value = str_replace("\\", "/", $value);
                if ($value[strlen($value) - 1] !== '/')
                    $value .= '/';
            }

            if (!in_array($key, array('var_account', 'var_account_id', 'var_password', 'var_step', 'var_email', 'var_player_name'), true)) {
                $content .= '$config[\'' . str_replace('var_', '', $key) . '\'] = \'' . $value . '\';';
                $content .= PHP_EOL;
            }
        }
    }

    require BASE . 'install/includes/config.php';

    if (!$error) {
        require BASE . 'install/includes/database.php';

        $locale['step_database_importing'] = str_replace('$DATABASE_NAME$', config('database_name'), $locale['step_database_importing']);
        success($locale['step_database_importing']);

        if (isset($database_error)) { // we failed connect to the database
            error($database_error);
        } else {
            if (!$db->hasTable('accounts')) {
                $tmp = str_replace('$TABLE$', 'accounts', $locale['step_database_error_table']);
                error($tmp);
                $error = true;
            }

            if (!$db->hasTable('players')) {
                $tmp = str_replace('$TABLE$', 'players', $locale['step_database_error_table']);
                error($tmp);
                $error = true;
            }

            if (!$db->hasTable('guilds')) {
                $tmp = str_replace('$TABLE$', 'guilds', $locale['step_database_error_table']);
                error($tmp);
                $error = true;
            }

            if (!$error) {
                $twig->display('install.installer.html.twig', array(
                    'url' => 'tools/5-database.php',
                    'message' => $locale['loading_spinner']
                ));

                if (!Validator::email($_SESSION['var_mail_admin'])) {
                    error($locale['step_config_mail_admin_error']);
                    $error = true;
                }

                if (!Validator::email($_SESSION['var_mail_address'])) {
                    error($locale['step_config_mail_address_error']);
                    $error = true;
                }

                $content .= '$config[\'session_prefix\'] = \'myaac_' . generateRandomString(8, true, false, true, false) . '_\';';
                $content .= PHP_EOL;
                $content .= '$config[\'cache_prefix\'] = \'myaac_' . generateRandomString(8, true, false, true, false) . '_\';';

                $saved = true;
                if (!$error) {
                    $saved = file_put_contents(BASE . 'config.local.php', $content);
                }

                if ($saved) {
                    success($locale['step_database_config_saved']);
                    if (!$error) {
                        $_SESSION['saved'] = true;
                    }
                } else {
                    $_SESSION['config_content'] = $content;
                    unset($_SESSION['saved']);

                    $locale['step_database_error_file'] = str_replace('$FILE$', '<b>' . BASE . 'config.local.php</b>', $locale['step_database_error_file']);
                    error($locale['step_database_error_file'] . '<br/><textarea cols="70" rows="10">' . $content . '</textarea>');
                }
            }
        }
    }
}
?>

<form action="<?= BASE_URL; ?>install/" method="post">
    <input type="hidden" name="step" id="step" value="admin"/>
    <?= next_buttons(true, !$error); ?>
</form>
