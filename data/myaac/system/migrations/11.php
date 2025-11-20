<?php
	// rename database tables
	$db->query("RENAME TABLE
		" . TABLE_PREFIX . "screenshots TO " . TABLE_PREFIX . "gallery,
		" . TABLE_PREFIX . "movies TO " . TABLE_PREFIX . "videos;");
	
	// rename images dir
	if(file_exists(BASE . 'images/screenshots') && !file_exists(BASE .'images/gallery')) {
		rename(BASE . 'images/screenshots', BASE . 'images/gallery');
	}
	
	// convert old database screenshots images to gallery
	$query = $db->query('SELECT `id`, `image`, `thumb` FROM `' . TABLE_PREFIX . 'gallery`;');
	foreach($query->fetchAll() as $item) {
		$db->update(TABLE_PREFIX . 'gallery', array(
			'image' => str_replace('/screenshots/', '/gallery/', $item['image']),
			'thumb' => str_replace('/screenshots/', '/gallery/', $item['thumb']),
		), array('id' => $item['id']));
	}
?>