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
 * List of IP bans.
 * 
 * @package POT
 * @version 0.1.5
 * @since 0.1.5
 */
class OTS_IPBans_List extends OTS_Bans_List
{
/**
 * Initializes list with IP bans filtering.
 * 
 * @version 0.1.5
 * @since 0.1.5
 */
    public function __construct()
    {
        parent::__construct();

        // filters only account bans
        $filter = new OTS_SQLFilter();
        $filter->addFilter( new OTS_SQLField('type', 'bans'), POT::BAN_IP);
        $this->setFilter($filter);
    }
}

?>
