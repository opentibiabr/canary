<?php

/**#@+
 * @version 0.0.1
 */

/**
 * @package POT
 * @version 0.1.4
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * OTServ user group abstraction.
 *
 * @package POT
 * @version 0.1.4
 * @property string $name Group name.
 * @property int $flags Access flags.
 * @property int $access Access level.
 * @property int $maxDepotItems Maximum count of items in depot.
 * @property int $maxVIPList Maximum count of entries in VIP list.
 * @property-read bool $loaded Loaded state check.
 * @property-read int $id Row ID.
 * @property-read OTS_Players_List $playersList List of members of this group.
 */
class OTS_Group extends OTS_Row_DAO implements IteratorAggregate, Countable
{
/**
 * Group data.
 *
 * @var array
 */
    protected $data = array('flags' => 0, 'customFlags' => 0, 'access' => 0, 'ghostAccess' => 0);

/**
 * Spell info resource.
 *
 * @var DOMElement
 */
    private $element;

/**
 * Sets group info.
 *
 * @param DOMElement $group  Group info.
 */
    public function __construct($data = array())
    {
		$this->data = $data;
    }

/**
 * Checks if object is loaded.
 *
 * @version 0.0.1
 * @return bool Load state.
 */
    public function isLoaded()
    {
        return isset($this->data['id']);
    }

/**
 * Loads group with given id.
 *
 * @version 0.0.5
 * @param int $id Group number.
 * @throws PDOException On PDO operation error.
 */
    public function load($element)
    {
        // SELECT query on database
 //       $this->data = $this->db->query('SELECT ' . $this->db->fieldName('id') . ', ' . $this->db->fieldName('name') . ', ' . $this->db->fieldName('flags') . ', ' . $this->db->fieldName('access') . ', ' . $this->db->fieldName('maxdepotitems') . ', ' . $this->db->fieldName('maxviplist') . ' FROM ' . $this->db->tableName('groups') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . (int) $id)->fetch();

		        $this->element = $element;
 //       $groups = new DOMDocument();
  //      $groups->load($path);
  //      foreach($groups->getElementsByTagName('group') as $group)
  //      {
	//		if($group->getAttribute('id') == $_id)
	//		{

				$this->data['id'] = $element->getAttribute('id');
				$this->data['access'] = $element->getAttribute('access');
				$this->data['name'] = $element->getAttribute('name');
				$this->data['maxviplist'] = $element->getAttribute('maxVips');
				$this->data['maxdepotitems'] = $element->getAttribute('depotLimit');
	//		}
    //    }
    }

/**
 * Loads group by it's name.
 *
 * @version 0.1.1
 * @since 0.1.1
 * @param string $name Group name.
 * @throws PDOException On PDO operation error.
 */
    public function find($name)
    {
        // finds group's ID
        $id = $this->db->query('SELECT ' . $this->db->fieldName('id') . ' FROM ' . $this->db->tableName('groups') . ' WHERE ' . $this->db->fieldName('name') . ' = ' . $this->db->quote($name) )->fetch();

        // if anything was found
        if( isset($id['id']) )
        {
            $this->load($id['id']);
        }
    }

/**
 * Saves group in database.
 *
 * <p>
 * If group is not loaded to represent any existing group it will create new row for it.
 * </p>
 *
 * @version 0.0.5
 * @throws PDOException On PDO operation error.
 */
    public function save()
    {
        // updates existing group
        if( isset($this->data['id']) )
        {
            // UPDATE query on database
            $this->db->exec('UPDATE ' . $this->db->tableName('groups') . ' SET ' . $this->db->fieldName('name') . ' = ' . $this->db->quote($this->data['name']) . ', ' . $this->db->fieldName('flags') . ' = ' . $this->data['flags'] . ', ' . $this->db->fieldName('access') . ' = ' . $this->data['access'] . ', ' . $this->db->fieldName('maxdepotitems') . ' = ' . $this->data['maxdepotitems'] . ', ' . $this->db->fieldName('maxviplist') . ' = ' . $this->data['maxviplist'] . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);
        }
        // creates new group
        else
        {
            // INSERT query on database
            $this->db->exec('INSERT INTO ' . $this->db->tableName('groups') . ' (' . $this->db->fieldName('name') . ', ' . $this->db->fieldName('flags') . ', ' . $this->db->fieldName('access') . ', ' . $this->db->fieldName('maxdepotitems') . ', ' . $this->db->fieldName('maxviplist') . ') VALUES (' . $this->db->quote($this->data['name']) . ', ' . $this->data['flags'] . ', ' . $this->data['access'] . ', ' . $this->data['maxdepotitems'] . ', ' . $this->data['maxviplist'] . ')');
            // ID of new group
            $this->data['id'] = $this->db->lastInsertId();
        }
    }

/**
 * Group ID.
 *
 * <p>
 * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded exception} instead of triggering E_USER_WARNING.
 * </p>
 *
 * @version 0.0.3
 * @return int Group ID.
 * @throws E_OTS_NotLoaded If group is not loaded.
 */
    public function getId()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['id'];
    }

