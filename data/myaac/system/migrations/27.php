<?php

$query = $db->query("SELECT `id` FROM `" . TABLE_PREFIX . "pages` WHERE `name` LIKE " . $db->quote('downloads') . " LIMIT 1;");
if($query->rowCount() === 0) {
	$db->exec("INSERT INTO `myaac_pages` (`id`, `name`, `title`, `body`, `date`, `player_id`, `php`, `access`, `hidden`) VALUES
	(null, 'downloads', 'Downloads', '<p>&nbsp;</p>
<p>&nbsp;</p>
<div style=\"text-align: center;\">We''re using official Tibia Client <strong>{{ config.client / 100 }}</strong><br />
<p>Download Tibia Client <strong>{{ config.client / 100 }}</strong>&nbsp;for Windows <a href=\"https://drive.google.com/drive/folders/0B2-sMQkWYzhGSFhGVlY2WGk5czQ\" target=\"_blank\" rel=\"noopener\">HERE</a>.</p>
<h2>IP Changer:</h2>
<a href=\"https://static.otland.net/ipchanger.exe\" target=\"_blank\" rel=\"noopener\">HERE</a></div>', 0, 1, 0, 1, 0);");
}

$query = $db->query("SELECT `id` FROM `" . TABLE_PREFIX . "pages` WHERE `name` LIKE " . $db->quote('commands') . " LIMIT 1;");
if($query->rowCount() === 0) {
	$db->exec("INSERT INTO `myaac_pages` (`id`, `name`, `title`, `body`, `date`, `player_id`, `php`, `access`, `hidden`) VALUES
(null, 'commands', 'Commands', '<table style=\"border-collapse: collapse; width: 87.8471%; height: 57px;\" border=\"1\">
<tbody>
<tr style=\"height: 18px;\">
<td style=\"width: 33.3333%; background-color: #505050; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Words</strong></span></td>
<td style=\"width: 33.3333%; background-color: #505050; height: 18px;\"><span style=\"color: #ffffff;\"><strong>Description</strong></span></td>
</tr>
<tr style=\"height: 18px; background-color: #f1e0c6;\">
<td style=\"width: 33.3333%; height: 18px;\"><em>!example</em></td>
<td style=\"width: 33.3333%; height: 18px;\">This is just an example</td>
</tr>
<tr style=\"height: 18px; background-color: #d4c0a1;\">
<td style=\"width: 33.3333%; height: 18px;\"><em>!buyhouse</em></td>
<td style=\"width: 33.3333%; height: 18px;\">Buy house you are looking at</td>
</tr>
<tr style=\"height: 18px; background-color: #f1e0c6;\">
<td style=\"width: 33.3333%; height: 18px;\"><em>!aol</em></td>
<td style=\"width: 33.3333%; height: 18px;\">Buy AoL</td>
</tr>
</tbody>
</table>', 0, 1, 0, 1, 0);");
}