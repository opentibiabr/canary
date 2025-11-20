<?php
/**
 * Polls
 *
 * @package   MyAAC
 * @author    Averatec <pervera.pl & otland.net>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Polls';

/* Polls System By Averatec from pervera.pl & otland.net */

function getColorByPercent($percent)
{
	if($percent < 15)
		return 'red';
	else if($percent < 35)
		return 'orange';
	else if($percent < 50)
		return 'yellow';

	return '';
}
	$number_of_rows = 0;
	$showed = false;
    $link = "polls"; // your link to polls in index.php
    $dark = $config['darkborder'];
    $light = $config['lightborder'];
    $time = time();
    $POLLS = $db->query('SELECT * FROM '.$db->tableName('myaac_polls').'');
    $level = 20; // need level to vote

    if(empty($_REQUEST['id']) and (!isset($_REQUEST['control']) || $_REQUEST['control'] != "true"))  // list of polls
    {
        $active = $db->query('SELECT * FROM `myaac_polls` where `end` > '.$time.''); // active polls
        $closed = $db->query('SELECT * FROM `myaac_polls` where `end` < '.$time.' order by `end` desc'); // closed polls
        /* Active Polls */
?>

<b>Welcome to the poll section!</b>
<br>
<br>
Let us and the Tibia community know what you think! Click on an active poll from the list below to get further details and to submit your vote.
<br>
<br>

<div class="TableContainer">
	<div class="CaptionContainer">
			<div class="CaptionInnerContainer">
				<span class="CaptionEdgeLeftTop" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
				<span class="CaptionEdgeRightTop" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
				<span class="CaptionBorderTop" style="background-image:url(<?php echo $template_path; ?>/images/global/content/table-headline-border.gif);"></span>
				<span class="CaptionVerticalLeft" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-vertical.gif);"></span>
				<div class="Text">Active Polls</div>
				<span class="CaptionVerticalRight" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-vertical.gif);"></span>
				<span class="CaptionBorderBottom" style="background-image:url(<?php echo $template_path; ?>/images/global/content/table-headline-border.gif);"></span>
				<span class="CaptionEdgeLeftBottom" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
				<span class="CaptionEdgeRightBottom" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
			</div>
		</div><table class="Table3" cellpadding="0" cellspacing="0">

		<tbody><tr>
			<td>
				<div class="InnerTableContainer">
					<table style="width:100%;">
						<tbody>
<tr><td>
<div class="TableContentContainer">
<table class="TableContent" width="100%" style="border:1px solid #faf0d7;">
<tbody>
<tr bgcolor="#F1E0C6">
<td class="LabelV175" width="70%">Topic</td>
<td class="LabelV175" style="text-align: right;">End</td>
</tr>
<?php

	$empty_active = false;
	foreach($active as $poll) {
		$bgcolor = getStyle($number_of_rows++);
            echo '
            <tr bgcolor="'.$bgcolor.'">
				<td width="70%">
					<a href="';
					if($logged)
						echo '?subtopic='.$link.'&id='.$poll['id'];
					else
						echo '?subtopic=accountmanagement&redirect=' . BASE_URL . urlencode('?subtopic='.$link.'&id='.$poll['id']);

					echo '">'.$poll['question'] . '</a>
				</td>
				<td style="text-align: right;">'.date("M j Y", $poll['end']).'</td>
			</tr>';
			$empty_active = true;
	}

	if(!$empty_active) {
		echo '<tr bgcolor="'.$bgcolor.'"><td colspan=2><div style="text-align:center"><i>There are no active polls.</i></div></td></tr>';
	}
?>
</tbody></table>
</div></td></tr>

					</tbody></table>
				</div>
			</td>
		</tr>
	</tbody></table>
</div>

<br>

<div class="TableContainer">
	<div class="CaptionContainer">
			<div class="CaptionInnerContainer">
				<span class="CaptionEdgeLeftTop" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
				<span class="CaptionEdgeRightTop" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
				<span class="CaptionBorderTop" style="background-image:url(<?php echo $template_path; ?>/images/global/content/table-headline-border.gif);"></span>
				<span class="CaptionVerticalLeft" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-vertical.gif);"></span>
				<div class="Text">Closed Polls</div>
				<span class="CaptionVerticalRight" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-vertical.gif);"></span>
				<span class="CaptionBorderBottom" style="background-image:url(<?php echo $template_path; ?>/images/global/content/table-headline-border.gif);"></span>
				<span class="CaptionEdgeLeftBottom" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
				<span class="CaptionEdgeRightBottom" style="background-image:url(<?php echo $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
			</div>
		</div><table class="Table3" cellpadding="0" cellspacing="0">

		<tbody><tr>
			<td>
				<div class="InnerTableContainer">
					<table style="width:100%;">
						<tbody>
