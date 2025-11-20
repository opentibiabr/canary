<?php

if(PAGE !== 'news') {
	return;
}

$poll = $db->query('SELECT `id`, `question` FROM `z_polls` WHERE end > ' . time() . ' ORDER BY `end` LIMIT 1');
if($poll->rowCount() > 0) {
	$poll = $poll->fetch(PDO::FETCH_ASSOC);
	$twig->display('poll.html.twig', array(
		'poll' => $poll
	));
}
