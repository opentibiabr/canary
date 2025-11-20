<?php

/**#@+
 * @version 0.0.4
 * @since 0.0.4
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Guild action interface.
 * 
 * <p>
 * This insterface indicates that class can handle OTServ guild action.
 * </p>
 * 
 * <p>
 * You can use it for example to handle invites or membership requests.
 * </p>
 * 
 * <p>
 * If you want to serialise (for example save in session) your guild obejcts with assigned drivers you need to implement also __sleep() and __wakeup() methods in your drivers, as assigned drivers are also serialised.
 * </p>
 * 
 * @package POT
 */
interface IOTS_GuildAction
{
/**
 * Objects are initialized with a guild that they are assigned to.
 * 
 * It is recommeded that your implementations calls assignment functions of $guild to automaticly assign itself as action handler.
 * 
 * @param OTS_Guild $guild Guild that this driver is assigned to.
 */
    public function __construct(OTS_Guild $guild);

/**
 * List of saved pending actions.
 * 
 * @return array List of actions.
 */
    public function listRequests();
/**
 * Adds new request.
 * 
 * @param OTS_Player $player Player which is object of request.
 */
    public function addRequest(OTS_Player $player);
/**
 * Deletes request.
 * 
 * @param OTS_Player $player Player which is object of request.
 */
    public function deleteRequest(OTS_Player $player);
/**
 * Finalizes request.
 * 
 * @param OTS_Player $player Player which is object of request.
 */
    public function submitRequest(OTS_Player $player);
}

/**#@-*/

?>
