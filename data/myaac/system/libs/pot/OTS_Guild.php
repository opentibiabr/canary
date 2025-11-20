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
 * OTServ guild abstraction.
 *
 * @package POT
 * @version 0.1.4
 * @property string $read Guild name.
 * @property OTS_Player $owner Guild founder.
 * @property int $creationData Guild creation data (mostly timestamp).
 * @property-read int $id Guild ID.
 * @property-read bool $loaded Loaded state.
 * @property-read OTS_GuildRanks_List $guildRanksList Ranks in this guild.
 * @property-read array $invites List of invited players.
 * @property-read array $requests List of players that requested invites.
 * @property-write IOTS_GuildAction $invitesDriver Invitations handler.
 * @property-write IOTS_GuildAction $requestsDriver Membership requests handler.
 * @tutorial POT/Guilds.pkg
 */
class OTS_Guild extends OTS_Row_DAO implements IteratorAggregate, Countable
{
/**
 * Guild data.
 *
 * @var array
 */
    private $data = array();

/**
 * Invites handler.
 *
 * @var IOTS_GuildAction
 */
    private $invites;

/**
 * Membership requests handler.
 *
 * @var IOTS_GuildAction
 */
    private $requests;

/**
 * Magic PHP5 method.
 *
 * Allows object serialisation.
 *
 * @return array List of properties that should be saved.
 */
    public function __sleep()
    {
        return array('data', 'invites', 'requests');
    }

/**
 * Creates clone of object.
 *
 * <p>
 * Copy of object needs to have different ID. Also invites and requests drivers are copied and assigned to object's copy.
 * </p>
 *
 * @version 0.1.3
 */
/*
    public function __clone()
    {
        unset($this->data['id']);

        if( isset($this->invites) )
        {
            $this->invites = clone $this->invites;
            $this->invites->__construct($this);
        }

        if( isset($this->requests) )
        {
            $this->requests = clone $this->requests;
            $this->requests->__construct($this);
        }
    }
*/
/**
 * Assigns invites handler.
 *
 * @param IOTS_GuildAction $invites Invites driver (don't pass it to clear driver).
 */
    public function setInvitesDriver(IOTS_GuildAction $invites = null)
    {
        $this->invites = $invites;
    }

/**
 * Assigns requests handler.
 *
 * @param IOTS_GuildAction $requests Membership requests driver (don't pass it to clear driver).
 */
    public function setRequestsDriver(IOTS_GuildAction $requests = null)
    {
        $this->requests = $requests;
    }

/**
 * Loads guild with given id.
 *
 * @version 0.0.5
 * @param int $id Guild's ID.
 * @throws PDOException On PDO operation error.
 */
    public function load($id)
    {
		$ownerid = 'ownerid';
		if($this->db->hasColumn('guilds', 'owner_id'))
			$ownerid = 'owner_id';

		$creationdata = 'creationdata';
		if($this->db->hasColumn('guilds', 'creationdate'))
			$creationdata = 'creationdate';
		else if($this->db->hasColumn('guilds', 'creation_time'))
			$creationdata = 'creation_time';

        // SELECT query on database
        $this->data = $this->db->query('SELECT `id`, `name`, `' . $ownerid . '` as `ownerid`, `' . $creationdata . '` as `creationdata` FROM `guilds` WHERE `id` = ' . (int) $id)->fetch();
    }

/**
 * Loads guild by it's name.
 *
 * @version 0.0.5
 * @param string $name Guild's name.
 * @throws PDOException On PDO operation error.
 */
    public function find($name)
    {
        // finds player's ID
        $id = $this->db->query('SELECT ' . $this->db->fieldName('id') . ' FROM ' . $this->db->tableName('guilds') . ' WHERE ' . $this->db->fieldName('name') . ' = ' . $this->db->quote($name) )->fetch();

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
 * Saves guild in database.
 *
 * <p>
 * If guild is not loaded to represent any existing group it will create new row for it.
 * </p>
 *
 * @version 0.0.5
 * @throws PDOException On PDO operation error.
 */
    public function save()
    {
		$ownerid = 'ownerid';
		if($this->db->hasColumn('guilds', 'owner_id'))
			$ownerid = 'owner_id';

		$creationdata = 'creationdata';
		if($this->db->hasColumn('guilds', 'creationdate'))
			$creationdata = 'creationdate';
		else if($this->db->hasColumn('guilds', 'creation_time'))
			$creationdata = 'creation_time';

        // updates existing guild
        if( isset($this->data['id']) )
        {
            // UPDATE query on database
            $this->db->exec('UPDATE `guilds` SET `name` = ' . $this->db->quote($this->data['name']) . ', `' . $ownerid . '` = ' . $this->data['ownerid'] . ', `' . $creationdata . '` = ' . $this->data['creationdata'] . ' WHERE `id` = ' . $this->data['id']);
        }
        // creates new guild
        else
        {
            // INSERT query on database
            $this->db->exec("INSERT INTO `guilds` (`name`, `" . $ownerid . "`, `" . $creationdata . "`, `description`) VALUES (" . $this->db->quote($this->data['name']) . ", " . $this->data['ownerid'] . ", " . $this->data['creationdata'] . ", '')");
            // ID of new group
            $this->data['id'] = $this->db->lastInsertId();
        }
    }

/**
 * Guild ID.
 *
 * @return int Guild ID.
 * @throws E_OTS_NotLoaded If guild is not loaded.
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
 * Guild name.
 *
 * @return string Guild's name.
 * @throws E_OTS_NotLoaded If guild is not loaded.
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
 * Sets guild's name.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Guild::save() save() method} to flush changed to database.
 * </p>
 *
 * @param string $name Name.
 */
    public function setName($name)
    {
        $this->data['name'] = (string) $name;
    }

/**
 * Returns owning player of this player.
 *
 * @version 0.1.0
 * @return OTS_Player Owning player.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function getOwner()
    {
        if( !isset($this->data['ownerid']) )
        {
            throw new E_OTS_NotLoaded();
        }

        $owner = new OTS_Player();
        $owner->load($this->data['ownerid']);
        return $owner;
    }

/**
 * Assigns guild to owner.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Guild::save() save() method} to flush changed to database.
 * </p>
 *
 * @param OTS_Player $owner Owning player.
 * @throws E_OTS_NotLoaded If given <var>$owner</var> object is not loaded.
 */
    public function setOwner(OTS_Player $owner)
    {
        $this->data['ownerid'] = $owner->getId();
    }

    public function hasMember(OTS_Player $player) {
        global $db;

        if(!$player || !$player->isLoaded()) {
            return false;
        }

	    $player_rank = $player->getRank();
	    if(!$player_rank->isLoaded()) {
	        return false;
	    }

	    foreach($this->getGuildRanksList() as $rank) {
		    if($rank->getId() == $player_rank->getId()) {
		        return true;
            }
        }

        return false;
    }
/**
 * Guild creation data.
 *
 * @return int Guild creation data.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 */
    public function getCreationData()
    {
        if( !isset($this->data['creationdata']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['creationdata'];
    }

/**
 * Sets guild creation data.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Guild::save() save() method} to flush changed to database.
 * </p>
 *
 * @param int $creationdata Guild creation data.
 */
    public function setCreationData($creationdata)
    {
        $this->data['creationdata'] = (int) $creationdata;
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
 * @version 0.0.8
 * @param string $field Field name.
 * @return string Field value.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function getCustomField($field)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        $value = $this->db->query('SELECT ' . $this->db->fieldName($field) . ' FROM ' . $this->db->tableName('guilds') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id'])->fetch();
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
 * @throws E_OTS_NotLoaded If guild is not loaded.
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

        $this->db->exec('UPDATE ' . $this->db->tableName('guilds') . ' SET ' . $this->db->fieldName($field) . ' = ' . $value . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);
    }

/**
 * @version 0.1.0
 * @return array List of ranks.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @deprecated 0.0.5 Use getGuildRanksList().
 */
    public function getGuildRanks()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        $guildRanks = array();

        foreach( $this->db->query('SELECT ' . $this->db->fieldName('id') . ' FROM ' . $this->db->tableName('guild_ranks') . ' WHERE ' . $this->db->fieldName('guild_id') . ' = ' . $this->data['id'])->fetchAll() as $guildRank)
        {
            // creates new object
            $object = new OTS_GuildRank();
            $object->load($guildRank['id']);
            $guildRanks[] = $object;
        }

        return $guildRanks;
    }

/**
 * List of ranks in guild.
 *
 * <p>
 * In difference to {@link OTS_Guild::getGuildRanks() getGuildRanks() method} this method returns filtered {@link OTS_GuildRanks_List OTS_GuildRanks_List} object instead of array of {@link OTS_GuildRank OTS_GuildRank} objects. It is more effective since OTS_GuildRanks_List doesn't perform all rows loading at once.
 * </p>
 *
 * <p>
 * Note: Returned object is only prepared, but not initialised. When using as parameter in foreach loop it doesn't matter since it will return it's iterator, but if you will wan't to execute direct operation on that object you will need to call {@link OTS_Base_List::rewind() rewind() method} first.
 * </p>
 *
 * @version 0.1.4
 * @since 0.0.5
 * @return OTS_GuildRanks_List List of ranks from current guild.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 */
    public function getGuildRanksList()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        // creates filter
        $filter = new OTS_SQLFilter();
        $filter->compareField('guild_id', (int) $this->data['id']);

        // creates list object
        $list = new OTS_GuildRanks_List();
        $list->setFilter($filter);

        return $list;
    }

/**
 * Returns list of invited players.
 *
 * <p>
 * OTServ and it's database doesn't provide such feature like guild invitations. In order to use this mechanism you have to write own {@link IOTS_GuildAction invitations drivers} and assign it using {@link OTS_Guild::setInvitesDriver() setInvitesDriver() method}.
 * </p>
 *
 * @return array List of invited players.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws E_OTS_NoDriver If there is no invites driver assigned.
 */
    public function listInvites()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        if( !isset($this->invites) )
        {
            throw new E_OTS_NoDriver();
        }

        // driven action
        return $this->invites->listRequests();
    }

/**
 * Invites player to guild.
 *
 * <p>
 * OTServ and it's database doesn't provide such feature like guild invitations. In order to use this mechanism you have to write own {@link IOTS_GuildAction invitations drivers} and assign it using {@link OTS_Guild::setInvitesDriver() setInvitesDriver() method}.
 * </p>
 *
 * @param OTS_Player Player to be invited.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws E_OTS_NoDriver If there is no invites driver assigned.
 */
    public function invite(OTS_Player $player)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        if( !isset($this->invites) )
        {
            throw new E_OTS_NoDriver();
        }

        // driven action
        return $this->invites->addRequest($player);
    }

/**
 * Deletes invitation for player to guild.
 *
 * <p>
 * OTServ and it's database doesn't provide such feature like guild invitations. In order to use this mechanism you have to write own {@link IOTS_GuildAction invitations drivers} and assign it using {@link OTS_Guild::setInvitesDriver() setInvitesDriver() method}.
 * </p>
 *
 * @param OTS_Player Player to be un-invited.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws E_OTS_NoDriver If there is no invites driver assigned.
 */
    public function deleteInvite(OTS_Player $player)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        if( !isset($this->invites) )
        {
            throw new E_OTS_NoDriver();
        }

