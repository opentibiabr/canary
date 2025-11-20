<?php
/**
 * Delete by admin
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$guild_name = isset($_REQUEST['guild']) ? urldecode($_REQUEST['guild']) : null;
if(!Validator::guildName($guild_name)) {
	$errors[] = Validator::getLastError();
}

if(empty($errors)) {
	$guild = new OTS_Guild();
	$guild->find($guild_name);
	if(!$guild->isLoaded()) {
		$errors[] = 'Guild with name <b>' . $guild_name . '</b> doesn\'t exist.';
	}
}

if(empty($errors)) {
	if($logged) {
		if(admin()) {
			$saved = false;
			if(isset($_POST['todo']) && $_POST['todo'] == 'save') {
				delete_guild($guild->getId());
				$saved = true;
			}

			if($saved) {
				$twig->display('success.html.twig', array(
					'title' => 'Guild Deleted',
					'description' => 'Guild with name <b>' . $guild_name . '</b> has been deleted.',
					'custom_buttons' => $twig->render('guilds.back_button.html.twig')
				));
			}
			else {
				$twig->display('success.html.twig', array(
					'title' => 'Delete Guild',
					'description' => 'Are you sure you want delete guild <b>' . $guild_name . '</b>?<br/>
				<form action="?subtopic=guilds&guild=' . $guild->getName() . '&action=delete_by_admin" METHOD="post"><input type="hidden" name="todo" value="save"><input type="submit" value="Yes, delete"></form>',
					'custom_buttons' => $twig->render('guilds.back_button.html.twig')
				));
			}
		}
		else {
			$errors[] = 'You are not an admin!';
		}
	}
	else {
		$errors[] = "You are not logged. You can't delete guild.";
	}
}
if(!empty($errors)) {
	$twig->display('error_box.html.twig', array('errors' => $errors));

	$twig->display('guilds.back_button.html.twig', array(
		'new_line' => true,
		'action' => '?subtopic=guilds'
	));
}
