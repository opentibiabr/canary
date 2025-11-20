<?php
/**
 * Forum
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Forum';

if (strtolower($config['forum']) != 'site') {
    if ($config['forum'] != '') {
        header('Location: ' . $config['forum']);
        exit;
    }

    echo 'Forum is disabled on this site.';
    return;
}

if (!$logged)
    echo 'You are not logged in. <a href="?subtopic=accountmanagement&redirect=' . BASE_URL . urlencode('?subtopic=forum') . '">Log in</a> to post on the forum.<br /><br />';

require_once LIBS . 'forum.php';

$canEdit = Forum::isModerator();
if ($canEdit) {
    $groups = new OTS_Groups_List();

    if (!empty($action)) {
        if ($action == 'delete_board' || $action == 'edit_board' || $action == 'hide_board' || $action == 'moveup_board' || $action == 'movedown_board')
            $id = $_REQUEST['id'];

        if (isset($_REQUEST['access']))
            $access = $_REQUEST['access'];

        if (isset($_REQUEST['guild']))
            $guild = $_REQUEST['guild'];

        if (isset($_REQUEST['name']))
            $name = $_REQUEST['name'];

        if (isset($_REQUEST['description']))
            $description = stripslashes($_REQUEST['description']);

        $errors = array();

        if ($action == 'add_board') {
            if (Forum::add_board($name, $description, $access, $guild, $errors))
                $action = $name = $description = '';
        } else if ($action == 'delete_board') {
            Forum::delete_board($id, $errors);
            $action = '';
        } else if ($action == 'edit_board') {
            if (isset($id) && !isset($name)) {
                $board = Forum::get_board($id);
                $name = $board['name'];
                $access = $board['access'];
                $guild = $board['guild'];
                $description = $board['description'];
            } else {
                Forum::update_board($id, $name, $access, $guild, $description);
                $action = $name = $description = '';
                $access = $guild = 0;
            }
        } else if ($action == 'hide_board') {
            Forum::toggleHidden_board($id, $errors);
            $action = '';
        } else if ($action == 'moveup_board') {
            Forum::move_board($id, -1, $errors);
            $action = '';
        } else if ($action == 'movedown_board') {
            Forum::move_board($id, 1, $errors);
            $action = '';
        }

        if (!empty($errors)) {
            $twig->display('error_box.html.twig', array('errors' => $errors));
            $action = '';
        }
    }

    if (empty($action) || $action == 'edit_board') {
        $guilds = $db->query('SELECT `id`, `name` FROM `guilds`')->fetchAll();
        $twig->display('forum.add_board.html.twig', array(
            'link' => getLink('forum', ($action == 'edit_board' ? 'edit_board' : 'add_board')),
            'action' => $action,
            'id' => isset($id) ? $id : null,
            'name' => isset($name) ? $name : null,
            'description' => isset($description) ? $description : null,
            'access' => isset($access) ? $access : 0,
            'guild' => isset($guild) ? $guild : null,
            'groups' => $groups,
            'guilds' => $guilds
        ));

        if ($action == 'edit_board')
            $action = '';
    }
}

$sections = array();
foreach (getForumBoards() as $section) {
    $sections[$section['id']] = array(
        'id' => $section['id'],
        'name' => $section['name'],
        'description' => $section['description'],
        'closed' => $section['closed'] == '1',
        'guild' => $section['guild'],
        'access' => $section['access']
    );

    if ($canEdit) {
        $sections[$section['id']]['hidden'] = $section['hidden'];
    } else {
        $sections[$section['id']]['hidden'] = 0;
    }
}

$number_of_rows = 0;
if (empty($action)) {
    $info = $db->query("SELECT `section`, COUNT(`id`) AS 'threads', SUM(`replies`) AS 'replies' FROM `" . FORUM_TABLE_PREFIX . "forum` WHERE `first_post` = `id` GROUP BY `section`")->fetchAll();

    $boards = array();
    foreach ($info as $data)
        $counters[$data['section']] = array('threads' => $data['threads'], 'posts' => $data['replies'] + $data['threads']);
    foreach ($sections as $id => $section) {
        $show = true;
        if (Forum::hasAccess($id)) {
            $last_post = $db->query("SELECT `players`.`name`, `" . FORUM_TABLE_PREFIX . "forum`.`post_date` FROM `players`, `" . FORUM_TABLE_PREFIX . "forum` WHERE `" . FORUM_TABLE_PREFIX . "forum`.`section` = " . (int)$id . " AND `players`.`id` = `" . FORUM_TABLE_PREFIX . "forum`.`author_guid` ORDER BY `post_date` DESC LIMIT 1")->fetch();
            $boards[] = array(
                'id' => $id,
                'link' => getForumBoardLink($id),
                'name' => $section['name'],
                'description' => $section['description'],
                'hidden' => $section['hidden'],
                'posts' => isset($counters[$id]['posts']) ? $counters[$id]['posts'] : 0,
                'threads' => isset($counters[$id]['threads']) ? $counters[$id]['threads'] : 0,
                'last_post' => array(
                    'name' => isset($last_post['name']) ? $last_post['name'] : null,
                    'date' => isset($last_post['post_date']) ? $last_post['post_date'] : null,
                    'player_link' => isset($last_post['name']) ? getPlayerLink($last_post['name']) : null,
                )
            );
        }
    }

    $twig->display('forum.boards.html.twig', array(
        'boards' => $boards,
        'currentTime' => date('H:i'),
        'canEdit' => $canEdit,
        'last' => count($sections)
    ));

    return;
}

$errors = array();
if ($action == 'show_board' || $action == 'show_thread') {
    require PAGES . 'forum/' . $action . '.php';
    return;
}

if (!$logged) {
    $extra_url = '';
    if ($action == 'new_post' && isset($_GET['thread_id'])) {
        $extra_url = '&action=new_post&thread_id=' . $_GET['thread_id'];
    }

    header('Location: ' . BASE_URL . '?subtopic=accountmanagement&redirect=' . BASE_URL . urlencode('?subtopic=forum' . $extra_url));
    return;
}

if (!ctype_alnum(str_replace(array('-', '_'), '', $action))) {
    $errors[] = 'Error: Action contains illegal characters.';
    displayErrorBoxWithBackButton($errors, getLink('forum'));
} else if (file_exists(PAGES . 'forum/' . $action . '.php')) {
    require PAGES . 'forum/' . $action . '.php';
} else {
    $errors[] = 'This page does not exists.';
    displayErrorBoxWithBackButton($errors, getLink('forum'));
}