        // driven action
        return $this->invites->deleteRequest($player);
    }

/**
 * Finalise invitation.
 *
 * <p>
 * OTServ and it's database doesn't provide such feature like guild invitations. In order to use this mechanism you have to write own {@link IOTS_GuildAction invitations drivers} and assign it using {@link OTS_Guild::setInvitesDriver() setInvitesDriver() method}.
 * </p>
 *
 * @param OTS_Player Player to be joined.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws E_OTS_NoDriver If there is no invites driver assigned.
 */
    public function acceptInvite(OTS_Player $player)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        if( !isset($this->invites) )
        {
            throw new E_OTS_NoDriver();
        }

        // driven action
        return $this->invites->submitRequest($player);
    }

/**
 * Returns list of players that requested membership.
 *
 * <p>
 * OTServ and it's database doesn't provide such feature like membership requests. In order to use this mechanism you have to write own {@link IOTS_GuildAction requests drivers} and assign it using {@link OTS_Guild::setInvitesDriver() setRequestsDriver() method}.
 * </p>
 *
 * @return array List of players.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws E_OTS_NoDriver If there is no requests driver assigned.
 */
    public function listRequests()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        if( !isset($this->requests) )
        {
            throw new E_OTS_NoDriver();
        }

        // driven action
        return $this->requests->listRequests();
    }

