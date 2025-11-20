<?php
/**
 * XCache class
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    Mark Samman (Talaturen) <marksamman@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

class Cache_XCache
{
	private $prefix;
	private $enabled;

	public function __construct($prefix = '') {
		$this->prefix = $prefix;
		$this->enabled = function_exists('xcache_get') && ini_get('xcache.var_size');
	}

	public function set($key, $var, $ttl = 0)
	{
		$key = $this->prefix . $key;
		xcache_unset($key);
		xcache_set($key, $var, $ttl);
	}

	public function get($key)
	{
		$tmp = '';
		if($this->fetch($this->prefix . $key, $tmp)) {
			return $tmp;
		}

		return '';
	}

	public function fetch($key, &$var)
	{
		$key = $this->prefix . $key;
		if(!xcache_isset($key)) {
			return false;
		}

		$var = xcache_get($key);
		return true;
	}

	public function delete($key) {
		xcache_unset($this->prefix . $key);
	}

	public function enabled() {
		return $this->enabled;
	}
}
