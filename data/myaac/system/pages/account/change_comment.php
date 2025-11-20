<?php
/**
 * Change comment
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$player_name = isset($_REQUEST['name']) ? stripslashes(urldecode($_REQUEST['name'])) : null;
$new_comment = isset($_POST['comment']) ? htmlspecialchars(stripslashes(substr($_POST['comment'], 0, 2000))) : NULL;
$new_hideacc = isset($_POST['accountvisible']) ? (int)$_POST['accountvisible'] : NULL;

if ($player_name != null) {
    if (Validator::characterName($player_name)) {
        $player = new OTS_Player();
        $player->find($player_name);
        if ($player->isLoaded()) {
            $player_account = $player->getAccount();
            if ($account_logged->getId() == $player_account->getId()) {
                if ($player->isDeleted()) {
                    $errors[] = 'This character is deleted.';
                    $player = null;
                }

                if (isset($_POST['changecommentsave']) && $_POST['changecommentsave'] == 1) {
                    if (empty($errors)) {
                        $player->setCustomField("hidden", $new_hideacc);
                        $player->setCustomField("comment", $new_comment);
                        $account_logged->logAction('Changed comment for character <b>' . $player->getName() . '</b>.');
                        $twig->display('success.html.twig', array(
                            'title' => 'Character Information Changed',
                            'description' => 'The character information has been changed.'
                        ));
                        $show_form = false;
                    }
                }
            } else {
                $errors[] = 'Error. Character <b>' . $player_name . '</b> is not on your account.';
            }
        } else {
            $errors[] = "Error. Character with this name doesn't exist.";
        }
    } else {
        $errors[] = 'Error. Name contain illegal characters.';
    }
} else {
    $errors[] = 'Please enter character name.';
}

if ($show_form) {
    if (!empty($errors)) {
        $twig->display('error_box.html.twig', array('errors' => $errors));
    }

    if (isset($player) && $player->isLoaded()) {
        $twig->display('account.change_comment.html.twig', array(
            'player' => $player
        ));
    }
}
