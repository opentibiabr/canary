<?php
defined('MYAAC') or die('Direct access not allowed!');

$twig->display('install.license.html.twig', array(
	'license' => file_get_contents(BASE . 'LICENSE'),
	'buttons' => next_buttons()
));
?>
