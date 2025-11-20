<?php
/**
 * Changelog
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Changelog';

$_page = isset($_GET['page']) ? $_GET['page'] : 0;
$id = isset($_GET['id']) ? $_GET['id'] : 0;
$limit = 30;
$offset = $_page * $limit;
$next_page = false;

$changelogs = $db->query('SELECT * FROM `' . TABLE_PREFIX . 'changelog' . '` WHERE `hidden` = 0 ORDER BY `id` DESC LIMIT ' . ($limit + 1) . ' OFFSET ' . $offset)->fetchAll();

$i = 0;
foreach($changelogs as $key => &$log)
{
	if($i < $limit) {
		$log['type'] = getChangelogType($log['type']);
		$log['where'] = getChangelogWhere($log['where']);
	}
	else {
		unset($changelogs[$key]);
	}

	if ($i >= $limit)
		$next_page = true;

	$i++;
}

$twig->display('changelog.html.twig', array(
	'changelogs' => $changelogs,
	'page' => $_page,
	'next_page' => $next_page,
));

function getChangelogType($v)
{
	switch($v) {
		case 1:
			return 'added';
		case 2:
			return 'removed';
		case 3:
			return 'changed';
		case 4:
			return 'fixed';
	}

	return 'unknown';
}

function getChangelogWhere($v)
{
	switch($v) {
		case 1:
			return 'server';
		case 2:
			return 'website';
	}

	return 'unknown';
}
