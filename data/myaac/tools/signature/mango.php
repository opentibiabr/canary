<?php
	defined('MYAAC') or die('Direct access not allowed!');

	/**
	ALTER TABLE `players` ADD `madphp_signature` TINYINT( 4 ) NOT NULL DEFAULT '1' COMMENT 'Absolute Mango © MadPHP.org', ADD `madphp_signature_bg` VARCHAR( 50 ) NOT NULL COMMENT 'Absolute Mango © MadPHP.org' AFTER `madphp_signature`, ADD `madphp_signature_eqs` TINYINT( 4 ) NOT NULL DEFAULT '0' COMMENT 'Absolute Mango © MadPHP.org' AFTER `madphp_signature_bg`, ADD `madphp_signature_bars` TINYINT( 4 ) NOT NULL DEFAULT '1' COMMENT 'Absolute Mango © MadPHP.org' AFTER `madphp_signature_eqs`, ADD `madphp_signature_cache` INT( 11 ) NOT NULL COMMENT 'Absolute Mango © MadPHP.org' AFTER `madphp_signature_bars`;
	**/

	/** Load the MadGD class **/
	require 'gd.class.php';
	/** Default values **/
	list( $i, $eachRow, $percent ) = array( .5, 14, array( 'size' => 7 ) );
	/** Get experience points for a certain level **/
	function getExpToLevel( $level )
	{
		return ( 50 / 3 ) * pow( $level, 3 ) - ( 100 * pow( $level, 2 ) ) + ( ( 850 / 3 ) * $level ) - 200;
	}

	/** Sprite settings **/
	$spr_path = SIGNATURES_DATA.'Tibia.spr';
	$dat_path = SIGNATURES_DATA.'Tibia.dat';
	$otb_path = SIGNATURES_DATA.'items.otb';

	$background = 'default.png';
	if ( !file_exists( SIGNATURES_BACKGROUNDS.$background ) )
	{
		header( 'Content-type: image/png' );
		readfile( SIGNATURES_IMAGES . 'nobackground.png' );
		exit;
	}

	$MadGD = new MadGD( SIGNATURES_BACKGROUNDS.$background );
	$MadGD->testMode = false;

	$MadGD->setDefaultStyle( SIGNATURES_FONTS.'arialbd.ttf', SIGNATURES_FONTS.'arialbd.ttf', 8 );
	$MadGD->setEquipmentBackground( SIGNATURES_IMAGES.'equipments.png' );

	/** NAME **/
	$MadGD->addText( 'Name:', $MadGD->textBold )->setPosition( 10, $i * $eachRow );
	$MadGD->addText( $player->getName(), ( $player->isOnline() ? array( 'color' => '5df82d' ) : array( ) ) )->setPosition( ); $i++;
	/** SEX **/
	$MadGD->addText( 'Sex:', $MadGD->textBold )->setPosition( 10, $i * $eachRow );
	$player_sex = 'unknown';
	if(isset($config['genders'][$player->getSex()]))
		$player_sex = strtolower($config['genders'][$player->getSex()]);
	$MadGD->addText($player_sex)->setPosition( ); $i++;
	/** PROFESSION **/
	$vocation = 'Unknown';
	if(isset($config['vocations'][$player->getVocation()]))
		$vocation = $config['vocations'][$player->getVocation()];

	$MadGD->addText( 'Profession:', $MadGD->textBold )->setPosition( 10, $i * $eachRow );
	$MadGD->addText( $vocation )->setPosition( ); $i++;
	/** LEVEL **/
	$MadGD->addText( 'Level:', $MadGD->textBold )->setPosition( 10, $i * $eachRow );
	$MadGD->addText( $player->getLevel() )->setPosition( ); $i++;
	/** WORLD **/
	if($config['multiworld']) {
		$MadGD->addText( 'World:', $MadGD->textBold )->setPosition( 10, $i * $eachRow );
		$MadGD->addText( $config['worlds'][$player->getWorldId()] )->setPosition( ); $i++;
	}

	/** RESIDENCE **/
	$MadGD->addText( 'Residence:', $MadGD->textBold )->setPosition( 10, $i * $eachRow );
	$MadGD->addText( $config['towns'][$player->getTownId()] )->setPosition( ); $i++;

	/** HOUSE **/
	$town = 'town';
	if($db->hasColumn('houses', 'town_id'))
		$town = 'town_id';
	else if($db->hasColumn('houses', 'townid'))
		$town = 'townid';

	$house = $db->query( 'SELECT `houses`.`name`, `houses`.`' . $town . '` as town FROM `houses` WHERE `houses`.`owner` = '.$player->getId().';' )->fetchAll();
	if ( count( $house ) != 0 )
	{
		$MadGD->addText( 'House:', $MadGD->textBold )->setPosition( 10, $i * $eachRow );
		$MadGD->addText( $house[0]['name'].' ('.$towns_list[$player->getWorldId()][$house[0]['town']].')' )->setPosition( ); $i++;
	}
	/** GUILD **/
	$rank = $player->getRank();
	if ($rank->isLoaded())
	{
		$MadGD->addText( 'Guild membership:', $MadGD->textBold )->setPosition( 10, $i * $eachRow );
		$MadGD->addText( $rank->getName().' of the '.$player->getRank()->getGuild()->getName() )->setPosition( ); $i++;
	}
	/** LAST LOGIN **/
	$MadGD->addText( 'Last login:', $MadGD->textBold )->setPosition( 10, $i * $eachRow );
	$MadGD->addText( ( $player->getLastLogin() == 0 ? 'Never logged in' : date( 'M d Y, H:i:s T', $player->getLastLogin() ) ) )->setPosition( ); $i++;
	/** ACCOUNT STATUS **/
	$MadGD->addText( 'Account Status:', $MadGD->textBold )->setPosition( 10, $i * $eachRow );
	$MadGD->addText( ( $player->getAccount()->getPremDays() > 0 ? 'Premium Account' : 'Free Account' ) )->setPosition( ); $i++;

	$MadGD->addIcon( SIGNATURES_IMAGES.'bg.png' )->setPosition( 200, 45 );
	$MadGD->addIcon( SIGNATURES_IMAGES.'bg.png' )->setPosition( 200, 54 );
	$MadGD->addIcon( SIGNATURES_IMAGES.'bg.png' )->setPosition( 200, 63 );

	/** HEALTH BAR **/
	$MadGD->addText( 'HP:', $percent )->setPosition( 182, 40 );
	if ( ( $player->getHealth() > $player->getHealthMax() ) or (  $player->getHealth() > 0 and $player->getHealthMax() > 0 ) )
	{
		$MadGD->addIcon( SIGNATURES_IMAGES.'health.png', $player->getHealth() / $player->getHealthMax() * 100 )->setPosition( 201, 46 );
		$MadGD->addText( floor( $player->getHealth() / $player->getHealthMax() * 100 ).'%', $percent )->setPosition( 305, 40 );
	}
	else
	{
		$MadGD->addIcon( SIGNATURES_IMAGES.'health.png', 100 )->setPosition( 201, 46 );
		$MadGD->addText( '100%', $percent )->setPosition( 305, 40 );
	}
	/** MANA BAR **/
	$MadGD->addText( 'MP:', $percent )->setPosition( 180, 50 );
	if ( ( $player->getMana() > $player->getManaMax() ) or ( $player->getMana() > 0 and $player->getManaMax() > 0 ) )
	{
		$MadGD->addIcon( SIGNATURES_IMAGES.'mana.png', $player->getMana() / $player->getManaMax() * 100 )->setPosition( 201, 55 );
		$MadGD->addText( floor( $player->getMana() / $player->getManaMax() * 100 ).'%', $percent )->setPosition( 305, 50 );
	}
	else
	{
		$MadGD->addIcon( SIGNATURES_IMAGES.'mana.png', 100 )->setPosition( 201, 55 );
		$MadGD->addText( '100%', $percent )->setPosition( 305, 50 );
	}
	/** EXPERIENCE BAR **/
	$MadGD->addText( 'EXP:', $percent )->setPosition( 176, 60 );
	if ( $player->getExperience() > 0 and ( $player->getExperience() / getExpToLevel( $player->getLevel() + 1 ) * 100 ) <= 100 )
	{
		$MadGD->addIcon( SIGNATURES_IMAGES.'exp.png', $player->getExperience() / getExpToLevel( $player->getLevel() + 1 ) * 100 )->setPosition( 201, 64 );
		$MadGD->addText( floor( $player->getExperience() / getExpToLevel( $player->getLevel() + 1 ) * 100 ).'%', $percent )->setPosition( 305, 60 );
	}
	else
	{
		$MadGD->addIcon( SIGNATURES_IMAGES.'exp.png', 100 )->setPosition( 201, 64 );
		$MadGD->addText( '100%', $percent )->setPosition( 305, 60 );
	}

	$slots = array(
		2 => array( $MadGD->equipment['x']['amulet'],      $MadGD->equipment['y']['amulet'] ),
		1 => array( $MadGD->equipment['x']['helmet'],      $MadGD->equipment['y']['helmet'] ),
		3 => array( $MadGD->equipment['x']['backpack'],    $MadGD->equipment['y']['backpack'] ),
		6 => array( $MadGD->equipment['x']['lefthand'],    $MadGD->equipment['y']['lefthand'] ),
		4 => array( $MadGD->equipment['x']['armor'],       $MadGD->equipment['y']['armor'] ),
		5 => array( $MadGD->equipment['x']['righthand'],   $MadGD->equipment['y']['righthand'] ),
		9 => array( $MadGD->equipment['x']['ring'],        $MadGD->equipment['y']['ring'] ),
		7 => array( $MadGD->equipment['x']['legs'],        $MadGD->equipment['y']['legs'] ),
		10 => array( $MadGD->equipment['x']['ammunition'], $MadGD->equipment['y']['ammunition'] ),
		8 => array( $MadGD->equipment['x']['boots'],       $MadGD->equipment['y']['boots'] )
	);
	foreach ( $slots as $pid => $position )
	{
		$item = $db->query( 'SELECT `itemtype`, `attributes` FROM `player_items` WHERE `player_items`.`player_id` = '.$player->getId().' AND `player_items`.`pid` = '.$pid.';' )->fetch();
		if ( $item['itemtype'] != null )
		{
			$count = unpack( 'C*', $item['attributes'] );
			if ( isset( $count[2] ) ) {
				$count = $count[2];
			}
			else {
				$count = 1;
			}

			$imagePath = SIGNATURES_ITEMS . ( $count > 1 ? $item['itemtype'].'/'.$count : $item['itemtype'] ).'.gif';
			//}
			if ( file_exists( $imagePath ) ) {
				$MadGD->addIcon( $imagePath )->setPosition( $position[0], $position[1] );
			}
			else {
				$MadGD->addIcon( SIGNATURES_IMAGES.'noitem.png' )->setPosition( $position[0], $position[1] );
			}
		}
	}

	$MadGD->save($player->getID());
?>
