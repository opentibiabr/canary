<?php
/**
 * Visitors viewer
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Visitors';

if (!$config['visitors_counter']): ?>
	Visitors counter is disabled.<br/>
	You can enable it by editing this configurable in <b>config.local.php</b> file:<br/>
	<p style="margin-left: 3em;"><b>$config['visitors_counter'] = true;</b></p>
	<?php
	return;
endif;

require SYSTEM . 'libs/visitors.php';
$visitors = new Visitors($config['visitors_counter_ttl']);

function compare($a, $b)
{
	return $a['lastvisit'] > $b['lastvisit'] ? -1 : 1;
}

$tmp = $visitors->getVisitors();
usort($tmp, 'compare');

$twig->display('admin.visitors.html.twig', array(
	'config_visitors_counter_ttl' => $config['visitors_counter_ttl'],
	'visitors' => $tmp
));
?>
