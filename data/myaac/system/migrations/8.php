<?php
	if($db->hasTable(TABLE_PREFIX . 'forum_sections'))
		$db->query('RENAME TABLE `' . TABLE_PREFIX . 'forum_sections` TO `' . TABLE_PREFIX . 'forum_boards`;');
	
	$query = $db->query('SELECT `id` FROM `' . TABLE_PREFIX . 'forum_boards` WHERE `ordering` > 0;');
	if($query->rowCount() == 0) {
		$boards = array(
			'News',
			'Trade',
			'Quests',
			'Pictures',
			'Bug Report'
		);
		
		foreach($boards as $id => $board)
			$db->query('UPDATE `' . TABLE_PREFIX . 'forum_boards` SET `ordering` = ' . $id . ' WHERE `name` = ' . $db->quote($board));
	}
?>