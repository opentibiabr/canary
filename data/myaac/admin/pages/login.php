<?php
/**
 * Login
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Login';
$logout = '';
if ($action == 'logout') {
    $logout = "You have  been logged out!";
}

if (isset($errors)) {
    foreach ($errors as $error) {
        error($error);
    }
}

$twig->display('admin.login.html.twig', array(
    'logout' => $logout,
    'account' => USE_ACCOUNT_NAME ? 'Name' : 'Number',
    'account_login_by' => getAccountLoginByLabel(),
    'myaac_version' => MYAAC_VERSION,
    'errors' => isset($errors) ? $errors : ''
));
