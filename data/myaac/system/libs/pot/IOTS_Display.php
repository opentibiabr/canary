<?php

/**#@+
 * @version 0.1.0
 * @since 0.1.0
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Display interface.
 * 
 * <p>
 * This way you can define low-level part of display logic to bind templates directly with POT objects.
 * </p>
 * 
 * @package POT
 */
interface IOTS_Display
{
/**
 * Displays player.
 * 
 * @param OTS_Player $player Player to be displayed.
 * @return string String representation.
 */
    public function displayPlayer(OTS_Player $player);
/**
 * Displays players list.
 * 
 * @param OTS_Players_List $playersList List to be displayed.
 * @return string String representation.
 */
    public function displayPlayersList(OTS_Players_List $playersList);
/**
 * Displays account.
 * 
 * @param OTS_Account $account Account to be displayed.
 * @return string String representation.
 */
    public function displayAccount(OTS_Account $account);
/**
 * Displays accounts list.
 * 
 * @param OTS_Accounts_List $accountsList List to be displayed.
 * @return string String representation.
 */
    public function displayAccountsList(OTS_Accounts_List $accountList);
/**
 * Displays guild.
 * 
 * @param OTS_Guild $guild Guild to be displayed.
 * @return string String representation.
 */
    public function displayGuild(OTS_Guild $guild);
/**
 * Displays guilds list.
 * 
 * @param OTS_Guilds_List $guildsList List to be displayed.
 * @return string String representation.
 */
    public function displayGuildsList(OTS_Guild_List $guildList);
/**
 * Displays group.
 * 
 * @param OTS_Group $group Group to be displayed.
 * @return string String representation.
 */
    public function displayGroup(OTS_Group $group);
/**
 * Displays groups list.
 * 
 * @param OTS_Groups_List $groupsList List to be displayed.
 * @return string String representation.
 */
    public function displayGroupsList(OTS_Groups_List $groupsList);
/**
 * Displays rank.
 * 
 * @param OTS_GuildRank $guildRank Rank to be displayed.
 * @return string String representation.
 */
    public function displayGuildRank(OTS_GuildRank $guildRank);
/**
 * Displays guild ranks list.
 * 
 * @param OTS_GuildRanks_List $guildRanksList List to be displayed.
 * @return string String representation.
 */
    public function displayGuildRanksList(OTS_GuildRanks_List $guildRanksList);
}

/**#@-*/

?>
