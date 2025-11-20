<style>
    .progress {
        display: -ms-flexbox;
        display: flex;
        height: 1rem;
        overflow: hidden;
        font-size: .75rem;
        background-color: #e9ecef;
        border-radius: 0.25rem;
    }

    .progress {
        height: 18px;
        margin-bottom: 0;
        border: 1px solid;
    }

    .progress-bar {
        font-size: 11px;
        line-height: 16px;
    }

    .progress-bar {
        display: -ms-flexbox;
        display: flex;
        -ms-flex-align: center;
        align-items: center;
        -ms-flex-pack: center;
        justify-content: center;
        color: #fff;
        background-color: #007bff;
    }

    .bg-danger {
        background-color: #dc3545 !important;
    }

    .bg-default {
        background-color: #007bff;
    }

    .bg-success {
        background-color: #28a745 !important;
    }

    .btn_clipboard {
        border: 0;
        padding: 7px 5px;
        font-size: 10px;
        position: absolute;
        right: 22px;
        margin-top: -12px;
        background-color: #5f4d41;
        color: #fff;
        cursor: pointer;
    }

    .btn_clipboard:hover {
        background-color: #fff;
        color: #007bff;
    }

    .input_clipboard {
        border-radius: 0.3rem;
        border: 0;
        padding: 5px;
    }
</style>

