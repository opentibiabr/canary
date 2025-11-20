<?php
/**
 * Records
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$title = "Players Online Records";

echo '
<b><div style="text-align:center">Players online records on '.$config['lua']['serverName'].'</div></b>
<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=4 WIDTH=100%>
	<TR BGCOLOR="'.$config['vdarkborder'].'">
		<TD class="white"><b><div style="text-align:center">Players</div></b></TD>
		<TD class="white"><b><div style="text-align:center">Date</div></b></TD>
	</TR>';

	$i = 0;
	$records_query = $db->query('SELECT * FROM `server_record` ORDER BY `record` DESC LIMIT 50;');
	foreach($records_query as $data)
	{
		echo '<TR BGCOLOR=' . getStyle(++$i) . '>
			<TD><div style="text-align:center">' . $data['record'] . '</div></TD>
			<TD><div style="text-align:center">' . date("d/m/Y, G:i:s", $data['timestamp']) . '</div></TD>
		</TR>';
	}

echo '</TABLE>';
?>
