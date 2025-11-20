<?php
/**
 * Invite to guild
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

//set rights in guild
$guild_name = isset($_REQUEST['guild']) ? urldecode($_REQUEST['guild']) : NULL;
$name = isset($_REQUEST['name']) ? stripslashes($_REQUEST['name']) : NULL;
if (!$logged) {
    $errors[] = "You are not logged in. You can't invite players.";
}

if (!Validator::guildName($guild_name)) {
    $errors[] = Validator::getLastError();
}

if (empty($errors)) {
    $guild = new OTS_Guild();
    $guild->find($guild_name);
    if (!$guild->isLoaded()) {
        $errors[] = 'Guild with name <b>' . $guild_name . '</b> doesn\'t exist.';
    }
}

if (empty($errors)) {
    $rank_list = $guild->getGuildRanksList();
    $rank_list->orderBy('level', POT::ORDER_DESC);
    $guild_leader = false;
    $guild_vice = false;
    $account_players = $account_logged->getPlayers();
    foreach ($account_players as $player) {
        $player_rank = $player->getRank();
        if ($player_rank->isLoaded()) {
            foreach ($rank_list as $rank_in_guild) {
                if ($rank_in_guild->getId() == $player_rank->getId()) {
                    $players_from_account_in_guild[] = $player->getName();
                    if ($player_rank->getLevel() > 1) {
                        $guild_vice = true;
                        $level_in_guild = $player_rank->getLevel();
                    }

                    if ($guild->getOwner()->getId() == $player->getId()) {
                        $guild_vice = true;
                        $guild_leader = true;
                    }
                }
            }
        }
    }
}

if (!$guild_vice) {
    $errors[] = 'You are not a leader or vice leader of guild <b>' . $guild_name . '</b>.' . $level_in_guild;
}

if (isset($_REQUEST['todo']) && $_REQUEST['todo'] == 'save') {
    if (!Validator::characterName($name)) {
        $errors[] = 'Invalid name format.';
    }

    if (empty($errors)) {
        $player = new OTS_Player();
        $player->find($name);
        if (!$player->isLoaded()) {
            $errors[] = 'Player with name <b>' . $name . '</b> doesn\'t exist.';
        } else if ($player->isDeleted()) {
            $errors[] = "Character with name <b>$name</b> has been deleted.";
        } else {
            $rank_of_player = $player->getRank();
            if ($rank_of_player->isLoaded()) {
                $errors[] = 'Player with name <b>' . $name . '</b> is already in guild. He must leave guild before you can invite him.';
            }
        }
    }
}
if (empty($errors)) {
    include(SYSTEM . 'libs/pot/InvitesDriver.php');
    new InvitesDriver($guild);
    $invited_list = $guild->listInvites();
    if (count($invited_list) > 0) {
        foreach ($invited_list as $invited) {
            if ($invited->getName() == $player->getName()) {
                $errors[] = '<b>' . $invited->getName() . '</b> is already invited to your guild.';
            }
        }
    }
}

$show = true;
if (!empty($errors)) {
    $twig->display('error_box.html.twig', array('errors' => $errors));
} else {
    if (isset($_REQUEST['todo']) && $_REQUEST['todo'] == 'save') {
        $guild->invite($player);
        $twig->display('success.html.twig', array(
            'title' => 'Invite player',
            'description' => 'Player with name <b>' . $player->getName() . '</b> has been invited to your guild.',
            'custom_buttons' => ''
        ));

        $show = false;
    }
}

if ($show) {
    $twig->display('success.html.twig', array(
        'title' => 'Invite player',
        'description' => $twig->render('guilds.invite.html.twig', array(
            'guild_name' => $guild->getName()
        )),
        'custom_buttons' => ''
    ));
}

$twig->display('guilds.back_button.html.twig', array(
    'action' => getLink('guilds') . '/' . $guild_name
));
