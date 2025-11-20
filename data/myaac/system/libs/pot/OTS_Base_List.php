<?php

/**#@+
 * @version 0.0.5
 * @since 0.0.5
 */

/**
 * @package POT
 * @version 0.1.5
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 * @todo future: Use fetchObject() to reduce amount of SQL queries.
 * @todo future: Iterator classes (to map id => name iterations) with tutorial.
 */

/**
 * Basic list class routines.
 *
 * <p>
 * This class defines entire lists mechanism for classes that represents records set from OTServ database. All child classes only have to define {@link OTS_Base_List::init() init() method} to set table info for queries.
 * </p>
 *
 * <p>
 * Table on which list will operate has to contain integer <var>"id"</var> field and single row representing class has to support loading by this filed as key.
 * </p>
 *
 * <p>
 * This class is mostly usefull when you create own extensions for POT code.
 * </p>
 *
 * @package POT
 * @version 0.1.5
 * @property-write int $limit Sets LIMIT clause.
 * @property-write int $offset Sets OFFSET clause.
 * @property-write OTS_SQLFilter $filter Sets filter for list SQL query.
 */
abstract class OTS_Base_List implements IOTS_DAO, Iterator, Countable
{
/**
 * Database connection.
 *
 * @var PDO
 * @version 0.1.5
 */
    protected $db;

/**
 * Limit for SELECT query.
 *
 * @var int
 */
    private $limit = false;

/**
 * Offset for SELECT query.
 *
 * @var int
 */
    private $offset = false;

/**
 * WHERE clause filter.
 *
 * @var OTS_SQLFilter
 */
    private $filter = null;

/**
 * List of sorting criteriums.
 *
 * @var array
 */
    private $orderBy = array();

/**
 * Query results.
 *
 * @var array
 * @version 0.1.5
 */
    protected $rows;

/**
 * Default table name for queries.
 *
 * @var string
 */
    protected $table;

/**
 * Class of generated objects.
 *
 * @var string
 */
    protected $class;

/**
 * Sets database connection handler.
 *
 * @version 0.1.0
 */
    public function __construct()
    {
        $this->db = POT::getInstance()->getDBHandle();
        $this->init();
    }

/**
 * Sets list parameters.
 */
    abstract public function init();

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
        return array('limit', 'offset', 'filter', 'orderBy', 'table', 'class');
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
 * Sets LIMIT clause.
 *
 * <p>
 * Reduces amount of seleced rows up to given number.
 * </p>
 *
 * @param int|bool $limit Limit for SELECT (false to reset).
 */
    public function setLimit($limit = false)
    {
        if( is_int($limit) )
        {
            $this->limit = $limit;
        }
        else
        {
            $this->limit = false;
        }
    }

/**
 * Sets OFFSET clause.
 *
 * <p>
 * Moves starting rows of selected set to given position.
 * </p>
 *
 * @param int|bool $offset Offset for SELECT (false to reset).
 */
    public function setOffset($offset = false)
    {
        if( is_int($offset) )
        {
            $this->offset = $offset;
        }
        else
        {
            $this->offset = false;
        }
    }

/**
 * Returns current row.
 *
 * <p>
 * Returns object of class which handle single row representation. Object is initialised with ID of current position in result cursor.
 * </p>
 *
 * @version 0.1.3
 * @return OTS_Base_DAO Current row.
 */
    #[\ReturnTypeWillChange]
    public function current()
    {
        $id = current($this->rows);

        $class = 'OTS_' . $this->class;
        return new $class( (int) $id['id']);
    }

/**
 * Select rows from database.
 *
 * @throws PDOException On PDO operation error.
 */
    public function rewind(): void
    {
        $this->rows = $this->db->query( $this->getSQL() )->fetchAll();
    }

/**
 * Moves to next row.
 */
    public function next(): void
    {
        next($this->rows);
    }

/**
 * Current cursor position.
 *
 * @return mixed Array key.
 */
    #[\ReturnTypeWillChange]
    public function key()
    {
        return key($this->rows);
    }

/**
 * Checks if there are any rows left.
 *
 * @return bool Does next row exist.
 */
    public function valid(): bool
    {
        return key($this->rows) !== null;
    }

/**
 * Returns number of rows on list in current criterium.
 *
 * @version 0.1.5
 * @return int Number of rows.
 * @throws PDOException On PDO operation error.
 */
    public function count(): int
    {
        return $this->db->query( $this->getSQL(true) )->fetchColumn();
    }

/**
 * Sets filter on list.
 *
 * <p>
 * Call without argument to reset filter.
 * </p>
 *
 * @param OTS_SQLFilter|null $filter Filter for list.
 */
    public function setFilter(OTS_SQLFilter $filter = null)
    {
        $this->filter = $filter;
    }

/**
 * Clears ORDER BY clause.
 */
    public function resetOrder()
    {
        $this->orderBy = array();
    }

/**
 * Appends sorting rule.
 *
 * <p>
 * First parameter may be of type string, then it will be used as literal field name, or object of {@link OTS_SQLField OTS_SQLField class}, then it's representation will be used as qualiffied SQL identifier name.
 * </p>
 *
 * <p>
 * Note: Since 0.0.7 version <var>$field</var> parameter can be instance of {@link OTS_SQLField OTS_SQLField class}.
 * </p>
 *
 * @version 0.0.7
 * @param OTS_SQLField|string $field Field name.
 * @param int $order Sorting order (ascending by default).
 */
    public function orderBy($field, $order = POT::ORDER_ASC)
    {
        // constructs field name filter
        if($field instanceof OTS_SQLField)
        {
            $table = $field->getTable();

            // full table name
            if( !empty($table) )
            {
                $table = $this->db->tableName($table) . '.';
            }

            $field = $table . $this->db->fieldName( $field->getName() );
        }
        // literal name
        else
        {
            $field = $this->db->fieldName($field);
        }

        $this->orderBy[] = array('field' => $field, 'order' => $order);
    }

/**
 * Returns SQL query for SELECT.
 *
 * @version 0.1.5
 * @param bool $count Shows if the SQL should be generated for COUNT() variant.
 * @return string SQL query part.
 */
    protected function getSQL($count = false)
    {
        // fields list
        if($count)
        {
            $fields = 'COUNT(' . $this->db->tableName($this->table) . '.' . $this->db->fieldName('id') . ')';
        }
        else
        {
            $fields = $this->db->tableName($this->table) . '.' . $this->db->fieldName('id') . ' AS ' . $this->db->fieldName('id');
        }

        return $this->prepareSQL( array($fields) );
    }

/**
 * Returns generic SQL query that can be adaptated by child classes.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param array $fields Fields to be selected.
 * @return string SQL query.
 */
    protected function prepareSQL($fields)
    {
        $tables = array();

        // generates tables list for current qeury
        if( isset($this->filter) )
        {
            $tables = $this->filter->getTables();
        }

        // adds default table
        if( !in_array($this->table, $tables) )
        {
            $tables[] = $this->table;
        }

        // prepares tables names
        foreach($tables as &$name)
        {
            $name = $this->db->tableName($name);
        }

        // WHERE clause
        if( isset($this->filter) )
        {
            $where = ' WHERE ' . $this->filter->__toString();
        }
        else
        {
            $where = '';
        }

        // ORDER BY clause
        if(empty($this->orderBy) )
        {
            $orderBy = '';
        }
        else
        {
            $orderBy = array();

            foreach($this->orderBy as $criterium)
            {
                switch($criterium['order'])
                {
                    case POT::ORDER_ASC:
                        $orderBy[] = $criterium['field'] . ' ASC';
                        break;

                    case POT::ORDER_DESC:
                        $orderBy[] = $criterium['field'] . ' DESC';
                        break;
                }
            }

            $orderBy = ' ORDER BY ' . implode(', ', $orderBy);
        }

        return 'SELECT ' . implode(', ', $fields) . ' FROM ' . implode(', ', $tables) . $where . $orderBy . $this->db->limit($this->limit, $this->offset);
    }

/**
 * Magic PHP5 method.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @param string $name Property name.
 * @param mixed $value Property value.
 * @throws OutOfBoundsException For non-supported properties.
 */
    public function __set($name, $value)
    {
        switch($name)
        {
            case 'limit':
                $this->setLimit($value);
                break;

            case 'offset':
                $this->setOffset($value);
                break;

            case 'filter':
                $this->setFilter($value);
                break;

            default:
                throw new OutOfBoundsException();
        }
    }
}

/**#@-*/

?>
