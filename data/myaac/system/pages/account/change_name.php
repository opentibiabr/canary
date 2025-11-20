<?php
/**
 * Change characters name
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$player_id = isset($_POST['player_id']) ? (int)$_POST['player_id'] : NULL;
$name = isset($_POST['name']) ? stripslashes(ucwords(strtolower($_POST['name']))) : NULL;
$coinType = $config['account_coin_type_usage'] ?? 'coins_transferable';
$coinName = $coinType == 'coins' ? $coinType : 'transferable coins';
$needCoins = $config['account_change_character_name_coins'];

if (!$config['account_change_character_name'])
    echo 'Changing character name for coins is disabled on this server.';
else {
    $coins = $account_logged->getCustomField($coinType);
    if (isset($_POST['changenamesave']) && $_POST['changenamesave'] == 1) {
        if ($coins < $needCoins)
            $errors[] = "You need {$needCoins} {$coinName} to change name. You have <b>{$coins}</b> {$coinName}.";

        $minLength = config('character_name_min_length');
        $maxLength = config('character_name_max_length');

        if (empty($errors) && empty($name))
            $errors[] = 'Please enter a new name for your character!';
        else if (strlen($name) > $maxLength)
            $errors['name'] = 'Name is too long. Max. length <b>' . $maxLength . '</b> letters.';
        else if (strlen($name) < $minLength)
            $errors['name'] = 'Name is too short. Min. length <b>' . $minLength . '</b> letters.';

        if (empty($errors)) {
            if (!admin() && !Validator::newCharacterName($name))
                $errors[] = Validator::getLastError();
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

                    if (empty($errors)) {
                        $show_form = false;
                        $old_name = $player->getName();
                        $player->setName($name);
                        $player->save();
                        $account_logged->setCustomField($coinType, $coins - $needCoins);
                        $account_logged->logAction('Changed name from <b>' . $old_name . '</b> to <b>' . $player->getName() . '</b>.');
                        $twig->display('success.html.twig', array(
                            'title' => 'Character Name Changed',
                            'description' => 'The character <b>' . $old_name . '</b> name has been changed to <b>' . $player->getName() . '</b>.'
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

    if ($show_form) {
        if (!empty($errors)) {
            $twig->display('error_box.html.twig', array('errors' => $errors));
        }

        $twig->display('account.change_name.html.twig', array(
            'coins'     => $coins,
            'coin_type' => $coinType,
            'coin_name' => $coinName,
            'errors'    => $errors,
        ));
    }
}
