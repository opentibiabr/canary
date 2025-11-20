<?php
/**
 * Cache eAccelerator class
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    Mark Samman (Talaturen) <marksamman@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

class Cache_eAccelerator
{
	private $prefix;
	private $enabled;

	public function __construct($prefix = '') {
		$this->prefix = $prefix;
		$this->enabled = function_exists('eaccelerator_get');
	}

	public function set($key, $var, $ttl = 0)
	{
		$key = $this->prefix . $key;
		eaccelerator_rm($key);
		eaccelerator_put($key, $var, $ttl);
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
		return ($var = eaccelerator_get($this->prefix . $key)) !== null;
	}

	public function delete($key) {
		eaccelerator_rm($this->prefix . $key);
	}

	public function enabled() {
		return $this->enabled;
	}
}
