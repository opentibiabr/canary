<?php

/**#@+
 * @version 0.1.1
 * @since 0.1.1
 */

/**
 * @package POT
 * @version 0.1.5
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Toolbox for common operations.
 *
 * @package POT
 * @version 0.1.5
 */
class OTS_Toolbox
{
    /**
     * Calculates experience points needed for given level.
     *
     * @param int $level Level for which experience should be calculated.
     * @param int $experience Current experience points.
     * @return int Experience points for level.
     */
    public static function experienceForLevel($level, $experience = 0)
    {
        //return 50 * ($level - 1) * ($level * $level - 5 * $level + 12) / 3 - $experience;
        $level = $level - 1;
        return ((50 * $level * $level * $level) - (150 * $level * $level) + (400 * $level)) / 3;
    }

    /**
     * Finds out which level user have basing on his/her experience.
     *
     * <p>
     * PHP doesn't support complex numbers natively so solving third-level polynomials would be quite hard. Rather then doing this, this method iterates calculating experience for next levels until it finds one which requires enought experience we have. Because of that, for high experience values this function can take relatively long time to be executed.
     * </p>
     *
     * @param int $experience Current experience points.
     * @return int Experience level.
     */
    public static function levelForExperience($experience)
    {
        // default level
        $level = 1;

        // until we will find level which requires more experience then we have we will step to next
        while (self::experienceForLevel($level + 1) <= $experience) {
            $level++;
        }

        return $level;
    }

    /**
     * Calculates mana points needed for given magic level.
     *
     * @param $vocation
     * @param $magLevel
     * @return false|float|int
     */
    public static function getManaReqForMagicLevel($vocation, $magLevel)
    {
        if (!$vocation || $magLevel == 0) {
            return 0;
        }
        global $config;

        $xml = simplexml_load_file($config['data_path'] . 'XML/vocations.xml');
        if (!$xml) return '';
        $vocations = [];
        foreach ($xml->vocation as $voc) {
            $vocations[(string)$voc['id']] = (float)$voc['manamultiplier'];
        }
        return floor((1600 * pow($vocations[$vocation], $magLevel)));
    }

    /**
     * @return OTS_Players_List Filtered list.
     * @since 0.1.3
     * @version 0.1.5
     * @deprecated 0.1.5 Use OTS_PlayerBans_List.
     */
    public static function bannedPlayers()
    {
        // creates filter
        $filter = new OTS_SQLFilter();
        $filter->addFilter(new OTS_SQLField('type', 'bans'), POT::BAN_PLAYER);
        $filter->addFilter(new OTS_SQLField('active', 'bans'), 1);
        $filter->addFilter(new OTS_SQLField('value', 'bans'), new OTS_SQLField('id', 'players'));

        // selects only active bans
        $actives = new OTS_SQLFilter();
        $actives->addFilter(new OTS_SQLField('expires', 'bans'), 0);
        $actives->addFilter(new OTS_SQLField('time', 'bans'), time(), OTS_SQLFilter::OPERATOR_GREATER, OTS_SQLFilter::CRITERIUM_OR);
        $filter->addFilter($actives);

        // creates list and aplies filter
        $list = new OTS_Players_List();
        $list->setFilter($filter);
        return $list;
    }

    /**
     * @return OTS_Accounts_List Filtered list.
     * @since 0.1.3
     * @version 0.1.5
     * @deprecated 0.1.5 Use OTS_AccountBans_List.
     */
    public static function bannedAccounts()
    {
        // creates filter
        $filter = new OTS_SQLFilter();
        $filter->addFilter(new OTS_SQLField('type', 'bans'), POT::BAN_ACCOUNT);
        $filter->addFilter(new OTS_SQLField('active', 'bans'), 1);
        $filter->addFilter(new OTS_SQLField('value', 'bans'), new OTS_SQLField('id', 'accounts'));

        // selects only active bans
        $actives = new OTS_SQLFilter();
        $actives->addFilter(new OTS_SQLField('expires', 'bans'), 0);
        $actives->addFilter(new OTS_SQLField('time', 'bans'), time(), OTS_SQLFilter::OPERATOR_GREATER, OTS_SQLFilter::CRITERIUM_OR);
        $filter->addFilter($actives);

        // creates list and aplies filter
        $list = new OTS_Accounts_List();
        $list->setFilter($filter);
        return $list;
    }
}

/**#@-*/

?>
