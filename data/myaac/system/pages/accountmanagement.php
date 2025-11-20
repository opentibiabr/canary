<?php
global $config, $db, $account_logged, $logged, $action, $template_path, $twig;
/**
 * Account management
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Account Management';

if ($config['account_country'])
    require SYSTEM . 'countries.conf.php';

$groups = new OTS_Groups_List();

$show_form = true;
$config_salt_enabled = $db->hasColumn('accounts', 'salt');

if (ACTION == "logout" && !isset($_REQUEST['account_login'])) {
    if (!defined('HOOK_LOGOUT_DISPLAY') || HOOK_LOGOUT_DISPLAY) { // plugin will take care of this message
        $twig->display('account.logout.html.twig');
    }

    return;
}

if (!$logged) {
    if (ACTION == 'confirm_email') {
        require PAGES . 'account/' . ACTION . '.php';
        return;
    }

    if (!empty($errors))
        $twig->display('error_box.html.twig', array('errors' => $errors));

    $twig->display('account.login.html.twig', array(
        'redirect' => isset($_REQUEST['redirect']) ? $_REQUEST['redirect'] : null,
        'account' => USE_ACCOUNT_NAME ? 'Name' : 'Number',
        'account_login_by' => getAccountLoginByLabel(),
        'error' => isset($errors[0]) ? $errors[0] : null
    ));

    return;
}

$errors = array();

if (isset($_REQUEST['redirect'])) {
    $redirect = urldecode($_REQUEST['redirect']);

    $twig->display('account.redirect.html.twig', array(
        'redirect' => $redirect
    ));
    return;
}

if ($action == '') {
    $freePremium = getBoolean(configLua('freePremium')) || $account_logged->getPremDays() == OTS_Account::GRATIS_PREMIUM_DAYS;
    $account_premdays = $account_logged->getPremDays();
    $daysLeft = "$account_premdays " . ($account_premdays > 1 ? ' days' : ' day');

    $recovery_key = $account_logged->getCustomField('key');
    $account_coins = $account_logged->getCustomField('coins');
    $acc_coins_transfer = $account_logged->getCustomField('coins_transferable');
    $tournament_coins = $account_logged->getCustomField('tournament_coins');

    $tag = isVipSystemEnabled() ? 'VIP' : "Premium";
    $account_status = $account_logged->isPremium()
        ? "<b><span style='color: green;'>{$tag} Account, {$daysLeft} left</span></b>"
        : (!isVipSystemEnabled() && $freePremium
            ? "<b><span style='color: green;'>Free Premium Account</span></b>"
            : '<b><span style="color: red;">Free Account</span></b>');

    if (empty($recovery_key)) {
        $account_registered = '<span style="color: red"><img src="' . $template_path . '/images/premiumfeatures/icon_no.png"> Not registered.</span>';
    } else {
        if ($config['generate_new_reckey'] && $config['mail_enabled'])
            $account_registered = '<b><span style="color: green">Yes ( <a href="' . getLink('account/register/new') . '"> Buy new Recovery Key </a> )</span></b>';
        else
            $account_registered = '<b><span style="color: green"><img src="' . $template_path . '/images/premiumfeatures/icon_yes.png"> Registered.</span></b>';
    }

    $account_created = $account_logged->getCreated();
    $account_email = $account_logged->getEMail();
    $email_new_time = $account_logged->getCustomField("email_new_time");
    if ($email_new_time > 1)
        $email_new = $account_logged->getCustomField("email_new");
    $account_rlname = $account_logged->getRLName();
    $account_location = $account_logged->getLocation();
    $account_phone = $account_logged->getCustomField("phone");
    if ($account_logged->isBanned())
        if ($account_logged->getBanTime() > 0)
            $welcome_message = '<span style="color: red">Your account is banished until ' . date("j F Y, G:i:s", $account_logged->getBanTime()) . '!</span>';
        else
            $welcome_message = '<span style="color: red">Your account is banished FOREVER!</span>';
    else
        $welcome_message = 'Welcome to your ' . configLua('serverName') . ' account!';

    $verify_message = "";
    if ($config['mail_enabled'] && $config['account_mail_verify'] && $account_logged->getCustomField('email_verified') != '1') {
      $verifyLink = getLink('account/resend/verify');
      $type = ($config['account_verified_only'] ?? false) ? 'required' : 'optional';
      $verify_message = "<span style='color: red'>Verification is {$type}! Please <b><a href='{$verifyLink}'>Verify</a></b> your Account!</span>";
    }

    $email_change = '';
    $email_request = false;
    if ($email_new_time > 1) {
        if ($email_new_time < time())
            $email_change = '<br>(You can accept <b>' . $email_new . '</b> as a new email.)';
        else {
            $email_change = ' <br>You can accept <b>new e-mail after ' . date("j F Y", $email_new_time) . ".</b>";
            $email_request = true;
        }
    }

    $actions = array();
    foreach ($account_logged->getActionsLog(0, 1000) as $action) {
        $actions[] = array('action' => $action['action'], 'date' => $action['date'], 'ip' => $action['ip'] != 0 ? long2ip($action['ip']) : inet_ntop($action['ipv6']));
    }

    $players = array();
    /** @var OTS_Players_List $account_players */
    $account_players = $account_logged->getPlayersList();
    $account_players->orderBy('id');

    $expiresIn = $account_logged->getExpirePremiumTime();
    $accountExpire = $expiresIn > 0 && $expiresIn > time()
        ? ["Your VIP Time will expire in " . date("M d Y, G:i:s", $expiresIn), false]
        : ['You do not have VIP time!', true];

    $twig->display('account.management.html.twig', array(
        'welcome_message' => $welcome_message,
        'verify_message' => $verify_message,
        'recovery_key' => $recovery_key,
        'email_change' => $email_change,
        'email_request' => $email_request,
        'email_new_time' => $email_new_time,
        'email_new' => $email_new ?? '',
        'account' => USE_ACCOUNT_NAME ? $account_logged->getName() : $account_logged->getNumber(),
        'account_premdays' => $account_premdays,
        'account_coins' => $account_coins,
        'account_coins_transferable' => $acc_coins_transfer,
        'tournament_coins' => $tournament_coins,
        'account_email' => $account_email,
        'account_created' => $account_created,
        'account_web_lastlogin' => $account_logged->getCustomField('web_lastlogin'),
        'account_status' => $account_status,
        'account_registered' => $account_registered,
        'account_rlname' => $account_rlname,
        'account_location' => $account_location,
        'account_phone' => $account_phone,
        'account_expire_time' => $accountExpire,
        'tag' => $tag,
        'actions' => $actions,
        'players' => $account_players,
        'account_update_info_on_register' => $config['account_update_info_on_register'],
    ));
} else {
    if (!ctype_alnum(str_replace(array('-', '_'), '', $action))) {
        error('Error: Action contains illegal characters.');
    } else if (file_exists(PAGES . 'account/' . $action . '.php')) {
        require PAGES . 'account/' . $action . '.php';
    } else {
        error('This page does not exists.');
    }
}
