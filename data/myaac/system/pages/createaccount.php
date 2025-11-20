<?php
global $config, $logged, $db, $hooks, $template_path, $twig;
/**
 * Create account
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Create Account';

if ($config['account_country'])
    require SYSTEM . 'countries.conf.php';

if ($logged) {
    ?>
    <div class="TableContainer">
        <div class="CaptionContainer">
            <div class="CaptionInnerContainer">
                <span class="CaptionEdgeLeftTop"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
                <span class="CaptionEdgeRightTop"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
                <span class="CaptionBorderTop"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/table-headline-border.gif);"></span>
                <span class="CaptionVerticalLeft"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-vertical.gif);"></span>
                <div class="Text">Please logout before attempting to create a new account.</div>
                <span class="CaptionVerticalRight"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-vertical.gif);"></span>
                <span class="CaptionBorderBottom"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/table-headline-border.gif);"></span>
                <span class="CaptionEdgeLeftBottom"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
                <span class="CaptionEdgeRightBottom"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
            </div>
        </div>
        <table class="Table3" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <td>
                    <div class="InnerTableContainer">
                        <table style="width:100%;">
                            <tbody>
                            <tr>
                                <td>
                                    <div class="TableContentContainer">
                                        <table class="TableContent" width="100%" style="border:1px solid #faf0d7;">
                                            <tbody>
                                            <tr bgcolor="#F1E0C6">
                                                <td>Please logout before attempting to create a new account.</td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <br>
    <div style="width: 135px; margin: 0 auto;">
        <div class="BigButton"
             style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton.gif)"><a
                href="?account/manage">
                <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                    <div class="BigButtonOver"
                         style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_over.gif); visibility: hidden;"></div>
                    <input class="BigButtonText" type="button" value="Login"></div>
            </a></div>
    </div>
    <?php
    return;
}

if (config('account_create_character_create')) {
    require_once LIBS . 'CreateCharacter.php';
    $createCharacter = new CreateCharacter();
}

$account_type = USE_ACCOUNT_NAME ? 'name' : 'number';
$errors = array();
$save = isset($_POST['save']) && $_POST['save'] == 1;
if ($save) {
    if (USE_ACCOUNT_NAME) {
        $account_name = $_POST['account'];
    } else {
        $account_id = $_POST['account'];
    }

    $email = $_POST['email'];
    $password = $_POST['password'];
    $password2 = $_POST['password2'];

    // account
    if (isset($account_id)) {
        if (!Validator::accountId($account_id))
            $errors['account'] = Validator::getLastError();
    } else if (!Validator::accountName($account_name))
        $errors['account'] = Validator::getLastError();

    // email
    if (!Validator::email($email))
        $errors['email'] = Validator::getLastError();

    // country
    $country = '';
    if ($config['account_country']) {
        $country = $_POST['country'];
        if (!isset($country))
            $errors['country'] = 'Country is not set.';
        elseif (!isset($config['countries'][$country]))
            $errors['country'] = 'Country is invalid.';
    }

    if ($config['recaptcha_enabled']) {
        if (isset($_POST['g-recaptcha-response']) && !empty($_POST['g-recaptcha-response'])) {
            $verifyResponse = file_get_contents('https://www.google.com/recaptcha/api/siteverify?secret=' . $config['recaptcha_secret_key'] . '&response=' . $_POST['g-recaptcha-response']);
            $responseData = json_decode($verifyResponse);
            if (!$responseData->success)
                $errors['verification'] = "Please confirm that you're not a robot.";
        } else
            $errors['verification'] = "Please confirm that you're not a robot.";
    }

    // password
    if (empty($password)) {
        $errors['password'] = 'Please enter the password for your new account.';
    } elseif ($password != $password2) {
        $errors['password'] = 'Passwords are not the same.';
    } else if (!Validator::password($password)) {
        $errors['password'] = Validator::getLastError();
    }

    // check if account name is not equal to password
    if (USE_ACCOUNT_NAME && strtoupper($account_name) == strtoupper($password)) {
        $errors['password'] = 'Password may not be the same as account name.';
    }

    if ($config['account_mail_unique']) {
        $test_email_account = new OTS_Account();
        $test_email_account->findByEMail($email);
        if ($test_email_account->isLoaded())
            $errors['email'] = 'Account with this e-mail address already exist.';
    }

    $account_db = new OTS_Account();
    if (USE_ACCOUNT_NAME)
        $account_db->find($account_name);
    else
        $account_db->load($account_id);

    if ($account_db->isLoaded()) {
        $errors['account'] = USE_ACCOUNT_NAME ? 'Account with this name already exist.' : 'Account with this id already exist.';
    }

    if (!isset($_POST['accept_rules']) || $_POST['accept_rules'] !== 'true')
        $errors['accept_rules'] = 'You have to agree to the ' . $config['lua']['serverName'] . ' Rules in order to create an account!';

    $params = array(
        'account' => $account_db,
        'email' => $email,
        'country' => $country,
        'password' => $password,
        'password2' => $password2,
        'accept_rules' => isset($_POST['accept_rules']) && $_POST['accept_rules'] === 'true',
    );

    if (USE_ACCOUNT_NAME) {
        $params['account_name'] = $_POST['account'];
    } else {
        $params['account_id'] = $_POST['account'];
    }

    $hooks->trigger(HOOK_ACCOUNT_CREATE_AFTER_SUBMIT, $params);

    if (config('account_create_character_create')) {
        $character_name = isset($_POST['name']) ? stripslashes(ucwords(strtolower($_POST['name']))) : null;
        $character_sex = isset($_POST['sex']) ? (int)$_POST['sex'] : null;
        $character_vocation = isset($_POST['vocation']) ? (int)$_POST['vocation'] : null;
        $character_town = isset($_POST['town']) ? (int)$_POST['town'] : null;
        $createCharacter->check($character_name, $character_sex, $character_vocation, $character_town, $errors);
    }

    if (empty($errors)) {
        $new_account = new OTS_Account();
        if (USE_ACCOUNT_NAME)
            $new_account->create($account_name);
        else
            $new_account->create(NULL, $account_id);

        $config_salt_enabled = $db->hasColumn('accounts', 'salt');
        if ($config_salt_enabled) {
            $salt = generateRandomString(10, false, true, true);
            $password = $salt . $password;
        }

        $new_account->setPassword(encrypt($password));
        $new_account->setEMail($email);
        $new_account->save();

        if ($config_salt_enabled)
            $new_account->setCustomField('salt', $salt);

        $new_account->setCustomField('created', time());
        $new_account->logAction('Account created.');

        if ($config['account_country']) {
            $new_account->setCustomField('country', $country);
        }

        if ($config['account_premium_days'] && $config['account_premium_days'] > 0) {
            if ($db->hasColumn('accounts', 'premend')) { // othire
                $new_account->setCustomField('premend', time() + $config['account_premium_days'] * 86400);
            } else { // rest
                $premdays = $config['account_premium_days'];
                $new_account->setCustomField('premdays', $premdays);
                $lastDay = ($premdays > 0 && $premdays < OTS_Account::GRATIS_PREMIUM_DAYS) ? time() + ($premdays * 86400) : 0;
                $new_account->setCustomField('lastday', $lastDay);
            }
        }

        if (($welcomeCoins = ($config['account_welcome_coins'] ?? 0)) > 0) {
          $coinType = $config['account_coin_type_usage'] ?? 'coins_transferable';
          $new_account->setCustomField($coinType, $welcomeCoins);
        }

        $tmp_account = (USE_ACCOUNT_NAME ? $account_name : $account_id);
        if ($config['mail_enabled'] && $config['account_mail_verify']) {
            $hash = md5(generateRandomString(16, true, true) . $email);
            $new_account->setCustomField('email_hash', $hash);

            $verify_url = getLink('account/confirm_email/' . $hash);
            $body_html = $twig->render('mail.account.verify.html.twig', array(
                'account' => $tmp_account,
                'verify_url' => generateLink($verify_url, $verify_url, true)
            ));

            if (_mail($email, 'New account on ' . $config['lua']['serverName'], $body_html)) {
                echo 'Your account has been created.<br/><br/>';
                $twig->display('success.html.twig', array(
                    'title' => 'Account Created',
                    'description' => 'Your account ' . $account_type . ' is <b>' . $tmp_account . '</b><br/>You will need the account ' . $account_type . ' and your password to play on ' . configLua('serverName') . '.
						Please keep your account ' . $account_type . ' and password in a safe place and
						never give your account ' . $account_type . ' or password to anybody.',
                    'custom_buttons' => config('account_create_character_create') ? '' : null
                ));
            } else {
                error('An error occurred while sending email! Account not created. Try again. For Admin: More info can be found in system/logs/mailer-error.log');
                $new_account->delete();
            }
        } else {
            if (config('account_create_character_create')) {
                // character creation
                $character_created = $createCharacter->doCreate($character_name, $character_sex, $character_vocation, $character_town, $new_account, $errors);
                if (!$character_created) {
                    error('There was an error creating your character. Please create your character later in account management page.');
                    error(implode(' ', $errors));
                }
            }

            if ($config['account_create_auto_login']) {
                $_POST['account_login'] = USE_ACCOUNT_NAME ? $account_name : $account_id;
                $_POST['password_login'] = $password2;

                require SYSTEM . 'login.php';
                header('Location: ' . getLink('account/manage'));
            }

            echo 'Your account';
            if (config('account_create_character_create')) {
                echo ' and character have';
            } else {
                echo ' has';
            }

            echo ' been created.';
            if (!config('account_create_character_create')) {
                echo ' Now you can login and create your first character.';
            }

            echo ' See you in Tibia!<br/><br/>';
            $twig->display('success.html.twig', array(
                'title' => 'Account Created',
                'description' => 'Your account ' . $account_type . ' is <b>' . $tmp_account . '</b><br/>You will need the account ' . $account_type . ' and your password to play on ' . configLua('serverName') . '.
						Please keep your account ' . $account_type . ' and password in a safe place and
						never give your account ' . $account_type . ' or password to anybody.',
                'custom_buttons' => config('account_create_character_create') ? '' : null
            ));

            if ($config['mail_enabled'] && $config['account_welcome_mail']) {
                $mailBody = $twig->render('account.welcome_mail.html.twig', array(
                    'account' => $tmp_account,
                    'email' => $email,
                    'password' => $password ?? null
                ));

                if (_mail($email, 'Your account on ' . $config['lua']['serverName'], $mailBody))
                    echo '<br /><small>This information was sent on email address <b>' . $email . '</b>.';
                else {
                    error('An error occurred while sending email. For Admin: More info can be found in system/logs/mailer-error.log');
                }
            }
        }

        return;
    }
}

$country_recognized = null;
if ($config['account_country_recognize']) {
    $country_session = getSession('country');
    if ($country_session !== false) { // get from session
        $country_recognized = $country_session;
    } else {
        $info = json_decode(@file_get_contents('http://ipinfo.io/' . $_SERVER['REMOTE_ADDR'] . '/geo'), true);
        if (isset($info['country'])) {
            $country_recognized = strtolower($info['country']);
            setSession('country', $country_recognized);
        }
    }
}

if (!empty($errors))
    $twig->display('error_box.html.twig', array('errors' => $errors));

if ($config['account_country']) {
    $countries = array();
    foreach (array('pl', 'se', 'br', 'us', 'gb') as $c)
        $countries[$c] = $config['countries'][$c];

    $countries['--'] = '----------';
    foreach ($config['countries'] as $code => $c)
        $countries[$code] = $c;
}

$twig->display('account.create.js.html.twig');

$params = array(
    'account' => $_POST['account'] ?? '',
    'email' => $_POST['email'] ?? '',
    'countries' => $countries ?? null,
    'accept_rules' => $_POST['accept_rules'] ?? false,
    'country_recognized' => $country_recognized,
    'country' => $country ?? null,
    'errors' => $errors,
    'save' => $save
);

if ($save && config('account_create_character_create')) {
    $params = array_merge($params, array(
        'name' => $character_name,
        'sex' => $character_sex,
        'vocation' => $character_vocation,
        'town' => $character_town
    ));
}

$twig->display('account.create.html.twig', $params);