<tr><td>
<div class="TableContentContainer">
<table class="TableContent" width="100%" style="border:1px solid #faf0d7;">
<tbody>
<tr bgcolor="#F1E0C6">
<td class="LabelV175" width="70%">Topic</td>
<td class="LabelV175" style="text-align: right;">End</td>
</tr>
<?php
	$bgcolor = getStyle($number_of_rows++);
		$empty_closed = false;
        foreach($closed as $poll)
        {
            echo '
            <tr bgcolor="'.$bgcolor.'">
				<td width="70%">
					<a href="';
					if($logged)
						echo '?subtopic='.$link.'&id='.$poll['id'];
					else
						echo '?subtopic=accountmanagement&redirect=' . BASE_URL . urlencode('?subtopic='.$link.'&id='.$poll['id']);

					echo '">'.$poll['question'] . '</a>
				</td>
				<td style="text-align: right;">'.date("M j Y", $poll['end']).'</td>
			</tr>';
            $empty_closed = true;
        }

        if(!$empty_closed)
        {
            echo '<tr BGCOLOR="'.$bgcolor.'"><td colspan=2><div style="text-align:center"><i>There are no closed polls.</i></div></td></tr>';
        }
?>
</tbody></table>
</div></td></tr>

					</tbody></table>
				</div>
			</td>
		</tr>
	</tbody></table>
</div>

<br>

