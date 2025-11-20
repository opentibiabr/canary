<?php

$twig->display('networks.html.twig', array(
	'topPlayers' => getTopPlayers(5)
));
