<?php
/**
 * Accept invite
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
$guild_name = isset($_REQUEST['guild']) ? urldecode($_REQUEST['guild']) : null;
$name = isset($_REQUEST['name']) ? stripslashes($_REQUEST['name']) : null;
if (!$logged) {
    $errors[] = 'You are not logged in. You can\'t accept invitations.';
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

if (isset($_REQUEST['todo']) && $_REQUEST['todo'] == 'save') {
    if (!Validator::characterName($name)) {
        $errors[] = 'Invalid name format.';
    }

    if (empty($errors)) {
        $player = new OTS_Player();
        $player->find($name);
        if (!$player->isLoaded()) {
            $errors[] = "Player with name <b>{$name}</b> doesn\'t exist.";
        } else if ($player->getAccountID() != $account_logged->getId()) {
            $errors[] = "Character with name <b>{$name}</b> is not in your account.";
        } else if ($player->getRank()->isLoaded()) {
            $errors[] = "Character with name <b>{$name}</b> is already in guild. You must leave guild before you join other guild.";
        } else if ($player->isDeleted()) {
            $errors[] = "Character with name <b>$name</b> has been deleted.";
        }
    }
}

if (isset($_REQUEST['todo']) && $_REQUEST['todo'] == 'save') {
    if (empty($errors)) {
        $is_invited = false;
        include(SYSTEM . 'libs/pot/InvitesDriver.php');
        new InvitesDriver($guild);
        $invited_list = $guild->listInvites();
        if (count($invited_list) > 0) {
            foreach ($invited_list as $invited) {
                if ($invited->getName() == $player->getName()) {
                    $is_invited = true;
                }
            }
        }

        if (!$is_invited) {
            $errors[] = "Character {$player->getName()} isn\'t invited to guild <b>{$guild->getName()}</b>.";
        }
    }
} else {
    if (empty($errors)) {
        $acc_invited = false;
        $account_players = $account_logged->getPlayersList(false);
        include(SYSTEM . 'libs/pot/InvitesDriver.php');
        new InvitesDriver($guild);
        $invited_list = $guild->listInvites();

        if (count($invited_list) > 0) {
            foreach ($invited_list as $invited) {
                foreach ($account_players as $player_from_acc) {
                    if ($invited->getName() == $player_from_acc->getName()) {
                        $acc_invited = true;
                        $list_of_invited_players[] = $player_from_acc->getName();
                    }
                }
            }
        }

        if (!$acc_invited) {
            $errors[] = "Any character from your account isn't invited to <b>" . $guild->getName() . "</b>.";
        }
    }
}

if (!empty($errors)) {
    $twig->display('error_box.html.twig', array('errors' => $errors));

    $twig->display('guilds.back_button.html.twig', array(
        'action' => getLink('guilds') . '/' . $guild_name
    ));
} else {
    if (isset($_REQUEST['todo']) && $_REQUEST['todo'] == 'save') {
        $guild->acceptInvite($player);
        $twig->display('success.html.twig', array(
            'title' => 'Accept invitation',
            'description' => 'Player with name <b>' . $player->getName() . '</b> has been added to guild <b>' . $guild->getName() . '</b>.',
            'custom_buttons' => $twig->render('guilds.back_button.html.twig', array(
                'action' => getLink('guilds') . '/' . $guild_name
            ))
        ));
    } else {
        sort($list_of_invited_players);

        $twig->display('guilds.accept_invite.html.twig', array(
            'guild_name' => $guild_name,
            'invited_players' => $list_of_invited_players
        ));
    }
}
