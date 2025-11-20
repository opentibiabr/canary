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
 * Wrapper for houses list.
 *
 * @package POT
 * @version 0.1.3
 * @tutorial POT/data_directory.pkg#towns.houses
 */
class OTS_HousesList implements IteratorAggregate, Countable, ArrayAccess
{
/**
 * List of houses elements.
 *
 * @var array
 */
    private $houses = array();

/**
 * Loads houses information.
 *
 * @version 0.1.3
 * @param string $path Houses file.
 * @throws DOMException On DOM operation error.
 */
    public function __construct($path)
    {
        $houses = new DOMDocument();
        $houses->load($path);

        foreach( $houses->getElementsByTagName('house') as $house)
        {
            $this->houses[ (int) $house->getAttribute('houseid') ] = new OTS_House($house->getAttribute('houseid'));
        }
    }

/**
 * Magic PHP5 method.
 *
 * <p>
 * Allows object importing from {@link http://www.php.net/manual/en/function.var-export.php var_export()}.
 * </p>
 *
 * @param array $properties List of object properties.
 * @throws DOMException On DOM operation error.
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
 * Checks if given house exists on list.
 *
 * @version 0.1.3
 * @since 0.1.3
 * @param string $name Name.
 * @return bool If house is set then true.
 */
    public function hasHouse($name)
    {
        foreach($this->houses as $id => $house)
        {
            // checks houses id
            if( $house->getName() == $name)
            {
                return true;
            }
        }

        return false;
    }

/**
 * Returns house information.
 *
 * @version 0.1.3
 * @param int $id House ID.
 * @return OTS_House House information wrapper.
 * @throws OutOfBoundsException If house was not found.
 */
    public function getHouse($id)
    {
        if( isset($this->houses[$id]) )
        {
            return $this->houses[$id];
        }

        throw new OutOfBoundsException();
    }

/**
 * Checks if given house ID exists on list.
 *
 * @version 0.1.3
 * @since 0.1.3
 * @param int $id ID.
 * @return bool If house is set then true.
 */
    public function hasHouseId($id)
    {
        return isset($this->houses[$id]);
    }

/**
 * Returns ID of house with given name.
 *
 * @version 0.1.3
 * @param string $name House name.
 * @return int House ID.
 * @throws OutOfBoundsException False if not found.
 */
    public function getHouseId($name)
    {
        foreach($this->houses as $id => $house)
        {
            // checks houses id
            if( $house->getName() == $name)
            {
                return $id;
            }
        }

        throw new OutOfBoundsException();
    }

/**
 * Returns amount of houses.
 *
 * @return int Count of houses.
 */
    public function count(): int
    {
        return count($this->houses);
    }

/**
 * Returns iterator handle for loops.
 *
 * @return ArrayIterator Houses list iterator.
 */
    public function getIterator()
    {
        return new ArrayIterator($this->houses);
    }

/**
 * Checks if given element exists.
 *
 * @param string|int $offset Array key.
 * @return bool True if it's set.
 */
    public function offsetExists($offset)
    {
        // integer key
        if( is_int($offset) )
        {
            return isset($this->houses[$offset]);
        }

        // house name
        return $this->hasHouse($offset);
    }

/**
 * Returns item from given position.
 *
 * @version 0.1.3
 * @param string|int $offset Array key.
 * @return OTS_House|int If key is an integer (type-sensitive!) then returns house instance. If it's a string then return associated ID found by house name.
 */
    public function offsetGet($offset)
    {
        // integer key
        if( is_int($offset) )
        {
            return $this->getHouse($offset);
        }

        // house name
        return $this->getHouseId($offset);
    }

/**
 * This method is implemented for ArrayAccess interface. In fact you can't write/append to houses list. Any call to this method will cause {@link E_OTS_ReadOnly E_OTS_ReadOnly} raise.
 *
 * @param string|int $offset Array key.
 * @param mixed $value Field value.
 * @throws E_OTS_ReadOnly Always - this class is read-only.
 */
    public function offsetSet($offset, $value)
    {
        throw new E_OTS_ReadOnly();
    }

/**
 * This method is implemented for ArrayAccess interface. In fact you can't write/append to houses list. Any call to this method will cause {@link E_OTS_ReadOnly E_OTS_ReadOnly} raise.
 *
 * @param string|int $offset Array key.
 * @throws E_OTS_ReadOnly Always - this class is read-only.
 */
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
            return $ots->getDataDisplayDriver()->displayHousesList($this);
        }

        return (string) $this->count();
    }
}

/**#@-*/

?>
