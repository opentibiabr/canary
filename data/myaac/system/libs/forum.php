<?php
/**
 * Forum class
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$configForumTablePrefix = config('forum_table_prefix');
if ($configForumTablePrefix !== null && !empty(trim($configForumTablePrefix))) {
	if(!in_array($configForumTablePrefix, array('myaac_', 'z_'))) {
		throw new RuntimeException('Invalid value for forum_table_prefix in config.php. Can be only: "myaac_" or "z_".');
	}

	define('FORUM_TABLE_PREFIX', $configForumTablePrefix);
}
else {
	if($db->hasTable('z_forum')) {
		define('FORUM_TABLE_PREFIX', 'z_');
	}
	else {
		define('FORUM_TABLE_PREFIX', 'myaac_');
	}
}

class Forum
{
	/**
	 * @param OTS_Account $account
	 * @return bool
	 * @throws E_OTS_NotLoaded
	 */
	public static function canPost($account)
	{
		global $db, $config;

		if(!$account->isLoaded() || $account->isBanned())
			return false;

		if(self::isModerator())
			return true;

		return
			$db->query(
				'SELECT `id` FROM `players` WHERE `account_id` = ' . $db->quote($account->getId()) .
				' AND `level` >= ' . $db->quote($config['forum_level_required']) .
				' LIMIT 1')->rowCount() > 0;
	}

	public static function isModerator() {
		return hasFlag(FLAG_CONTENT_FORUM) || superAdmin();
	}

	public static function add_thread($title, $body, $section_id, $player_id, $account_id, &$errors)
	{
		global $db;
		$thread_id = 0;
		if($db->insert(FORUM_TABLE_PREFIX . 'forum', array(
			'first_post' => 0,
			'last_post' => time(),
			'section' => $section_id,
			'replies' => 0,
			'views' => 0,
			'author_aid' => isset($account_id) ? $account_id : 0,
			'author_guid' => isset($player_id) ? $player_id : 0,
			'post_text' => $body, 'post_topic' => $title,
			'post_smile' => 0, 'post_html' => 1,
			'post_date' => time(),
			'last_edit_aid' => 0, 'edit_date' => 0,
			'post_ip' => $_SERVER['REMOTE_ADDR']
		))) {
			$thread_id = $db->lastInsertId();
			$db->query("UPDATE `" . FORUM_TABLE_PREFIX . "forum` SET `first_post`=".(int) $thread_id." WHERE `id` = ".(int) $thread_id);
		}

		return $thread_id;
	}

	public static function add_post($thread_id, $section, $author_aid, $author_guid, $post_text, $post_topic, $smile, $html)
	{
		global $db;
		$db->insert(FORUM_TABLE_PREFIX . 'forum', array(
			'first_post' => $thread_id,
			'section' => $section,
			'author_aid' => $author_aid,
			'author_guid' => $author_guid,
			'post_text' => $post_text,
			'post_topic' => $post_topic,
			'post_smile' => $smile,
			'post_html' => $html,
			'post_date' => time(),
			'post_ip' => $_SERVER['REMOTE_ADDR']
		));
	}
	public static function add_board($name, $description, $access, $guild, &$errors)
	{
		global $db;
		if(isset($name[0]) && isset($description[0]))
		{
			$query = $db->select(TABLE_PREFIX . 'forum_boards', array('name' => $name));

			if($query === false)
			{
				$query =
					$db->query(
						'SELECT ' . $db->fieldName('ordering') .
						' FROM ' . $db->tableName(TABLE_PREFIX . 'forum_boards') .
						' ORDER BY ' . $db->fieldName('ordering') . ' DESC LIMIT 1'
					);

				$ordering = 0;
				if($query->rowCount() > 0) {
					$query = $query->fetch();
					$ordering = $query['ordering'] + 1;
				}
				$db->insert(TABLE_PREFIX . 'forum_boards', array('name' => $name, 'description' => $description, 'access' => $access, 'guild' => $guild, 'ordering' => $ordering));
			}
			else
				$errors[] = 'Forum board with this name already exists.';
		}
		else
			$errors[] = 'Please fill all inputs.';

		return !count($errors);
	}

	public static function get_board($id) {
		global $db;
		return $db->select(TABLE_PREFIX . 'forum_boards', array('id' => $id));
	}

	public static function update_board($id, $name, $access, $guild, $description) {
		global $db;
		$db->update(TABLE_PREFIX . 'forum_boards', array('name' => $name, 'description' => $description, 'access' => $access, 'guild' => $guild), array('id' => $id));
	}

	public static function delete_board($id, &$errors)
	{
		global $db;
		if(isset($id))
		{
			if(self::get_board($id) !== false)
				$db->delete(TABLE_PREFIX . 'forum_boards', array('id' => $id));
			else
				$errors[] = 'Forum board with id ' . $id . ' does not exists.';
		}
		else
			$errors[] = 'id not set';

		return !count($errors);
	}

	public static function toggleHidden_board($id, &$errors)
	{
		global $db;
		if(isset($id))
		{
			$query = self::get_board($id);
			if($query !== false)
				$db->update(TABLE_PREFIX . 'forum_boards', array('hidden' => ($query['hidden'] == 1 ? 0 : 1)), array('id' => $id));
			else
				$errors[] = 'Forum board with id ' . $id . ' does not exists.';
		}
		else
			$errors[] = 'id not set';

		return !count($errors);
	}

	public static function move_board($id, $i, &$errors)
	{
		global $db;
		$query = self::get_board($id);
		if($query !== false)
		{
			$ordering = $query['ordering'] + $i;
			$old_record = $db->select(TABLE_PREFIX . 'forum_boards', array('ordering' => $ordering));
			if($old_record !== false)
				$db->update(TABLE_PREFIX . 'forum_boards', array('ordering' => $query['ordering']), array('ordering' => $ordering));

			$db->update(TABLE_PREFIX . 'forum_boards', array('ordering' => $ordering), array('id' => $id));
		}
		else
			$errors[] = 'Forum board with id ' . $id . ' does not exists.';

		return !count($errors);
	}

	public static function parseSmiles($text)
	{
		$smileys = array(
			';D' => 1,
			':D' => 1,
			':cool:' => 2,
			';cool;' => 2,
			':ekk:' => 3,
			';ekk;' => 3,
			';o' => 4,
			';O' => 4,
			':o' => 4,
			':O' => 4,
			':(' => 5,
			';(' => 5,
			':mad:' => 6,
			';mad;' => 6,
			';rolleyes;' => 7,
			':rolleyes:' => 7,
			':)' => 8,
			';d' => 9,
			':d' => 9,
			';)' => 10
		);

		foreach($smileys as $search => $replace)
			$text = str_replace($search, '<img src="images/forum/smile/'.$replace.'.gif" alt="'. $search .'" title="' . $search . '" />', $text);

		return $text;
	}

	public static function parseBBCode($text, $smiles)
	{
		$rows = 0;
		while(stripos($text, '[code]') !== false && stripos($text, '[/code]') !== false )
		{
			$code = substr($text, stripos($text, '[code]')+6, stripos($text, '[/code]') - stripos($text, '[code]') - 6);
			if(!is_int($rows / 2)) { $bgcolor = 'ABED25'; } else { $bgcolor = '23ED25'; } $rows++;
			$text = str_ireplace('[code]'.$code.'[/code]', '<i>Code:</i><br /><table cellpadding="0" style="background-color: #'.$bgcolor.'; width: 480px; border-style: dotted; border-color: #CCCCCC; border-width: 2px"><tr><td>'.$code.'</td></tr></table>', $text);
		}
		$rows = 0;
		while(stripos($text, '[quote]') !== false && stripos($text, '[/quote]') !== false )
		{
			$quote = substr($text, stripos($text, '[quote]')+7, stripos($text, '[/quote]') - stripos($text, '[quote]') - 7);
			if(!is_int($rows / 2)) { $bgcolor = 'AAAAAA'; } else { $bgcolor = 'CCCCCC'; } $rows++;
			$text = str_ireplace('[quote]'.$quote.'[/quote]', '<table cellpadding="0" style="background-color: #'.$bgcolor.'; width: 480px; border-style: dotted; border-color: #007900; border-width: 2px"><tr><td>'.$quote.'</td></tr></table>', $text);
		}
		$rows = 0;
		while(stripos($text, '[url]') !== false && stripos($text, '[/url]') !== false )
		{
			$url = substr($text, stripos($text, '[url]')+5, stripos($text, '[/url]') - stripos($text, '[url]') - 5);
			$text = str_ireplace('[url]'.$url.'[/url]', '<a href="'.$url.'" target="_blank">'.$url.'</a>', $text);
		}

		$xhtml = false;
		$tags = array(
			'#\[b\](.*?)\[/b\]#si' => ($xhtml ? '<strong>\\1</strong>' : '<b>\\1</b>'),
			'#\[i\](.*?)\[/i\]#si' => ($xhtml ? '<em>\\1</em>' : '<i>\\1</i>'),
			'#\[u\](.*?)\[/u\]#si' => ($xhtml ? '<span style="text-decoration: underline;">\\1</span>' : '<u>\\1</u>'),
			'#\[s\](.*?)\[/s\]#si' => ($xhtml ? '<strike>\\1</strike>' : '<s>\\1</s>'),

			'#\[guild\](.*?)\[/guild\]#si' => urldecode(generateLink(getGuildLink('$1', false), '$1', true)),
			'#\[house\](.*?)\[/house\]#si' => urldecode(generateLink(getHouseLink('$1', false), '$1', true)),
			'#\[player\](.*?)\[/player\]#si' => urldecode(generateLink(getPlayerLink('$1', false), '$1', true)),
			// TODO: [poll] tag

			'#\[color=(.*?)\](.*?)\[/color\]#si' => ($xhtml ? '<span style="color: \\1;">\\2</span>' : '<span style="color: \\1">\\2</span>'),
			'#\[img\](.*?)\[/img\]#si' => ($xhtml ? '<img class="forum-image" style="max-width:550px; max-height; 550px;" src="\\1" border="0" alt="" />' : '<img class="forum-image" style="max-width:550px; max-height; 550px;" src="\\1" border="0" alt="">'),
			'#\[url=(.*?)\](.*?)\[/url\]#si' => '<a href="\\1" title="\\2">\\2</a>',
//		'#\[email\](.*?)\[/email\]#si' => '<a href="mailto:\\1" title="Email \\1">\\1</a>',
			'#\[code\](.*?)\[/code\]#si' => '<code>\\1</code>',
//		'#\[align=(.*?)\](.*?)\[/align\]#si' => ($xhtml ? '<div style="text-align: \\1;">\\2</div>' : '<div align="\\1">\\2</div>'),
//		'#\[br\]#si' => ($xhtml ? '<br style="clear: both;" />' : '<br>'),
		);

		foreach($tags as $search => $replace)
			$text = preg_replace($search, $replace, $text);

		return ($smiles ? Forum::parseSmiles($text) : $text);
	}

	public static function showPost($topic, $text, $smiles = true, $html = false)
	{
		if($html) {
			return '<b>' . $topic . '</b><hr />' . $text;
		}

		$post = '';
		if(!empty($topic))
			$post .= '<b>'.($smiles ? self::parseSmiles($topic) : $topic).'</b><hr />';

		$post .= self::parseBBCode(nl2br($text), $smiles);
		return $post;
	}

	public static function hasAccess($board_id) {
		global $sections, $logged, $account_logged, $logged_access;
		if(!isset($sections[$board_id]))
			return false;

		$hasAccess = true;
		$section = $sections[$board_id];
		if($section['guild'] > 0) {
			if($logged) {
				$guild = new OTS_Guild();
				$guild->load($section['guild']);
				$status = false;
				if($guild->isLoaded()) {
					$account_players = $account_logged->getPlayers();
					foreach ($account_players as $player) {
						if($guild->hasMember($player)) {
							$status = true;
						}
					}
				}

				if (!$status) $hasAccess = false;
			}
			else {
				$hasAccess = false;
			}
		}

		if($section['access'] > 0) {
			if($logged_access < $section['access']) {
				$hasAccess = false;
			}
		}

		return $hasAccess;
	}
}
?>
