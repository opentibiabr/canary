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
 * OTServ IP ban.
 * 
 * @package POT
 * @version 0.1.5
 * @since 0.1.5
 */
class OTS_IPBan extends OTS_Ban
{
/**
 * Ban data.
 * 
 * @var array
 * @version 0.1.5
 * @since 0.1.5
 */
    private $data = array('type' => POT::BAN_IP, 'param' => 0, 'active' => true, 'admin_id' => 0, 'comment' => '', 'reason' => 0);

/**
 * Loads IP ban with given id.
 * 
 * @version 0.1.5
 * @since 0.1.5
 * @param int $id Ban ID.
 * @throws PDOException On PDO operation error.
 */
    public function load($id)
    {
        // SELECT query on database
        $this->data = $this->db->query('SELECT ' . $this->db->fieldName('id') . ', ' . $this->db->fieldName('type') . ', ' . $this->db->fieldName('value') . ', ' . $this->db->fieldName('param') . ', ' . $this->db->fieldName('active') . ', ' . $this->db->fieldName('expires') . ', ' . $this->db->fieldName('added') . ', ' . $this->db->fieldName('admin_id') . ', ' . $this->db->fieldName('comment') . ', ' . $this->db->fieldName('reason') . ' FROM ' . $this->db->tableName('bans') . ' WHERE ' . $this->db->fieldName('type') . ' = ' . POT::BAN_IP . ' AND ' . $this->db->fieldName('id') . ' = ' . (int) $id)->fetch();
    }

/**
 * Loads IP ban by banned IP.
 * 
 * <p>
 * This method loads ban that matches given IP (including mask). To unban IP you should rather use {@link OTS_IPBan::load() load() method} to load exacly that ban that you are seeking for.
 * </p>
 * 
 * @version 0.1.5
 * @since 0.1.5
 * @param int $ip IP.
 * @throws PDOException On PDO operation error.
 */
    public function find($ip)
    {
        // SELECT query on database
        $this->data = $this->db->query('SELECT ' . $this->db->fieldName('id') . ', ' . $this->db->fieldName('type') . ', ' . $this->db->fieldName('value') . ', ' . $this->db->fieldName('param') . ', ' . $this->db->fieldName('active') . ', ' . $this->db->fieldName('expires') . ', ' . $this->db->fieldName('added') . ', ' . $this->db->fieldName('admin_id') . ', ' . $this->db->fieldName('comment') . ', ' . $this->db->fieldName('reason') . ' FROM ' . $this->db->tableName('bans') . ' WHERE ' . $this->db->fieldName('type') . ' = ' . POT::BAN_IP . ' AND ' . $this->db->fieldName('value') . ' & ' . $this->db->fieldName('param') . ' = ' . (int) $ip . ' & ' . $this->db->fieldName('param') )->fetch();
    }
}

?>
