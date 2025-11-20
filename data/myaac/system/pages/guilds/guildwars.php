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

$guild_owner = $guild->getOwner();
if($guild_owner->isLoaded()){
    $guild_owner_name = $guild_owner->getName();
}

$wars_list = $db->query('SELECT `id`, `guild1`, `guild2`, `name1`, `name2`, `status`, `duration`, `kills`, `price` FROM `guild_wars`');
$wars_list = $wars_list->fetch();

$countkills_list = $db->query('SELECT `id`, `killerguild`, `targetguild`, `warid`, `time` FROM `guildwar_kills`');
$countkills_list = $countkills_list->fetch();


if($wars_list['status'] == 0){
	$wars_list_status = 'None';
	$wars_list_helper = 'None';
	$wars_list_color = 'red';
}elseif($wars_list['status'] == 1){
	$wars_list_status = 'Invited';
	$wars_list_helper = 'War must be accepted.';
	$wars_list_color = '#fd8202';
}elseif($wars_list['status'] == 2){
	$wars_list_status = 'Accepted';
	$wars_list_helper = 'War in progress.';
	$wars_list_color = 'green';
}elseif($wars_list['status'] == 3){
	$wars_list_status = 'Closed';
	$wars_list_helper = 'War ended.';
	$wars_list_color = 'red';
}elseif($wars_list['status'] == 4){
	$wars_list_status = 'Rejected';
	$wars_list_helper = 'War rejected.';
	$wars_list_color = 'red';
}else{
	$wars_list_status = 'None';
	$wars_list_helper = 'None';
	$wars_list_color = 'red';
}

if($_POST['war_guild'] == $wars_list['name1']){
	$wars_list_name = $wars_list['name2'];
}else{
	$wars_list_name = $wars_list['name1'];
}

$wars_list_price = number_format($wars_list['price'], 0, ',', ',');
$wars[] = array('id' => $wars_list['id'],
				'guild1' => $wars_list['guild1'],
				'guild2' => $wars_list['guild2'],
				'name' => $wars_list_name,
				'statusid' => $wars_list['status'],
				'status' => $wars_list_status,
				'statushelper' => $wars_list_helper,
				'statuscolor' => $wars_list_color,
				'duration' => $wars_list['duration'],
				'kills' => $wars_list['kills'],
				'price' => $wars_list_price,
			   );

$show = true;
if(!empty($errors)){
	$twig->display('error_box.html.twig', array('errors' => $errors));
}else{
	$twig->display('guilds.guildwars.html.twig', array(
		'wars' => $wars,
		'guild_name' => $guild_name,
		'guild_owner' => $guild_owner_name,
		'isLeader' => $guild_leader,
		'isVice' => $guild_vice,
		'logged' => $logged,
	));
}
$status_acpt = '2';
$status_rej = '4';
if(isset($_POST['war_acpt']) && !empty($_POST['war_acpt'])){
	$acpt_war = $db->query('UPDATE guild_wars SET `status` = '.$status_acpt.' WHERE `id` = '.$_POST['war_acpt'].'');
}
if(isset($_POST['war_rej']) && !empty($_POST['war_rej'])){
	$acpt_war = $db->query('UPDATE `guild_wars` SET `status` = '.$status_rej.' WHERE `id` = '.$_POST['war_rej'].'');
}

?>