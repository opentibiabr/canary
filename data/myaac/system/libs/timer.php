<?php
/**
 * Timer class
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

class Timer
{
	private $start = 0;
	private $stop = 0;
	private $elapsed = 0;

	function __construct($start = true) {
		if($start) $this->start();
	}

	function start() {
		$this->start = $this->_gettime();
	}

	function stop()
	{
		$this->stop = $this->_gettime();
		$this->elapsed = $this->_compute();
	}

	function elapsed()
	{
		if(!$this->elapsed)
			$this->stop();

		return $this->elapsed;
	}

	function reset()
	{
		$this->start = 0;
		$this->stop = 0;
		$this->elapsed = 0;
	}

	private function _gettime() {
		return microtime(true);
	}

	private function _compute() {
		return $this->stop - $this->start;
	}
}
?>
