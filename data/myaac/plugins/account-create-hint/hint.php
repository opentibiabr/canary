<?php
/**
 * account-create index.php
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

global $twig_loader;
$twig_loader->prependPath(BASE . 'plugins/account-create-hint');

$twig->display('hint.html.twig');
