<?php
defined('MYAAC') or die('Direct access not allowed!');

$guild_name = isset($_REQUEST['guild']) ? urldecode($_REQUEST['guild']) : NULL;
$name = isset($_REQUEST['name']) ? stripslashes($_REQUEST['name']) : NULL;

if(empty($errors)) {
	$guild = new OTS_Guild();
	$guild->find($guild_name);
	if(!$guild->isLoaded()) {
		$errors[] = 'Guild with name <b>'.$guild_name.'</b> doesn\'t exist.';
	}
}

$guild_name = $guild->getName();
$title = $guild_name . ' - ' . $title;

$guild_owner = $guild->getOwner();
$rank_list = $guild->getGuildRanksList();
$rank_list->orderBy('level', POT::ORDER_DESC);

$guild_leader = false;
$guild_vice = false;
$level_in_guild = 0;

$players_from_account_in_guild = array();
$players_from_account_ids = array();
if($logged)
{
    $account_players = $account_logged->getPlayers();
    foreach($account_players as $player)
    {
        $players_from_account_ids[] = $player->getId();
        $player_rank = $player->getRank();
        if($player_rank->isLoaded())
        {
            foreach($rank_list as $rank_in_guild)
            {
                if($guild_owner->isLoaded() && $rank_in_guild->isLoaded() && $player_rank->isLoaded() &&
                    $rank_in_guild->getId() == $player_rank->getId())
                {
                    $players_from_account_in_guild[] = $player->getName();
                    if($guild_owner->getId() == $player->getId())
                    {
                        $guild_vice = true;
                        $guild_leader = true;
                    }
                    else if($player_rank->getLevel() > 1)
                    {
                        $guild_vice = true;
                        $level_in_guild = $player_rank->getLevel();
                    }
                }
            }
        }
    }
}

// GET GUILDS
$myguild_id = $guild->getId();
$guilds_list = new OTS_Guilds_List();
$guilds_list->orderBy("name");
$guilds_war_list = $db->query('SELECT `guild1`, `guild2` FROM `guild_wars`')->fetch();
$guilds = array();
if(count($guilds_list) > 0){
    foreach ($guilds_list as $guild) {
		if($guild->getName() != $guild_name){ // NO SHOW MY GUILD
			if($guilds_war_list['guild1'] != $myguild_id && $guilds_war_list['guild2'] != $guild->getId()){
				if($guilds_war_list['guild1'] != $guild->getId() && $guilds_war_list['guild2'] != $myguild_id){
					$guildId = $guild->getId();
					$guildName = $guild->getName();
					$guilds[] = array('id' => $guildId, 'name' => $guildName);
				}
			}
		}
    }
};
// GET GUILDS


$guild_owner = $guild->getOwner();
if($guild_owner->isLoaded()){
    $guild_owner_name = $guild_owner->getName();
}

$show = true;

if(!empty($errors)){
	$twig->display('error_box.html.twig', array('errors' => $errors));
}else{
	$twig->display('guilds.guildwars_declare.html.twig', array(
		'guilds' => $guilds,
		'guild_name' => $guild_name,
		'guild_owner' => $guild_owner_name,
		'isLeader' => $guild_leader,
		'isVice' => $guild_vice,
		'logged' => $logged,
	));
}

// CREATE WAR
if(!empty($errors)) {
	$twig->display('error_box.html.twig', array('errors' => $errors));
}
else {
	if(isset($_REQUEST['war_st']) && $_REQUEST['war_st'] == 'save') {
		if(isset($_REQUEST['war_opp']) && $_REQUEST['war_days'] > 7 && $_REQUEST['war_kills'] > 10){
	
		
	$opp_id = $_REQUEST['war_opp']; // opponent
	$war_days = $_REQUEST['war_days'];
	$war_kills = $_REQUEST['war_kills'];
	$war_price = $_REQUEST['war_price']; // my guild gold
	$war_comment = $_REQUEST['war_comment'];
	
	$opp_guilds_list = new OTS_Guilds_List();
	foreach ($opp_guilds_list as $opp_guild) {
		if($opp_guild->getId() == $opp_id){
			$opp_name = $opp_guild->getName();
		}
	}
		
	$myguild_id = $guild->getId();
	$myguild_name = $guild->getName();
	$war_status = 1;
	
	$insert_war = $db->exec("INSERT INTO `guild_wars` (`guild1`, `guild2`, `name1`, `name2`, `status`, `duration`, `kills`, `price`, `comment`) VALUES ('".intval($myguild_id)."', '".intval($opp_id)."', '".$myguild_name."', '".$opp_name."', '1', '".$war_days."', '".$war_kills."', '".$war_price."', '".$war_comment."');");

		$twig->display('success.html.twig', array(
			'title' => 'Success Declared War',
			'description' => 'You declared a war against the '.$opp_name.' guild. ',
			'custom_buttons' => ''
		));
		$show = false;
	
	
		}
	}
}





?>