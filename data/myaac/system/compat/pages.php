<?php
/**
 * Compat pages (backward support for Gesior AAC)
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
switch ($page) {
    case 'adminpanel':
        header('Location: ' . ADMIN_URL);
        die;

    case 'archive':
        $page = 'newsarchive';
        break;

    case 'whoisonline':
        $page = 'online';
        break;

    case 'latestnews':
        $page = 'news';
        break;

    case 'tibiarules':
        $page = 'rules';
        break;

    case 'killstatistics':
        $page = 'lastkills';
        break;

    case 'buypoints':
        $page = 'points';
        break;

    case 'shopsystem':
        $page = 'gifts';
        break;

    default:
        break;
}
?>
