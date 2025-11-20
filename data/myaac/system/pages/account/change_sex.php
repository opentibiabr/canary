<?php
/**
 * Change sex
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$sex_changed = false;
$player_id = isset($_POST['player_id']) ? (int)$_POST['player_id'] : NULL;
$new_sex = isset($_POST['new_sex']) ? (int)$_POST['new_sex'] : NULL;
$coinType = $config['account_coin_type_usage'] ?? 'coins_transferable';
$coinName = $coinType == 'coins' ? $coinType : 'transferable coins';
$needCoins = $config['account_change_character_sex_coins'];

if (!$config['account_change_character_sex'])
    echo 'Changing sex for coins is disabled on this server.';
else {
    $coins = $account_logged->getCustomField($coinType);
    if (isset($_POST['changesexsave']) && $_POST['changesexsave'] == 1) {
        if ($coins < $needCoins)
            $errors[] = "You need {$needCoins} {$coinName} to change sex. You have <b>{$coins}</b> {$coinName}.";

        if (empty($errors) && !isset($config['genders'][$new_sex])) {
            $errors[] = 'This sex is invalid.';
        }

        if (empty($errors)) {
            $player = new OTS_Player();
            $player->load($player_id);

            if ($player->isLoaded()) {
                $player_account = $player->getAccount();

                if ($account_logged->getId() == $player_account->getId()) {
                    if ($player->isDeleted()) {
                        $errors[] = 'This character is deleted.';
                    }

                    if ($player->isOnline()) {
                        $errors[] = 'This character is online.';
                    }

                    if (empty($errors) && $player->getSex() == $new_sex)
                        $errors[] = 'Sex cannot be same';

                    if (empty($errors)) {
                        $sex_changed = true;
                        $old_sex = $player->getSex();
                        $player->setSex($new_sex);

                        $old_sex_str = 'Unknown';
                        if (isset($config['genders'][$old_sex]))
                            $old_sex_str = $config['genders'][$old_sex];

                        $new_sex_str = 'Unknown';
                        if (isset($config['genders'][$new_sex]))
                            $new_sex_str = $config['genders'][$new_sex];

                        $player->save();
                        $account_logged->setCustomField($coinType, $coins - $needCoins);
                        $account_logged->logAction('Changed sex on character <b>' . $player->getName() . '</b> from <b>' . $old_sex_str . '</b> to <b>' . $new_sex_str . '</b>.');
                        $twig->display('success.html.twig', array(
                            'title' => 'Character Sex Changed',
                            'description' => 'The character <b>' . $player->getName() . '</b> sex has been changed to <b>' . $new_sex_str . '</b>.'
                        ));
                    }
                } else {
                    $errors[] = 'Character is not on your account.';
                }
            } else {
                $errors[] = "Character with this name doesn't exist.";
            }
        }
    }

    if (!$sex_changed) {
        if (!empty($errors)) {
            $twig->display('error_box.html.twig', array('errors' => $errors));
        }
        $twig->display('account.change_sex.html.twig', array(
            'players'    => $account_logged->getPlayersList(false),
            'player_sex' => isset($player) ? $player->getSex() : -1,
            'coins'      => $coins,
            'coin_type'  => $coinType,
            'coin_name'  => $coinName,
        ));
    }
}
