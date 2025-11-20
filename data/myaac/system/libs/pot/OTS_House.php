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
 * Wrapper for house information.
 *
 * <p>
 * Unlike other {@link OTS_Base_DAO OTS_Base_DAO} child classes, OTS_House bases not only on database, but also loads some additional info from XML DOM node. It can't be load - it is always initialised with {@link http://www.php.net/manual/en/ref.dom.php DOMElement} object. Saving will only update database row - won't change XML data. Same about using {@link OTS_House::delete() delete() method}.
 * </p>
 *
 * @package POT
 * @version 0.1.3
 * @property OTS_Player $owner House owner.
 * @property int $paid Paid time.
 * @property int $warnings Warnings message.
 * @property-read int $id House ID.
 * @property-read string $name House name.
 * @property-read int $townId ID of town where house is located.
 * @property-read string $townName Name of town where house is located.
 * @property-read int $rent Rent cost.
 * @property-read int $size House size.
 * @property-read OTS_MapCoords $entry Entry point.
 * @property-read array $tiles List of tile points which house uses.
 */
class OTS_House extends OTS_Row_DAO
{
/**
 * House rent info.
 *
 * @var array
 */
    private $data = array();

	//private $columns = array('id', 'name', 'owner', 'paid', 'warnings', 'rent', 'beds');

/**
 * Information handler.
 *
 * @var DOMElement
 */
    private $element;

/**
 * Tiles list.
 *
 * @var array
 */
    private $tiles = array();

	public function load($id) {
		$this->data = $this->db->query('SELECT * FROM `houses` WHERE `id` = ' . $id )->fetch();
		foreach($this->data as $key => $value) {
			if(is_numeric($key)) {
				unset($this->data[$key]);
			}
		}
	}

    public function find($name)
    {
        // finds player's ID
        $id = $this->db->query('SELECT `id` FROM `houses` WHERE `name` = ' . $this->db->quote($name) )->fetch();

        // if anything was found
        if( isset($id['id']) )
        {
            $this->load($id['id']);
        }
    }

	public function setElement(DOMElement $element) {
		$this->element = $element;
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
        return array('data', 'element');
    }

/**
 * Saves info in database.
 *
 * @throws PDOException On PDO operation error.
 */
    public function save()
    {
        // inserts new record
        if( empty($this->data) )
        {
            $this->db->exec('INSERT INTO ' . $this->db->tableName('houses') . ' (' . $this->db->fieldName('id') . ', ' . $this->db->fieldName('owner') . ', ' . $this->db->fieldName('paid') . ', ' . $this->db->fieldName('warnings') . ') VALUES (' . $this->getId() . ', ' . $this->data['owner'] . ', ' . $this->data['paid'] . ', ' . $this->data['warnings'] . ')');
        }
        // updates previous one
        else
        {
			$this->db->update('houses', $this->data, array('id' => $this->getId()));
        }
    }

/**
 * Deletes house info from database.
 *
 * @throws PDOException On PDO operation error.
 */
    public function delete()
    {
        // deletes row from database
        $this->db->exec('DELETE FROM ' . $this->db->tableName('houses') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);

        // resets object handle
        $this->data = array();
    }

/**
 * Returns house's ID.
 *
 * @return int House ID.
 * @throws DOMException On DOM operation error.
 */
    public function getId()
    {
		if(isset($this->data['id'])) {
			return $this->data['id'];
		}

		if($this->element) {
			return $this->element->getAttribute('houseid');
		}
    }

/**
 * Return house's name.
 *
 * @return string House name.
 * @throws DOMException On DOM operation error.
 */
    public function getName()
    {
		if(isset($this->data['name'])) {
			return $this->data['name'];
		}

		if($this->element) {
			return $this->element->getAttribute('name');
		}
    }

/**
 * Returns town ID in which house is located.
 *
 * @return int Town ID.
 * @throws DOMException On DOM operation error.
 */
    public function getTownId()
    {
		if(isset($this->data['town_id'])) {
			return $this->data['town_id'];
		}
		if(isset($this->data['town'])) {
			return $this->data['town'];
		}
		if(isset($this->data['townid'])) {
			return $this->data['townid'];
		}

		if($this->element) {
			return (int) $this->element->getAttribute('townid');
		}

		return null;
    }


/**
 * Returns town name.
 *
 * @return string Town name.
 * @throws E_OTS_NotLoaded When map file is not loaded to fetch towns names.
 */
    public function getTownName()
    {
        return POT::getInstance()->getMap()->getTownName( $this->getTownId() );
    }

/**
 * Returns house rent cost.
 *
 * @return int Rent cost.
 * @throws DOMException On DOM operation error.
 */
    public function getRent()
    {
        return (int) $this->element->getAttribute('rent');
    }

/**
 * Returns house size.
 *
 * @return int House size.
 * @throws DOMException On DOM operation error.
 */
    public function getSize()
    {
        return (int) $this->element->getAttribute('size');
    }

/**
 * Returns entry position.
 *
 * @return OTS_MapCoords Entry coordinations on map.
 */
    public function getEntry()
    {
        return new OTS_MapCoords( (int) $this->element->getAttribute('entryx'), (int) $this->element->getAttribute('entryy'), (int) $this->element->getAttribute('entryz') );
    }

