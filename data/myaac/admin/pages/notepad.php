<?php
/**
 * Notepad
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Notepad';

$notepad_content = Notepad::get($account_logged->getId());
if (isset($_POST['content'])) {
	$_content = html_entity_decode(stripslashes($_POST['content']));
	if (!$notepad_content)
		Notepad::create($account_logged->getId(), $_content);
	else
		Notepad::update($account_logged->getId(), $_content);

	echo '<div class="success" style="text-align: center;">Saved at ' . date('H:i') . '</div>';
} else {
	if ($notepad_content !== false)
		$_content = $notepad_content;
}

$twig->display('admin.notepad.html.twig', array('content' => isset($_content) ? $_content : null));

class Notepad
{
	static public function get($account_id)
	{
		global $db;
		$query = $db->select(TABLE_PREFIX . 'notepad', array('account_id' => $account_id));
		if ($query !== false)
			return $query['content'];

		return false;
	}

	static public function create($account_id, $content = '')
	{
		global $db;
		$db->insert(TABLE_PREFIX . 'notepad', array('account_id' => $account_id, 'content' => $content));
	}

	static public function update($account_id, $content = '')
	{
		global $db;
		$db->update(TABLE_PREFIX . 'notepad', array('content' => $content), array('account_id' => $account_id));
	}
}
