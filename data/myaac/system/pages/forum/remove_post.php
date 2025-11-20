<?php
/**
 * Remove forum post
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

if (Forum::isModerator()) {
    $id = (int)$_REQUEST['id'];
    $post = $db->query("SELECT `id`, `first_post`, `section` FROM `" . FORUM_TABLE_PREFIX . "forum` WHERE `id` = " . $id . " LIMIT 1")->fetch();
    if ($post['id'] == $id && Forum::hasAccess($post['section'])) {
        if ($post['id'] == $post['first_post']) {
            $db->query("DELETE FROM `" . FORUM_TABLE_PREFIX . "forum` WHERE `first_post` = " . $post['id']);
            header('Location: ' . getForumBoardLink($post['section']));
        } else {
            $post_page = $db->query("SELECT COUNT(`" . FORUM_TABLE_PREFIX . "forum`.`id`) AS posts_count FROM `players`, `" . FORUM_TABLE_PREFIX . "forum` WHERE `players`.`id` = `" . FORUM_TABLE_PREFIX . "forum`.`author_guid` AND `" . FORUM_TABLE_PREFIX . "forum`.`id` < " . $id . " AND `" . FORUM_TABLE_PREFIX . "forum`.`first_post` = " . (int)$post['first_post'])->fetch();
            $_page = (int)ceil($post_page['posts_count'] / $config['forum_threads_per_page']) - 1;
            $db->query("DELETE FROM `" . FORUM_TABLE_PREFIX . "forum` WHERE `id` = " . $post['id']);
            header('Location: ' . getForumThreadLink($post['first_post'], (int)$_page));
        }
    } else {
        $errors[] = 'Post with ID ' . $id . ' does not exist.';
        displayErrorBoxWithBackButton($errors, getLink('forum'));
    }
} else {
    $errors[] = 'You are not logged in or you are not moderator.';
    displayErrorBoxWithBackButton($errors, getLink('forum'));
}
