<?php

$query = $db->query("SELECT `id` FROM `" . TABLE_PREFIX . "pages` WHERE `name` LIKE " . $db->quote('rules_on_the_page') . " LIMIT 1;");
if($query->rowCount() === 0) {
	$db->exec("INSERT INTO `myaac_pages` (`id`, `name`, `title`, `body`, `date`, `player_id`, `php`, `enable_tinymce`, `access`, `hidden`) VALUES
	(null, 'rules_on_the_page', 'Rules', '1. Names
a) Names which contain insulting (e.g. \"Bastard\"), racist (e.g. \"Nigger\"), extremely right-wing (e.g. \"Hitler\"), sexist (e.g. \"Bitch\") or offensive (e.g. \"Copkiller\") language.
b) Names containing parts of sentences (e.g. \"Mike returns\"), nonsensical combinations of letters (e.g. \"Fgfshdsfg\") or invalid formattings (e.g. \"Thegreatknight\").
c) Names that obviously do not describe a person (e.g. \"Christmastree\", \"Matrix\"), names of real life celebrities (e.g. \"Britney Spears\"), names that refer to real countries (e.g. \"Swedish Druid\"), names which were created to fake other players\' identities (e.g. \"Arieswer\" instead of \"Arieswar\") or official positions (e.g. \"System Admin\").

2. Cheating
a) Exploiting obvious errors of the game (\"bugs\"), for instance to duplicate items. If you find an error you must report it to CipSoft immediately.
b) Intentional abuse of weaknesses in the gameplay, for example arranging objects or players in a way that other players cannot move them.
c) Using tools to automatically perform or repeat certain actions without any interaction by the player (\"macros\").
d) Manipulating the client program or using additional software to play the game.
e) Trying to steal other players\' account data (\"hacking\").
f) Playing on more than one account at the same time (\"multi-clienting\").
g) Offering account data to other players or accepting other players\' account data (\"account-trading/sharing\").

3. Gamemasters
a) Threatening a gamemaster because of his or her actions or position as a gamemaster.
b) Pretending to be a gamemaster or to have influence on the decisions of a gamemaster.
c) Intentionally giving wrong or misleading information to a gamemaster concerning his or her investigations or making false reports about rule violations.

4. Player Killing
a) Excessive killing of characters who are not marked with a \"skull\" on worlds which are not PvP-enforced. Please note that killing marked characters is not a reason for a banishment.

A violation of the Tibia Rules may lead to temporary banishment of characters and accounts. In severe cases removal or modification of character skills, attributes and belongings, as well as the permanent removal of accounts without any compensation may be considered. The sanction is based on the seriousness of the rule violation and the previous record of the player. It is determined by the gamemaster imposing the banishment.

These rules may be changed at any time. All changes will be announced on the official website.', 0, 1, 0, 0, 1, 0);");
}
