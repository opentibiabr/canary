<?php
/**
 * Create guild
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$guild_name = isset($_REQUEST['guild']) ? urldecode($_REQUEST['guild']) : NULL;
$name = isset($_REQUEST['name']) ? stripslashes($_REQUEST['name']) : NULL;
$todo = isset($_REQUEST['todo']) ? $_REQUEST['todo'] : NULL;
if (!$logged) {
    $guild_errors[] = 'You are not logged in. You can\'t create guild.';
}

$array_of_player_nig = array();
if (empty($guild_errors)) {
    $account_players = $account_logged->getPlayersList(false);
    foreach ($account_players as $player) {
        $player_rank = $player->getRank();
        if (!$player_rank->isLoaded()) {
            if ($player->getLevel() >= $config['guild_need_level']) {
                if (!$config['guild_need_premium'] || $account_logged->isPremium()) {
                    $array_of_player_nig[] = $player->getName();
                }
            }
        }
    }
}

if (empty($todo)) {
    if (count($array_of_player_nig) == 0) {
        $guild_errors[] = 'On your account all characters are in guilds, have too low level to create new guild' . ($config['guild_need_premium'] ? ' or you don\' have a premium account' : '') . '.';
    }
}

if ($todo == 'save') {
    if (!Validator::guildName($guild_name)) {
        $guild_errors[] = Validator::getLastError();
        $guild_name = '';
    }

    if (!Validator::characterName($name)) {
        $guild_errors[] = 'Invalid character name format.';
        $name = '';
    }

    if (empty($guild_errors)) {
        $player = new OTS_Player();
        $player->find($name);
        if (!$player->isLoaded()) {
            $guild_errors[] = 'Character <b>' . $name . '</b> doesn\'t exist.';
        }
    }


    if (empty($guild_errors)) {
        $guild = new OTS_Guild();
        $guild->find($guild_name);
        if ($guild->isLoaded()) {
            $guild_errors[] = 'Guild <b>' . $guild_name . '</b> already exist. Select other name.';
        }
    }

    if (empty($guild_errors) && $player->isDeleted()) {
        $guild_errors[] = "Character <b>$name</b> has been deleted.";
    }

    if (empty($guild_errors)) {
        $bad_char = true;
        foreach ($array_of_player_nig as $nick_from_list) {
            if ($nick_from_list == $player->getName()) {
                $bad_char = false;
            }
        }
        if ($bad_char) {
            $guild_errors[] = 'Character <b>' . $name . '</b> isn\'t on your account or is already in guild.';
        }
    }

    if (empty($guild_errors)) {
        if ($player->getLevel() < $config['guild_need_level']) {
            $guild_errors[] = 'Character <b>' . $name . '</b> has too low level. To create guild you need character with level <b>' . $config['guild_need_level'] . '</b>.';
        }
        if ($config['guild_need_premium'] && !$account_logged->isPremium()) {
            $guild_errors[] = 'Character <b>' . $name . '</b> is on FREE account. To create guild you need PREMIUM account.';
        }
    }
}

if (!empty($guild_errors)) {
    $twig->display('error_box.html.twig', array('errors' => $guild_errors));
    unset($todo);
}

if (isset($todo) && $todo == 'save') {
    $new_guild = new OTS_Guild();
    $new_guild->setCreationData(time());
    $new_guild->setName($guild_name);
    $new_guild->setOwner($player);
    $new_guild->save();
    $new_guild->setCustomField('description', 'New guild. Leader must edit this text :)');
    //$new_guild->setCustomField('creationdata', time());
    $ranks = $new_guild->getGuildRanksList();
    $ranks->orderBy('level', POT::ORDER_DESC);
    foreach ($ranks as $rank) {
        if ($rank->getLevel() == 3) {
            $player->setRank($rank);
        }
    }
    $twig->display('guilds.create.success.html.twig', array(
        'guild_name' => $guild_name,
        'leader_name' => $player->getName()
    ));

    /*$db->exec('INSERT INTO `guild_ranks` (`id`, `guild_id`, `name`, `level`) VALUES (null, '.$new_guild->getId().', "the Leader", 3)');
    $db->exec('INSERT INTO `guild_ranks` (`id`, `guild_id`, `name`, `level`) VALUES (null, '.$new_guild->getId().', "a Vice-Leader", 2)');
    $db->exec('INSERT INTO `guild_ranks` (`id`, `guild_id`, `name`, `level`) VALUES (null, '.$new_guild->getId().', "a Member", 1)');*/
} else {
    sort($array_of_player_nig);
    $twig->display('guilds.create.html.twig', array(
        'players' => $array_of_player_nig
    ));
}