/**
 * Group name.
 *
 * <p>
 * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded exception} instead of triggering E_USER_WARNING.
 * </p>
 *
 * @version 0.0.3
 * @return string Name.
 * @throws E_OTS_NotLoaded If group is not loaded.
 */
    public function getName()
    {
        if( !isset($this->data['name']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['name'];
    }

/**
 * Sets group's name.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Group::save() save() method} to flush changed to database.
 * </p>
 *
 * @param string $name Name.
 */
    public function setName($name)
    {
        $this->data['name'] = (string) $name;
    }

/**
 * Rights flags.
 *
 * <p>
 * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded exception} instead of triggering E_USER_WARNING.
 * </p>
 *
 * @version 0.0.3
 * @return int Flags.
 * @throws E_OTS_NotLoaded If group is not loaded.
 */
    public function getFlags()
    {
        if( !isset($this->data['flags']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['flags'];
    }

/**
 * Sets rights flags.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Group::save() save() method} to flush changed to database.
 * </p>
 *
 * @param int $flags Flags.
 */
    public function setFlags($flags)
    {
        $this->data['flags'] = (int) $flags;
    }

/**
 * Custom flags.
 *
 * <p>
 * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded exception} instead of triggering E_USER_WARNING.
 * </p>
 *
 * @version 0.0.3
 * @return int Flags.
 * @throws E_OTS_NotLoaded If group is not loaded.
 */
    public function getCustomFlags()
    {
        if( !isset($this->data['customFlags']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['customFlags'];
    }

/**
 * Sets rights flags.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Group::save() save() method} to flush changed to database.
 * </p>
 *
 * @param int $flags Flags.
 */
    public function setCustomFlags($flags)
    {
        $this->data['customFlags'] = (int) $flags;
    }

/**
 * Access level.
 *
 * <p>
 * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded exception} instead of triggering E_USER_WARNING.
 * </p>
 *
 * @version 0.0.3
 * @return int Access level.
 * @throws E_OTS_NotLoaded If group is not loaded.
 */
    public function getAccess()
    {
        if( !isset($this->data['access']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['access'];
    }

/**
 * Sets access level.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Group::save() save() method} to flush changed to database.
 * </p>
 *
 * @param int $access Access level.
 */
    public function setAccess($access)
    {
        $this->data['access'] = (int) $access;
    }

/**
 * Maximum count of items in depot.
 *
 * <p>
 * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded exception} instead of triggering E_USER_WARNING.
 * </p>
 *
 * @version 0.0.3
 * @return int Maximum value.
 * @throws E_OTS_NotLoaded If group is not loaded.
 */
    public function getMaxDepotItems()
    {
        if( !isset($this->data['maxdepotitems']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['maxdepotitems'];
    }

/**
 * Sets maximum count of items in depot.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Group::save() save() method} to flush changed to database.
 * </p>
 *
 * @param int $maxdepotitems Maximum value.
 */
    public function setMaxDepotItems($maxdepotitems)
    {
        $this->data['maxdepotitems'] = (int) $maxdepotitems;
    }

/**
 * Maximum count of players in VIP list.
 *
 * <p>
 * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded exception} instead of triggering E_USER_WARNING.
 * </p>
 *
 * @version 0.0.3
 * @return int Maximum value.
 * @throws E_OTS_NotLoaded If group is not loaded.
 */
    public function getMaxVIPList()
    {
        if( !isset($this->data['maxviplist']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['maxviplist'];
    }

/**
 * Sets maximum count of players in VIP list.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Group::save() save() method} to flush changed to database.
 * </p>
 *
 * @param int $maxviplist Maximum value.
 */
    public function setMaxVIPList($maxviplist)
    {
        $this->data['maxviplist'] = (int) $maxviplist;
    }

/**
 * Reads custom field.
 *
 * <p>
 * Reads field by it's name. Can read any field of given record that exists in database.
 * </p>
 *
 * <p>
 * Note: You should use this method only for fields that are not provided in standard setters/getters (SVN fields). This method runs SQL query each time you call it so it highly overloads used resources.
 * </p>
 *
 * @version 0.0.5
 * @since 0.0.3
 * @param string $field Field name.
 * @return string Field value.
 * @throws E_OTS_NotLoaded If group is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function getCustomField($field)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        $value = $this->db->query('SELECT ' . $this->db->fieldName($field) . ' FROM ' . $this->db->tableName('groups') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id'])->fetch();
        return $value[$field];
    }

/**
 * Writes custom field.
 *
 * <p>
 * Write field by it's name. Can write any field of given record that exists in database.
 * </p>
 *
 * <p>
 * Note: You should use this method only for fields that are not provided in standard setters/getters (SVN fields). This method runs SQL query each time you call it so it highly overloads used resources.
 * </p>
 *
 * <p>
 * Note: Make sure that you pass $value argument of correct type. This method determinates whether to quote field name. It is safe - it makes you sure that no unproper queries that could lead to SQL injection will be executed, but it can make your code working wrong way. For example: $object->setCustomField('foo', '1'); will quote 1 as as string ('1') instead of passing it as a integer.
 * </p>
 *
 * @version 0.0.5
 * @since 0.0.3
 * @param string $field Field name.
 * @param mixed $value Field value.
 * @throws E_OTS_NotLoaded If group is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function setCustomField($field, $value)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        // quotes value for SQL query
        if(!( is_int($value) || is_float($value) ))
        {
            $value = $this->db->quote($value);
        }

        $this->db->exec('UPDATE ' . $this->db->tableName('groups') . ' SET ' . $this->db->fieldName($field) . ' = ' . $value . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);
    }

/**
 * @version 0.1.0
 * @return array Array of OTS_Player objects from given group.
 * @throws E_OTS_NotLoaded If group is not loaded.
 * @deprecated 0.0.5 Use getPlayersList().
 */
    public function getPlayers()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        $players = array();

        foreach( $this->db->query('SELECT ' . $this->db->fieldName('id') . ' FROM ' . $this->db->tableName('players') . ' WHERE ' . $this->db->fieldName('group_id') . ' = ' . $this->data['id'])->fetchAll() as $player)
        {
            // creates new object
            $object = new OTS_Player();
            $object->load($player['id']);
            $players[] = $object;
        }

        return $players;
    }

/**
 * List of characters in group.
 *
 * <p>
 * In difference to {@link OTS_Group::getPlayers() getPlayers() method} this method returns filtered {@link OTS_Players_List OTS_Players_List} object instead of array of {@link OTS_Player OTS_Player} objects. It is more effective since OTS_Player_List doesn't perform all rows loading at once.
 * </p>
 *
 * <p>
 * Note: Returned object is only prepared, but not initialised. When using as parameter in foreach loop it doesn't matter since it will return it's iterator, but if you will wan't to execute direct operation on that object you will need to call {@link OTS_Base_List::rewind() rewind() method} first.
 * </p>
 *
 * @version 0.1.4
 * @since 0.0.5
 * @return OTS_Players_List List of players from current group.
 * @throws E_OTS_NotLoaded If group is not loaded.
 */
    public function getPlayersList()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        // creates filter
        $filter = new OTS_SQLFilter();
        $filter->compareField('group_id', (int) $this->data['id']);
		global $db;
		if($db->hasColumn('players', 'deletion'))
			$filter->compareField('deletion', 0);
		else
      	  $filter->compareField('deleted', 0);

        // creates list object
        $list = new OTS_Players_List();
        $list->setFilter($filter);

        return $list;
    }

/**
 * Deletes group.
 *
 * @version 0.0.5
 * @since 0.0.5
 * @throws E_OTS_NotLoaded If group is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function delete()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        // deletes row from database
        $this->db->exec('DELETE FROM ' . $this->db->tableName('groups') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);

        // resets object handle
        unset($this->data['id']);
    }

/**
 * Returns players iterator.
 *
 * <p>
 * There is no need to implement entire Iterator interface since we have {@link OTS_Players_List players list class} for it.
 * </p>
 *
 * @version 0.0.5
 * @since 0.0.5
 * @throws E_OTS_NotLoaded If group is not loaded.
 * @throws PDOException On PDO operation error.
 * @return Iterator List of players.
 */
    #[\ReturnTypeWillChange]
    public function getIterator()
    {
        return $this->getPlayersList();
    }

/**
 * Returns number of player within.
 *
 * @version 0.0.5
 * @since 0.0.5
 * @throws E_OTS_NotLoaded If group is not loaded.
 * @throws PDOException On PDO operation error.
 * @return int Count of players.
 */
    public function count(): int
    {
        return $this->getPlayersList()->count();
    }

/**
 * Magic PHP5 method.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @param string $name Property name.
 * @return mixed Property value.
 * @throws E_OTS_NotLoaded If group is not loaded.
 * @throws OutOfBoundsException For non-supported properties.
 * @throws PDOException On PDO operation error.
 */
    public function __get($name)
    {
        switch($name)
        {
            case 'loaded':
                return $this->isLoaded();

            case 'id':
                return $this->getId();

            case 'name':
                return $this->getName();

            case 'flags':
                return $this->getFlags();

            case 'access':
                return $this->getAccess();

            case 'maxDepotItems':
                return $this->getMaxDepotItems();

            case 'maxVIPList':
                return $this->getMaxVIPList();

            case 'playersList':
                return $this->getPlayersList();

            default:
                throw new OutOfBoundsException();
        }
    }

/**
 * Magic PHP5 method.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @param string $name Property name.
 * @param mixed $value Property value.
 * @throws OutOfBoundsException For non-supported properties.
 * @throws PDOException On PDO operation error.
 */
    public function __set($name, $value)
    {
        switch($name)
        {
			case 'id':
				$this->data['id'] = $value;
				break;

            case 'name':
                $this->setName($value);
                break;

            case 'flags':
                $this->setFlags($value);
                break;

            case 'access':
                $this->setAccess($value);
                break;

            case 'maxDepotItems':
                $this->setMaxDepotItems($value);
                break;

            case 'maxVIPList':
                $this->setMaxVIPList($value);
                break;

            default:
                throw new OutOfBoundsException();
        }
    }

/**
 * Returns string representation of object.
 *
 * <p>
 * If any display driver is currently loaded then it uses it's method. Else it returns group name.
 * </p>
 *
 * @version 0.1.3
 * @since 0.1.0
 * @return string String representation of object.
 */
    public function __toString()
    {
        $ots = POT::getInstance();

        // checks if display driver is loaded
        if( $ots->isDisplayDriverLoaded() )
        {
            return $ots->getDisplayDriver()->displayGroup($this);
        }

        return $this->getName();
    }
}

/**#@-*/

?>
