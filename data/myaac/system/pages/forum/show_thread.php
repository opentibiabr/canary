<?php
/**
 * Show forum thread
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$links_to_pages = '';
$thread_id = (int)$_REQUEST['id'];
$_page = (int)(isset($_REQUEST['page']) ? $_REQUEST['page'] : 0);
$thread_starter = $db->query("SELECT `players`.`name`, `" . FORUM_TABLE_PREFIX . "forum`.`post_topic`, `" . FORUM_TABLE_PREFIX . "forum`.`section` FROM `players`, `" . FORUM_TABLE_PREFIX . "forum` WHERE `" . FORUM_TABLE_PREFIX . "forum`.`first_post` = " . (int)$thread_id . " AND `" . FORUM_TABLE_PREFIX . "forum`.`id` = `" . FORUM_TABLE_PREFIX . "forum`.`first_post` AND `players`.`id` = `" . FORUM_TABLE_PREFIX . "forum`.`author_guid` LIMIT 1")->fetch();

if (empty($thread_starter['name'])) {
    $errors[] = 'Thread with this ID does not exists.';
    displayErrorBoxWithBackButton($errors, getLink('forum'));
    return;
}

if (!Forum::hasAccess($thread_starter['section'])) {
    $errors[] = "You don't have access to view this thread.";
    displayErrorBoxWithBackButton($errors, getLink('forum'));
    return;
}

$posts_count = $db->query("SELECT COUNT(`" . FORUM_TABLE_PREFIX . "forum`.`id`) AS posts_count FROM `players`, `" . FORUM_TABLE_PREFIX . "forum` WHERE `players`.`id` = `" . FORUM_TABLE_PREFIX . "forum`.`author_guid` AND `" . FORUM_TABLE_PREFIX . "forum`.`first_post` = " . (int)$thread_id)->fetch();
for ($i = 0; $i < $posts_count['posts_count'] / $config['forum_threads_per_page']; $i++) {
    if ($i != $_page)
        $links_to_pages .= '<a href="' . getForumThreadLink($thread_id, $i) . '">' . ($i + 1) . '</a> ';
    else
        $links_to_pages .= '<b>' . ($i + 1) . ' </b>';
}
$posts = $db->query("SELECT `players`.`id` as `player_id`, `" . FORUM_TABLE_PREFIX . "forum`.`id`,`" . FORUM_TABLE_PREFIX . "forum`.`first_post`, `" . FORUM_TABLE_PREFIX . "forum`.`section`,`" . FORUM_TABLE_PREFIX . "forum`.`post_text`, `" . FORUM_TABLE_PREFIX . "forum`.`post_topic`, `" . FORUM_TABLE_PREFIX . "forum`.`post_date` AS `date`, `" . FORUM_TABLE_PREFIX . "forum`.`post_smile`, `" . FORUM_TABLE_PREFIX . "forum`.`post_html`, `" . FORUM_TABLE_PREFIX . "forum`.`author_aid`, `" . FORUM_TABLE_PREFIX . "forum`.`author_guid`, `" . FORUM_TABLE_PREFIX . "forum`.`last_edit_aid`, `" . FORUM_TABLE_PREFIX . "forum`.`edit_date` FROM `players`, `" . FORUM_TABLE_PREFIX . "forum` WHERE `players`.`id` = `" . FORUM_TABLE_PREFIX . "forum`.`author_guid` AND `" . FORUM_TABLE_PREFIX . "forum`.`first_post` = " . (int)$thread_id . " ORDER BY `" . FORUM_TABLE_PREFIX . "forum`.`post_date` LIMIT " . $config['forum_posts_per_page'] . " OFFSET " . ($_page * $config['forum_posts_per_page']))->fetchAll();
if (isset($posts[0]['player_id'])) {
    $db->query("UPDATE `" . FORUM_TABLE_PREFIX . "forum` SET `views`=`views`+1 WHERE `id` = " . (int)$thread_id);
}

$lookaddons = $db->hasColumn('players', 'lookaddons');
$groups = new OTS_Groups_List();
foreach ($posts as &$post) {
    $post['player'] = new OTS_Player();
    $player = $post['player'];
    $player->load($post['player_id']);
    if (!$player->isLoaded()) {
        throw new RuntimeException('Forum error: Player not loaded.');
    }

    if ($config['characters']['outfit']) {
        $post['outfit'] = $config['outfit_images_url'] . '?id=' . $player->getLookType() . ($lookaddons ? '&addons=' . $player->getLookAddons() : '') . '&head=' . $player->getLookHead() . '&body=' . $player->getLookBody() . '&legs=' . $player->getLookLegs() . '&feet=' . $player->getLookFeet();
    }

    $groupName = '';
    $group = $player->getGroup();
    if ($group->isLoaded()) {
        $groupName = $group->getName();
    }

    $post['group'] = $groupName;
    $post['player_link'] = getPlayerLink($player->getName());

    $post['vocation'] = $player->getVocationName();

    $rank = $player->getRank();
    if ($rank->isLoaded()) {
        $guild = $rank->getGuild();
        if ($guild->isLoaded())
            $post['guildRank'] = $rank->getName() . ' of <a href="' . getGuildLink($guild->getName(), false) . '">' . $guild->getName() . '</a>';
    }

    $player_account = $player->getAccount();
    $post['content'] = Forum::showPost(($post['post_html'] > 0 ? $post['post_topic'] : htmlspecialchars($post['post_topic'])), ($post['post_html'] > 0 ? $post['post_text'] : htmlspecialchars($post['post_text'])), $post['post_smile'] == 0, $post['post_html'] > 0);

    $query = $db->query("SELECT COUNT(`id`) AS 'posts' FROM `" . FORUM_TABLE_PREFIX . "forum` WHERE `author_aid`=" . (int)$player_account->getId())->fetch();
    $post['author_posts_count'] = (int)$query['posts'];

    if ($post['edit_date'] > 0) {
        if ($post['last_edit_aid'] != $post['author_aid']) {
            $post['edited_by'] = 'moderator';
        } else {
            $post['edited_by'] = $player->getName();
        }
    }
}

$twig->display('forum.show_thread.html.twig', array(
    'thread_id' => $thread_id,
    'posts' => $posts,
    'links_to_pages' => $links_to_pages,
    'author_link' => getPlayerLink($thread_starter['name']),
    'section' => array('id' => $posts[0]['section'], 'name' => $sections[$posts[0]['section']]['name']),
    'thread_starter' => $thread_starter,
    'is_moderator' => Forum::isModerator()
));

$twig->display('forum.fullscreen.html.twig');
