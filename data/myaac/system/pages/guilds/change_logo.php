<?php
/**
 * Change guild logo
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
		$errors[] = 'Guild with name <b>'.$guild_name.'</b> doesn\'t exist.';
	}
}

if(empty($errors)) {
	if($logged) {
		$guild_leader_char = $guild->getOwner();
		$guild_leader = false;
		$account_players = $account_logged->getPlayers();

		foreach($account_players as $player) {
			if($guild_leader_char->getId() == $player->getId()) {
				$guild_vice = true;
				$guild_leader = true;
				$level_in_guild = 3;
			}
		}

		if($guild_leader)
		{
			$max_image_size_b = $config['guild_image_size_kb'] * 1024;
			$allowed_ext = array('image/gif', 'image/jpg', 'image/pjpeg', 'image/jpeg', 'image/bmp', 'image/png', 'image/x-png');
			$ext_name = array('image/gif' => 'gif', 'image/jpg' => 'jpg', 'image/jpeg' => 'jpg', 'image/pjpeg' => 'jpg', 'image/bmp' => 'bmp', 'image/png' => 'png', 'image/x-png' => 'png');
			$save_file_name = str_replace(' ', '_', strtolower($guild->getName()));
			$save_path = 'images/guilds/' . $save_file_name;
			if(isset($_REQUEST['todo']) && $_REQUEST['todo'] == 'save')
			{
				$file = $_FILES['newlogo'];
				if(is_uploaded_file($file['tmp_name']))
				{
					if($file['size'] > $max_image_size_b) {
						$upload_errors[] = 'Uploaded image is too big. Size: <b>'.$file['size'].' bytes</b>, Max. size: <b>'.$max_image_size_b.' bytes</b>.';
					}

					$type = strtolower($file['type']);
					if(!in_array($type, $allowed_ext)) {
						$upload_errors[] = 'Your file type isn\' allowed. Allowed: <b>gif, jpg, bmp, png</b>. Your file type: <b>'.$type.'</b> If it\'s valid image contact with admin.';
					}
				}
				else {
					$upload_errors[] = 'You didn\'t send file or file is too big. Limit: <b>'.$config['guild_image_size_kb'].' KB</b>.';
				}

				if(empty($upload_errors)) {
					$extension = $ext_name[$type];
					if(!move_uploaded_file($file['tmp_name'], $save_path.'.'.$extension)) {
						$upload_errors[] = "Sorry! Can't save your image.";
					}
				}

				if(empty($upload_errors))
				{
					$guild_logo = $guild->getCustomField('logo_name');
					$guild_logo = str_replace(array('..', '/', '\\'), array('','',''), $guild->getCustomField('logo_name'));
					if(empty($guild_logo) || !file_exists('images/guilds/' . $guild_logo)) {
						$guild_logo = "default.gif";
					}

					if($guild_logo != "default.gif" && $guild_logo != $save_file_name.'.'.$extension) {
						unlink('images/guilds/' . $guild_logo);
					}
				}

				//show errors or save file
				if(!empty($upload_errors)) {
					$twig->display('error_box.html.twig', array('errors' => $upload_errors));
				}
				else {
					success('Logo has been changed.');
					$guild->setCustomField('logo_name', $save_file_name.'.'.$extension);
				}
			}

			$guild_logo = $guild->getCustomField('logo_name');
			if(empty($guild_logo) || !file_exists('images/guilds/' . $guild_logo)) {
				$guild_logo = "default.gif";
			}

			$twig->display('guilds.change_logo.html.twig', array(
				'guild_logo' => $guild_logo,
				'guild' => $guild,
				'max_image_size_b' => $max_image_size_b
			));

		}
		else {
			$errors[] = 'You are not a leader of guild!';
		}
	}
	else
	{
		$errors[] = 'You are not logged. You can\'t manage guild.';
	}
}
if(!empty($errors)) {
	$twig->display('error_box.html.twig', array('errors' => $errors));

	$twig->display('guilds.back_button.html.twig', array(
		'new_line' => true,
		'action' => '?subtopic=guilds'
	));
}
