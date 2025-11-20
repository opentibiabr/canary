<?php
/**
 * Change info
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
if ($config['account_update_info_on_register']) {
    echo 'Updating public info is disabled on this server.';
    return;
}

if (isset($_POST['changeinfosave']) && $_POST['changeinfosave'] == 1) {
    if (!isset($config['countries'][$new_country]))
        $errors[] = 'Country is not correct.';

    if (empty($errors)) {
        $new_rlname = isset($_POST['info_rlname']) ? htmlspecialchars(stripslashes($_POST['info_rlname'])) : NULL;
        $new_location = isset($_POST['info_location']) ? htmlspecialchars(stripslashes($_POST['info_location'])) : NULL;
        $new_phone = isset($_POST['info_phone']) ? htmlspecialchars(stripslashes($_POST['info_phone'])) : NULL;
        $new_country = isset($_POST['info_country']) ? htmlspecialchars(stripslashes($_POST['info_country'])) : NULL;

        //save data from form
        $account_logged->setCustomField("rlname", $new_rlname);
        $account_logged->setCustomField("location", $new_location);
        $account_logged->setCustomField("country", $new_country);
        $account_logged->setCustomField("phone", $new_phone);
        $account_logged->logAction("Changed Real Name to <b>$new_rlname</b>, Location to <b>$new_location</b>, Phone to <b>$new_phone</b> and Country to <b>{$config['countries'][$new_country]}</b>.");
        $twig->display('success.html.twig', array(
            'title' => 'Public Information Changed',
            'description' => 'Your public information has been changed.'
        ));
        $show_form = false;
    } else {
        $twig->display('error_box.html.twig', array('errors' => $errors));
    }
}

//show form
if ($show_form) {
    $account_rlname = $account_logged->getCustomField("rlname");
    $account_location = $account_logged->getCustomField("location");
    $account_phone = $account_logged->getCustomField("phone");
    if ($config['account_country']) {
        $account_country = $account_logged->getCustomField("country");

        $countries = [];
        foreach (['pl', 'se', 'br', 'us', 'gb'] as $country)
            $countries[$country] = $config['countries'][$country];

        $countries['--'] = '----------';

        foreach ($config['countries'] as $code => $country)
            $countries[$code] = $country;
    }

    $twig->display('account.change_info.html.twig', array(
        'countries' => $countries ?? [],
        'account_rlname' => $account_rlname,
        'account_location' => $account_location,
        'account_phone' => $account_phone,
        'account_country' => $account_country ?? '',
    ));
}
