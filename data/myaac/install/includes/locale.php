<?php
defined('MYAAC') or die('Direct access not allowed!');
if (isset($_POST['lang'])) {
	setcookie('locale', $_POST['lang']);
	$_COOKIE['locale'] = $_POST['lang'];
}

if (isset($_COOKIE['locale'])) {
	$detected_locale = $_COOKIE['locale'];
	$lang_size = strlen($detected_locale);
	if (!$lang_size || $lang_size > 4 || !preg_match("/[a-z]/", $detected_locale)) // validate locale
		$_COOKIE['locale'] = "en";
} else {
	// detect locale
	$locale_s = get_browser_languages();
	if (!count($locale_s))
		$detected_locale = 'en';
	else {
		foreach ($locale_s as $id => $tmp) {
			$tmp_file = LOCALE .  $tmp;
			if (@file_exists($tmp_file)) {
				$detected_locale = $tmp;
				break;
			}
		}
	}

	if (!isset($detected_locale))
		$detected_locale = 'en';
}

require LOCALE . 'en/main.php';
require LOCALE . 'en/install.php';

$file_main = LOCALE . $detected_locale . '/main.php';
if (!file_exists($file_main))
	$file_main = LOCALE . 'en/main.php';

$file_install = LOCALE . $detected_locale . '/install.php';
if (!file_exists($file_install))
	$file_install = LOCALE . 'en/install.php';

require $file_main;
require $file_install;
