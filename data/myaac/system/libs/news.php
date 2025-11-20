<?php

class News
{
	static public function verify($title, $body, $article_text, $article_image, &$errors)
	{
		if(!isset($title[0]) || !isset($body[0])) {
			$errors[] = 'Please fill all inputs.';
			return false;
		}
		if(strlen($title) > TITLE_LIMIT) {
			$errors[] = 'News title cannot be longer than ' . TITLE_LIMIT . ' characters.';
			return false;
		}
		if(strlen($body) > BODY_LIMIT) {
			$errors[] = 'News content cannot be longer than ' . BODY_LIMIT . ' characters.';
			return false;
		}
		if(strlen($article_text) > ARTICLE_TEXT_LIMIT) {
			$errors[] = 'Article text cannot be longer than ' . ARTICLE_TEXT_LIMIT . ' characters.';
			return false;
		}
		if(strlen($article_image) > ARTICLE_IMAGE_LIMIT) {
			$errors[] = 'Article image cannot be longer than ' . ARTICLE_IMAGE_LIMIT . ' characters.';
			return false;
		}
		return true;
	}

	static public function add($title, $body, $type, $category, $player_id, $comments, $article_text, $article_image, &$errors)
	{
		global $db;
		if(!self::verify($title, $body, $article_text, $article_image, $errors))
			return false;

		$db->insert(TABLE_PREFIX . 'news', array('title' => $title, 'body' => $body, 'type' => $type, 'date' => time(), 'category' => $category, 'player_id' => isset($player_id) ? $player_id : 0, 'comments' => $comments, 'article_text' => ($type == 3 ? $article_text : ''), 'article_image' => ($type == 3 ? $article_image : '')));
		self::clearCache();
		return true;
	}

	static public function get($id) {
		global $db;
		return $db->select(TABLE_PREFIX . 'news', array('id' => $id));
	}

	static public function update($id, $title, $body, $type, $category, $player_id, $comments, $article_text, $article_image, &$errors)
	{
		global $db;
		if(!self::verify($title, $body, $article_text, $article_image, $errors))
			return false;

		$db->update(TABLE_PREFIX . 'news', array('title' => $title, 'body' => $body, 'type' => $type, 'category' => $category, 'last_modified_by' => isset($player_id) ? $player_id : 0, 'last_modified_date' => time(), 'comments' => $comments, 'article_text' => $article_text, 'article_image' => $article_image), array('id' => $id));
		self::clearCache();
		return true;
	}

	static public function delete($id, &$errors)
	{
		global $db;
		if(isset($id))
		{
			if($db->select(TABLE_PREFIX . 'news', array('id' => $id)) !== false)
				$db->delete(TABLE_PREFIX . 'news', array('id' => $id));
			else
				$errors[] = 'News with id ' . $id . ' does not exists.';
		}
		else
			$errors[] = 'News id not set.';

		if(count($errors)) {
			return false;
		}

		self::clearCache();
		return true;
	}

	static public function toggleHidden($id, &$errors, &$status)
	{
		global $db;
		if(isset($id))
		{
			$query = $db->select(TABLE_PREFIX . 'news', array('id' => $id));
			if($query !== false)
			{
				$db->update(TABLE_PREFIX . 'news', array('hidden' => ($query['hidden'] == 1 ? 0 : 1)), array('id' => $id));
				$status = $query['hidden'];
			}
			else
				$errors[] = 'News with id ' . $id . ' does not exists.';
		}
		else
			$errors[] = 'News id not set.';

		if(count($errors)) {
			return false;
		}

		self::clearCache();
		return true;
	}

	static public function getCached($type)
	{
		global $template_name;

		$cache = Cache::getInstance();
		if ($cache->enabled())
		{
			$tmp = '';
			if ($cache->fetch('news_' . $template_name . '_' . $type, $tmp) && isset($tmp[0])) {
				return $tmp;
			}
		}

		return false;
	}

	static public function clearCache()
	{
		$cache = Cache::getInstance();
		if (!$cache->enabled()) {
			return;
		}

		$tmp = '';
		foreach (get_templates() as $template) {
			if ($cache->fetch('news_' . $template . '_' . NEWS, $tmp)) {
				$cache->delete('news_' . $template . '_' . NEWS);
			}

			if ($cache->fetch('news_' . $template . '_' . TICKER, $tmp)) {
				$cache->delete('news_' . $template . '_' . TICKER);
			}

			if ($cache->fetch('news_' . $template . '_' . ARTICLE, $tmp)) {
				$cache->delete('news_' . $template . '_' . ARTICLE);
			}
		}
	}
}