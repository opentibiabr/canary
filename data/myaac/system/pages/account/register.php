<?php
/**
 * Register Account
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$show_form = true;
$reg_password = $_POST['reg_password'] ?? '';
$reg_password = encrypt(($config_salt_enabled ? $account_logged->getCustomField('salt') : '') . $reg_password);
$can_update_info = $config['account_update_info_on_register'];
$save = $_POST['registeraccountsave'] ?? null;

if ($save == "1") {
    if ($reg_password == $account_logged->getPassword()) {

        if ($can_update_info) {
            $new_rlname = isset($_POST['info_rlname']) ? htmlspecialchars(stripslashes($_POST['info_rlname'])) : NULL;
            $new_location = isset($_POST['info_location']) ? htmlspecialchars(stripslashes($_POST['info_location'])) : NULL;
            $new_phone = isset($_POST['info_phone']) ? htmlspecialchars(stripslashes($_POST['info_phone'])) : NULL;
            $new_country = isset($_POST['info_country']) ? htmlspecialchars(stripslashes($_POST['info_country'])) : NULL;
            if (!$new_rlname || !$new_location || !$new_phone || !$new_country) {
                $errors[] = 'All fields are required, please try again!';
                $show_form = true;
            }
        }

        if (empty($errors)) {
            if (empty($account_logged->getCustomField("key"))) {
                $show_form = false;
                $new_rec_key = generateRandomString($config['recovery_key_length'] ?? 15, false, true, true);

                $account_logged->setCustomField("key", $new_rec_key);

                $resultInfo = ['log' => '', 'title' => '', 'desc' => ''];
                if ($can_update_info) {
                    if (!isset($config['countries'][$new_country]))
                        $errors[] = 'Country is not correct.';

                    if (empty($errors)) {
                        //save data from form
                        $account_logged->setCustomField("rlname", $new_rlname);
                        $account_logged->setCustomField("location", $new_location);
                        $account_logged->setCustomField("country", $new_country);
                        $account_logged->setCustomField("phone", $new_phone);
                        $resultInfo = [
                            'log' => " and Updated your Real Name to <b>$new_rlname</b>, Location to <b>$new_location</b>, Phone to <b>$new_phone</b> and Country to <b>{$config['countries'][$new_country]}</b>",
                            'title' => ' and Public Information Changed',
                            'desc' => 'Your public information has been changed.<br/>',
                        ];
                        $show_form = false;
                    }
                }

                $account_logged->logAction("Generated recovery key{$resultInfo['log']}.");
                $message = '';

                if ($config['mail_enabled'] && $config['send_mail_when_generate_reckey']) {
                    $mailBody = $twig->render('mail.account.register.html.twig', array(
                        'recovery_key' => $new_rec_key
                    ));
                    if (_mail($account_logged->getEMail(), configLua('serverName') . " - Recovery Key", $mailBody))
                        $message = '<br /><small>Your recovery key were send on email address <b>' . $account_logged->getEMail() . '</b>.</small>';
                    else
                        $message = '<br /><p class="error">An error occurred while sending email. For Admin: More info can be found in system/logs/mailer-error.log</p>';
                }

                $twig->display('success.html.twig', [
                    'title' => "Account Registered{$resultInfo['title']}",
                    'description' => "{$resultInfo['desc']}Thank you for registering your account! You can now recover your account if you have lost access to the assigned email address by using the following<br/><br/><span style='font-size: 24px'>&nbsp;&nbsp;&nbsp;<b>Recovery Key: {$new_rec_key}</b></span><br/><br/><br/><b>Important:</b><ul><li>Write down this recovery key carefully.</li><li>Store it at a safe place!</li>{$message}</ul>"
                ]);
            } else
                $errors[] = 'Your account is already registered.';
        }
    } else
        $errors[] = 'Wrong password to account.';
}

if ($show_form) {
    if (!empty($errors)) {
        //show errors
        $twig->display('error_box.html.twig', ['errors' => $errors]);
    }

    $countries = [];
    if ($can_update_info && $config['account_country']) {
        $account_country = $account_logged->getCustomField("country");

        foreach (['pl', 'se', 'br', 'us', 'gb'] as $country)
            $countries[$country] = $config['countries'][$country];

        $countries['--'] = '----------';

        foreach ($config['countries'] as $code => $country)
            $countries[$code] = $country;
    }

    //show form
    $twig->display('account.generate_recovery_key.html.twig', [
        'can_update_public_info' => $can_update_info,
        'countries' => $countries,
        'account_country' => $account_country ?? '',
    ]);
}
