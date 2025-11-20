<?php
	defined('MYAAC') or die('Direct access not allowed!');

	$img = imagecreatefrompng(SIGNATURES_IMAGES . 'stats.png');
	if(!$img) {
		die('Error while using function imagecreatefrompng. Maybe you got php extension xdebug loaded?');
	}

	$font = SIGNATURES_FONTS . "arialbd.ttf";
	$fontsize = 8;

	$title = imagecolorallocate($img, 160, 160, 160);
	$text = imagecolorallocate($img, 180, 180, 180);
	$bar = imagecolorallocate($img, 0, 0, 0);
	$barfill = imagecolorallocate($img, 200, 0, 0);
	$hpfill = imagecolorallocate($img, 200, 0, 0);
	$manafill = imagecolorallocate($img, 0, 0, 200);

	imagettftext($img, $fontsize, 0, 20, 11, $title, $font, $player->getName() . ' - ' . BASE_URL);

	// experience
	$needexp = OTS_Toolbox::experienceForLevel($player->getLevel() + 1);
	$experience = $player->getExperience();
	if($experience > $needexp) $experience = $needexp;
	imagettftext($img, $fontsize, 0, 15, 30, $text, $font, 'Experience');
	imagettftext($img, $fontsize, 0, 100, 30, $text, $font, number_format($experience)." (".number_format($needexp).")");

	// level
	imagettftext($img, $fontsize, 0, 15, 43, $text, $font, 'Level');
	imagettftext($img, $fontsize, 0, 100, 43, $text, $font, number_format($player->getLevel()));

	// experience bar
	$currLevelExp = OTS_Toolbox::experienceForLevel($player->getLevel());
	$nextLevelExp = OTS_Toolbox::experienceForLevel($player->getLevel() + 1);
	$levelPercent = 0;
	if($nextLevelExp > $currLevelExp)
		$levelPercent = (int)OTS_Player::getPercentLevel($experience - $currLevelExp, $nextLevelExp - $currLevelExp);

	imagerectangle($img, 14, 46, 166, 50, $bar);
	if($levelPercent > 0)
		imagefilledrectangle($img, 15, 47, $levelPercent * 1.5 + 15, 49, $barfill);

	imagettftext($img, $fontsize, 0, 170, 51, $text, $font, $levelPercent . '%');

	// vocation
	$vocation = 'Unknown';
	if(isset($config['vocations'][$player->getVocation()]))
		$vocation = $config['vocations'][$player->getVocation()];
	
	imagettftext($img, $fontsize, 0, 15, 62, $text, $font, 'Vocation');
	imagettftext($img, $fontsize, 0, 100, 62, $text, $font, $vocation);

	// hit points, Mana, Soul Points, Capacity
	$health = $player->getHealth();
	if($health > $player->getHealthMax())
		$health = $player->getHealthMax();

	$empty = imagecreatefrompng('images/empty.png');
	//imagerectangle($img, 39, 67, 141, 75, $bar);
	$fillhp = round($player->getHealth()/$player->getHealthMax() * 100);
	//imagefilledrectangle($img, 40, 68, 40+$fillhp, 74, $hpfill);
	$healthicon = imagecreatefrompng('images/hpicon.png');
	imagecopy($img, $healthicon, 15, 65, 0, 0, 12, 12);
	$healthfg = imagecreatefrompng('images/healthfull.png');
	imagecopy($img, $empty, 32, 65, 0, 0, 100, 12);
	imagecopy($img, $healthfg, 32, 65, 0, 0, $fillhp, 12);
	//imagettftext($img, $fontsize, 0, 15, 75, $text, $font, "Hit Points");
	imagettftext($img, $fontsize, 0, 140, 75, $text, $font, $player->getHealth());

	//imagerectangle($img, 39, 80, 141, 88, $bar);
	$mana = $player->getMana();
	if($mana > $player->getManaMax())
		$mana = $player->getManaMax();

	$fillmana = 0;
	if($player->getMana() > 0 && $player->getManaMax() > 0)
		$fillmana = round($player->getMana()/$player->getManaMax() * 100);

	//imagefilledrectangle($img, 40, 81, 40+$fillmana, 87, $manafill);
	$manaicon = imagecreatefrompng('images/manaicon.png');
	imagecopy($img, $manaicon, 15, 79, 0, 0, 12, 10);
	$manafg = imagecreatefrompng('images/manafull.png');
	imagecopy($img, $empty, 32, 78, 0, 0, 100, 12);
	imagecopy($img, $manafg, 32, 78, 0, 0, $fillmana, 12);
	//imagettftext($img, $fontsize, 0, 15, 88, $text, $font, "Mana");
	imagettftext($img, $fontsize, 0, 140, 88, $text, $font, $player->getMana());

	imagettftext($img, $fontsize, 0, 15, 101, $text, $font, 'Soul Points');
	imagettftext($img, $fontsize, 0, 100, 101, $text, $font, number_format($player->getSoul()));
	imagettftext($img, $fontsize, 0, 15, 114, $text, $font, 'Capacity');
	imagettftext($img, $fontsize, 0, 100, 114, $text, $font, number_format($player->getCap()));

	// magic Level
	imagettftext($img, $fontsize, 0, 15, 127, $text, $font, 'Magic Level');
	imagettftext($img, $fontsize, 0, 100, 127, $text, $font, number_format($player->getMagLevel()));

	// premium status
	$account = $player->getAccount();
	imagettftext($img, $fontsize, 0, 15, 140, $text, $font, $account->getPremDays() > 0 ? 'Premium Account': 'Free Account');

	imagefilledrectangle($img, 225, 40, 225, 130, $title); //seperator
	$posy = 50;
	
	if($db->hasColumn('players', 'skill_fist')) {// tfs 1.0+
		$skills_db = $db->query('SELECT `skill_fist`, `skill_club`, `skill_sword`, `skill_axe`, `skill_dist`, `skill_shielding`, `skill_fishing` FROM `players` WHERE `id` = ' . $player->getId())->fetch();
		
		$skill_ids = array(
			POT::SKILL_FIST => 'skill_fist',
			POT::SKILL_CLUB => 'skill_club',
			POT::SKILL_SWORD => 'skill_sword',
			POT::SKILL_AXE => 'skill_axe',
			POT::SKILL_DIST => 'skill_dist',
			POT::SKILL_SHIELD => 'skill_shielding',
			POT::SKILL_FISH => 'skill_fishing',
		);
		
		$skills = array();
		foreach($skill_ids as $skillid => $field_name) {
			$skills[] = array('skillid' => $skillid, 'value' => $skills_db[$field_name]);
		}
	}
	else {
		$skills = $db->query('SELECT ' . $db->fieldName('skillid') . ', ' . $db->fieldName('value') . ' FROM ' . $db->tableName('player_skills') . ' WHERE ' . $db->fieldName('player_id') . ' = ' . $player->getId() . ' LIMIT 7');
	}

	foreach($skills	as $skill)
	{
		imagettftext($img, $fontsize, 0, 235, $posy, $text, $font, getSkillName($skill['skillid']));
		imagettftext($img, $fontsize, 0, 360, $posy, $text, $font, $skill['value']);
		$posy = $posy + 13;
	}

	imagepng($img, SIGNATURES_CACHE . $player->getID() . '.png');
	imagedestroy($img);
?>
