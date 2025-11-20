<?php
/**
 * Pages
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

require_once LIBS . 'forum.php';
require_once LIBS . 'news.php';

$title = 'News Panel';

if (!hasFlag(FLAG_CONTENT_PAGES) && !superAdmin()) {
	echo 'Access denied.';
	return;
}

header('X-XSS-Protection:0');

// some constants, used mainly by database (cannot by modified without schema changes)
define('TITLE_LIMIT', 100);
define('BODY_LIMIT', 65535); // maximum news body length
define('ARTICLE_TEXT_LIMIT', 300);
define('ARTICLE_IMAGE_LIMIT', 100);

$name = $p_title = '';
if(!empty($action))
{
	$id = isset($_REQUEST['id']) ? $_REQUEST['id'] : null;
	$p_title = isset($_REQUEST['title']) ? $_REQUEST['title'] : null;
	$body = isset($_REQUEST['body']) ? stripslashes($_REQUEST['body']) : null;
	$comments = isset($_REQUEST['comments']) ? $_REQUEST['comments'] : null;
	$type = isset($_REQUEST['type']) ? (int)$_REQUEST['type'] : null;
	$category = isset($_REQUEST['category']) ? (int)$_REQUEST['category'] : null;
	$player_id = isset($_REQUEST['player_id']) ? (int)$_REQUEST['player_id'] : null;
	$article_text = isset($_REQUEST['article_text']) ? $_REQUEST['article_text'] : null;
	$article_image = isset($_REQUEST['article_image']) ? $_REQUEST['article_image'] : null;
	$forum_section = isset($_REQUEST['forum_section']) ? $_REQUEST['forum_section'] : null;
	$errors = array();

	if($action == 'add') {
		if(isset($forum_section) && $forum_section != '-1') {
			$forum_add = Forum::add_thread($p_title, $body, $forum_section, $player_id, $account_logged->getId(), $errors);
		}

		if(News::add($p_title, $body, $type, $category, $player_id, isset($forum_add) && $forum_add != 0 ? $forum_add : 0, $article_text, $article_image, $errors)) {
			$p_title = $body = $comments = $article_text = $article_image = '';
			$type = $category = $player_id = 0;

			success("Added successful.");
		}
	}
	else if($action == 'delete') {
		News::delete($id, $errors);
		success("Deleted successful.");
	}
	else if($action == 'edit')
	{
		if(isset($id) && !isset($p_title)) {
			$news = News::get($id);
			$p_title = $news['title'];
			$body = $news['body'];
			$comments = $news['comments'];
			$type = $news['type'];
			$category = $news['category'];
			$player_id = $news['player_id'];
			$article_text = $news['article_text'];
			$article_image = $news['article_image'];
		}
		else {
			if(News::update($id, $p_title, $body, $type, $category, $player_id, $forum_section, $article_text, $article_image, $errors)) {
				// update forum thread if exists
				if(isset($forum_section) && Validator::number($forum_section)) {
					$db->query("UPDATE `" . TABLE_PREFIX . "forum` SET `author_guid` = ".(int) $player_id.", `post_text` = ".$db->quote($body).", `post_topic` = ".$db->quote($p_title).", `edit_date` = " . time() . " WHERE `id` = " . $db->quote($forum_section));
				}

				$action = $p_title = $body = $comments = $article_text = $article_image = '';
				$type = $category = $player_id = 0;

				success("Updated successful.");
			}
		}
	}
	else if($action == 'hide') {
		News::toggleHidden($id, $errors, $status);
		success(($status == 1 ? 'Show' : 'Hide') . " successful.");
	}

	if(!empty($errors))
		error(implode(", ", $errors));
}

$categories = array();
foreach($db->query('SELECT `id`, `name`, `icon_id` FROM `' . TABLE_PREFIX . 'news_categories` WHERE `hidden` != 1') as $cat)
{
	$categories[$cat['id']] = array(
		'name' => $cat['name'],
		'icon_id' => $cat['icon_id']
	);
}

if($action == 'edit' || $action == 'new') {
	if($action == 'edit') {
		$player = new OTS_Player();
		$player->load($player_id);
	}

	$account_players = $account_logged->getPlayersList();
	$account_players->orderBy('group_id', POT::ORDER_DESC);
	$twig->display('admin.news.form.html.twig', array(
		'action' => $action,
		'news_link' => getLink(PAGE),
		'news_link_form' => '?p=news&action=' . ($action == 'edit' ? 'edit' : 'add'),
		'news_id' => isset($id) ? $id : null,
		'title' => isset($p_title) ? $p_title : '',
		'body' => isset($body) ? escapeHtml($body) : '',
		'type' => isset($type) ? $type : null,
		'player' => isset($player) && $player->isLoaded() ? $player : null,
		'player_id' => isset($player_id) ? $player_id : null,
		'account_players' => $account_players,
		'category' => isset($category) ? $category : 0,
		'categories' => $categories,
		'forum_boards' => getForumBoards(),
		'forum_section' => isset($forum_section) ? $forum_section : null,
		'comments' => isset($comments) ? $comments : null,
		'article_text' => isset($article_text) ? $article_text : null,
		'article_image' => isset($article_image) ? $article_image : null
	));
}

$query = $db->query('SELECT * FROM ' . $db->tableName(TABLE_PREFIX . 'news'));
$newses = array();
foreach ($query as $_news) {
	$_player = new OTS_Player();
	$_player->load($_news['player_id']);

	$newses[$_news['type']][] = array(
		'id' => $_news['id'],
		'hidden' => $_news['hidden'],
		'archive_link' => getLink('news') . '/archive/' . $_news['id'],
		'title' => $_news['title'],
		'date' => $_news['date'],
		'player_name' => isset($_player) && $_player->isLoaded() ? $_player->getName() : '',
		'player_link' => isset($_player) && $_player->isLoaded() ? getPlayerLink($_player->getName(), false) : '',
	);
}

$twig->display('admin.news.html.twig', array(
	'newses' => $newses
));
