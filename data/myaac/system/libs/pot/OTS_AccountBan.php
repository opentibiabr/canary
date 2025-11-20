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
 * OTServ account ban.
 * 
 * @package POT
 * @version 0.1.5
 * @since 0.1.5
 */
class OTS_AccountBan extends OTS_Ban
{
/**
 * Ban data.
 * 
 * @var array
 * @version 0.1.5
 * @since 0.1.5
 */
    private $data = array('type' => POT::BAN_ACCOUNT, 'param' => 0, 'active' => true, 'admin_id' => 0, 'comment' => '', 'reason' => 0);

/**
 * Loads account ban with given id.
 * 
 * @version 0.1.5
 * @since 0.1.5
 * @param int $id Ban ID.
 * @throws PDOException On PDO operation error.
 */
    public function load($id)
    {
        // SELECT query on database
        $this->data = $this->db->query('SELECT ' . $this->db->fieldName('id') . ', ' . $this->db->fieldName('type') . ', ' . $this->db->fieldName('value') . ', ' . $this->db->fieldName('param') . ', ' . $this->db->fieldName('active') . ', ' . $this->db->fieldName('expires') . ', ' . $this->db->fieldName('added') . ', ' . $this->db->fieldName('admin_id') . ', ' . $this->db->fieldName('comment') . ', ' . $this->db->fieldName('reason') . ' FROM ' . $this->db->tableName('bans') . ' WHERE ' . $this->db->fieldName('type') . ' = ' . POT::BAN_ACCOUNT . ' AND ' . $this->db->fieldName('id') . ' = ' . (int) $id)->fetch();
    }

/**
 * Loads account ban by banned account ID.
 * 
 * @version 0.1.5
 * @since 0.1.5
 * @param int $id Account's ID.
 * @throws PDOException On PDO operation error.
 */
    public function find($id)
    {
        // SELECT query on database
        $this->data = $this->db->query('SELECT ' . $this->db->fieldName('id') . ', ' . $this->db->fieldName('type') . ', ' . $this->db->fieldName('value') . ', ' . $this->db->fieldName('param') . ', ' . $this->db->fieldName('active') . ', ' . $this->db->fieldName('expires') . ', ' . $this->db->fieldName('added') . ', ' . $this->db->fieldName('admin_id') . ', ' . $this->db->fieldName('comment') . ', ' . $this->db->fieldName('reason') . ' FROM ' . $this->db->tableName('bans') . ' WHERE ' . $this->db->fieldName('type') . ' = ' . POT::BAN_ACCOUNT . ' AND ' . $this->db->fieldName('value') . ' = ' . (int) $id)->fetch();
    }
}

?>
