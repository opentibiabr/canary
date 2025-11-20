<?php
/**
 * Cache APC class
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    Mark Samman (Talaturen) <marksamman@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

class Cache_APC
{
	private $prefix;
	private $enabled;

	public function __construct($prefix = '')
	{
		$this->prefix = $prefix;
		$this->enabled = function_exists('apc_fetch');
	}

	public function set($key, $var, $ttl = 0)
	{
		$key = $this->prefix . $key;
		apc_delete($key);
		apc_store($key, $var, $ttl);
	}

	public function get($key)
	{
		$tmp = '';
		if($this->fetch($this->prefix . $key, $tmp)) {
			return $tmp;
		}

		return '';
	}

	public function fetch($key, &$var) {
		return ($var = apc_fetch($this->prefix . $key)) !== false;
	}

	public function delete($key) {
		apc_delete($this->prefix . $key);
	}

	public function enabled() {
		return $this->enabled;
	}
}
