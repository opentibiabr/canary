<?php

/**#@+
 * @version 0.0.5
 * @since 0.0.5
 */

/**
 * @package POT
 * @version 0.1.3
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * SQL WHERE clause object.
 * 
 * <p>
 * Objects of this class can be used to filter {@link OTS_Base_List list objects} using {@link OTS_Base_List::setFilter() setFilter() method}. To compose more complex WHERE clauses you can append another filter to this one to create sub-condition.
 * </p>
 * 
 * @package POT
 * @version 0.1.3
 * @property-read array $tables List of tables used by this statement.
 * @tutorial POT/List_objects.pkg#filters
 */
class OTS_SQLFilter extends OTS_Base_DAO
{
/**
 * Equal operator.
 */
    const OPERATOR_EQUAL = 1;
/**
 * Lower-then operator.
 */
    const OPERATOR_LOWER = 2;
/**
 * Greater-then operator.
 */
    const OPERATOR_GREATER = 3;
/**
 * Not-equal operator.
 */
    const OPERATOR_NEQUAL = 4;
/**
 * Not-lower-then operator.
 */
    const OPERATOR_NLOWER = 5;
/**
 * Not-greater-then operator.
 */
    const OPERATOR_NGREATER = 6;
/**
 * LIKE operator.
 */
    const OPERATOR_LIKE = 7;
/**
 * Not-LIKE operator.
 */
    const OPERATOR_NLIKE = 8;

/**
 * AND sibling.
 */
    const CRITERIUM_AND = 1;
/**
 * OR sibling.
 */
    const CRITERIUM_OR = 2;

/**
 * List of criteriums.
 * 
 * @var array
 */
    private $criteriums = array();

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
        return array('criteriums');
    }

/**
 * Creates clone of object.
 * 
 * <p>
 * This method is empty to override {@link OTS_Base_DAO::__clone() OTS_Base_DAO method}.
 * </p>
 * 
 * @version 0.1.3
 * @since 0.1.3
 */
    public function __clone()
    {
    }

/**
 * Returns string representation of WHERE clause.
 * 
 * <p>
 * Returned string can be easily inserted into SQL query.
 * </p>
 * 
 * @version 0.1.0
 * @return string String WHERE clause.
 */
    public function __toString()
    {
        $where = '';

        // first filter element
        $first = true;

        // inserts filters into string
        foreach($this->criteriums as $criterium)
        {
            // next elements merged
            if(!$first)
            {
                switch($criterium['criterium'])
                {
                    case self::CRITERIUM_AND:
                        $where .= ' AND ';
                        break;

                    case self::CRITERIUM_OR:
                        $where .= ' OR ';
                        break;
                }
            }
            else
            {
                $first = false;
            }

            // sub-filter
            if($criterium['left'] instanceof OTS_SQLFilter)
            {
                $where .= '(' . $criterium['left']->__toString() . ')';
            }
            // single criterium
            else
            {
                // left side
                if($criterium['left'] instanceof OTS_SQLField)
                {
                    $where .= $criterium['left']->__toString();
                }
                else
                {
                    if( is_int($criterium['left']) || is_float($criterium['left']) )
                    {
                        $where .= $criterium['left'];
                    }
                    // quotes string
                    else
                    {
                        $where .= $this->db->quote($criterium['left']);
                    }
                }

                // appends operator
                switch($criterium['operator'])
                {
                    case self::OPERATOR_EQUAL:
                        $where .= ' = ';
                        break;

                    case self::OPERATOR_LOWER:
                        $where .= ' < ';
                        break;

                    case self::OPERATOR_GREATER:
                        $where .= ' > ';
                        break;

                    case self::OPERATOR_NEQUAL:
                        $where .= ' != ';
                        break;

                    case self::OPERATOR_NLOWER:
                        $where .= ' >= ';
                        break;

                    case self::OPERATOR_NGREATER:
                        $where .= ' <= ';
                        break;

                    case self::OPERATOR_LIKE:
                        $where .= ' LIKE ';
                        break;

                    case self::OPERATOR_NLIKE:
                        $where .= ' NOT LIKE ';
                        break;
                }

                // right side
                if($criterium['right'] instanceof OTS_SQLField)
                {
                    $where .= $criterium['right']->__toString();
                }
                else
                {
                    if( is_int($criterium['right']) || is_float($criterium['right']) )
                    {
                        $where .= $criterium['right'];
                    }
                    // quotes string
                    else
                    {
                        $where .= $this->db->quote($criterium['right']);
                    }
                }
            }
        }

        return $where;
    }

