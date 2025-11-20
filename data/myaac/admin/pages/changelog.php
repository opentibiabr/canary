<?php
/**
 * CHANGELOG viewer
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'MyAAC Changelog';

if (!file_exists(BASE . 'CHANGELOG.md')) {
	echo 'File CHANGELOG.md doesn\'t exist.';
	return;
}

require LIBS . 'Parsedown.php';

$changelog = file_get_contents(BASE . 'CHANGELOG.md');

$Parsedown = new Parsedown();

$changelog = $Parsedown->text($changelog); # prints: <p>Hello <em>Parsedown</em>!</p>

echo '<div>' . $changelog . '</div>';
