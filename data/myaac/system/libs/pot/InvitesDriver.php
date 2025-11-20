<?php
/*
    This file is part of OTSCMS (http://www.otscms.com/) project.

    Copyright (C) 2005 - 2008 Wrzasq (wrzasq@gmail.com)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

/*
    POT guilds invites driver.
*/

class InvitesDriver implements IOTS_GuildAction
{
    // assigned guild
    private $guild;
	
    // database
    private $db;
	
    // initializes driver
    public function __construct(OTS_Guild $guild)
    {
        $this->guild = $guild;
        $this->db = POT::getInstance()->getDBHandle();
        $this->guild->invitesDriver = $this;
    }

    // returns all invited players to current guild
    public function listRequests()
    {
        $invites = array();
        foreach( $this->db->query('SELECT ' . $this->db->fieldName('player_id') . ' FROM ' . $this->db->tableName('guild_invites') . ' WHERE ' . $this->db->fieldName('guild_id') . ' = '.$this->db->quote($this->guild->id)) as $invite)
        {
            $player = new OTS_Player();
            $player->load($invite['player_id']);
            $invites[] = $player;
        }
        return $invites;
    }

    // invites player to current guild
    public function addRequest(OTS_Player $player)
    {
        $extra_keys = $extra_values = '';
        if($this->db->hasColumn('guild_invites', 'date')) {
            $extra_keys = ', `date`';
            $extra_values = ', '.$this->db->quote(time());
        }
        $this->db->query('INSERT INTO `guild_invites` (`player_id`, `guild_id`' . $extra_keys . ') VALUES ('.$this->db->quote($player->getId()).', '.$this->db->quote($this->guild->id). $extra_values . ')');
    }

    // un-invites player
    public function deleteRequest(OTS_Player $player)
    {
        $this->db->query('DELETE FROM ' . $this->db->tableName('guild_invites') . ' WHERE ' . $this->db->fieldName('player_id') . ' = '.$this->db->quote($player->getId()).' AND ' . $this->db->fieldName('guild_id') . ' = '.$this->db->quote($this->guild->id));
    }

    // commits invitation
    public function submitRequest(OTS_Player $player)
    {
        $rank = null;

        // finds normal member rank
        foreach($this->guild as $guildRank)
        {
            if($guildRank->level == 1)
            {
                $rank = $guildRank;
                break;
            }
        }
		if(empty($rank)) {
		$rank = new OTS_GuildRank();
		$rank->setGuild($this->guild);
		$rank->setName('New Members');
		$rank->setLevel(1);
		$rank->save();
		}
        $player->setRank($rank);
        $player->save();

        // clears invitation
        $this->deleteRequest($player);
    }
}

?>
