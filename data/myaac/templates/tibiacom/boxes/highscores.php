<?php

$topPlayers = getTopPlayers(5);
foreach($topPlayers as &$player) {
	$outfit_url = '';
	if($config['online_outfit']) {
		$outfit_url = $config['outfit_images_url'] . '?id=' . $player['looktype']	. (!empty
			($player['lookaddons']) ? '&addons=' . $player['lookaddons'] : '') . '&head=' . $player['lookhead'] . '&body=' . $player['lookbody'] . '&legs=' . $player['looklegs'] . '&feet=' . $player['lookfeet'];

		$player['outfit'] = $outfit_url;
	}
}

$twig->display('highscores.html.twig', array(
	'topPlayers' => $topPlayers
));
