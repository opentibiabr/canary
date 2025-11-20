<?php

/**#@+
 * @version 0.0.4
 * @since 0.0.4
 */

/**
 * @package POT
 * @version 0.1.4
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * OTServ guild rank abstraction.
 *
 * @package POT
 * @version 0.1.4
 * @property string $name Rank title.
 * @property OTS_Guild $guild Guild in which rank exists.
 * @property int $level Guild access level.
 * @property-read bool $loaded Loaded state check.
 * @property-read int $id Row ID.
 * @property-read OTS_Players_List $playersList List of members with this rank.
 */
class OTS_GuildRank extends OTS_Row_DAO implements IteratorAggregate, Countable
{
/**
 * Rank data.
 *
 * @var array
 */
    private $data = array();

/**
 * Loads rank with given id.
 *
 * @version 0.0.5
 * @param int $id Rank's ID.
 * @throws PDOException On PDO operation error.
 */
    public function load($id)
    {
        // SELECT query on database
        $this->data = $this->db->query('SELECT ' . $this->db->fieldName('id') . ', ' . $this->db->fieldName('guild_id') . ', ' . $this->db->fieldName('name') . ', ' . $this->db->fieldName('level') . ' FROM ' . $this->db->tableName('guild_ranks') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . (int) $id)->fetch();
    }

/**
 * Loads rank by it's name.
 *
 * <p>
 * As there can be several ranks with same name in different guilds you can pass optional second parameter to specify in which guild script should look for rank.
 * </p>
 *
 * @version 0.0.5
 * @param string $name Rank's name.
 * @param OTS_Guild $guild Guild in which rank should be found.
 * @throws PDOException On PDO operation error.
 * @throws E_OTS_NotLoaded If given <var>$guild</var> object is not loaded.
 */
    public function find($name, OTS_Guild $guild = null)
    {
        $where = '';

        // additional guild id criterium
        if( isset($guild) )
        {
            $where = ' AND ' . $this->db->fieldName('guild_id') . ' = ' . $guild->getId();
        }

        // finds player's ID
        $id = $this->db->query('SELECT ' . $this->db->fieldName('id') . ' FROM ' . $this->db->tableName('guilds') . ' WHERE ' . $this->db->fieldName('name') . ' = ' . $this->db->quote($name) . $where)->fetch();

        // if anything was found
        if( isset($id['id']) )
        {
            $this->load($id['id']);
        }
    }

/**
 * Checks if object is loaded.
 *
 * @return bool Load state.
 */
    public function isLoaded()
    {
        return isset($this->data['id']);
    }

/**
 * Saves rank in database.
 *
 * <p>
 * If rank is not loaded to represent any existing group it will create new row for it.
 * </p>
 *
 * @version 0.0.8
 * @throws PDOException On PDO operation error.
 */
    public function save()
    {
        // updates existing rank
        if( isset($this->data['id']) )
        {
            // UPDATE query on database
            $this->db->exec('UPDATE ' . $this->db->tableName('guild_ranks') . ' SET ' . $this->db->fieldName('guild_id') . ' = ' . $this->db->quote($this->data['guild_id']) . ', ' . $this->db->fieldName('name') . ' = ' . $this->db->quote($this->data['name']) . ', ' . $this->db->fieldName('level') . ' = ' . $this->data['level'] . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);
        }
        // creates new rank
        else
        {
            // INSERT query on database
            $this->db->exec('INSERT INTO ' . $this->db->tableName('guild_ranks') . ' (' . $this->db->fieldName('guild_id') . ', ' . $this->db->fieldName('name') . ', ' . $this->db->fieldName('level') . ') VALUES (' . $this->data['guild_id'] . ', ' . $this->db->quote($this->data['name']) . ', ' . $this->data['level'] . ')');
            // ID of new rank
            $this->data['id'] = $this->db->lastInsertId();
        }
    }

/**
 * Rank ID.
 *
 * @return int Rank ID.
 * @throws E_OTS_NotLoaded If rank is not loaded.
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
 * Rank name.
 *
 * @return string Rank's name.
 * @throws E_OTS_NotLoaded If rank is not loaded.
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
 * Sets rank's name.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_GuildRank::save() save() method} to flush changed to database.
 * </p>
 *
 * @param string $name Name.
 */
    public function setName($name)
    {
        $this->data['name'] = (string) $name;
    }

/**
 * Returns guild of this rank.
 *
 * @version 0.1.0
 * @return OTS_Guild Guild of this rank.
 * @throws E_OTS_NotLoaded If rank is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function getGuild()
    {
        if( !isset($this->data['guild_id']) )
        {
            return new OTS_Guild();
        }

        $guild = new OTS_Guild();
        $guild->load($this->data['guild_id']);
        return $guild;
    }

/**
 * Assigns rank to guild.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_GuildRank::save() save() method} to flush changed to database.
 * </p>
 *
 * @param OTS_Guild $guild Owning guild.
 * @throws E_OTS_NotLoaded If given <var>$guild</var> object is not loaded.
 */
    public function setGuild(OTS_Guild $guild)
    {
        $this->data['guild_id'] = $guild->getId();
    }

/**
 * Rank's access level.
 *
 * @return int Rank access level within guild.
 * @throws E_OTS_NotLoaded If rank is not loaded.
 */
    public function getLevel()
    {
        if( !isset($this->data['level']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['level'];
    }

/**
 * Sets rank's access level within guild.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_GuildRank::save() save() method} to flush changed to database.
 * </p>
 *
 * @param int $level access level within guild.
 */
    public function setLevel($level)
    {
        $this->data['level'] = (int) $level;
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
 * @param string $field Field name.
 * @return string Field value.
 * @throws E_OTS_NotLoaded If rank is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function getCustomField($field)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        $value = $this->db->query('SELECT ' . $this->db->fieldName($field) . ' FROM ' . $this->db->tableName('guild_ranks') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id'])->fetch();
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
 * Note: Make sure that you pass $value argument of correct type. This method determinates whether to quote field value. It is safe - it makes you sure that no unproper queries that could lead to SQL injection will be executed, but it can make your code working wrong way. For example: $object->setCustomField('foo', '1'); will quote 1 as as string ('1') instead of passing it as a integer.
 * </p>
 *
 * @version 0.0.5
 * @param string $field Field name.
 * @param mixed $value Field value.
 * @throws E_OTS_NotLoaded If rank is not loaded.
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

        $this->db->query('UPDATE ' . $this->db->tableName('guild_ranks') . ' SET ' . $this->db->fieldName($field) . ' = ' . $value . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);
    }

/**
 * @version 0.1.0
 * @return array List of members.
 * @throws E_OTS_NotLoaded If rank is not loaded.
 * @deprecated 0.0.5 Use getPlayersList().
 */
    public function getPlayers()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        $players = array();

        foreach( $this->db->query('SELECT ' . $this->db->fieldName('id') . ' FROM ' . $this->db->tableName('players') . ' WHERE ' . $this->db->fieldName('rank_id') . ' = ' . $this->data['id'])->fetchAll() as $player)
        {
            // creates new object
            $object = new OTS_Player();
            $object->load($player['id']);
            $players[] = $object;
        }

        return $players;
    }

/**
 * List of characters with current rank.
 *
 * <p>
 * In difference to {@link OTS_GuildRank::getPlayers() getPlayers() method} this method returns filtered {@link OTS_Players_List OTS_Players_List} object instead of array of {@link OTS_Player OTS_Player} objects. It is more effective since OTS_Player_List doesn't perform all rows loading at once.
 * </p>
 *
 * <p>
 * Note: Returned object is only prepared, but not initialised. When using as parameter in foreach loop it doesn't matter since it will return it's iterator, but if you will wan't to execute direct operation on that object you will need to call {@link OTS_Base_List::rewind() rewind() method} first.
 * </p>
 *
 * @version 0.1.4
 * @since 0.0.5
 * @return OTS_Players_List List of players with current rank.
 * @throws E_OTS_NotLoaded If rank is not loaded.
 */
    public function getPlayersList()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        // creates filter
		if($this->db->hasColumn('players', 'rank_id')) {
			$filter = new OTS_SQLFilter();
			$filter->compareField('rank_id', (int) $this->data['id']);
		}
		else {
			$filter = new OTS_SQLFilter(new OTS_SQLField('rank_id', 'guild_membership'), OTS_SQLFilter::OPERATOR_EQUAL, $this->getID());
			$filterPlayer = new OTS_SQLFilter(new OTS_SQLField('id', 'players'), OTS_SQLFilter::OPERATOR_EQUAL, new OTS_SQLField('player_id', 'guild_membership'));
		}
        $filter->compareField('deleted', 0);

        // creates list object
        $list = new OTS_Players_List();
        $list->setFilter(new OTS_SQLFilter($filter, OTS_SQLFilter::CRITERIUM_AND, $filterPlayer));;
		//$list->addOrder(new OTS_SQLOrder(new OTS_SQLField('name', 'players')));
        return $list;
    }

/**
 * Deletes guild rank.
 *
 * @version 0.0.5
 * @since 0.0.5
 * @throws E_OTS_NotLoaded If guild rank is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function delete()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        // deletes row from database
        $this->db->query('DELETE FROM ' . $this->db->tableName('guild_ranks') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);

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
 * @throws E_OTS_NotLoaded If rank is not loaded.
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
 * @throws E_OTS_NotLoaded If rank is not loaded.
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

            case 'guild':
                return $this->getGuild();

            case 'level':
                return $this->getLevel();

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
            case 'name':
                $this->setName($value);
                break;

            case 'guild':
                $this->setGuild($value);
                break;

            case 'level':
                $this->setLevel($value);
                break;

            default:
                throw new OutOfBoundsException();
        }
    }

/**
 * Returns string representation of object.
 *
 * <p>
 * If any display driver is currently loaded then it uses it's method. Else it returns rank name.
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
            return $ots->getDisplayDriver()->displayGuildRank($this);
        }

        return $this->getName();
    }
}

/**#@-*/

?>
