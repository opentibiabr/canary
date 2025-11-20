<?php
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Spells';

$canEdit = hasFlag(FLAG_CONTENT_SPELLS) || admin();
if (isset($_POST['reload_spells']) && $canEdit) {
	require LIBS . 'spells.php';
	if (!Spells::loadFromXML(true)) {
		error(Spells::getLastError());
	}
}

$spellsJson = BASE . "tools/spells.json";
$getJson = json_decode(file_get_contents($spellsJson), true);

$array = [];
foreach ($getJson as $tipos) {
	foreach ($tipos as $data) {
		$array[] = $data;
	}
}

$get = filter_input(INPUT_GET, 'spell');

/**
 * PÁGINA DA MAGIA:
 */
if (!empty($get)) {
	$replaces = [];
	$replaces['title'] = $get;

	$key = null;
	foreach ($array as $index => $spell) {
		if ($spell['name'] == $get) {
			$key = $index;
			break;
		}
	}

	$dados = $array[$key] ?? null;
	$dados['vocation'] = implode(', ', $dados['vocation']);
	$dados['type'] = $dados['type'] == "Spell" ? "Instant" : "Rune";
	$dados['cooldown'] = $dados['cooldown'] / 1000;
	$dados['groupCooldown'] = $dados['groupCooldown'] / 1000;

	$replaces['dados'] = $dados;
	$replaces['imageName'] = str_replace(' ', '_', $get) . ".png";

	$twig->display('spell.html.twig', $replaces);
	return;
}

/**
 *
 *
 * LISTA DE MAGIAS ABAIXO
 *
 *
 */

$post = filter_input_array(INPUT_POST);

$sortName = $post['sort'] ?? 'name';

usort($array, function ($a, $b) use ($sortName) {
	if (in_array($sortName, ['level', 'mana', 'price'])) {
		return $a[$sortName] < $b[$sortName];
	}

	if ($sortName == "premium") {
		$sortName = "isPremium";
	}

	return strcmp($a[$sortName], $b[$sortName]);
});

if (!empty($post)) {
	foreach ($array as $index => $spell) {
		if (!empty($post['premium']) && isset($spell['isPremium'])) {
			$premium = $post['premium'] == 'yes' ? "true" : "false";
			if ($spell['isPremium'] != $premium) {
				unset($array[$index]);
			}
		}

		if (!empty($post['type']) && isset($spell['type'])) {
			$type = $post['type'] == 'Instant' ? "Spell" : "";
			if ($spell['type'] != $type) {
				unset($array[$index]);
			}
		}

		if (!empty($post['group']) && !empty($spell['group'])) {
			if (!strContains(strtolower($post['group']), $spell['group'])) {
				unset($array[$index]);
			}
		}

		if (!empty($spell['vocation']) && !empty($post['vocation'])) {
			if (!in_array($post['vocation'], $spell['vocation'])) {
				unset($array[$index]);
			}
		}
	}
}

$twig->display('spells.html.twig', array(
	'BASE_URL'  => BASE_URL,
	'canEdit'   => $canEdit,
	'spells'    => $array,
	'post'      => $post,
	'item_path' => $config['item_images_url'],
));
