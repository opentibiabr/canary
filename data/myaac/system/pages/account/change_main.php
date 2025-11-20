<?php
/**
 * Change main character
 *
 * @package   MyAAC
 * @author    Elson <elsongabriel@hotmail.com>
 */
defined('MYAAC') or die('Direct access not allowed!');

if (!$db->hasColumn('players', 'ismain')) {
    echo "You can't set main character.";
    return;
}

if (!$config['account_change_character_main']) {
    echo 'Changing main character for coins is disabled on this server.';
    return;
}
$coinType = $config['account_coin_type_usage'] ?? 'coins_transferable';
$coinName = $coinType == 'coins' ? $coinType : 'transferable coins';
$needCoins = $config['account_change_character_main_coins'];

/** @var OTS_Players_List $account_players */
$account_players = $account_logged->getPlayersList();
$account_players->orderBy('id');
$coins = $account_logged->getCustomField($coinType);
$main_changed = false;
$player_id = isset($_POST['player_id']) ? (int)$_POST['player_id'] : NULL;
if (isset($_POST['changemainsave']) && $_POST['changemainsave'] == 1) {
    if ($coins < $needCoins) {
        $errors[] = "You need {$needCoins} {$coinName} to change the main character. You have <b>{$coins}</b> {$coinName}.";
    }

    if (empty($errors)) {
        $player = new OTS_Player();
        $player->load($player_id);
        if ($player->isLoaded()) {
            $player_account = $player->getAccount();
            if ($account_logged->getId() == $player_account->getId()) {
                if (empty($errors)) {
                    $db->query("update `players` set `ismain` = 0 where `account_id` = {$player_account->getId()}");
                    $db->query("update `players` set `ismain` = 1, `hidden` = 0 where `id` = {$player_id}");
                    $main_changed = true;
                    $account_logged->setCustomField($coinType, $coins - $needCoins);
                    $account_logged->logAction($desc = "Changed main character to <b>{$player->getName()}</b>.");
                    $twig->display('success.html.twig', array(
                        'title' => 'Main Character Changed',
                        'description' => $desc
                    ));
                }
            } else {
                $errors[] = "Character <b>{$player->getName()}</b> is not on your account.";
            }
        } else {
            $errors[] = "Character with this name doesn't exist.";
        }
    }
}

if (!$main_changed) {
    if (!empty($errors)) {
        $twig->display('error_box.html.twig', array('errors' => $errors));
    }
    $twig->display('account.change_main.html.twig', array(
        'players'   => $account_players,
        'coins'     => $coins,
        'coin_type' => $coinType,
        'coin_name' => $coinName,
    ));
}
