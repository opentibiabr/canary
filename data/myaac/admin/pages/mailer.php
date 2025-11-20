<?php
/**
 * Mailer
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Mailer';

if (!hasFlag(FLAG_CONTENT_MAILER) && !superAdmin()) {
	echo 'Access denied.';
	return;
}

if (!$config['mail_enabled']) {
	echo 'Mail support disabled.';
	return;
}

$mail_content = isset($_POST['mail_content']) ? stripslashes($_POST['mail_content']) : NULL;
$mail_subject = isset($_POST['mail_subject']) ? stripslashes($_POST['mail_subject']) : NULL;
$preview = isset($_REQUEST['preview']);

$preview_done = false;
if ($preview) {
	if (!empty($mail_content) && !empty($mail_subject)) {
		$preview_done = _mail($account_logged->getCustomField('email'), $mail_subject, $mail_content);

		if (!$preview_done)
			error('Error while sending preview mail. More info can be found in system/logs/mailer-error.log');
	}
}


$twig->display('admin.mailer.html.twig', array(
	'mail_subject' => $mail_subject,
	'mail_content' => $mail_content,
	'preview_done' => $preview_done
));

if (empty($mail_content) || empty($mail_subject) || $preview)
	return;

$success = 0;
$failed = 0;

$add = '';
if ($config['account_mail_verify']) {
	note('Note: Sending only to users with verified E-Mail.');
	$add = ' AND ' . $db->fieldName('email_verified') . ' = 1';
}

$query = $db->query('SELECT ' . $db->fieldName('email') . ' FROM ' . $db->tableName('accounts') . ' WHERE ' . $db->fieldName('email') . ' != ""' . $add);
foreach ($query as $email) {
	if (_mail($email['email'], $mail_subject, $mail_content))
		$success++;
	else {
		$failed++;
		echo '<br />';
		error('An error occurred while sending email to <b>' . $email['email'] . '</b>. For Admin: More info can be found in system/logs/mailer-error.log');
	}
}

success('Mailing finished.');
success("$success emails delivered.");
warning("$failed emails failed.");