<?php
$showed=true;

    }

	if(!$logged)
	{
		echo  'You are not logged in. <a href="?subtopic=accountmanagement&redirect=' . BASE_URL . urlencode('?subtopic=polls') . '">Log in</a> to vote in polls.<br /><br />';
		return;
	}

    /* Checking Account */
	$allow = false;
    $account_players = $account_logged->getPlayers();
    foreach($account_players as $player)
    {
        $player = $player->getLevel();
        if($player >= $level)
        $allow=true;
    }

    if(!empty($_REQUEST['id']) and (!isset($_REQUEST['control']) || $_REQUEST['control'] != "true"))
    {
        foreach($POLLS as $POLL)
        {
            if($_REQUEST['id'] == $POLL['id'])
            {
                $ANSWERS = $db->query('SELECT * FROM '.$db->tableName('myaac_polls_answers').' where `poll_id` = '.addslashes(htmlspecialchars(trim($_REQUEST['id']))).' order by `answer_id`');
                $votes_all = $POLL['votes_all'];

                if($votes_all == 0)
                {
                    $i=1;
                    foreach($ANSWERS as $answer)
                    {
                        $percent[$i] = 0;
                        $i++;
                    }
                }
                else
                {
                    $i=1;
                    foreach($ANSWERS as $answer)
                    {
                        $percent[$i] = round(((100*$answer['votes'])/$votes_all),2);
                        $i++;
                    }
                }
?>
			<style type="text/css" media="screen">
				 div.progress-container {
				 border: 1px solid #ccc;
				 width: 100px;
				 margin: 2px 5px 2px 0;
				 padding: 1px;
				 float: left;
				 background: white;
				}

			   div.progress-container > div {
				 background-color: #ACE97C;
				 height: 12px
			   }
			</style>
<?php
			function slaw_getPercentBar($percent)
			{
				$color = getColorByPercent($percent);
				return '<div class="progress-container" style="width: 100px">
					<div style="width: ' . $percent . '%; ' . ($color != "" ? 'background: ' . $color : '') . '"></div>
				  </div>';
			}

                if($POLL['end'] > $time) // active poll
                {
                    if(isset($_REQUEST['vote']) && $_REQUEST['vote'] == true and $allow == true)
                    {
                        if($account_logged->getCustomField('vote') < $_REQUEST['id'] and !empty($_POST['answer']))
                        {
                            if(isset($_POST['continue']))
                            {
                                $vote = addslashes(htmlspecialchars(trim($_REQUEST['id'])));
                                $account_logged->setCustomField("vote", $vote);
                                $UPDATE_poll = $db->query('UPDATE `myaac_polls` SET `votes_all` = `votes_all` + 1 where `id` = '.addslashes(htmlspecialchars(trim($_REQUEST['id']))).'');
                                $UPDATE_answer = $db->query('UPDATE `myaac_polls_answers` SET `votes` = `votes` + 1 where `answer_id` = '.addslashes(htmlspecialchars($_POST['answer'])).' and`poll_id` = '.addslashes(htmlspecialchars(trim($_REQUEST['id']))).'');
                                header('Location: ?subtopic='.$link.'&id='.$_REQUEST['id'].'');
                            }
                        }
                        else
                        {
                            header('Location: ?subtopic='.$link.'&id='.$_REQUEST['id'].'');
                        }
                    }

                    if($account_logged->getCustomField('vote') < $_REQUEST['id'] and $allow == true)
                    {
                        echo '<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=4 WIDTH=100%><TR BGCOLOR='.$config['vdarkborder'].'><TD COLSPAN=2 class=white><B>Vote</B></TD></TR>';
                        echo '<TR BGCOLOR="'.$dark.'"><td COLSPAN=2><b>'.$POLL['question'].'</b><br/>' . $POLL['description'] . '</td></tr>
                        <form action="?subtopic='.$link.'&id='.$_REQUEST['id'].'&vote=true" method="POST"> ';
                        $ANSWERS_input = $db->query('SELECT * FROM '.$db->tableName('myaac_polls_answers').' where `poll_id` = '.$_REQUEST['id'].' order by `answer_id`');
                        $i=1;
                        foreach($ANSWERS_input as $answer)
                        {
                            if(is_int($i / 2)) {
                                $bgcolor = $dark;
                            }
                            else
                            {
                                $bgcolor = $light;
                            }
                            echo '<tr BGCOLOR="'.$bgcolor.'"><td><input type=radio name=answer value="'.$i.'">'.$answer['answer'].'</td></tr>';
                            $i++;
                        }
                        echo '</table><input type="submit" name="continue" value="Submit" class="input2" /></form><br><br>';
                    }
                    elseif($account_logged->getCustomField('vote') >= $_REQUEST['id'])
                    {
                        $result[] = '<br><b>You have already voted.</b><br>';

						echo '<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=4 WIDTH=100%><TR BGCOLOR='.$config['vdarkborder'].'><TD COLSPAN=3 class=white><B>Results</B></TD></TR>';
						echo '<TR BGCOLOR="'.$dark.'"><td COLSPAN=3><b>'.$POLL['question'].'</b><br/>' . $POLL['description'] . '</td></tr>';
						$ANSWERS_show = $db->query('SELECT * FROM '.$db->tableName('myaac_polls_answers').' where `poll_id` = '.$_REQUEST['id'].' order by `answer_id`');
						$i=1;
						foreach($ANSWERS_show as $answer)
						{
							if(is_int($i / 2)) {
								$bgcolor = $dark;
							}
							else
							{
								$bgcolor = $light;
							}
							$x=0;
						echo '<TR BGCOLOR="'.$bgcolor.'">
							<td width=60%>'.$answer['answer'].'</td>
							<td width=20%>
								' . slaw_getPercentBar($percent[$i]) . '
							</td>
							<td>' . $answer['votes'] . '(<span style="color: ' . getColorByPercent($percent[$i]) . '"><b>' . $percent[$i] . '%</b></span>)</td>
						</tr>';
							$i++;
						}
						echo '</table>';
					}

					$result[] = '<br>All players with a character of at least level ' . $level . ' may vote.<br>';
                    foreach($result as $error)
                    {
                        echo $error;
                    }

                    echo '<br>The poll started at '.date("M j Y", $POLL['start']).'<br>';
                    echo 'The poll will end at '.date("M j Y", $POLL['end']).'<br>';
                    echo '<br>Total votes <b>'.$POLL['votes_all'].'</b><br>';

                }
                else // closed poll
                {
                    echo '<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=4 WIDTH=100%><TR BGCOLOR='.$config['vdarkborder'].'><TD COLSPAN=3 class=white><B>Results</B></TD></TR>';
                    echo '<TR BGCOLOR="'.$dark.'"><td COLSPAN=3><b>'.$POLL['question'].'</b></td></tr>';
                    $ANSWERS_show = $db->query('SELECT * FROM '.$db->tableName('myaac_polls_answers').' where `poll_id` = '.$_REQUEST['id'].' order by `answer_id`');
                    $i=1;
                    foreach($ANSWERS_show as $answer)
                    {
                        if(is_int($i / 2)) {
                            $bgcolor = $dark;
                        }
                        else
                        {
                            $bgcolor = $light;
                        }

					echo '<TR BGCOLOR="'.$bgcolor.'">
						<td width=60%>'.$answer['answer'].'</td>
						<td width=20%>
							' . slaw_getPercentBar($percent[$i]) . '
						</td>
						<td>' . $answer['votes'] . '(<span style="color:' . getColorByPercent($percent[$i]) . '"><b>' . $percent[$i] . '%</b></span>)</td>
					</tr>';
                       $i++;
                    }
                    echo '</table><br><br>';

                    echo '<br>The poll started at '.date("M j Y", $POLL['start']).'<br>';
                    echo 'The poll ended at '.date("M j Y", $POLL['end']).'<br>';
                    echo '<br>Total votes <b>'.$POLL['votes_all'].'</b><br>';

                }
                $showed=true;
                echo '<div class=\'hr1\'></div><a href="?subtopic='.$link.'"><span style="font-size: 13px"><b>Go to list of polls</b></span></a>';
            }
        }
    }

    if(admin() && (!isset($_REQUEST['control']) || $_REQUEST['control'] != "true")) {
?>
<a href="?subtopic=<?php echo $link ?>&control=true">
<div class="BigButton" style="background-image:url(<?php echo $template_path; ?>/images/global/buttons/sbutton.gif)">
	<div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);"><div class="BigButtonOver" style="background-image: url(<?php echo $template_path; ?>/global/buttons/sbutton_over.gif); visibility: hidden;"></div>
		<input class="BigButtonText" type="submit" name="View" alt="View" value="Panel Control"></div>
