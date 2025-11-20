<?php
	defined('MYAAC') or die('Direct access not allowed!');

	$font = SIGNATURES_FONTS . 'font.ttf';
	$fontsize = 12;

	$image = imagecreatefrompng(SIGNATURES_BACKGROUNDS . 'signature.png');
	$color= imagecolorallocate($image , 255, 255, 255);
	imagettftext($image , 12, 0, 20, 32, $color, $font, 'Name:');
	imagettftext($image , 12, 0, 70, 32, $color, $font, $player->getName());

	$vocation = 'Unknown vocation';
	if(isset($config['vocations'][$player->getVocation()]))
		$vocation = $config['vocations'][$player->getVocation()];
	
	imagettftext($image , $fontsize, 0, 20, 52, $color, $font, 'Level:');
	imagettftext($image , $fontsize, 0, 70, 52, $color, $font, $player->getLevel() . ' ' . $vocation);

	$rank = $player->getRank();
	if($rank->isLoaded())
	{
		imagettftext($image , $fontsize, 0, 20, 75, $color, $font, 'Guild:');
		imagettftext($image , $fontsize, 0, 70, 75, $color, $font, $player->getRank()->getName() . ' of the ' . $rank->getGuild()->getName());
	}
	imagettftext($image , $fontsize, 0, 20, 95, $color, $font, 'Last Login:');
	imagettftext($image , $fontsize, 0, 100, 95, $color, $font, (($player->getLastLogin() > 0) ? date("j F Y, g:i a", $player->getLastLogin()) : 'Never logged in.'));
	imagepng($image, SIGNATURES_CACHE . $player->getID() . '.png');
	imagedestroy($image);
?>