/**
 * Requests membership in guild for player player.
 *
 * <p>
 * OTServ and it's database doesn't provide such feature like membership requests. In order to use this mechanism you have to write own {@link IOTS_GuildAction requests drivers} and assign it using {@link OTS_Guild::setInvitesDriver() setRequestsDriver() method}.
 * </p>
 *
 * @param OTS_Player Player that requested membership.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws E_OTS_NoDriver If there is no requests driver assigned.
 */
    public function request(OTS_Player $player)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        if( !isset($this->requests) )
        {
            throw new E_OTS_NoDriver();
        }

        // driven action
        return $this->requests->addRequest($player);
    }

/**
 * Deletes request from player.
 *
 * <p>
 * OTServ and it's database doesn't provide such feature like membership requests. In order to use this mechanism you have to write own {@link IOTS_GuildAction requests drivers} and assign it using {@link OTS_Guild::setInvitesDriver() setRequestsDriver() method}.
 * </p>
 *
 * @param OTS_Player Player to be rejected.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws E_OTS_NoDriver If there is no requests driver assigned.
 */
    public function deleteRequest(OTS_Player $player)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        if( !isset($this->requests) )
        {
            throw new E_OTS_NoDriver();
        }

        // driven action
        return $this->requests->deleteRequest($player);
    }

