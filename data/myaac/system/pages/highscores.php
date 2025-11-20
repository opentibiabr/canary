<?php global $db, $config;
/**
 * Highscores
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Highscores';

if ($config['account_country'] && $config['highscores_country_box'])
    require SYSTEM . 'countries.conf.php';

$list = $_GET['list'] ?? '';
$_page = $_GET['page'] ?? 0;
$vocation = $_GET['vocation'] ?? null;

if (!is_numeric($_page) || $_page < 0 || $_page > PHP_INT_MAX) {
    $_page = 0;
}

$add_sql = '';
$config_vocations = $config['vocations'];

$normalized_vocations = array_map('strtolower', $config_vocations);
if (!array_search(strtolower($vocation), $normalized_vocations)) $vocation = "None";

if ($config['highscores_vocation_box'] && isset($vocation)) {
    foreach ($config['vocations'] as $id => $name) {
        if (strtolower($name) == $vocation) {
            $add_vocs = array($id);

            $i = $id + $config['vocations_amount'];
            while (isset($config['vocations'][$i])) {
                $add_vocs[] = $i;
                $i += $config['vocations_amount'];
            }

            $add_sql = 'AND `vocation` IN (' . implode(', ', $add_vocs) . ')';
            break;
        }
    }
}

define('SKILL_FRAGS', -1);
define('SKILL_BALANCE', -2);

$skill = POT::SKILL_LEVEL;
if (is_numeric($list)) {
    $list = (int)$list;
    if ($list >= POT::SKILL_FIRST && $list <= POT::SKILL__LAST)
        $skill = $list;
} else {
    switch ($list) {
        case 'fist':
            $skill = POT::SKILL_FIST;
            break;

        case 'club':
            $skill = POT::SKILL_CLUB;
            break;

        case 'sword':
            $skill = POT::SKILL_SWORD;
            break;

        case 'axe':
            $skill = POT::SKILL_AXE;
            break;

        case 'distance':
            $skill = POT::SKILL_DIST;
            break;

        case 'shield':
            $skill = POT::SKILL_SHIELD;
            break;

        case 'fishing':
            $skill = POT::SKILL_FISH;
            break;

        case 'level':
        case 'experience':
            $skill = POT::SKILL_LEVEL;
            break;

        case 'magic':
            $skill = POT::SKILL_MAGLEVEL;
            break;

        case 'frags':
            if ($config['highscores_frags'] && $config['otserv_version'] == TFS_03)
                $skill = SKILL_FRAGS;
            break;

        case 'balance':
            if ($config['highscores_balance'])
                $skill = SKILL_BALANCE;
            break;
    }
}

$promotion = '';
if ($db->hasColumn('players', 'promotion'))
    $promotion = ',promotion';

$online = '';
if ($db->hasColumn('players', 'online'))
    $online = ',online';

$deleted = 'deleted';
if ($db->hasColumn('players', 'deletion'))
    $deleted = 'deletion';

$outfit_addons = false;
$outfit = '';
if ($config['highscores_outfit']) {
    $outfit = ', lookbody, lookfeet, lookhead, looklegs, looktype';
    if ($db->hasColumn('players', 'lookaddons')) {
        $outfit .= ', lookaddons';
        $outfit_addons = true;
    }
}

$limit = $config['highscores_length'] ?? 30;
$limit_ = $limit + 1;
$offset = $_page * $limit;
if ($skill >= POT::SKILL_FIRST && $skill <= POT::SKILL_LAST) { // skills
    if ($db->hasColumn('players', 'skill_fist')) {// tfs 1.0
        $skill_ids = array(
            POT::SKILL_FIST => 'skill_fist',
            POT::SKILL_CLUB => 'skill_club',
            POT::SKILL_SWORD => 'skill_sword',
            POT::SKILL_AXE => 'skill_axe',
            POT::SKILL_DIST => 'skill_dist',
            POT::SKILL_SHIELD => 'skill_shielding',
            POT::SKILL_FISH => 'skill_fishing',
        );

        $skills = $db->query('SELECT accounts.country,players.id,players.name' . $online . ',level,vocation' . $promotion . $outfit . ', ' . $skill_ids[$skill] . ' as value FROM accounts,players WHERE players.id NOT IN (' . implode(', ', $config['highscores_ids_hidden']) . ') AND players.' . $deleted . ' = 0 AND players.group_id < ' . $config['highscores_groups_hidden'] . ' ' . $add_sql . ' AND accounts.id = players.account_id ORDER BY ' . $skill_ids[$skill] . ' DESC, players.name ASC LIMIT ' . $limit_ . ' OFFSET ' . $offset)->fetchAll();
    } else
        $skills = $db->query('SELECT accounts.country,players.id,players.name' . $online . ',value,level,vocation' . $promotion . $outfit . ' FROM accounts,players,player_skills WHERE players.id NOT IN (' . implode(', ', $config['highscores_ids_hidden']) . ') AND players.' . $deleted . ' = 0 AND players.group_id < ' . $config['highscores_groups_hidden'] . ' ' . $add_sql . ' AND players.id = player_skills.player_id AND player_skills.skillid = ' . $skill . ' AND accounts.id = players.account_id ORDER BY value DESC, count DESC, players.name ASC LIMIT ' . $limit_ . ' OFFSET ' . $offset)->fetchAll();
} else if ($skill == SKILL_FRAGS && $config['otserv_version'] == TFS_03) // frags
{
    $skills = $db->query('SELECT accounts.country, players.id,players.name' . $online . ',level,vocation' . $promotion . $outfit . ',COUNT(`player_killers`.`player_id`) as value' .
        ' FROM `accounts`, `players`, `player_killers` ' .
        ' WHERE players.id NOT IN (' . implode(', ', $config['highscores_ids_hidden']) . ') AND players.' . $deleted . ' = 0 AND players.group_id < ' . $config['highscores_groups_hidden'] . ' ' . $add_sql . ' AND players.id = player_killers.player_id AND accounts.id = players.account_id' .
        ' GROUP BY `player_id`' .
        ' ORDER BY value DESC' .
        ' LIMIT ' . $limit_ . ' OFFSET ' . $offset)->fetchAll();
} else if ($skill == SKILL_BALANCE) // balance
{
    $skills = $db->query('SELECT accounts.country, players.id,players.name' . $online . ',level,balance as value,vocation' . $promotion . $outfit . ' FROM accounts,players WHERE players.id NOT IN (' . implode(', ', $config['highscores_ids_hidden']) . ') AND players.' . $deleted . ' = 0 AND players.group_id < ' . $config['highscores_groups_hidden'] . ' ' . $add_sql . ' AND accounts.id = players.account_id ORDER BY value DESC, name ASC LIMIT ' . $limit_ . ' OFFSET ' . $offset)->fetchAll();
} else {
    if ($skill == POT::SKILL_MAGLEVEL) {
        $skills = $db->query('SELECT accounts.country, players.id,players.name' . $online . ',maglevel,level,vocation' . $promotion . $outfit . ' FROM accounts, players WHERE players.id NOT IN (' . implode(', ', $config['highscores_ids_hidden']) . ') AND players.' . $deleted . ' = 0 ' . $add_sql . ' AND players.group_id < ' . $config['highscores_groups_hidden'] . ' AND accounts.id = players.account_id ORDER BY maglevel DESC, manaspent DESC, players.name ASC LIMIT ' . $limit_ . ' OFFSET ' . $offset)->fetchAll();
    } else { // level
        $skills = $db->query('SELECT accounts.country, players.id,players.name' . $online . ',level,experience,vocation' . $promotion . $outfit . ' FROM accounts, players WHERE players.id NOT IN (' . implode(', ', $config['highscores_ids_hidden']) . ') AND players.' . $deleted . ' = 0 ' . $add_sql . ' AND players.group_id < ' . $config['highscores_groups_hidden'] . ' AND accounts.id = players.account_id ORDER BY level DESC, experience DESC, players.name ASC LIMIT ' . $limit_ . ' OFFSET ' . $offset)->fetchAll();
        $list = 'experience';
    }
}
?>
<div class="TableContainer">
    <div class="CaptionContainer">
        <div class="CaptionInnerContainer"><span class="CaptionEdgeLeftTop"
                                                 style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
            <span class="CaptionEdgeRightTop"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
            <span class="CaptionBorderTop"
                  style="background-image:url(https://static.tibia.com/images/global/content/table-headline-border.gif);"></span>
            <span class="CaptionVerticalLeft"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-vertical.gif);"></span>
            <div class="Text">Highscores Filter</div>
            <span class="CaptionVerticalRight"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-vertical.gif);"></span>
            <span class="CaptionBorderBottom"
                  style="background-image:url(https://static.tibia.com/images/global/content/table-headline-border.gif);"></span>
            <span class="CaptionEdgeLeftBottom"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
            <span class="CaptionEdgeRightBottom"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
        </div>
    </div>
    <table class="Table1" cellpadding="0" cellspacing="0">
        <tbody>
        <tr>
            <td>
                <div class="InnerTableContainer">
                    <table style="width:100%;">
                        <tbody>
                        <form method="post" action="">
                            <tr>
                                <td>World:</td>
                                <td><select name="world">
                                        <option value="0" selected>All Worlds</option>
                                    </select></td>
                            </tr>
                            <tr>
                                <td>Vocation:</td>
                                <td>
                                    <select name="profession">
                                        <option value="" <?= !$vocation ? 'selected' : '' ?>>(all)</option>
                                        <option value="knight" <?= $vocation == 'knight' ? 'selected' : '' ?>>
                                            Knights
                                        </option>
                                        <option value="paladin" <?= $vocation == 'paladin' ? 'selected' : '' ?>>
                                            Paladins
                                        </option>
                                        <option value="sorcerer" <?= $vocation == 'sorcerer' ? 'selected' : '' ?>>
                                            Sorcerers
                                        </option>
                                        <option value="druid" <?= $vocation == 'druid' ? 'selected' : '' ?>>
                                            Druids
                                        </option>
                                    </select>
                                </td>
                                <td>
                                    <div class="BigButton"
                                         style="background-image:url(https://static.tibia.com/images/global/buttons/button_blue.gif)">
                                        <div onmouseover="MouseOverBigButton(this);"
                                             onmouseout="MouseOutBigButton(this);">
                                            <div class="BigButtonOver"
                                                 style="background-image:url(https://static.tibia.com/images/global/buttons/button_blue_over.gif);"></div>
                                            <input class="BigButtonText" type="submit" value="Submit"></div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Category:</td>
                                <td>
                                    <select name="category">
                                        <option value="axe" <?= $list == 'axe' ? 'selected' : '' ?>>Axe Fighting
                                        </option>
                                        <option value="club" <?= $list == 'club' ? 'selected' : '' ?>>Club Fighting
                                        </option>
                                        <option value="distance" <?= $list == 'distance' ? 'selected' : '' ?>>Distance
                                            Fighting
                                        </option>
                                        <option
                                            value="experience" <?= $list == 'experience' || $limit == '' ? 'selected' : '' ?>>
                                            Experience Points
                                        </option>
                                        <option value="fishing" <?= $list == 'fishing' ? 'selected' : '' ?>>Fishing
                                        </option>
                                        <option value="fist" <?= $list == 'fist' ? 'selected' : '' ?>>Fist Fighting
                                        </option>
                                        <option value="magic" <?= $list == 'magic' ? 'selected' : '' ?>>Magic Level
                                        </option>
                                        <option value="shield" <?= $list == 'shield' ? 'selected' : '' ?>>Shielding
                                        </option>
                                        <option value="sword" <?= $list == 'sword' ? 'selected' : '' ?>>Sword Fighting
                                        </option>
                                    </select>
                                </td>
                            </tr>
                        </form>
                        </tbody>
                    </table>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<?php
$rank_world = $_POST['world'] ?? null;
$rank_category = $_POST['category'] ?? null;
if (!$rank_vocation = $_POST['profession'] ?? null) {
    if ($rank_category) {
        header('Location: ?highscores/' . $rank_category);
    }
} else {
    if ($rank_category) {
        header('Location: ?highscores/' . $rank_category . '/' . $rank_vocation);
    }
}
?>

<p><i>Skills displayed in the Highscores do not include any bonuses (loyalty, equipment etc.).</i></p>


<div class="TableContainer">
    <div class="CaptionContainer">
        <div class="CaptionInnerContainer">
            <span class="CaptionEdgeLeftTop"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
            <span class="CaptionEdgeRightTop"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
            <span class="CaptionBorderTop"
                  style="background-image:url(https://static.tibia.com/images/global/content/table-headline-border.gif);"></span>
            <span class="CaptionVerticalLeft"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-vertical.gif);"></span>
            <div class="Text">Highscores</div>
            <span class="CaptionVerticalRight"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-vertical.gif);"></span>
            <span class="CaptionBorderBottom"
                  style="background-image:url(https://static.tibia.com/images/global/content/table-headline-border.gif);"></span>
            <span class="CaptionEdgeLeftBottom"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
            <span class="CaptionEdgeRightBottom"
                  style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
        </div>
    </div>
    <table class="Table3" cellpadding="0" cellspacing="0">
        <tbody>
        <tr>
            <td>
                <div class="InnerTableContainer">
                    <table style="width:100%;">
                        <tbody>
                        <tr>
                            <td>
                                <div class="TableContentContainer">
                                    <table class="TableContent" width="100%" style="border:1px solid #faf0d7;">
                                        <tbody>
                                        <tr class="LabelH">
                                            <td style="width: 10%">Rank</td>
                                            <?php if ($config['highscores_outfit']) { ?>
                                                <td style="width: 10%">Outfit</td>
                                            <?php } ?>
                                            <td style="width: 30%">Name</td>
                                            <td style="width: 20%; text-align:right">Vocation</td>
                                            <td style="width: 10%; text-align: right">
                                                <?= ($skill != SKILL_FRAGS && $skill != SKILL_BALANCE ? 'Level' : ($skill == SKILL_BALANCE ? 'Balance' : 'Frags')); ?>
                                            </td>
                                            <?php if ($skill == POT::SKILL_LEVEL) { ?>
                                                <td style="width: 20%; text-align: right">Points</td>
                                            <?php } ?>
                                        </tr>
                                        <?php

                                        $show_link_to_next_page = false;
                                        $i = 0;

                                        $online_exist = false;
                                        if ($db->hasColumn('players', 'online'))
                                            $online_exist = true;

                                        $players = array();
                                        foreach ($skills as $player) {
                                            $players[] = $player['id'];
                                        }

                                        if ($db->hasTable('players_online') && count($players) > 0) {
                                            $query = $db->query('SELECT `player_id`, 1 FROM `players_online` WHERE `player_id` IN (' . implode(', ', $players) . ')')->fetchAll();
                                            foreach ($query as $t) {
                                                $is_online[$t['player_id']] = true;
                                            }
                                        }

                                        foreach ($skills as $player) {
                                            if (isset($is_online)) {
                                                $player['online'] = (isset($is_online[$player['id']]) ? 1 : 0);
                                            } else {
                                                if (!isset($player['online'])) {
                                                    $player['online'] = 0;
                                                }
                                            }

                                            if (++$i <= $limit) {
                                                if ($skill == POT::SKILL_MAGLEVEL)
                                                    $player['value'] = $player['maglevel'];
                                                else if ($skill == POT::SKILL_LEVEL)
                                                    $player['value'] = $player['level'];
                                                echo '
			<tr style="height: 64px;"><td>' . ($offset + $i) . '.</td>';
                                                if ($config['highscores_outfit'])
                                                    echo '<td><img style="position:absolute;margin-top:' . (in_array($player['looktype'], array(75, 266, 302)) ? '-15px;margin-left:5px' : '-45px;margin-left:-25px') . ';" src="' . $config['outfit_images_url'] . '?id=' . $player['looktype'] . ($outfit_addons ? '&addons=' . $player['lookaddons'] : '') . '&head=' . $player['lookhead'] . '&body=' . $player['lookbody'] . '&legs=' . $player['looklegs'] . '&feet=' . $player['lookfeet'] . '" alt="" /></td>';

                                                echo '
			<td>
				<a href="' . getPlayerLink($player['name'], false) . '">
					<span style="color: ' . ($player['online'] > 0 ? 'green' : 'red') . '">' . $player['name'] . '</span>
				</a>';
                                                if ($config['highscores_vocation']) {
                                                    if (isset($player['promotion'])) {
                                                        if ((int)$player['promotion'] > 0)
                                                            $player['vocation'] += ($player['promotion'] * $config['vocations_amount']);
                                                    }

                                                    $tmp = 'Unknown';
                                                    if (isset($config['vocations'][$player['vocation']])) {
                                                        $tmp = $config['vocations'][$player['vocation']];
                                                    }

                                                }
                                                echo '
			</td>
			<td style="text-align:right;">' . $tmp . '</td>
			<td>
				<div style="text-align:right;">' . $player['value'] . '</div>
			</td>';

                                                if ($skill == POT::SKILL_LEVEL)
                                                    echo '<td><div style="text-align:right">' . number_format($player['experience']) . '</div></td>';

                                                echo '</tr>';
                                            } else
                                                $show_link_to_next_page = true;
                                        }

                                        if (!$i) {
                                            $extra = ($config['highscores_outfit'] ? 1 : 0);
                                            ?>
                                            <tr bgcolor="<?= $config['darkborder'] ?>">
                                                <td colspan="<?= $skill == POT::SKILL_LEVEL ? 5 + $extra : 4 + $extra ?>">
                                                    No records yet.
                                                </td>
                                            </tr>
                                        <?php }
                                        //link to previous page if actual page is not first
                                        if ($_page > 0) {
                                            ?>
                                            <tr>
                                                <td colspan="2" width="100%" align="right" valign="bottom">
                                                    <a href="<?= getLink('highscores') . '/' . $list . (isset($vocation) ? '/' . $vocation : '') . '/' . ($_page - 1) ?>"
                                                       class="size_xxs">Previous Page</a>
                                                </td>
                                            </tr>
                                            <?php
                                        }
                                        //link to next page if any result will be on next page
                                        if ($show_link_to_next_page) {
                                            ?>
                                            <tr>
                                                <td colspan="2" width="100%" align="right" valign="bottom">
                                                    <a href="<?= getLink('highscores') . '/' . $list . (isset($vocation) ? '/' . $vocation : '') . '/' . ($_page + 1) ?>"
                                                       class="size_xxs">Next Page</a>
                                                </td>
                                            </TR>
                                            <?php
                                        }
                                        ?>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</div>
