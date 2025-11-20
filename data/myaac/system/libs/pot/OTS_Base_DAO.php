<?php

/**#@+
 * @version 0.0.5
 * @since 0.0.5
 */

/**
 * @package POT
 * @version 0.1.0
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Basic data access object routines.
 * 
 * <p>
 * This class defines basic mechanisms for all classes that will represent database accessors. However no coding logic is defined here - only connection handling and PHP core-related stuff to enable variouse operations with objects.
 * </p>
 * 
 * <p>
 * This class is mostly usefull when you create own extensions for POT code.
 * </p>
 * 
 * @package POT
 * @version 0.1.0
 */
abstract class OTS_Base_DAO implements IOTS_DAO
{
/**
 * Database connection.
 * 
 * @var PDO
 */
    protected $db;

/**
 * Sets database connection handler.
 * 
 * @version 0.1.0
 */
    public function __construct()
    {
        $this->db = POT::getInstance()->getDBHandle();
    }

/**
 * Magic PHP5 method.
 * 
 * <p>
 * Allows object serialisation.
 * </p>
 * 
 * @return array List of properties that should be saved.
 */
    public function __sleep()
    {
        return array('data');
    }

/**
 * Magic PHP5 method.
 * 
 * <p>
 * Allows object unserialisation.
 * </p>
 */
    public function __wakeup()
    {
        $this->db = POT::getInstance()->getDBHandle();
    }

/**
 * Creates clone of object.
 * 
 * <p>
 * Copy of object needs to have different ID.
 * </p>
 */
    public function __clone()
    {
        unset($this->data['id']);
    }

/**
 * Magic PHP5 method.
 * 
 * <p>
 * Allows object importing from {@link http://www.php.net/manual/en/function.var-export.php var_export()}.
 * </p>
 * 
 * @version 0.1.0
 * @param array $properties List of object properties.
 */
    public static function __set_state($properties)
    {
        // deletes database handle
        if( isset($properties['db']) )
        {
            unset($properties['db']);
        }

        // initializes new object with current database connection
        $object = new self();

        // loads properties
        foreach($properties as $name => $value)
        {
            $object->$name = $value;
        }

        return $object;
    }
}

/**#@-*/

?>
