<?php
/**
 * Account confirm mail
 * Keept for compability
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

if ($action == 'confirm_email') {
    require_once PAGES . 'account/confirm_email.php';
}
