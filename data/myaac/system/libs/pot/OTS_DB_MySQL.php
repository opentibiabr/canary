<?php

/**#@+
 * @version 0.0.1
 */

/**
 * @package POT
 * @version 0.1.3
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * MySQL connection interface.
 *
 * <p>
 * At all everything that you really need to read from this class documentation is list of parameters for driver's constructor.
 * </p>
 *
 * @package POT
 * @version 0.1.3
 */
class OTS_DB_MySQL extends OTS_Base_DB
{
	private $has_table_cache = array();
	private $has_column_cache = array();
/**
 * Creates database connection.
 *
 * <p>
 * Connects to MySQL database on given arguments.
 * </p>
 *
 * <p>
 * List of parameters for this drivers:
 * </p>
 *
 * <ul>
 * <li><var>host</var> - database server.</li>
 * <li><var>port</var> - port (optional, also it is possible to use host:port in <var>host</var> parameter).</li>
 * <li><var>database</var> - database name.</li>
 * <li><var>user</var> - user login.</li>
 * <li><var>password</var> - user password.</li>
 * </ul>
 *
 * @version 0.0.6
 * @param array $params Connection parameters.
 * @throws PDOException On PDO operation error.
 */
    public function __construct($params)
    {
        $user = null;
        $password = null;
        $dns = array();

        // host:port support
        if( strpos(':', $params['host']) !== false)
        {
            $host = explode(':', $params['host'], 2);

            $params['host'] = $host[0];
            $params['port'] = $host[1];
        }

        if( isset($params['database']) )
        {
            $dns[] = 'dbname=' . $params['database'];
        }

        if( isset($params['user']) )
        {
            $user = $params['user'];
        }

        if( isset($params['password']) )
        {
            $password = $params['password'];
        }

        if( isset($params['prefix']) )
        {
            $this->prefix = $params['prefix'];
        }

        if( isset($params['log']) && $params['log'] )
        {
            $this->logged = true;
        }

        if( !isset($params['persistent']) ) {
            $params['persistent'] = false;
        }

		global $config;
		if(class_exists('Cache') && ($cache = Cache::getInstance()) && $cache->enabled()) {
			$tmp = null;
			$need_revalidation = true;
			if($cache->fetch('database_checksum', $tmp) && $tmp) {
				$tmp = unserialize($tmp);
				if(sha1($config['database_host'] . '.' . $config['database_name']) === $tmp) {
					$need_revalidation = false;
				}
			}

			if(!$need_revalidation) {
				$tmp = null;
				if($cache->fetch('database_tables', $tmp) && $tmp) {
					$this->has_table_cache = unserialize($tmp);
				}

				$tmp = null;
				if($cache->fetch('database_columns', $tmp) && $tmp) {
					$this->has_column_cache = unserialize($tmp);
				}
			}
		}

		if(isset($params['socket'][0])) {
			$dns[] = 'unix_socket=' . $params['socket'];

			parent::__construct('mysql:' . implode(';', $dns), $user, $password, array(
				PDO::ATTR_PERSISTENT => $params['persistent']
			));

			return;
		}

		if( isset($params['host']) ) {
			$dns[] = 'host=' . $params['host'];
		}

		if( isset($params['port']) ) {
			$dns[] = 'port=' . $params['port'];
		}

		parent::__construct('mysql:' . implode(';', $dns), $user, $password, array(
			PDO::ATTR_PERSISTENT => $params['persistent']
		));
    }

	public function __destruct()
    {
		global $config;

	    if(class_exists('Cache') && ($cache = Cache::getInstance()) && $cache->enabled()) {
			$cache->set('database_tables', serialize($this->has_table_cache), 3600);
			$cache->set('database_columns', serialize($this->has_column_cache), 3600);
			$cache->set('database_checksum', serialize(sha1($config['database_host'] . '.' . $config['database_name'])), 3600);
		}

		if($this->logged) {
			log_append('database.log', $_SERVER['REQUEST_URI'] . PHP_EOL . $this->getLog());
		}
	}

/**
 * Query-quoted field name.
 *
 * @param string $name Field name.
 * @return string Quoted name.
 */
    public function fieldName($name)
    {
        return '`' . $name . '`';
    }

/**
 * LIMIT/OFFSET clause for queries.
 *
 * @param int|bool $limit Limit of rows to be affected by query (false if no limit).
 * @param int|bool $offset Number of rows to be skipped before applying query effects (false if no offset).
 * @return string LIMIT/OFFSET SQL clause for query.
 */
    public function limit($limit = false, $offset = false)
    {
        // by default this is empty part
        $sql = '';

        if($limit !== false)
        {
            $sql = ' LIMIT ';

            // OFFSET has no effect if there is no LIMIT
            if($offset !== false)
            {
                $sql .= $offset . ', ';
            }

            $sql .= $limit;
        }

        return $sql;
    }

	public function hasTable($name) {
		if(isset($this->has_table_cache[$name])) {
			return $this->has_table_cache[$name];
		}

		return $this->hasTableInternal($name);
	}

	private function hasTableInternal($name) {
		global $config;
		return ($this->has_table_cache[$name] = $this->query('SELECT `TABLE_NAME` FROM `information_schema`.`tables` WHERE `TABLE_SCHEMA` = ' . $this->quote($config['database_name']) . ' AND `TABLE_NAME` = ' . $this->quote($name) . ' LIMIT 1;')->rowCount() > 0);
	}

	public function hasColumn($table, $column) {
		if(isset($this->has_column_cache[$table . '.' . $column])) {
			return $this->has_column_cache[$table . '.' . $column];
		}

		return $this->hasColumnInternal($table, $column);
	}

    /**
     * Check if table exists and after check all columns passed of table
     *
     * @param $table
     * @param array $columns
     * @return bool
     */
    public function hasTableAndColumns($table, array $columns = [])
    {
        if (!$this->hasTable($table)) return false;
        foreach ($columns as $column) {
            if (!$this->hasColumn($table, $column)) {
                return false;
            }
        }
        return true;
    }

	private function hasColumnInternal($table, $column) {
		return $this->hasTable($table) && ($this->has_column_cache[$table . '.' . $column] = count($this->query('SHOW COLUMNS FROM `' . $table . "` LIKE '" . $column . "'")->fetchAll()) > 0);
	}

	public function revalidateCache() {
		foreach($this->has_table_cache as $key => $value) {
			$this->hasTableInternal($key);
		}

		foreach($this->has_column_cache as $key => $value) {
			$explode = explode('.', $key);
			if(!isset($this->has_table_cache[$explode[0]])) { // first check if table exist
				$this->hasTableInternal($explode[0]);
			}

			if($this->has_table_cache[$explode[0]]) {
				$this->hasColumnInternal($explode[0], $explode[1]);
			}
		}
	}
}

/**#@-*/

?>
