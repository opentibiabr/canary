<?php

/**#@+
 * @version 0.0.8
 * @since 0.0.8
 */

/**
 * Code in this file bases on oryginal OTServ items loading C++ code (items.cpp, items.h).
 * 
 * @package POT
 * @version 0.1.3
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Item type info.
 * 
 * <p>
 * This class represents only item type information. You can't assign it to player. To do that, you need to create instance of this item type (you can use {@link OTS_ItemType::createItem() createItem() method} to do that).
 * </p>
 * 
 * @package POT
 * @version 0.1.3
 * @property int $clientId Client ID.
 * @property string $name Item name.
 * @property int $group Group.
 * @property int $type Item type.
 * @property-read int $id Item type ID.
 * @property-read array $attributesList List of all attributes.
 * @property-read bool $blocking Is item blocking move.
 * @property-read bool $hasHeight Does item have height.
 * @property-read bool $usable Is item usable.
 * @property-read bool $pickupable Is player able to pick it up.
 * @property-read bool $movable Can be moved.
 * @property-read bool $stackable Can be stacked.
 * @property-read bool $alwaysOnTop Is always on top of stack.
 * @property-read bool $readable Has readable sign.
 * @property-read bool $rotable Can be rotated.
 * @property-read bool $hangable Can be hang.
 * @property-read bool $vertical Is verticaly oriented.
 * @property-read bool $horizontal Is horizontaly oriented.
 * @property-write int $flags Special flags. 
 */