	public function getOwnerId() {
		if( isset($this->data['owner'])) {
			return $this->data['owner'];
		}

		return null;
	}
/**
 * Returns current house owner.
 *
 * @return OTS_Player|null Player that currently owns house (null if there is no owner).
 */
    public function getOwner()
    {
        if( isset($this->data['owner']) && $this->data['owner'] != 0)
        {
            $player = new OTS_Player();
            $player->load($this->data['owner']);
            return $player;
        }
        // not rent
        else
        {
            return null;
        }
    }

/**
 * Sets house owner.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_House::save() save() method} to flush changed to database.
 * </p>
 *
 * @param OTS_Player $player House owner to be set.
 * @throws E_OTS_NotLoaded If given <var>$player</var> object is not loaded.
 */
    public function setOwner(OTS_Player $player)
    {
        $this->data['owner'] = $player->getId();
    }

/**
 * Returns paid date.
 *
 * @return int|false Date timestamp until which house is rent (false if none).
 */
    public function getPaid()
    {
        if( isset($this->data['paid']) )
        {
            return $this->data['paid'];
        }
        // not rent
        else
        {
            return false;
        }
    }

/**
 * Sets paid date.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_House::save() save() method} to flush changed to database.
 * </p>
 *
 * @param int $paid Sets paid timestamp to passed one.
 */
    public function setPaid($paid)
    {
        $this->data['paid'] = $paid;
    }

/**
 * Returns house warnings.
 *
 * @version 0.1.2
 * @return int|false Warnings text (false if none).
 */
    public function getWarnings()
    {
        if( isset($this->data['warnings']) )
        {
            return $this->data['warnings'];
        }
        // not rent
        else
        {
            return false;
        }
    }

/**
 * Sets house warnings.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_House::save() save() method} to flush changed to database.
 * </p>
 *
 * @version 0.1.2
 * @param int $warnings Sets house warnings.
 */
    public function setWarnings($warnings)
    {
        $this->data['warnings'] = (int) $warnings;
    }

	public function getBid() {
		if(isset($this->data['bid'])) {
			return $this->data['bid'];
		}

		return null;
	}

	public function setBid($bid) {
		$this->data['bid'] = $bid;
	}

	public function getBidEnd() {
		if(isset($this->data['bid_end'])) {
			return $this->data['bid_end'];
		}

		return null;
	}

	public function setBidEnd($bid_end) {
		$this->data['bid_end'] = $bid_end;
	}

	public function getLastBid() {
		if(isset($this->data['last_bid'])) {
			return $this->data['last_bid'];
		}

		return null;
	}

	public function setLastBid($last_bid) {
		$this->data['last_bid'] = $last_bid;
	}

	public function getHighestBidder() {
		if(isset($this->data['highest_bidder'])) {
			return $this->data['highest_bidder'];
		}

		return null;
	}

	public function setHighestBidder($highest_bidder) {
		$this->data['highest_bidder'] = $highest_bidder;
	}
/**
 * Adds tile to house.
 *
 * @param OTS_MapCoords $tile Tile to be added.
 */
    public function addTile(OTS_MapCoords $tile)
    {
        $this->tiles[] = $tile;
    }

/**
 * Returns tiles list.
 *
 * <p>
 * This returns list of coords of tiles used by this house on map. It will succeed only if house object was created during map loading with houses file opened to assign loaded tiles.
 * </p>
 *
 * @return array List of tiles.
 */
    public function getTiles()
    {
        return $this->tiles;
    }

/**
 * Magic PHP5 method.
 *
 * @param string $name Property name.
 * @return mixed Property value.
 * @throws E_OTS_NotLoaded When atempt to read info about map while map not being loaded.
 * @throws OutOfBoundsException For non-supported properties.
 * @throws DOMException On DOM operation error.
 */
    public function __get($name)
    {
        switch($name)
        {
            case 'id':
                return $this->getId();

            case 'name':
                return $this->getName();

            case 'townId':
                return $this->getTownId();

            case 'townName':
                return $this->getTownName();

            case 'rent':
                return $this->getRent();

            case 'size':
                return $this->getSize();

            case 'entry':
                return $this->getEntry();

            case 'owner':
                return $this->getOwner();

            case 'paid':
                return $this->getPaid();

            case 'warnings':
                return $this->getWarnings();

            case 'tiles':
                return $this->getTiles();

            default:
                throw new OutOfBoundsException();
        }
    }

/**
 * Magic PHP5 method.
 *
 * @param string $name Property name.
 * @param mixed $value Property value.
 * @throws E_OTS_NotLoaded If passed parameter for owner field won't be loaded.
 * @throws OutOfBoundsException For non-supported properties.
 */
    public function __set($name, $value)
    {
        switch($name)
        {
            case 'owner':
                $this->setOwner($value);
                break;

            case 'paid':
                $this->setPaid($value);
                break;

            case 'warnings':
                $this->setWarnings($values);
                break;

            default:
                throw new OutOfBoundsException();
        }
    }

/**
 * Returns string representation of object.
 *
 * <p>
 * If any display driver is currently loaded then it uses it's method. Otherwise just returns house ID.
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
            return $ots->getDataDisplayDriver()->displayHouse($this);
        }

        return $this->getId();
    }
}

/**#@-*/

?>
