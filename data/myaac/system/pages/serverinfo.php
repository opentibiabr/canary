<?php
/**
 * Server info
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    whiteblXK
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Server Info';

$rent = trim(strtolower(configLua('houseRentPeriod')));
if ($rent != 'yearly' && $rent != 'monthly' && $rent != 'weekly' && $rent != 'daily')
    $rent = 'never';

$houseLevel = configLua('houseBuyLevel');
$cleanOld = null;

if ($pzLocked = configLua('pzLocked') ?? null)
    $pzLocked = eval('return ' . $pzLocked . ';');

if ($whiteSkullTime = configLua('whiteSkullTime') ?? null)
    $whiteSkullTime = eval('return ' . $whiteSkullTime . ';');

if ($redSkullDuration = configLua('redSkullDuration') ?? null)
    $redSkullDuration = eval('return ' . $redSkullDuration . ';');

if ($blackSkullDuration = configLua('blackSkullDuration') ?? null)
    $blackSkullDuration = eval('return ' . $blackSkullDuration . ';');

$explodeServerSave = explode(':', configLua('globalServerSaveTime') ?? '05:00:00');
$hours_ServerSave = $explodeServerSave[0];
$minutes_ServerSave = $explodeServerSave[1];
$seconds_ServerSave = $explodeServerSave[2];

$now = new DateTime();
$serverSaveTime = new DateTime();
$serverSaveTime->setTime($hours_ServerSave, $minutes_ServerSave, $seconds_ServerSave);

if ($now > $serverSaveTime) {
    $serverSaveTime->modify('+1 day');
}

$twig->display('serverinfo.html.twig', [
    'serverSave' => $explodeServerSave,
    'serverSaveTime' => $serverSaveTime->format('Y, n-1, j, G, i, s'),
    'rateUseStages' => $rateUseStages = getBoolean(configLua('rateUseStages')),
    'rateStages' => $rateUseStages && isset($config['lua']['rateStages']) ? $config['lua']['rateStages'] : [],
    'serverIp' => str_replace(['http://', 'https://', '/'], '', configLua('url')),
    'clientVersion' => $status['clientVersion'] ?? null,
    'protectionLevel' => configLua('protectionLevel'),
    'houseRent' => $rent == 'never' ? 'disabled' : $rent,
    'houseOld' => $cleanOld ?? null, // in progressing
    'rateExp' => configLua('rateExp'),
    'rateMagic' => configLua('rateMagic'),
    'rateSkill' => configLua('rateSkill'),
    'rateLoot' => configLua('rateLoot'),
    'rateSpawn' => configLua('rateSpawn'),
    'houseLevel' => $houseLevel,
    'pzLocked' => $pzLocked,
    'whiteSkullTime' => $whiteSkullTime,
    'redSkullDuration' => $redSkullDuration,
    'blackSkullDuration' => $blackSkullDuration,
    'dailyFragsToRedSkull' => configLua('dayKillsToRedSkull') ?? null,
    'weeklyFragsToRedSkull' => configLua('weekKillsToRedSkull') ?? null,
    'monthlyFragsToRedSkull' => configLua('monthKillsToRedSkull') ?? null,
]);
