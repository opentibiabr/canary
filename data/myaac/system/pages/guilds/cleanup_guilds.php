<?php
/**
 * Cleanup guilds
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

if(!$logged)
{
	echo "You are not logged in.";
	$twig->display('guilds.back_button.html.twig');
	return;
}

$guilds_list = new OTS_Guilds_List();
$guilds_list->init();
if(count($guilds_list) > 0)
{
	foreach($guilds_list as $guild)
	{
		$error = 0;
		$leader = $guild->getOwner();
		if($leader->isLoaded())
		{
			$leader_rank = $leader->getRank();
			if($leader_rank->isLoaded())
			{
				if($leader_rank->isLoaded())
				{
					$leader_guild = $leader_rank->getGuild();
					if($leader_guild->isLoaded())
					{
						if($leader_guild->getId() != $guild->getId())
							$error = 1;
					}
					else
						$error = 1;
				}
				else
					$error = 1;
			}
			else
				$error = 1;
		}
		else
			$error = 1;
		if($error == 1)
		{
			$deleted_guilds[] = $guild->getName();
			$status = delete_guild($guild->getId());
		}
	}
	echo "<b>Deleted guilds (leaders of this guilds are not members of this guild [fix bugged guilds]):</b>";
	if(!empty($deleted_guilds))
		foreach($deleted_guilds as $guild)
			echo "<li>".$guild;
}
else
	echo "0 guilds found.";

$twig->display('guilds.back_button.html.twig');
