<?php

if(PAGE !== 'news') {
	return;
}

$query = $db->query('SELECT `thumb` FROM `' . TABLE_PREFIX . 'gallery` WHERE `id` = ' . $db->quote($config['gallery_image_id_from_database']));
if($query->rowCount() === 1) {
$image = $query->fetch();
	$twig->display('gallery.html.twig', array(
		'image' => $image
	));
}
