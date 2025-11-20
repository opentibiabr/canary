<?php

if (PHP_VERSION_ID >= 80000) {
	require LIBS . 'pot/OTS_DB_PDOQuery_PHP71.php';
} else {
	trait OTS_DB_PDOQuery
	{
		/**
		 * @return PDOStatement
		 */
		public function query()
		{
			return $this->doQuery(...func_get_args());
		}
	}
}
