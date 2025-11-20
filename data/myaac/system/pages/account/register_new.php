<?php
/**
 * Register Account New
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

if (isset($_POST['reg_password']))
    $reg_password = encrypt(($config_salt_enabled ? $account_logged->getCustomField('salt') : '') . $_POST['reg_password']);

$reckey = $account_logged->getCustomField('key');
if ((!$config['generate_new_reckey'] || !$config['mail_enabled']) || empty($reckey))
    echo "You can't get new recovery key";
else {
    $coinType = $config['account_coin_type_usage'] ?? 'coins_transferable';
    $coinName = $coinType == 'coins' ? $coinType : 'transferable coins';
    $needCoins = $config['generate_new_reckey_price'];

    $coins = $account_logged->getCustomField($coinType);
    if (isset($_POST['registeraccountsave']) && $_POST['registeraccountsave'] == '1') {
        if ($reg_password == $account_logged->getPassword()) {
            if ($coins < $needCoins) {
                $errors[] = "You need {$needCoins} {$coinName} to generate new recovery key. You have <b>{$coins}</b> {$coinName}.";
            } else {
                $show_form = false;
                $new_rec_key = generateRandomString($config['recovery_key_length'] ?? 15, false, true, true);

                $mailBody = $twig->render('mail.account.register.html.twig', array(
                    'recovery_key' => $new_rec_key
                ));

                if (_mail($account_logged->getEMail(), $config['lua']['serverName'] . " - new recovery key", $mailBody)) {
                    $account_logged->setCustomField("key", $new_rec_key);
                    $account_logged->setCustomField($coinType, $account_logged->getCustomField($coinType) - $needCoins);
                    $account_logged->logAction("Generated new recovery key for {$needCoins} {$coinName}");
                    $message = "<br />Your recovery key were send on email address <b>{$account_logged->getEMail()}</b> for {$needCoins} {$coinName}";
                } else
                    $message = '<br /><p class="error">An error occurred while sending email ( <b>' . $account_logged->getEMail() . '</b> ) with recovery key! Recovery key not changed. Try again later. For Admin: More info can be found in system/logs/mailer-error.log</p>';

                $twig->display('success.html.twig', array(
                    'title' => 'Account Registered',
                    'description' => '<ul>' . $message . '</ul>'
                ));
            }
        } else
            $errors[] = 'Wrong password to account.';
    }

    //show errors if not empty
    if (!empty($errors)) {
        $twig->display('error_box.html.twig', array('errors' => $errors));
    }

    if ($show_form) {
        //show form
        $twig->display('account.generate_new_recovery_key.html.twig', array(
            'coins'     => $coins,
            'coin_type' => $coinType,
            'coin_name' => $coinName,
            'color'     => $coins >= $needCoins ? 'green' : 'red',
        ));
    }
}
