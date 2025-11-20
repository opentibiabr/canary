<?php

/**#@+
 * @version 0.1.0
 * @since 0.1.0
 */

/**
 * @package POT
 * @version 0.1.3
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Wrapper for monsters list.
 *
 * @package POT
 * @version 0.1.3
 * @tutorial POT/data_directory.pkg#monsters
 */
class OTS_MonstersList implements Iterator, Countable, ArrayAccess
{
/**
 * Monsters directory.
 *
 * @var string
 */
    private $monstersPath;

/**
 * List of loaded monsters.
 *
 * @var array
 */
    private $monsters = array();

	private $lastMonsterFile = '';
	private $hasErrors = false;

    /**
     * Loads monsters mapping file.
     *
     * <p>
     * Note: You pass directory path, not monsters.xml file name itself.
     * </p>
     *
     * @param string $path Monsters directory.
     * @throws DOMException On DOM operation error.
     */
    public function __construct($path)
    {
        $this->monstersPath = $path;

        // makes sure it has directory separator at the end
        $last = substr($this->monstersPath, -1);
        if ($last != '/' && $last != '\\') {
            $this->monstersPath .= '/';
        }

        // check if monsters.xml exist
        if (!@file_exists($this->monstersPath . 'monsters.xml')) {
            log_append('error.log', '[OTS_MonstersList.php] Fatal error: Cannot load monsters.xml. File does not exist. (' . $this->monstersPath . 'monsters.xml' . ').');
            throw new Exception('Error: Cannot load monsters.xml. File not found.');
        }

        // loads monsters mapping file
        $monsters = new DOMDocument();
        if (!@$monsters->load($this->monstersPath . 'monsters.xml')) {
            log_append('error.log', '[OTS_MonstersList.php] Fatal error: Cannot load monsters.xml (' . $this->monstersPath . 'monsters.xml' . '). Error: ' . print_r(error_get_last(), true));
            throw new Exception('Error: Cannot load monsters.xml. File is invalid. More info in system/logs/error.log file.');
        }

        foreach ($monsters->getElementsByTagName('monster') as $monster) {
            $this->monsters[$monster->getAttribute('name')] = $monster->getAttribute('file');
            //echo $this->monsters[ $monster->getAttribute('name')];
        }
    }

/**
 * Magic PHP5 method.
 *
 * Allows object importing from {@link http://www.php.net/manual/en/function.var-export.php var_export()}.
 *
 * @param array $properties List of object properties.
 */
    public static function __set_state($properties)
    {
        $object = new self();

        // loads properties
        foreach($properties as $name => $value)
        {
            $object->$name = $value;
        }

        return $object;
    }

/**
 * Checks if given monster ID exists on list.
 *
 * @version 0.1.3
 * @since 0.1.3
 * @param string $name Monster name.
 * @return bool If monster is set then true.
 */
    public function hasMonster($name)
    {
        return isset($this->monsters[$name]);
    }

	function xmlErrorHandler($errno, $errstr, $errfile, $errline)
	{
		if($errno==E_WARNING && (substr_count($errstr,"DOMDocument::loadXML()")>0)) {
			//throw new DOMException($errstr);
			log_append('error.log', '[OTS_MonstersList.php] Fatal error: Cannot load ' . $this->lastMonsterFile . ' - ' . $errstr);
			$this->hasErrors = true;
		}
		else
			return false;
	}
/**
 * Returns loaded data of given monster.
 *
 * @version 0.1.3
 * @param string $name Monster name.
 * @return OTS_Monster Monster data.
 * @throws OutOfBoundsException If not exists.
 * @throws DOMException On DOM operation error.
 */
    public function getMonster($name)
    {
		global $lastMonsterFile;
        // checks if monster exists
        if( isset($this->monsters[$name]) )
        {
            // loads file
            $monster = new OTS_Monster();
			//echo $this->monstersPath . $this->monsters[$name];

			// check if monster file exist
           if(file_exists($this->monstersPath . $this->monsters[$name])) {
				set_error_handler(array($this, 'xmlErrorHandler'));
				$this->lastMonsterFile = $this->monstersPath . $this->monsters[$name];
				@$monster->loadXML(trim(file_get_contents($this->monstersPath . $this->monsters[$name])));
				restore_error_handler();
			}

            return $monster;
        }

        throw new OutOfBoundsException();
    }

	public function hasErrors() {
		return $this->hasErrors;
	}
/**
 * Returns amount of monsters loaded.
 *
 * @return int Count of monsters.
 */
    public function count(): int
    {
        return count($this->monsters);
    }

/**
 * Returns monster at current position in iterator.
 *
 * @return OTS_Monster Monster.
 * @throws DOMException On DOM operation error.
 */
    #[\ReturnTypeWillChange]
    public function current()
    {
        return $this->getMonster( key($this->monsters) );
    }

    public function currentFile()
    {
        return $this->monsters[key($this->monsters)];
    }

/**
 * Moves to next iterator monster.
 */
    public function next(): void
    {
        next($this->monsters);
    }

/**
 * Returns name of current position.
 *
 * @return string Current position key.
 */
    #[\ReturnTypeWillChange]
    public function key()
    {
        return key($this->monsters);
    }

/**
 * Checks if there is anything more in interator.
 *
 * @return bool If iterator has anything more.
 */
    public function valid(): bool
    {
        return key($this->monsters) !== null;
    }

/**
 * Resets iterator index.
 */
    public function rewind(): void
    {
        reset($this->monsters);
    }

/**
 * Checks if given element exists.
 *
 * @param string $offset Array key.
 * @return bool True if it's set.
 */
    #[\ReturnTypeWillChange]
    public function offsetExists($offset)
    {
        return isset($this->monsters[$offset]);
    }

/**
 * Returns item from given position.
 *
 * @version 0.1.3
 * @param string $offset Array key.
 * @return OTS_Monster Monster instance.
 * @throws DOMException On DOM operation error.
 */
    #[\ReturnTypeWillChange]
    public function offsetGet($offset)
    {
        return $this->getMonster($offset);
    }

/**
 * This method is implemented for ArrayAccess interface. In fact you can't write/append to monsters list. Any call to this method will cause {@link E_OTS_ReadOnly E_OTS_ReadOnly} raise.
 *
 * @param string|int $offset Array key.
 * @param mixed $value Field value.
 * @throws E_OTS_ReadOnly Always - this class is read-only.
 */
    #[\ReturnTypeWillChange]
    public function offsetSet($offset, $value)
    {
        throw new E_OTS_ReadOnly();
    }

/**
 * This method is implemented for ArrayAccess interface. In fact you can't write/append to monsters list. Any call to this method will cause {@link E_OTS_ReadOnly E_OTS_ReadOnly} raise.
 *
 * @param string|int $offset Array key.
 * @throws E_OTS_ReadOnly Always - this class is read-only.
 */
    #[\ReturnTypeWillChange]
    public function offsetUnset($offset)
    {
        throw new E_OTS_ReadOnly();
    }

/**
 * Returns string representation of object.
 *
 * <p>
 * If any display driver is currently loaded then it uses it's method.
 * </p>
 *
 * @version 0.1.3
 * @since 0.1.3
 * @return string String representation of object.
 */
    public function __toString()
    {
        $ots = POT::getInstance();

        // checks if display driver is loaded
        if( $ots->isDataDisplayDriverLoaded() )
        {
            return $ots->getDataDisplayDriver()->displayMonstersList($this);
        }

        return (string) $this->count();
    }
}

/**#@-*/

?>
