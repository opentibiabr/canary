<?php
/**
 * Version check
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Version check';

// fetch version
$myaac_version = trim(@file_get_contents('https://github.com/opentibiabr/myaac/raw/main/VERSION'));
if (!$myaac_version) {
    warning('Error while fetching version info from https://github.com/opentibiabr/myaac<br/>
	Please try again later.');
    return;
}

// compare them
$version_compare = version_compare($myaac_version, MYAAC_VERSION);
if ($version_compare == 0) {
    success('MyAAC latest version is ' . $myaac_version . '. You\'re using the latest version.
	<br/>View CHANGELOG ' . generateLink(ADMIN_URL . '?p=changelog', 'here'));
} else if ($version_compare < 0) {
    success('Woah, seems you\'re using newer version as latest released one! MyAAC latest released version is ' . $myaac_version . ', and you\'re using version ' . MYAAC_VERSION . '.
	<br/>View CHANGELOG ' . generateLink(ADMIN_URL . '?p=changelog', 'here'));
} else {
    warning('You\'re using outdated version.<br/>
		Your version: <b>' . MYAAC_VERSION . '</b><br/>
		Latest version: <b>' . $myaac_version . '</b><br/>
		Download available at: <a href="https://github.com/opentibiabr/myaac" target="_blank">github.com/opentibiabr/myaac</a>');
}
