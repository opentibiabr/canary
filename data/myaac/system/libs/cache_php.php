<?php
/**
 * PHP cache class
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

class Cache_PHP
{
	private $prefix;
	private $dir;
	private $enabled;

	public function __construct($prefix = '', $dir = '') {
		$this->prefix = $prefix;
		$this->dir = $dir;
		$this->enabled = (file_exists($this->dir) && is_dir($this->dir) && is_writable($this->dir));
	}

	public function set($key, $var, $ttl = 0)
	{
		$var = var_export($var, true);

		// Write to temp file first to ensure atomicity
		$tmp = $this->dir . "tmp_$key." . uniqid('', true) . '.tmp';
		file_put_contents($tmp, '<?php $var = ' . $var . ';', LOCK_EX);

		$file = $this->_name($key);
		rename($tmp, $file);
		if($ttl !== 0) {
			touch($file, time() + $ttl);
		}
		else {
			touch($file, time() + 24 * 60 * 60);
		}
	}

	public function get($key)
	{
		$tmp = '';
		if($this->fetch($key, $tmp)) {
			return $tmp;
		}

		return '';
	}

	public function fetch($key, &$var)
	{
		$file = $this->_name($key);
		if(!file_exists($file) || filemtime($file) < time()) {
			return false;
		}

		@include $file;
		$var = isset($var) ? $var : null;
		return true;
	}

	public function delete($key)
	{
		$file = $this->_name($key);
		if(file_exists($file)) {
			unlink($file);
		}
	}

	public function enabled() {
		return $this->enabled;
	}

	private function _name($key) {
		return sprintf('%s%s%s', $this->dir, $this->prefix, sha1($key) . '.php');
	}
}
