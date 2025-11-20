<?php
/**
 * Tools
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Tools';

$tool = $_GET['tool'];
if (!isset($tool)) {
	echo 'Tool not set.';
	return;
}

if (preg_match("/[^A-z0-9_\-]/", $tool)) {
	echo 'Invalid tool.';
	return;
}

$file = BASE . 'admin/pages/tools/' . $tool . '.php';
if (!@file_exists($file))
	require $file;
?>
