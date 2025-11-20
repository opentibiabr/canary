<?php

/**#@+
 * @version 0.1.1
 * @since 0.1.1
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Base class for all single-row classes. It implements auto-loading constructors.
 *
 * <p>
 * This class extends {@link OTS_Base_DAO basic DAO class} by initialising interface.
 * </p>
 *
 * <p>
 * This class is mostly usefull when you create own extensions for POT code.
 * </p>
 *
 * @package POT
 */
abstract class OTS_Row_DAO extends OTS_Base_DAO
{
    /**
     * Handles automatic loading for record.
     *
     * <p>
     * You can call class constructor with optional parameter which can be either of integer type (then it will be treated as primary key value) or string type (then it will be used as name identifier).
     * </p>
     *
     * <p>
     * Note: Make sure that you pass <var>$id</var> argument of correct type. This method determinates action which should be taken based on variable type. It means that 1 is primary key value, but '1' is name value.
     * </p>
     *
     * @param int|string|null $id Row ID (or name identifier dependend on child class).
     */
    public function __construct($id = null)
    {
        parent::__construct();

        // checks if row identifier is set
        if (isset($id)) {
            // checks if it's ID, or name identifier
            if (is_int($id)) {
                $this->load($id);
            } else {
                $this->find($id);
            }
        }
    }

    /**
     * Loads row by it's ID.
     *
     * @param int $id Integer identifier.
     */
    abstract public function load($id);

    /**
     * Loads row by it's name.
     *
     * @param string $name String identifier.
     */
    abstract public function find($name);
}

/**#@-*/
