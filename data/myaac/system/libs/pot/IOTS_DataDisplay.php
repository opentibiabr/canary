<?php

/**#@+
 * @version 0.1.3
 * @since 0.1.3
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Display interface for non-database resources.
 * 
 * <p>
 * This way you can define low-level part of display logic to bind templates directly with POT objects.
 * </p>
 * 
 * @package POT
 */
interface IOTS_DataDisplay
{
/**
 * Displays house.
 * 
 * @param OTS_House $house House to be displayed.
 * @return string String representation.
 */
    public function displayHouse(OTS_House $house);
/**
 * Displays houses list.
 * 
 * @param OTS_Houses_List $housesList List to be displayed.
 * @return string String representation.
 */
    public function displayHousesList(OTS_Houses_List $housesList);
/**
 * Displays item types list.
 * 
 * @param OTS_ItemsList $itemsList Items list to be displayed.
 * @return string String representation.
 */
    public function displayItemsList(OTS_ItemsList $itemsList);
/**
 * Displays item type.
 * 
 * @param OTS_ItemType $itemType Type information.
 * @return string String representation.
 */
    public function displayItemType(OTS_ItemType $itemType);
/**
 * Displays monster.
 * 
 * @param OTS_Monster $monster Monster to be displayed.
 * @return string String representation.
 */
    public function displayMonster(OTS_Monster $monster);
/**
 * Displays monsters list.
 * 
 * @param OTS_MonstersList $monstersList List to be displayed.
 * @return string String representation.
 */
    public function displayMonstersList(OTS_MonstersList $monstersList);
/**
 * Displays OTBM map info.
 * 
 * @param OTS_OTBMFile $map Map to be displayed.
 * @return string String representation.
 */
    public function displayOTBMMap(OTS_OTBMFile $map);
/**
 * Displays spell information.
 * 
 * @param OTS_Spell $spell Spell to be displayed.
 * @return string String representation.
 */
    public function displaySpell(OTS_Spell $spell);
/**
 * Displays spells list.
 * 
 * @param OTS_GuildRanks_List $spellsList List to be displayed.
 * @return string String representation.
 */
    public function displaySpellsList(OTS_SpellsList $spellsList);
}

/**#@-*/

?>
