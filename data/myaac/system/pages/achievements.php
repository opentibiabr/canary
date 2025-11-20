<?php

defined('MYAAC') or die('Direct access not allowed!');
$title = 'Achievements';

require_once BASE . 'tools/achievements.php';

$secret = 0;
foreach ($achievements as $achievement){
	$secret_achievement = $achievement['secret'];
	if ($achievement['secret'] == true){
		$secret++;
	}
}

$twig->display('achievements.html.twig', array(
	'BASE_URL'  => BASE_URL,
	'PATH_URL' => $template_path,
	'achievements_base'  => $config['achievements_base'],
	'achievements' => $achievements,
	'secret' => $secret,
));