<?php global $db, $config, $template_path, $twig, $achievements ?>
<?php
/**
 * Characters
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Characters';

require_once SYSTEM . 'item.php';

$groups = new OTS_Groups_List();
function generate_search_form($autofocus = false)
{
    global $config, $twig;
    return $twig->render('characters.form.html.twig', array(
        'link' => getLink('characters'),
        'autofocus' => $autofocus
    ));
}

function retrieve_former_name($name)
{
    global $oldName, $db;

    if ($db->hasTable('player_namelocks') && $db->hasColumn('player_namelocks', 'name')) {
        $newNameSql = $db->query('SELECT `name`, `new_name` FROM `player_namelocks` WHERE `name` = ' . $db->quote($name));
        if ($newNameSql->rowCount() > 0) // namelocked
        {
            $newNameSql = $newNameSql->fetch();
            $oldName = ' (<small><b>Former name:</b> ' . $newNameSql['name'] . '</small>)';
            return $newNameSql['new_name'];
        }
    }

    return '';
}

$name = '';
if (isset($_REQUEST['name']))
    $name = urldecode(stripslashes(ucwords(strtolower($_REQUEST['name']))));

if (empty($name)) {
    $tmp_link = getPlayerLink($name);
    echo generate_search_form(true);
    return;
}

$name = str_replace('/', '', $name);

$oldName = '';

$player = new OTS_Player();
$player->find($name);
if (!$player->isLoaded()) {
    $tmp_zmienna = "";
    $tmp_name = retrieve_former_name($name);
    while (!empty($tmp_name)) {
        $tmp_zmienna = $tmp_name;
        $tmp_name = retrieve_former_name($tmp_zmienna);
    }

    if (!empty($tmp_zmienna))
        $player->find($tmp_zmienna);
}

if ($player->isLoaded() && !$player->isDeleted()) {
    $title = $player->getName() . ' - ' . $title;
    $account = $player->getAccount();
    $rows = 0;
    $hidden = $player->isHidden();

    if ($config['characters']['outfit'])
        $outfit = $config['outfit_images_url'] . '?id=' . $player->getLookType() . ($db->hasColumn('players', 'lookaddons') ? '&addons=' . $player->getLookAddons() : '') . '&head=' . $player->getLookHead() . '&body=' . $player->getLookBody() . '&legs=' . $player->getLookLegs() . '&feet=' . $player->getLookFeet();

    $flag = '';
    if ($config['account_country']) {
        $flag = getFlagImage($account->getCountry());
        $country = strtoupper($account->getCountry());
    }

    $player_sex = 'Unknown';
    if (isset($config['genders'][$player->getSex()]))
        $player_sex = strtolower($config['genders'][$player->getSex()]);

    $marital_status = 'single';
    $marriage_id = $player->getMarriage();
    if ($marriage_id > 0) {
        $marriage = new OTS_Player();
        $marriage->load($player->getMarriage(), array('id', 'name'), false);
        if ($marriage->isLoaded()) {
            $marital_status = 'married to ' . getPlayerLink($marriage->getName());
        }
    }


    $player_HealthCurrent = $player->getHealth();
    $player_HealthMax = $player->getHealthMax();
    $percent_Health = ($player_HealthCurrent / $player_HealthMax) * 100;
    $percent_Health = number_format($percent_Health, 0, '.', '');

    $player_ManaMax = $player->getManaMax();
    $player_ManaCurrent = $player->getMana();
    $percent_Mana = ($player_ManaCurrent / $player_ManaMax) * 100;
    $percent_Mana = number_format($percent_Mana, 0, '.', '');

    $player_cap = $player->getCap();
    $player_soul = $player->getSoul();
    $player_exp = $player->getExperience();

    $frags_enabled = $db->hasTable('player_killers') && $config['characters']['frags'];
    $frags_count = 0;
    if ($frags_enabled) {
        $query = $db->query(
            'SELECT COUNT(`player_id`) as `frags`' .
            'FROM `player_killers`' .
            'WHERE `player_id` = ' . $player->getId() . ' ' .
            'GROUP BY `player_id`' .
            'ORDER BY COUNT(`player_id`) DESC');

        if ($query->rowCount() > 0) {
            $query = $query->fetch();
            $frags_count = $query['frags'];
        }
    }

    $town_field = 'town';
    if ($db->hasColumn('houses', 'town_id'))
        $town_field = 'town_id';
    else if ($db->hasColumn('houses', 'townid'))
        $town_field = 'townid';
    else if (!$db->hasColumn('houses', 'town'))
        $town_field = false;

    if ($db->hasColumn('houses', 'name')) {
        $house = $db->query('SELECT `id`, `paid`, `name`' . ($town_field != false ? ', `' . $town_field . '` as `town`' : '') . ' FROM `houses` WHERE `owner` = ' . $player->getId())->fetch();
        if (isset($house['id'])) {
            $add = '';
            if ($house['paid'] > 0)
                $add = ' is paid until ' . date("M d Y", $house['paid']);
        }
    }

    $rank_of_player = $player->getRank();
    if ($rank_of_player->isLoaded()) {
        $guild = $rank_of_player->getGuild();
        if ($guild->isLoaded()) {
            $guild_name = $guild->getName();
        }
    }

    $comment = $player->getComment();

    if ($config['characters']['skills']) {
        if ($db->hasColumn('players', 'skill_fist')) {// tfs 1.0+
            $skills_db = $db->query('SELECT `maglevel`, `skill_fist`, `skill_club`, `skill_sword`, `skill_axe`, `skill_dist`, `skill_shielding`, `skill_fishing` FROM `players` WHERE `id` = ' . $player->getId())->fetch();

            $skill_ids = array(
                POT::SKILL_MAGIC => 'maglevel',
                POT::SKILL_FIST => 'skill_fist',
                POT::SKILL_CLUB => 'skill_club',
                POT::SKILL_SWORD => 'skill_sword',
                POT::SKILL_AXE => 'skill_axe',
                POT::SKILL_DIST => 'skill_dist',
                POT::SKILL_SHIELD => 'skill_shielding',
                POT::SKILL_FISH => 'skill_fishing',
            );

            $skills = array();
            foreach ($skill_ids as $skillid => $field_name) {
                $skills[] = array('skillid' => $skillid, 'value' => $skills_db[$field_name]);
            }
        } else {
            $skills_db = $db->query('SELECT `skillid`, `value` FROM `player_skills` WHERE `player_id` = ' . $player->getId() . ' LIMIT 7');
            $skills = $skills_db->fetchAll();
        }

        foreach ($skills as &$skill) {
            $skill['name'] = getSkillName($skill['skillid']);
        }
    }

    $quests_enabled = $config['characters']['quests'] && !empty($config['quests']);
    if ($quests_enabled) {
        $quests = $config['quests'];
        $sql_query_in = '';
        $i = 0;
        foreach ($quests as $quest_name => $quest_storage) {
            if ($i != 0)
                $sql_query_in .= ', ';

            $sql_query_in .= $quest_storage;
            $i++;
        }

        $storage_sql = $db->query('SELECT `key`, `value` FROM `player_storage` WHERE `player_id` = ' . $player->getId() . ' AND `key` IN (' . $sql_query_in . ')');
        $player_storage = array();
        foreach ($storage_sql as $storage)
            $player_storage[$storage['key']] = $storage['value'];

        foreach ($quests as &$storage) {
            $storage = isset($player_storage[$storage]) && $player_storage[$storage] > 0;
        }
        unset($storage);
    }

    if ($config['characters']['equipment'] && $db->hasTableAndColumns('player_items', ['pid', 'sid', 'itemtype'])) {
        $equipment = [];
        $empty_slots = array("", "no_helmet", "no_necklace", "no_backpack", "no_armor", "no_handleft", "no_handright", "no_legs", "no_boots", "no_ring", "no_ammo");
        if ($hidden) {
            for ($i = 1; $i <= 10; $i++) {
                $equipment[$i] = '<img src="images/items/' . $empty_slots[$i] . '.gif" width="40" height="40" border="0" alt="hidden" />';
            }
        } else {
            global $db;
            $eq_sql = $db->query('SELECT `pid`, `itemtype` FROM player_items WHERE player_id = ' . $player->getId() . ' AND (`pid` >= 1 and `pid` <= 10)');
            foreach ($eq_sql as $eq)
                $equipment[$eq['pid']] = $eq['itemtype'];

            for ($i = 0; $i <= 10; $i++) {
                if (!isset($equipment[$i]) || $equipment[$i] == 0)
                    $equipment[$i] = $empty_slots[$i];
            }

            for ($i = 1; $i < 11; $i++) {
                if (Validator::number($equipment[$i]))
                    $equipment[$i] = getItemImage($equipment[$i]);
                else
                    $equipment[$i] = '<img src="images/items/' . $equipment[$i] . '.gif" width="40" height="40" border="0" alt=" ' . $equipment[$i] . '" />';
            }

            $skulls = array(
                1 => 'yellow_skull',
                2 => 'green_skull',
                3 => 'white_skull',
                4 => 'red_skull',
                5 => 'black_skull'
            );
        }
    }

    $dead_add_content = '';
    $deaths = array();
    if ($db->hasTable('killers')) {
        $player_deaths = $db->query('SELECT `id`, `date`, `level` FROM `player_deaths` WHERE `player_id` = ' . $player->getId() . ' ORDER BY `date` DESC LIMIT 0,10;')->fetchAll();
        if (count($player_deaths)) {
            $number_of_rows = 0;
            foreach ($player_deaths as $death) {
                $killers = $db->query("SELECT environment_killers.name AS monster_name, players.name AS player_name, players.deleted AS player_exists FROM killers LEFT JOIN environment_killers ON killers.id = environment_killers.kill_id
LEFT JOIN player_killers ON killers.id = player_killers.kill_id LEFT JOIN players ON players.id = player_killers.player_id
WHERE killers.death_id = '" . $death['id'] . "' ORDER BY killers.final_hit DESC, killers.id ASC")->fetchAll();

                $description = '';
                $i = 0;
                $count = count($killers);
                foreach ($killers as $killer) {
                    $i++;
                    if ($killer['player_name'] != "") {
                        if ($i == 1)
                            $description .= "Killed at level <b>" . $death['level'] . "</b>";
                        else if ($i == $count)
                            $description .= " and";
                        else
                            $description .= ",";

                        $description .= " by ";
                        if ($killer['monster_name'] != "")
                            $description .= $killer['monster_name'] . " summoned by ";

                        if ($killer['player_exists'] == 0)
                            $description .= getPlayerLink($killer['player_name']);
                        else
                            $description .= $killer['player_name'];
                    } else {
                        if ($i == 1)
                            $description .= "Died at level <b>" . $death['level'] . "</b>";
                        else if ($i == $count)
                            $description .= " and";
                        else
                            $description .= ",";

                        $description .= " by " . $killer['monster_name'];
                    }
                }

                $deaths[] = array('time' => $death['date'], 'description' => $description . '.');
            }
        }
    } else if ($db->hasTableAndColumns('player_deaths', ['time', 'level', 'killed_by', 'is_player'])) {
        $mostdamage = '';
        if ($db->hasColumn('player_deaths', 'mostdamage_by'))
            $mostdamage = ', `mostdamage_by`, `mostdamage_is_player`, `unjustified`, `mostdamage_unjustified`';
        $deaths_db = $db->query('SELECT
				`player_id`, `time`, `level`, `killed_by`, `is_player`' . $mostdamage . '
				FROM `player_deaths`
				WHERE `player_id` = ' . $player->getId() . ' ORDER BY `time` DESC LIMIT 10;')->fetchAll();

        if (count($deaths_db)) {
            $number_of_rows = 0;
            foreach ($deaths_db as $death) {
                $lasthit = ($death['is_player']) ? getPlayerLink($death['killed_by']) : $death['killed_by'];
                $description = 'Killed at level ' . $death['level'] . ' by ' . $lasthit;
                if ($death['unjustified']) {
                    $description .= ' <span style="color: red; font-style: italic;">(unjustified)</span>';
                }

                $mostdmg = ($death['mostdamage_by'] !== $death['killed_by']) ? true : false;
                if ($mostdmg) {
                    $mostdmg = ($death['mostdamage_is_player']) ? getPlayerLink($death['mostdamage_by']) : $death['mostdamage_by'];
                    $description .= ' and by ' . $mostdmg;

                    if ($death['mostdamage_unjustified']) {
                        $description .= ' <span style="color: red; font-style: italic;">(unjustified)</span>';
                    }
                } else {
                    $description .= " <b>(soled)</b>";
                }

                $deaths[] = array('time' => $death['time'], 'description' => $description);
            }
        }
    }

    $frags = array();
    $frag_add_content = '';
    if ($config['characters']['frags'] && $db->hasTable('killers')) {
        //frags list by Xampy
        $i = 0;
        $frags_limit = 10; // frags limit to show? // default: 10
        $player_frags = $db->query('SELECT `player_deaths`.*, `players`.`name`, `killers`.`unjustified` FROM `player_deaths` LEFT JOIN `killers` ON `killers`.`death_id` = `player_deaths`.`id` LEFT JOIN `player_killers` ON `player_killers`.`kill_id` = `killers`.`id` LEFT JOIN `players` ON `players`.`id` = `player_deaths`.`player_id` WHERE `player_killers`.`player_id` = ' . $player->getId() . ' ORDER BY `date` DESC LIMIT 0,' . $frags_limit . ';')->fetchAll();
        if (count($player_frags)) {
            $row_count = 0;
            foreach ($player_frags as $frag) {
                $description = 'Fragged <a href="' . getPlayerLink($frag['name'], false) . '">' . $frag['name'] . '</a> at level ' . $frag['level'];
                $frags[] = array('time' => $frag['date'], 'description' => $description, 'unjustified' => $frag['unjustified'] != 0);
            }
        }
    }

    // signature
    if ($config['signature_enabled']) {
        $signature_url = BASE_URL . ($config['friendly_urls'] ? '' : '?') . urlencode($player->getName()) . '.png';
    }

    if (!$hidden) {
        // check if account has been banned
        $bannedUntil = '';
        $banned = array();
        if ($db->hasTable('account_bans'))
            $banned = $db->query('SELECT `expires_at` as `expires` FROM `account_bans` WHERE `account_id` = ' . $account->getId() . ' and (`expires_at` > ' . time() . ' OR `expires_at` = -1);');
        else if ($db->hasTable('bans')) {
            if ($db->hasColumn('bans', 'expires'))
                $banned = $db->query('SELECT `expires` FROM `bans` WHERE (`value` = ' . $account->getId() . ' or `value` = ' . $player->getId() . ') and `active` = 1 and `type` != 2 and `type` != 4 and (`expires` > ' . time() . ' OR `expires` = -1);');
            else
                $banned = $db->query('SELECT `time` as `time` FROM `bans` WHERE (`account` = ' . $account->getId() . ' or `player` = ' . $player->getId() . ') and `type` != 2 and `type` != 4 and (`time` > ' . time() . ' OR `time` = -1);');
        }
        foreach ($banned as $ban) {
            $bannedUntil = $ban['expires'];
        }

        $account_players = array();
        $query = $db->query('SELECT `id` FROM `players` WHERE `account_id` = ' . $account->getId() . ' ORDER BY `name`')->fetchAll();
        foreach ($query as $p) {
            $_player = new OTS_Player();
            $fields = array('id', 'name', 'vocation', 'level', 'online', 'deleted', 'hidden');
            $_player->load($p['id'], $fields, false);
            if ($_player->isLoaded() && !$_player->isHidden()) {
                $account_players[] = $_player;
            }
        }
    }

    // Percent experience
    class Functions
    {
        public static function getExpForLevel($lv)
        {
            $lv--;
            $lv = (string)$lv;
            return bcdiv(bcadd(bcsub(bcmul(bcmul(bcmul("50", $lv), $lv), $lv), bcmul(bcmul("150", $lv), $lv)), bcmul("400", $lv)), "3", 0);
        }
    }

    $expCurrent = Functions::getExpForLevel($player->getLevel());
    $expNext = Functions::getExpForLevel($player->getLevel() + 1);
    $expLeft = bcsub($expNext, $player->getExperience(), 0);
    $expLeftPercent = max(0, min(100, ($player->getExperience() - $expCurrent) / ($expNext - $expCurrent) * 100));
    $expLeftPercent = number_format($expLeftPercent, '2', '.', '');

    $achievementPoints = 0;
    $listAchievement = [];
    require_once BASE . '/tools/achievements.php';
    foreach ($achievements as $achievement => $value) {
        $achievementStorage = $config['achievements_base'] + $achievement;
        $achievementsPlayer = $db->query("SELECT `key`, `value` FROM `player_storage` WHERE `key` = {$achievementStorage} AND `player_id` = {$player->getId()}")->fetch();
        if ($achievementsPlayer && $achievementsPlayer['key'] == $achievementStorage) {
            $achievementPoints = $achievementPoints + $value['points'];
            $insertAchievement = [
                'BASE_URL' => BASE_URL,
                'PATH_URL' => $template_path,
                'name'     => $value['name'],
                'grade'    => $value['grade'],
                'secret'   => $value['secret'] ?? false,
            ];
        }
    }
    $listAchievement[] = $insertAchievement ?? [];

    $twig->display('characters.html.twig', array(
        'outfit' => $outfit ?? null,
        'player' => $player,
        'achievementPoints' => $achievementPoints,
        'achievements' => $listAchievement,
        'account' => $account,
        'expCurrent' => $expCurrent,
        'expNext' => $expNext,
        'expLeft' => $expLeft,
        'expLeftPercent' => $expLeftPercent,
        'flag' => $flag,
        'country' => $country,
        'oldName' => $oldName,
        'sex' => $player_sex,
        'health_max' => $player_HealthMax,
        'health_current' => $player_HealthCurrent,
        'health_percent' => $percent_Health,
        'mana_max' => $player_ManaMax,
        'mana_current' => $player_ManaCurrent,
        'mana_percent' => $percent_Mana,
        'soul' => $player_soul,
        'cap' => $player_cap,
        'experience' => $player_exp,
        'marriage_enabled' => $config['characters']['marriage_info'] && $db->hasColumn('players', 'marriage'),
        'marital_status' => $marital_status,
        'vocation' => $player->getVocationName(),
        'frags_enabled' => $frags_enabled,
        'frags_count' => $frags_count,
        'town' => isset($config['towns'][$player->getTownId()]) ? $config['towns'][$player->getTownId()] : null,
        'house' => array(
            'found' => isset($house['id']),
            'add' => isset($house['id']) ? $add : null,
            'name' => isset($house['id']) ? (isset($house['name']) ? $house['name'] : $house['id']) : null,
            'town' => isset($house['town']) ? ' (' . $config['towns'][$house['town']] . ')' : ''
        ),
        'balance' => number_format($player->getBalance(), 0, ',', ','),
        'guild' => array(
            'rank' => isset($guild_name) ? $rank_of_player->getName() : null,
            'link' => isset($guild_name) ? getGuildLink($guild_name) : null
        ),
        'comment' => !empty($comment) ? nl2br($comment) : null,
        'skills' => isset($skills) ? $skills : null,
        'quests_enabled' => $quests_enabled,
        'quests' => isset($quests) ? $quests : null,
        'equipment' => isset($equipment) ? $equipment : null,
        'skull' => $player->getSkullTime() > 0 && ($player->getSkull() == 4 || $player->getSkull() == 5) ? $skulls[$player->getSkull()] : null,
        'deaths' => $deaths,
        'frags' => $frags,
        'signature_url' => isset($signature_url) ? $signature_url : null,
        'player_link' => getPlayerLink($player->getName(), false),
        'hidden' => $hidden,
        'bannedUntil' => isset($bannedUntil) ? $bannedUntil : null,
        'characters_link' => getLink('characters'),
        'account_players' => isset($account_players) ? $account_players : null,
        'search_form' => generate_search_form(),
        'canEdit' => hasFlag(FLAG_CONTENT_PLAYERS) || superAdmin(),
        'vip_enabled' => isVipSystemEnabled()
    ));
} else {
    $search_errors[] = 'Character <b>' . $name . '</b> does not exist or has been deleted.';
    $twig->display('error_box.html.twig', array('errors' => $search_errors));
    $search_errors = array();

    $promotion = '';
    if ($db->hasColumn('players', 'promotion'))
        $promotion = ', `promotion`';

    $deleted = 'deleted';
    if ($db->hasColumn('players', 'deletion'))
        $deleted = 'deletion';

    $query = $db->query('SELECT `name`, `level`, `vocation`' . $promotion . ' FROM `players` WHERE `name` LIKE  ' . $db->quote('%' . $name . '%') . ' AND ' . $deleted . ' != 1 LIMIT ' . (int)config('characters_search_limit') . ';');
    if ($query->rowCount() > 0) {
        echo 'Did you mean:<ul>';
        foreach ($query as $player) {
            if (isset($player['promotion'])) {
                if ((int)$player['promotion'] > 0)
                    $player['vocation'] += ($player['promotion'] * $config['vocations_amount']);
            }
            echo '<li>' . getPlayerLink($player['name']) . ' (<small><strong>level ' . $player['level'] . ', ' . $config['vocations'][$player['vocation']] . '</strong></small>)</li>';
        }
        echo '</ul>';
    }
    echo generate_search_form(true);
}

if (!empty($search_errors))
    $twig->display('error_box.html.twig', array('errors' => $search_errors));
