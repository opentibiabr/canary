<?php
/**
 * Visitors class
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

class Visitors
{
	private $sessionTime; // time session will live
	private $data; // cached data
	private $cacheEnabled;
	private $cache;

	public function __construct($sessionTime = 10)
	{
		$this->cache = Cache::getInstance();

		$this->cacheEnabled = $this->cache->enabled();
		if($this->cacheEnabled)
		{
			$tmp = '';
			if($this->cache->fetch('visitors', $tmp))
				$this->data = unserialize($tmp);
			else
				$this->data = array();
		}

		$this->sessionTime = $sessionTime;
		$this->cleanVisitors();

		$ip = $_SERVER['REMOTE_ADDR'];
		if($this->visitorExists($ip))
			$this->updateVisitor($ip, $_SERVER['REQUEST_URI']);
		else
			$this->addVisitor($ip, $_SERVER['REQUEST_URI']);
	}

	public function __destruct()
	{
		if($this->cacheEnabled)
			$this->cache->set('visitors', serialize($this->data), 120);
	}

	public function visitorExists($ip)
	{
		if($this->cacheEnabled) {
			return isset($this->data[$ip]);
		}

		global $db;
		$users = $db->query('SELECT COUNT(`ip`) as count FROM `' . TABLE_PREFIX . 'visitors' . '` WHERE ' . $db->fieldName('ip') . ' = ' . $db->quote($ip))->fetch();
		return ($users['count'] > 0);
	}

	private function cleanVisitors()
	{
		if($this->cacheEnabled)
		{
			$timeNow = time();
			foreach($this->data as $ip => $details)
			{
				if($timeNow - (int)$details['lastvisit'] > $this->sessionTime * 60)
					unset($this->data[$ip]);
			}

			return;
		}

		global $db;
		$db->exec('DELETE FROM ' . $db->tableName(TABLE_PREFIX . 'visitors') . ' WHERE ' . $db->fieldName('lastvisit') . ' < ' . (time() - $this->sessionTime * 60));
	}

	private function updateVisitor($ip, $page)
	{
		if($this->cacheEnabled) {
			$this->data[$ip] = array('page' => $page, 'lastvisit' => time());
			return;
		}

		global $db;
		$db->exec('UPDATE ' . $db->tableName(TABLE_PREFIX . 'visitors') . ' SET ' . $db->fieldName('lastvisit') . ' = ' . time() . ', ' . $db->fieldName('page') . ' = ' . $db->quote($page) . ' WHERE ' . $db->fieldName('ip') . ' = ' . $db->quote($ip));
	}

	private function addVisitor($ip, $page)
	{
		if($this->cacheEnabled) {
			$this->data[$ip] = array('page' => $page, 'lastvisit' => time());
			return;
		}

		global $db;
		$db->exec('INSERT INTO ' . $db->tableName(TABLE_PREFIX . 'visitors') . ' (' . $db->fieldName('ip') . ' ,' . $db->fieldName('lastvisit') . ', ' . $db->fieldName('page') . ') VALUE (' . $db->quote($ip) . ', ' . time() . ', ' . $db->quote($page) . ')');
	}

	public function getVisitors()
	{
		if($this->cacheEnabled) {
			foreach($this->data as $ip => &$details)
				$details['ip'] = $ip;

			return $this->data;
		}

		global $db;
		return $db->query('SELECT ' . $db->fieldName('ip') . ', ' . $db->fieldName('lastvisit') . ', ' . $db->fieldName('page') . ' FROM ' . $db->tableName(TABLE_PREFIX . 'visitors') . ' ORDER BY ' . $db->fieldName('lastvisit') . ' DESC')->fetchAll();
	}

	public function getAmountVisitors()
	{
		if($this->cacheEnabled) {
			return count($this->data);
		}

		global $db;
		$users = $db->query('SELECT COUNT(`ip`) as count FROM `' . TABLE_PREFIX . 'visitors`')->fetch();
		return $users['count'];
	}

	public function show() {
		echo $this->getAmountVisitors();
	}
}
?>