class OTS_ItemType
{
/**
 * No group speciffied.
 */
    const ITEM_GROUP_NONE = 0;
/**
 * Ground tile.
 */
    const ITEM_GROUP_GROUND = 1;
/**
 * Container.
 */
    const ITEM_GROUP_CONTAINER = 2;
/**
 * Weapon.
 */
    const ITEM_GROUP_WEAPON = 3;
/**
 * Ammunition.
 */
    const ITEM_GROUP_AMMUNITION = 4;
/**
 * Armor.
 */
    const ITEM_GROUP_ARMOR = 5;
/**
 * Rune.
 */
    const ITEM_GROUP_RUNE = 6;
/**
 * Teleport field.
 */
    const ITEM_GROUP_TELEPORT = 7;
/**
 * Magic field.
 */
    const ITEM_GROUP_MAGICFIELD = 8;
/**
 * Item that can store editable sign.
 */
    const ITEM_GROUP_WRITEABLE = 9;
/**
 * Key.
 */
    const ITEM_GROUP_KEY = 10;
/**
 * Splash effect.
 */
    const ITEM_GROUP_SPLASH = 11;
/**
 * Liquid thing.
 */
    const ITEM_GROUP_FLUID = 12;
/**
 * Door.
 */
    const ITEM_GROUP_DOOR = 13;
/**
 * Deprecated item.
 * 
 * @version 0.1.0
 * @since 0.1.0
 */
    const ITEM_GROUP_DEPRECATED = 14;

/**
 * No special type.
 */
    const ITEM_TYPE_NONE = 0;
/**
 * Depot locker.
 */
    const ITEM_TYPE_DEPOT = 1;
/**
 * Mailbox.
 */
    const ITEM_TYPE_MAILBOX = 2;
/**
 * Trash can.
 */
    const ITEM_TYPE_TRASHHOLDER = 3;
/**
 * Container.
 */
    const ITEM_TYPE_CONTAINER = 4;
/**
 * Door.
 */
    const ITEM_TYPE_DOOR = 5;
/**
 * Magic field.
 */
    const ITEM_TYPE_MAGICFIELD = 6;
/**
 * Teleport.
 * 
 * @version 0.1.0
 * @since 0.1.0
 */
    const ITEM_TYPE_TELEPORT = 7;

/**
 * Can block characters from walking.
 */
    const FLAG_BLOCK_SOLID = 1;
/**
 * BLOCK_PROJECTILE flag(?).
 */
    const FLAG_BLOCK_PROJECTILE = 2;
/**
 * Can block searching for path.
 */
    const FLAG_BLOCK_PATHFIND = 4;
/**
 * Does item rises stack height on it's field.
 */
    const FLAG_HAS_HEIGHT = 8;
/**
 * Can be used by players.
 */
    const FLAG_USEABLE = 16;
/**
 * Can be picked up by player.
 */
    const FLAG_PICKUPABLE = 32;
/**
 * Can be moved by player.
 */
    const FLAG_MOVEABLE = 64;
/**
 * Can be grouped with another items.
 */
    const FLAG_STACKABLE = 128;
/**
 * Changes floor under it.
 */
    const FLAG_FLOORCHANGEDOWN = 256;
/**
 * Changes floor north from it's position.
 */
    const FLAG_FLOORCHANGENORTH = 512;
/**
 * Changes floor east from it's position.
 */
    const FLAG_FLOORCHANGEEAST = 1024;
/**
 * Changes floor south from it's position.
 */
    const FLAG_FLOORCHANGESOUTH = 2048;
/**
 * Changes floor west from it's position.
 */
    const FLAG_FLOORCHANGEWEST = 4096;
/**
 * Is always over other items in stack.
 */
    const FLAG_ALWAYSONTOP = 8192;
/**
 * Has readable sign.
 */
    const FLAG_READABLE = 16384;
/**
 * Can be rotated by player.
 */
    const FLAG_ROTABLE = 32768;
/**
 * Can be hang(?).
 */
    const FLAG_HANGABLE = 65536;
/**
 * Is oriented verticaly.
 */
    const FLAG_VERTICAL = 131072;
/**
 * Is oriented horizontaly.
 */
    const FLAG_HORIZONTAL = 262144;
/**
 * Doesn't decay.
 */
    const FLAG_CANNOTDECAY = 524288;
/**
 * Can be read from distance.
 */
    const FLAG_ALLOWDISTREAD = 1048576;

/**
 * Item type (server) ID.
 * 
 * @var int
 */
    private $id;

/**
 * Item client mask ID.
 * 
 * @var int
 */
    private $clientId;

/**
 * Item name.
 * 
 * @var string
 */
    private $name;

/**
 * Attributes.
 * 
 * @var array
 */
    private $attributes;

/**
 * Item group.
 * 
 * @var int
 */
    private $group = self::ITEM_GROUP_NONE;

/**
 * Item type.
 * 
 * @var int
 */
    private $type = self::ITEM_TYPE_NONE;

/**
 * Type flags.
 * 
 * @var int
 */
    private $flags;

/**
 * Initializes new item type object.
 * 
 * @param int $id Server ID.
 */
    public function __construct($id)
    {
        $this->id = $id;
    }

/**
 * Magic PHP5 method.
 * 
 * <p>
 * Allows object importing from {@link http://www.php.net/manual/en/function.var-export.php var_export()}.
 * </p>
 * 
 * @version 0.1.3
 * @param array $properties List of object properties.
 */
    public static function __set_state($properties)
    {
        $object = new self($properties['id']);

        unset($properties['id']);

        // loads properties
        foreach($properties as $name => $value)
        {
            $object->$name = $value;
        }

        return $object;
    }

/**
 * Returns item type server ID.
 * 
 * @return int ID.
 */
    public function getId()
    {
        return $this->id;
    }

/**
 * Returns item type client ID.
 * 
 * @return int Cient ID.
 */
    public function getClientId()
    {
        return $this->clientId;
    }

/**
 * Sets client side ID.
 * 
 * @param int $clientId Client ID.
 */
    public function setClientId($clientId)
    {
        $this->clientId = $clientId;
    }

/**
 * Returns item name.
 * 
 * @return string Item type name.
 */
    public function getName()
    {
        return $this->name;
    }

/**
 * Sets item type name.
 * 
 * @param string $name Name.
 */
    public function setName($name)
    {
        $this->name = $name;
    }

/**
 * Checks if this type has given attribute.
 * 
 * @version 0.1.3
 * @since 0.1.3
 * @param string $attribyte Attribute name.
 * @return bool Attribute set state.
 */
    public function hasAttribute($name)
    {
        return isset($this->attributes[$name]);
    }

/**
 * Returns given attribute.
 * 
 * @version 0.1.3
 * @param string $attribyte Attribute name.
 * @return string Attribute value.
 * @throws OutOfBoundsException If not set.
 */
    public function getAttribute($name)
    {
        if( isset($this->attributes[$name]) )
        {
            return $this->attributes[$name];
        }

        throw new OutOfBoundsException();
    }

/**
 * Sets given attribute.
 * 
 * @param string $attribute Attribute name.
 * @param string $value Attribute value.
 */
    public function setAttribute($name, $value)
    {
        $this->attributes[$name] = $value;
    }

/**
 * Returns all attributes list.
 * 
 * @return array List of attributes.
 */
    public function getAttributesList()
    {
        return $this->attributes;
    }

/**
 * Returns group.
 * 
 * @return int Item group.
 */
    public function getGroup()
    {
        return $this->group;
    }

/**
 * Sets item group.
 * 
 * @param int $group Group.
 */
    public function setGroup($group)
    {
        $this->group = $group;
    }

/**
 * Returns item type.
 * 
 * @return int Item type.
 */
    public function getType()
    {
        return $this->type;
    }

/**
 * Sets item type.
 * 
 * @param int $type Type.
 */
    public function setType($type)
    {
        $this->type = $type;
    }

/**
 * Sets type flags.
 * 
 * @param int $flags Flags.
 */
    public function setFlags($flags)
    {
        $this->flags = $flags;
    }

/**
 * Checks if item is blocking.
 * 
 * @return bool Is item blocking.
 */
    public function isBlocking()
    {
        return ($this->flags & self::FLAG_BLOCK_SOLID) == self::FLAG_BLOCK_SOLID;
    }

/**
 * Checks if item has height.
 * 
 * @return bool Has item height.
 */
    public function hasHeight()
    {
        return ($this->flags & self::FLAG_HAS_HEIGHT) == self::FLAG_HAS_HEIGHT;
    }

/**
 * Checks if item is usable.
 * 
 * @return bool Is item usable.
 */
    public function isUsable()
    {
        return ($this->flags & self::FLAG_USEABLE) == self::FLAG_USEABLE;
    }

/**
 * Checks if item is pickupable.
 * 
 * @return bool Is item pickuable.
 */
    public function isPickupable()
    {
        return ($this->flags & self::FLAG_PICKUPABLE) == self::FLAG_PICKUPABLE;
    }

/**
 * Checks if item is movable.
 * 
 * @return bool Is item movable.
 */
    public function isMovable()
    {
        return ($this->flags & self::FLAG_MOVEABLE) == self::FLAG_MOVEABLE;
    }

/**
 * Checks if item is stackable.
 * 
 * @return bool Is item stackable.
 */
    public function isStackable()
    {
        return ($this->flags & self::FLAG_STACKABLE) == self::FLAG_STACKABLE;
    }

/**
 * Checks if item is always on top.
 * 
 * @return bool Is item always on top.
 */
    public function isAlwaysOnTop()
    {
        return ($this->flags & self::FLAG_ALWAYSONTOP) == self::FLAG_ALWAYSONTOP;
    }

/**
 * Checks if item is readable.
 * 
 * @return bool Is item readable.
 */
    public function isReadable()
    {
        return ($this->flags & self::FLAG_READABLE) == self::FLAG_READABLE;
    }

/**
 * Checks if item can be rotated.
 * 
 * @return bool Is item can be rotated.
 */
    public function isRotable()
    {
        return ($this->flags & self::FLAG_ROTABLE) == self::FLAG_ROTABLE;
    }

/**
 * Checks if item can be hanged.
 * 
 * @return bool Is item can be hanged.
 */
    public function isHangable()
    {
        return ($this->flags & self::FLAG_HANGABLE) == self::FLAG_HANGABLE;
    }

/**
 * Checks if item is vertical.
 * 
 * @return bool Is item vertical.
 */
    public function isVertical()
    {
        return ($this->flags & self::FLAG_VERTICAL) == self::FLAG_VERTICAL;
    }

/**
 * Checks if item is horizontal.
 * 
 * @return bool Is item horizontal.
 */
    public function isHorizontal()
    {
        return ($this->flags & self::FLAG_HORIZONTAL) == self::FLAG_HORIZONTAL;
    }

/**
 * Creates instance of this type.
 * 
 * @return OTS_Item Item instance.
 */
    public function createItem()
    {
        // container
        if($this->group == self::ITEM_GROUP_CONTAINER)
        {
            return new OTS_Container($this->id);
        }
        // normal item
        else
        {
            return new OTS_Item($this->id);
        }
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
            case 'id':
                return $this->getId();

            case 'clientId':
                return $this->getClientId();

            case 'name':
                return $this->getName();

            case 'group':
                return $this->getGroup();

            case 'type':
                return $this->getType();

            case 'attributesList':
                return $this->getAttributesList();

            case 'blocking':
                return $this->isBlocking();

            case 'hasHeight':
                return $this->hasHeight();

            case 'usable':
                return $this->isUsable();

            case 'pickupable':
                return $this->isPickupable();

            case 'movable':
                return $this->isMovable();

            case 'stackable':
                return $this->isStackable();

            case 'alwaysOnTop':
                return $this->isAlwaysOnTop();

            case 'readable':
                return $this->isReadable();

            case 'rotable':
                return $this->isRotable();

            case 'hangable':
                return $this->isHangable();

            case 'vertical':
                return $this->isVertical();

            case 'horizontal':
                return $this->isHorizontal();

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
 */
    public function __set($name, $value)
    {
        switch($name)
        {
            case 'flags':
                $this->setFlags($value);
                break;

            case 'clientId':
                $this->setClientId($value);
                break;

            case 'name':
                $this->setName($value);
                break;

            case 'group':
                $this->setGroup($value);
                break;

            case 'type':
                $this->setType($value);
                break;

            default:
                throw new OutOfBoundsException();
        }
    }

/**
 * Returns string representation of object.
 * 
 * <p>
 * If any display driver is currently loaded then it uses it's method. Otherwise just returns item ID.
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
            return $ots->getDataDisplayDriver()->displayItemType($this);
        }

        return $this->getId();
    }
}

/**#@-*/

?>
