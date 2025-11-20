<?php
/**
 * Show forum board
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
$section_id = isset($_REQUEST['id']) ? (int)$_REQUEST['id'] : null;

if ($section_id == null || !isset($sections[$section_id])) {
    $errors[] = "Board with this id does't exist.";
    displayErrorBoxWithBackButton($errors, getLink('forum'));
    return;
}

if (!Forum::hasAccess($section_id)) {
    $errors[] = "You don't have access to this board.";
    displayErrorBoxWithBackButton($errors, getLink('forum'));
    return;
}

$_page = (int)(isset($_REQUEST['page']) ? $_REQUEST['page'] : 0);
$threads_count = $db->query("SELECT COUNT(`" . FORUM_TABLE_PREFIX . "forum`.`id`) AS threads_count FROM `players`, `" . FORUM_TABLE_PREFIX . "forum` WHERE `players`.`id` = `" . FORUM_TABLE_PREFIX . "forum`.`author_guid` AND `" . FORUM_TABLE_PREFIX . "forum`.`section` = " . (int)$section_id . " AND `" . FORUM_TABLE_PREFIX . "forum`.`first_post` = `" . FORUM_TABLE_PREFIX . "forum`.`id`")->fetch();
for ($i = 0; $i < $threads_count['threads_count'] / $config['forum_threads_per_page']; $i++) {
    if ($i != $_page)
        $links_to_pages .= '<a href="' . getForumBoardLink($section_id, $i) . '">' . ($i + 1) . '</a> ';
    else
        $links_to_pages .= '<b>' . ($i + 1) . ' </b>';
}
if (!$logged) {
    ?>
    <p class="ForumWelcome">You are <b>not</b> logged in.<br><a href="?account/manage">Log in</a> to post on the forum.
    </p>
<?php } ?>
<div class="ForumBreadCrumbs"><a href="<?php echo getLink('forum') ?>">Community Boards</a> |
    <b><?php echo $sections[$section_id]['name'] ?></b></div>
<div class="ForumBreadCrumbsSeparator"></div>

<div class="TableContainer">
    <div class="CaptionContainer">
        <div class="CaptionInnerContainer">
            <span class="CaptionEdgeLeftTop"
                  style="background-image:url(<?php echo $template_path ?>/images/global/content/box-frame-edge.gif);"></span>
            <span class="CaptionEdgeRightTop"
                  style="background-image:url(<?php echo $template_path ?>/images/global/content/box-frame-edge.gif);"></span>
            <span class="CaptionBorderTop"
                  style="background-image:url(<?php echo $template_path ?>/images/global/content/table-headline-border.gif);"></span>
            <span class="CaptionVerticalLeft"
                  style="background-image:url(<?php echo $template_path ?>/images/global/content/box-frame-vertical.gif);"></span>
            <?php if (!$sections[$section_id]['closed'] || Forum::isModerator()) { ?>
                <a href="?subtopic=forum&action=new_thread&section_id=<?php echo $section_id ?>">
                    <div class="TableHeaderRightButton">
                        <div class="BigButton"
                             style="background-image:url(<?php echo $template_path ?>/images/global/buttons/sbutton_green.gif)">
                            <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                                <div class="BigButtonOver"
                                     style="background-image: url(<?php echo $template_path ?>/images/global/buttons/sbutton_green_over.gif); visibility: hidden;"></div>
                                <input class="BigButtonText" type="submit" value="New Topic"></div>
                        </div>
                    </div>
                </a>
            <?php } ?>
            <div class="ForumTitleText">Topic List</div>
            <span class="CaptionVerticalRight"
                  style="background-image:url(<?php echo $template_path ?>/images/global/content/box-frame-vertical.gif);"></span>
            <span class="CaptionBorderBottom"
                  style="background-image:url(<?php echo $template_path ?>/images/global/content/table-headline-border.gif);"></span>
            <span class="CaptionEdgeLeftBottom"
                  style="background-image:url(<?php echo $template_path ?>/images/global/content/box-frame-edge.gif);"></span>
            <span class="CaptionEdgeRightBottom"
                  style="background-image:url(<?php echo $template_path ?>/images/global/content/box-frame-edge.gif);"></span>
        </div>
    </div>
    <table class="Table3" cellpadding="0" cellspacing="0">
        <tbody>
        <tr>
            <td>
                <div class="InnerTableContainer">
                    <table style="width:100%;">
                        <tbody>
                        <tr>
                            <td>
                                <div class="TableContentContainer">
                                    <table class="TableContent" width="100%" style="border:1px solid #faf0d7;">
                                        <tbody>

                                        <tr class="LabelH">
                                            <?php if (Forum::isModerator()) { ?>
                                                <td width="5%"></td>
                                            <?php } ?>
                                            <td width="35%">Thread</td>
                                            <td>Thread Starter</td>
                                            <td>Replies</td>
                                            <td>Views</td>
                                            <td>Last Update</td>
                                        </tr>
                                        <?php
                                        $last_threads = $db->query("SELECT `players`.`id` as `player_id`, `players`.`name`, `" . FORUM_TABLE_PREFIX . "forum`.`post_text`, `" . FORUM_TABLE_PREFIX . "forum`.`post_topic`, `" . FORUM_TABLE_PREFIX . "forum`.`id`, `" . FORUM_TABLE_PREFIX . "forum`.`last_post`, `" . FORUM_TABLE_PREFIX . "forum`.`replies`, `" . FORUM_TABLE_PREFIX . "forum`.`views`, `" . FORUM_TABLE_PREFIX . "forum`.`post_date` FROM `players`, `" . FORUM_TABLE_PREFIX . "forum` WHERE `players`.`id` = `" . FORUM_TABLE_PREFIX . "forum`.`author_guid` AND `" . FORUM_TABLE_PREFIX . "forum`.`section` = " . (int)$section_id . " AND `" . FORUM_TABLE_PREFIX . "forum`.`first_post` = `" . FORUM_TABLE_PREFIX . "forum`.`id` ORDER BY `" . FORUM_TABLE_PREFIX . "forum`.`last_post` DESC LIMIT " . $config['forum_threads_per_page'] . " OFFSET " . ($_page * $config['forum_threads_per_page']))->fetchAll();

                                        if (isset($last_threads[0])) {

                                            $player = new OTS_Player();
                                            foreach ($last_threads as $thread) {
                                                echo '<tr bgcolor="' . getStyle($number_of_rows++) . '"><td>';
                                                if (Forum::isModerator()) {
                                                    echo '<a href="?subtopic=forum&action=move_thread&id=' . $thread['id'] . '"\')"><span style="color:darkgreen">[MOVE]</span></a>';
                                                    echo '<a href="?subtopic=forum&action=remove_post&id=' . $thread['id'] . '" onclick="return confirm(\'Are you sure you want remove thread > ' . $thread['post_topic'] . ' <?\')"><span style="color: red">[REMOVE]</span></a></td><td>';
                                                }

                                                $player->load($thread['player_id']);
                                                if (!$player->isLoaded()) {
                                                    throw new RuntimeException('Forum error: Player not loaded.');
                                                }

                                                $player_account = $player->getAccount();
                                                $canEditForum = $player_account->hasFlag(FLAG_CONTENT_FORUM) || $player_account->isAdmin();

                                                echo '<a href="' . getForumThreadLink($thread['id']) . '">' . ($canEditForum ? $thread['post_topic'] : htmlspecialchars($thread['post_topic'])) . '</a>
		<br /><small>' . ($canEditForum ? substr(strip_tags($thread['post_text']), 0, 50) : htmlspecialchars(substr($thread['post_text'], 0, 50))) . '...</small></td><td>' . getPlayerLink($thread['name']) . '</td><td>' . (int)$thread['replies'] . '</td><td>' . (int)$thread['views'] . '</td><td>';
                                                if ($thread['last_post'] > 0) {
                                                    $last_post = $db->query("SELECT `players`.`name`, `" . FORUM_TABLE_PREFIX . "forum`.`post_date` FROM `players`, `" . FORUM_TABLE_PREFIX . "forum` WHERE `" . FORUM_TABLE_PREFIX . "forum`.`first_post` = " . (int)$thread['id'] . " AND `players`.`id` = `" . FORUM_TABLE_PREFIX . "forum`.`author_guid` ORDER BY `post_date` DESC LIMIT 1")->fetch();
                                                    if (isset($last_post['name']))
                                                        echo '<img src="' . $template_path . '/images/global/forum/logo_lastpost.gif" border="0" width="10" height="9"> ' . date('d.m.y H:i:s', $last_post['post_date']) . '<br />by ' . getPlayerLink($last_post['name']);
                                                    else
                                                        echo 'No posts.';
                                                } else
                                                    echo '<img src="' . $template_path . '/images/global/forum/logo_lastpost.gif" border="0" width="10" height="9"> ' . date('d.m.y H:i:s', $thread['post_date']) . '<br />by ' . getPlayerLink($thread['name']);
                                                echo '</td></tr>';
                                            }
                                        } else
                                            echo '<h3>No threads in this board.</h3>';
                                        ?>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td><?php
                                echo 'Page: ' . $links_to_pages . '<br />';

                                ?></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</div>

<br>

<table border="0" cellpadding="2" cellspacing="0" width="100%">
    <tbody>
    <tr>
        <td></td>
        <td>
            <div style="float: right;">
                <?php if (!$sections[$section_id]['closed'] || Forum::isModerator()) { ?>
                    <a href="?subtopic=forum&action=new_thread&section_id=<?php echo $section_id ?>">
                        <div class="BigButton"
                             style="background-image:url(<?php echo $template_path ?>/images/global/buttons/sbutton_green.gif)">
                            <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                                <div class="BigButtonOver"
                                     style="background-image: url(<?php echo $template_path ?>/images/global/buttons/sbutton_green_over.gif); visibility: hidden;"></div>
                                <input class="BigButtonText" type="submit" value="New Topic"></div>
                        </div>
                    </a>
                <?php } ?>
            </div>
        </td>
    </tr>
    </tbody>
</table>

<br>
<b>Board Rights:<br></b>
View threads.
<br><br>
Replace code is ON. Smileys are ON. Images are OFF. Links are ON. "Thank You!" option is OFF.
<br>
Account muting option is ON.
<br>