/**
 * Accepts player.
 *
 * <p>
 * OTServ and it's database doesn't provide such feature like membership requests. In order to use this mechanism you have to write own {@link IOTS_GuildAction requests drivers} and assign it using {@link OTS_Guild::setInvitesDriver() setRequestsDriver() method}.
 * </p>
 *
 * @param OTS_Player Player to be accepted.
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws E_OTS_NoDriver If there is no requests driver assigned.
 */
    public function acceptRequest(OTS_Player $player)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        if( !isset($this->requests) )
        {
            throw new E_OTS_NoDriver();
        }

        // driven action
        return $this->requests->submitRequest($player);
    }

/**
 * Deletes guild.
 *
 * @version 0.0.5
 * @since 0.0.5
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function delete()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        // deletes row from database
        $this->db->exec('DELETE FROM ' . $this->db->tableName('guilds') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);

        // resets object handle
        unset($this->data['id']);
    }

/**
 * Returns ranks iterator.
 *
 * <p>
 * There is no need to implement entire Iterator interface since we have {@link OTS_GuildRanks_List ranks list class} for it.
 * </p>
 *
 * @version 0.0.5
 * @since 0.0.5
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws PDOException On PDO operation error.
 * @return Iterator List of ranks.
 */
    #[\ReturnTypeWillChange]
    public function getIterator()
    {
        return $this->getGuildRanksList();
    }

/**
 * Returns number of ranks within.
 *
 * @version 0.0.5
 * @since 0.0.5
 * @throws E_OTS_NotLoaded If guild is not loaded.
 * @throws PDOException On PDO operation error.
 * @return int Count of ranks.
 */
    public function count(): int
    {
        return $this->getGuildRanksList()->count();
    }

/**
 * Magic PHP5 method.
 *
 * @version 0.1.3
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

            case 'owner':
                return $this->getOwner();

            case 'creationData':
                return $this->getCreationData();

            case 'guildRanksList':
                return $this->getGuildRanksList();

            case 'invites':
                return $this->listInvites();

            case 'requests':
                return $this->listRequests();

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
 * @throws E_OTS_NotLoaded If passed parameter for owner field won't be loaded.
 * @throws OutOfBoundsException For non-supported properties.
 */
    public function __set($name, $value)
    {
        switch($name)
        {
            case 'name':
                $this->setName($value);
                break;

            case 'owner':
                $this->setOwner($value);
                break;

            case 'creationData':
                $this->setCreationData($value);
                break;

            case 'invitesDriver':
                $this->setInvitesDriver($value);
                break;

            case 'requestsDriver':
                $this->setRequestsDriver($value);
                break;

            default:
                throw new OutOfBoundsException();
        }
    }

/**
 * Returns string representation of object.
 *
 * <p>
 * If any display driver is currently loaded then it uses it's method. Else it returns guild name.
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
            return $ots->getDisplayDriver()->displayGuild($this);
        }

        return $this->getName();
    }
}

/**#@-*/

?>
