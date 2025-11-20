<?php

/**
 * @package POT
 * @version 0.1.5
 * @since 0.1.5
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * OTServ ban generic class. For particular purpose use {@link OTS_AccountBan OTS_AccountBan}, {@link OTS_PlayerBan OTS_PlayerBan} or {@link OTS_IPBan OTS_IPBan} classes respectively.
 *
 * @package POT
 * @version 0.1.5
 * @since 0.1.5
 * @property int $value Banned target identifier.
 * @property int $param Additional parameter (usualy IP mask).
 * @property bool $active Activation state.
 * @property int $expires Expiration time.
 * @property int $added Creation time.
 * @property int $adminId ID of admin who created ban.
 * @property string $command Additional comment.
 * @property int $reason Reason identifier.
 * @property-read bool $loaded Loaded state check.
 * @property-read int $id Row ID.
 */
abstract class OTS_Ban extends OTS_Row_DAO
{
/**
 * Ban data.
 *
 * @var array
 * @version 0.1.5
 * @since 0.1.5
 */
    private $data = array('param' => 0, 'active' => true, 'admin_id' => 0, 'comment' => '', 'reason' => 0);

/**
 * Loads ban with given id.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param int $id Ban ID.
 * @throws PDOException On PDO operation error.
 */
    public function load($id)
    {
        // SELECT query on database
        $this->data = $this->db->query('SELECT ' . $this->db->fieldName('id') . ', ' . $this->db->fieldName('type') . ', ' . $this->db->fieldName('value') . ', ' . $this->db->fieldName('param') . ', ' . $this->db->fieldName('active') . ', ' . $this->db->fieldName('expires') . ', ' . $this->db->fieldName('added') . ', ' . $this->db->fieldName('admin_id') . ', ' . $this->db->fieldName('comment') . ', ' . $this->db->fieldName('reason') . ' FROM ' . $this->db->tableName('bans') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . (int) $id)->fetch();
    }

/**
 * Checks if object is loaded.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return bool Load state.
 */
    public function isLoaded()
    {
        return isset($this->data['id']);
    }

/**
 * Saves ban in database.
 *
 * <p>
 * If object is not loaded to represent any existing ban it will create new row for it.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 * @throws PDOException On PDO operation error.
 */
    public function save()
    {
        // updates existing ban
        if( isset($this->data['id']) )
        {
            // UPDATE query on database
            $this->db->exec('UPDATE ' . $this->db->tableName('bans') . ' SET ' . $this->db->fieldName('type') . ' = ' . $this->data['type'] . ', ' . $this->db->fieldName('value') . ' = ' . $this->data['value'] . ', ' . $this->db->fieldName('param') . ' = ' . $this->data['param'] . ', ' . $this->db->fieldName('active') . ' = ' . (int) $this->data['active'] . ', ' . $this->db->fieldName('expires') . ' = ' . $this->data['expires'] . ', ' . $this->db->fieldName('added') . ' = ' . $this->data['added'] . ', ' . $this->db->fieldName('admin_id') . ' = ' . $this->data['admin_id'] . ', ' . $this->db->fieldName('comment') . ' = ' . $this->db->quote($this->data['comment']) . ', ' . $this->db->fieldName('reason') . ' = ' . $this->data['reason'] . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);
        }
        // creates new ban
        else
        {
            // INSERT query on database
            $this->db->exec('INSERT INTO ' . $this->db->tableName('bans') . ' (' . $this->db->fieldName('type') . ', ' . $this->db->fieldName('value') . ', ' . $this->db->fieldName('param') . ', ' . $this->db->fieldName('active') . ', ' . $this->db->fieldName('expires') . ', ' . $this->db->fieldName('added') . ', ' . $this->db->fieldName('admin_id') . ', ' . $this->db->fieldName('comment') . ', ' . $this->db->fieldName('reason') . ') VALUES (' . $this->data['type'] . ', ' . $this->data['value'] . ', ' . $this->data['param'] . ', ' . (int) $this->data['active'] . ', ' . $this->data['expires'] . ', ' . $this->data['added'] . ', ' . $this->data['admin_id'] . ', ' . $this->db->quote($this->data['comment']) . ', ' . $this->data['reason'] . ')');
            // ID of new ban
            $this->data['id'] = $this->db->lastInsertId();
        }
    }

/**
 * Ban ID.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return int Ban ID.
 * @throws E_OTS_NotLoaded If ban is not loaded.
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
 * Deletes ban.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @throws E_OTS_NotLoaded If ban is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function delete()
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        // deletes row from database
        $this->db->exec('DELETE FROM ' . $this->db->tableName('bans') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);

        // resets object handle
        unset($this->data['id']);
    }

/**
 * Banned target.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return int Target identifier.
 * @throws E_OTS_NotLoaded If ban is not loaded.
 */
    public function getValue()
    {
        if( !isset($this->data['value']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['value'];
    }

/**
 * Sets banned target.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Ban::save() save() method} to flush changed to database.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param int $value Banned target identifier.
 */
    public function setValue($value)
    {
        $this->data['value'] = (int) $value;
    }

/**
 * Additional parameter.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return int Parameter value (usualy used as IP mask).
 * @throws E_OTS_NotLoaded If ban is not loaded.
 */
    public function getParam()
    {
        if( !isset($this->data['param']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['param'];
    }

/**
 * Sets additional parameter.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Ban::save() save() method} to flush changed to database.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param int $param Parameter value (usualy used as IP mask).
 */
    public function setParam($param)
    {
        $this->data['param'] = (int) $param;
    }

/**
 * Activation state.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return bool Is ban active.
 * @throws E_OTS_NotLoaded If ban is not loaded.
 */
    public function isActive()
    {
        if( !isset($this->data['active']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['active'];
    }

/**
 * Activates ban.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Ban::save() save() method} to flush changed to database.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 */
    public function activate()
    {
        $this->data['active'] = true;
    }

/**
 * Deactivates ban.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Ban::save() save() method} to flush changed to database.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 */
    public function deactivate()
    {
        $this->data['active'] = false;
    }

/**
 * Expiration time.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return int Ban expiration time (0 - forever).
 * @throws E_OTS_NotLoaded If ban is not loaded.
 */
    public function getExpires()
    {
        if( !isset($this->data['expires']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['expires'];
    }

/**
 * Sets expiration time.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Ban::save() save() method} to flush changed to database.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param int $expires Ban expiration time (0 - forever).
 */
    public function setExpires($expires)
    {
        $this->data['expires'] = (int) $expires;
    }

/**
 * Banned time.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return int Ban creation time.
 * @throws E_OTS_NotLoaded If ban is not loaded.
 */
    public function getAdded()
    {
        if( !isset($this->data['added']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['added'];
    }

/**
 * Sets banned time.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Ban::save() save() method} to flush changed to database.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param int $added Ban creation time.
 */
    public function setAdded($added)
    {
        $this->data['added'] = (int) $added;
    }

/**
 * Ban creator.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return int ID of administrator who created ban entry.
 * @throws E_OTS_NotLoaded If ban is not loaded.
 */
    public function getAdminId()
    {
        if( !isset($this->data['admin_id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['admin_id'];
    }

/**
 * Sets ban creator.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Ban::save() save() method} to flush changed to database.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param int $adminId ID of administrator who created ban entry.
 */
    public function setAdminId($adminId)
    {
        $this->data['admin_id'] = (int) $adminId;
    }

/**
 * Explaination comment.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return string Ban description.
 * @throws E_OTS_NotLoaded If ban is not loaded.
 */
    public function getComment()
    {
        if( !isset($this->data['comment']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['comment'];
    }

/**
 * Sets explaination comment.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Ban::save() save() method} to flush changed to database.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param string $comment Ban description.
 */
    public function setComment($comment)
    {
        $this->data['comment'] = (string) $comment;
    }

/**
 * Ban reason.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return int Reason for which ban was created.
 * @throws E_OTS_NotLoaded If ban is not loaded.
 */
    public function getReason()
    {
        if( !isset($this->data['reason']) )
        {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['reason'];
    }

/**
 * Sets ban reason.
 *
 * <p>
 * This method only updates object state. To save changes in database you need to use {@link OTS_Ban::save() save() method} to flush changed to database.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param int $reason Reason for which ban was created.
 */
    public function setReason($reason)
    {
        $this->data['reason'] = (int) $reason;
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
 * @version 0.1.5
 * @since 0.1.5
 * @param string $field Field name.
 * @return string Field value.
 * @throws E_OTS_NotLoaded If ban is not loaded.
 * @throws PDOException On PDO operation error.
 */
    public function getCustomField($field)
    {
        if( !isset($this->data['id']) )
        {
            throw new E_OTS_NotLoaded();
        }

        $value = $this->db->query('SELECT ' . $this->db->fieldName($field) . ' FROM ' . $this->db->tableName('bans') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id'])->fetch();
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
 * @version 0.1.5
 * @since 0.1.5
 * @param string $field Field name.
 * @param mixed $value Field value.
 * @throws E_OTS_NotLoaded If account is not loaded.
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

        $this->db->exec('UPDATE ' . $this->db->tableName('bans') . ' SET ' . $this->db->fieldName($field) . ' = ' . $value . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);
    }

/**
 * Magic PHP5 method.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param string $name Property name.
 * @return mixed Property value.
 * @throws E_OTS_NotLoaded If ban is not loaded.
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

            case 'value':
                return $this->getValue();

            case 'param':
                return $this->getParam();

            case 'active':
                return $this->isActive();

            case 'expires':
                return $this->getExpires();

            case 'added':
                return $this->getAdded();

            case 'adminId':
                return $this->getAdminId();

            case 'comment':
                return $this->getComment();

            case 'reason':
                return $this->getReason();

            default:
                throw new OutOfBoundsException();
        }
    }

/**
 * Magic PHP5 method.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @param string $name Property name.
 * @param mixed $value Property value.
 * @throws OutOfBoundsException For non-supported properties.
 * @throws PDOException On PDO operation error.
 */
    public function __set($name, $value)
    {
        switch($name)
        {
            case 'value':
                $this->setValue($value);
                break;

            case 'param':
                $this->setParam($value);
                break;

            case 'active':
                if($value)
                {
                    $this->activate();
                }
                else
                {
                    $this->deactivate();
                }
                break;

            case 'expires':
                $this->setExpires($value);
                break;

            case 'added':
                $this->setAdded($value);
                break;

            case 'adminId':
                $this->setAdminId($value);
                break;

            case 'comment':
                $this->setComment($value);
                break;

            case 'reason':
                $this->setReason($value);
                break;

            default:
                throw new OutOfBoundsException();
        }
    }
}

?>
