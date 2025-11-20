<?php
/**
 * Data class
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

class Data
{
	private $table = '';

	public function __construct($table) {
		$this->table = $table;
	}

	public function get($where)
	{
		global $db;
		return $db->select($this->table, $where);
	}

	public function add($data)
	{
		global $db;
		return $db->insert($this->table, $data);
	}

	public function delete($data, $where)
	{
		global $db;
		return $db->delete($this->table, $data, $where);
	}

	public function update($data, $where)
	{
		global $db;
		return $db->update($this->table, $data, $where);
	}
}
?>