</div>
</a>
<?php
    }

    /* Control Panel - Only Add Poll Function */

    if(admin() && isset($_REQUEST['control']) && $_REQUEST['control'] == "true")
    {
		$show = false;
        if(isset($_POST['submit']))
        {
            setSession('answers', $_POST['answers']);
            echo '<form method="post" action=""><b><span style="font-size: 16px">Adding Poll</span></b><br><br>
            <input type=text name=question value="" /> Question<br>
            <input type=text name=description value="" /> Description<br>
            <input type=text name=end value="" /> Time to end, in days<br>';

            for( $x = 1; $x <= getSession('answers'); $x++ )
            {
                echo '<input type=text name='.$x.' value="" /> Answer no. '.$x.'<br>';
            }
            echo '<input type="submit" name="finish" value="Submit" class="input2"/></form><br><br>';
            $show=true;
        }

        if(isset($_POST['finish']))
        {
                $id = $db->query('SELECT MAX(id) FROM `myaac_polls`')->fetch();
                $id_next = $id[0] + 1;

                for( $x = 1; $x <= getSession('answers'); $x++ )
                {
                	$db->insert('myaac_polls_answers', array(
                		'poll_id' => $id_next,
						'answer_id' => $x,
						'answer' => $_POST[$x],
						'votes' => 0
					));
                }
                $end = $time+24*60*60*$_POST['end'];
                $db->insert('myaac_polls', array(
                	'id' => $id_next,
					'question' => $_POST['question'],
					'description' => $_POST['description'],
					'end' => $end,
					'answers' => getSession('answers'),
					'start' => $time,
					'votes_all' => 0
				));
        }

        $POLLS_check = $db->query('SELECT MAX(end) FROM '.$db->tableName('myaac_polls').'');
        foreach($POLLS_check as $checked)
        {
            if($checked[0] > $time)
            $check=true;
            else
            $check=false;
        }
        if(!$show)
        {
            if(!$check)
            {
                echo '<form method="post" action=""><b><span style="font-size: 16px">Adding Poll</span></b><br><br>
                <input type=text name=answers value="" /> Number of Answers<br>
                <input type="submit" name="submit" value="Submit" class="input2"/></form><br><br>';
            }
            else
            {
                echo '<b><span style="font-size: 16px"><br>Cannot be two and more active polls.<br><br></span></b>';
            }
        }
        $showed=true;
        echo '<br><div class=\'hr1\'></div><a href="?subtopic='.$link.'"><span style="font-size: 13px"><b>Go to list of polls</b></span></a>';
    }

    if(!$showed)
    {
        echo 'This poll doesn\'t exist.<br>';
        echo '<div class=\'hr1\'></div><a href="?subtopic='.$link.'"><span style="font-size: 13px"><b>Go to list of  polls</b></span></a>';
    }
?>
