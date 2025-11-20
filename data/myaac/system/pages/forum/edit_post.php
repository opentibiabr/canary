<?php
/**
 * Edit forum post
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

if (Forum::canPost($account_logged)) {
    $post_id = isset($_REQUEST['id']) ? (int)$_REQUEST['id'] : false;
    if (!$post_id) {
        $errors[] = 'Please enter post id.';
        displayErrorBoxWithBackButton($errors, getLink('forum'));
        return;
    }

    $thread = $db->query("SELECT `author_guid`, `author_aid`, `first_post`, `post_topic`, `post_date`, `post_text`, `post_smile`, `post_html`, `id`, `section` FROM `" . FORUM_TABLE_PREFIX . "forum` WHERE `id` = " . $post_id . " LIMIT 1")->fetch();
    if (isset($thread['id'])) {
        $first_post = $db->query("SELECT `" . FORUM_TABLE_PREFIX . "forum`.`author_guid`, `" . FORUM_TABLE_PREFIX . "forum`.`author_aid`, `" . FORUM_TABLE_PREFIX . "forum`.`first_post`, `" . FORUM_TABLE_PREFIX . "forum`.`post_topic`, `" . FORUM_TABLE_PREFIX . "forum`.`post_text`, `" . FORUM_TABLE_PREFIX . "forum`.`post_smile`, `" . FORUM_TABLE_PREFIX . "forum`.`id`, `" . FORUM_TABLE_PREFIX . "forum`.`section` FROM `" . FORUM_TABLE_PREFIX . "forum` WHERE `" . FORUM_TABLE_PREFIX . "forum`.`id` = " . (int)$thread['first_post'] . " LIMIT 1")->fetch();
        echo '<a href="' . getLink('forum') . '">Boards</a> >> <a href="' . getForumBoardLink($thread['section']) . '">' . $sections[$thread['section']]['name'] . '</a> >> <a href="' . getForumThreadLink($thread['first_post']) . '">' . $first_post['post_topic'] . '</a> >> <b>Edit post</b>';
        if (Forum::hasAccess($thread['section'] && ($account_logged->getId() == $thread['author_aid'] || Forum::isModerator()))) {
            $char_id = $post_topic = $text = $smile = $html = null;
            $players_from_account = $db->query("SELECT `players`.`name`, `players`.`id` FROM `players` WHERE `players`.`account_id` = " . (int)$account_logged->getId())->fetchAll();
            $saved = false;
            if (isset($_REQUEST['save'])) {
                $text = stripslashes(trim($_REQUEST['text']));
                $char_id = (int)$_REQUEST['char_id'];
                $post_topic = stripslashes(trim($_REQUEST['topic']));
                $smile = isset($_REQUEST['smile']) ? (int)$_REQUEST['smile'] : 0;
                $html = isset($_REQUEST['html']) ? (int)$_REQUEST['html'] : 0;
                if (!superAdmin()) {
                    $html = 0;
                }
                $length = strlen($post_topic);
                if (($length < 1 || $length > 60) && $thread['id'] == $thread['first_post'])
                    $errors[] = "Too short or too long topic (Length: $length letters). Minimum 1 letter, maximum 60 letters.";

                $length = strlen($text);
                if ($length < 1 || $length > 15000)
                    $errors[] = "Too short or too long post (Length: $length letters). Minimum 1 letter, maximum 15000 letters.";

                if ($char_id == 0)
                    $errors[] = 'Please select a character.';
                if (empty($post_topic) && $thread['id'] == $thread['first_post'])
                    $errors[] = 'Thread topic can\'t be empty.';

                $player_on_account = false;

                if (count($errors) == 0) {
                    foreach ($players_from_account as $player)
                        if ($char_id == $player['id'])
                            $player_on_account = true;
                    if (!$player_on_account)
                        $errors[] = 'Player with selected ID ' . $char_id . ' doesn\'t exist or isn\'t on your account';
                }

                if (count($errors) == 0) {
                    $saved = true;
                    if ($account_logged->getId() != $thread['author_aid'])
                        $char_id = $thread['author_guid'];
                    $db->query("UPDATE `" . FORUM_TABLE_PREFIX . "forum` SET `author_guid` = " . (int)$char_id . ", `post_text` = " . $db->quote($text) . ", `post_topic` = " . $db->quote($post_topic) . ", `post_smile` = " . $smile . ", `post_html` = " . $html . ", `last_edit_aid` = " . (int)$account_logged->getId() . ",`edit_date` = " . time() . " WHERE `id` = " . (int)$thread['id']);
                    $post_page = $db->query("SELECT COUNT(`" . FORUM_TABLE_PREFIX . "forum`.`id`) AS posts_count FROM `players`, `" . FORUM_TABLE_PREFIX . "forum` WHERE `players`.`id` = `" . FORUM_TABLE_PREFIX . "forum`.`author_guid` AND `" . FORUM_TABLE_PREFIX . "forum`.`post_date` <= " . $thread['post_date'] . " AND `" . FORUM_TABLE_PREFIX . "forum`.`first_post` = " . (int)$thread['first_post'])->fetch();
                    $_page = (int)ceil($post_page['posts_count'] / $config['forum_threads_per_page']) - 1;
                    header('Location: ' . getForumThreadLink($thread['first_post'], $_page));
                    echo '<br />Thank you for editing post.<br /><a href="' . getForumThreadLink($thread['first_post'], $_page) . '">GO BACK TO LAST THREAD</a>';
                }
            } else {
                $text = $thread['post_text'];
                $char_id = (int)$thread['author_guid'];
                $post_topic = $thread['post_topic'];
                $smile = (int)$thread['post_smile'];
                $html = (int)$thread['post_html'];
            }

            if (!$saved) {
                if (!empty($errors))
                    $twig->display('error_box.html.twig', array('errors' => $errors));

                $twig->display('forum.edit_post.html.twig', array(
                    'post_id' => $post_id,
                    'players' => $players_from_account,
                    'player_id' => $char_id,
                    'post_topic' => $canEdit ? $post_topic : htmlspecialchars($post_topic),
                    'post_text' => $canEdit ? $text : htmlspecialchars($text),
                    'post_smile' => $smile > 0,
                    'post_html' => $html > 0,
                    'html' => $html,
                    'canEdit' => $canEdit
                ));
            }
        } else {
            $errors[] = 'You are not an author of this post.';
            displayErrorBoxWithBackButton($errors, getLink('forum'));
        }
    } else {
        $errors[] = "Post with ID $post_id doesn't exist.";
        displayErrorBoxWithBackButton($errors, getLink('forum'));
    }
} else {
    $errors[] = "Your account is banned, deleted or you don't have any player with level " . $config['forum_level_required'] . " on your account. You can't post.";
    displayErrorBoxWithBackButton($errors, getLink('forum'));
}
