<?php
/**
 * PHP Info
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'PHP Info';

if (!function_exists('phpinfo')) { ?>
	<b>phpinfo()</b> function is disabled in your webserver config.<br/>
	You can enable it by editing <b>php.ini</b> file.
	<?php return;
}
?>
<iframe src="<?php echo BASE_URL; ?>admin/tools/phpinfo.php" width="1024" height="550"/>