/**
 * General-purpose filter.
 * 
 * <p>
 * Appends new filter in universal way. You can append either literal value comparsion, fields comparsion or another filter object as sub-condition.
 * </p>
 * 
 * <p>
 * To append subset of another filters use addFilter($OTS_SQLFilterObject).
 * </p>
 * 
 * @param mixed $left Left side ({@link OTS_SQLField OTS_SQLField class} object, {@link OTS_SQLFilter OTS_SQLFilter class} object, or literal value).
 * @param mixed $right Right side ({@link OTS_SQLField OTS_SQLField class} object, or literal value).
 * @param int $operator Operator used for comparsion (equal check by default).
 * @param int $criterium Criterium merging method (AND by default).
 */
    public function addFilter($left, $right = null, $operator = self::OPERATOR_EQUAL, $criterium = self::CRITERIUM_AND)
    {
        $this->criteriums[] = array('left' => $left, 'right' => $right, 'operator' => $operator, 'criterium' => $criterium);
    }

/**
 * Compares field with a literal value.
 * 
 * @param string $field Field name.
 * @param mixed $value Literal value.
 * @param int $operator Operator used for comparsion (equal by default).
 * @param int $criterium Criterium merging method (AND by default).
 * @example examples/filter.php filter.php
 */
    public function compareField($field, $value, $operator = self::OPERATOR_EQUAL, $criterium = self::CRITERIUM_AND)
    {
        $this->addFilter( new OTS_SQLField($field), $value, $operator, $criterium);
    }

/**
 * Returns list of all tables used by filter.
 * 
 * <p>
 * This is required for FROM clause.
 * </p>
 * 
 * @return array List of all tables used by this filter.
 */
    public function getTables()
    {
        $tables = array();

        // finds all unique table names
        foreach($this->criteriums as $criterium)
        {
            // subcriterium
            if($criterium['left'] instanceof OTS_SQLFilter)
            {
                // puts all it's tables into current list
                foreach( $criterium['left']->getTables() as $table)
                {
                    // checks if it's not default table neither already saved table
                    if(!( empty($table) || in_array($table, $tables) ))
                    {
                        $tables[] = $table;
                    }
                }
            }

            // field name on left side
            if($criterium['left'] instanceof OTS_SQLField)
            {
                $table = $criterium['left']->getTable();

                // checks if it's not default table neither already saved table
                if(!( empty($table) || in_array($table, $tables) ))
                {
                    $tables[] = $table;
                }
            }

            // field name on right side
            if($criterium['right'] instanceof OTS_SQLField)
            {
                $table = $criterium['right']->getTable();

                // checks if it's not default table neither already saved table
                if(!( empty($table) || in_array($table, $tables) ))
                {
                    $tables[] = $table;
                }
            }
        }

        return $tables;
    }

/**
 * Magic PHP5 method.
 * 
 * @version 0.1.0
 * @since 0.1.0
 * @param string $name Property name.
 * @return mixed Property value.
 * @throws OutOfBoundsException For non-supported properties.
 */
    public function __get($name)
    {
        switch($name)
        {
            case 'tables':
                return $this->getTables();

            default:
                throw new OutOfBoundsException();
        }
    }
}

/**#@-*/

?>
