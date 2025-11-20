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
 * List of all bans.
 * 
 * @package POT
 * @version 0.1.5
 * @since 0.1.5
 */
class OTS_Bans_List extends OTS_Base_List
{
/**
 * Sets list parameters.
 * 
 * <p>
 * This method is called at object creation.
 * </p>
 * 
 * @version 0.1.5
 * @since 0.1.5
 */
    public function init()
    {
        $this->table = 'bans';
    }

/**
 * Overwrites generic query.
 * 
 * @version 0.1.5
 * @since 0.1.5
 * @throws PDOException On PDO operation error.
 */
    public function rewind()
    {
        $this->rows = $this->db->query( $this->getSQL() )->fetchAll();
    }

/**
 * Returns SQL query for SELECT.
 * 
 * @version 0.1.5
 * @since 0.1.5
 * @param bool $count Shows if the SQL should be generated for COUNT() variant.
 * @return string SQL query part.
 */
    protected function getSQL($count = false)
    {
        $fields = array();

        // fields list
        if($count)
        {
            $fields[] = 'COUNT(' . $this->db->tableName($this->table) . '.' . $this->db->fieldName('id') . ')';
        }
        else
        {
            $fields[] = $this->db->tableName('bans') . '.' . $this->db->fieldName('id') . ' AS ' . $this->db->fieldName('id');
            $fields[] = $this->db->tableName('bans') . '.' . $this->db->fieldName('type') . ' AS ' . $this->db->fieldName('type');
        }

        return $this->prepareSQL($fields);
    }

/**
 * Returns current row.
 * 
 * <p>
 * Returns object of class which handle single row representation. Object is initialised with ID of current position in result cursor.
 * </p>
 * 
 * @version 0.1.5
 * @since 0.1.5
 * @return OTS_Ban Current row.
 */
    public function current()
    {
        $row = current($this->rows);

        // selects correct class
        switch($row['type'])
        {
            case POT::BAN_IP:
                return new OTS_IPBan( (int) $id['id']);

            case POT::BAN_ACCOUNT:
                return new OTS_AccountBan( (int) $id['id']);

            case POT::BAN_PLAYER:
                return new OTS_PlayerBan( (int) $id['id']);
        }
    }
}

?>
