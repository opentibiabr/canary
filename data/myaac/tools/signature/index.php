<?php
	if(isset($_SERVER['HTTP_IF_MODIFIED_SINCE']))
	{
		header('HTTP/1.0 304 Not Modified');
		/* PHP/webserver by default can return 'no-cache', so we must modify it */
		header('Cache-Control: public');
		header('Pragma: cache');
		exit;
	}

	require_once '../../common.php';
	require_once SYSTEM . 'functions.php';
	require_once SYSTEM . 'init.php';

	// Definitions
	define('SIGNATURES', TOOLS . 'signature/');
	define('SIGNATURES_BACKGROUNDS', 'images/backgrounds/');
	define('SIGNATURES_CACHE', CACHE . 'signatures/');
	define('SIGNATURES_DATA', SYSTEM . 'data/');
	define('SIGNATURES_FONTS', SIGNATURES . 'fonts/');
	define('SIGNATURES_IMAGES', SIGNATURES . 'images/');
	define('SIGNATURES_ITEMS', BASE . 'images/items/');

	if(!$config['signature_enabled'])
		die('Signatures are disabled on this server.');

	$file = trim(strtolower($config['signature_type'])) . '.php';
	if(!file_exists($file))
		die('ERROR: Wrong signature_type in config.');

	putenv('GDFONTPATH=' . SIGNATURES_FONTS);

	if(!isset($_REQUEST['name']))
		die('Please enter name as get or post parameter.');

	$name = stripslashes(ucwords(strtolower(trim($_REQUEST['name']))));
	$player = new OTS_Player();
	$player->find($name);

	if(!$player->isLoaded())
	{
		header('Content-type: image/png');
		readfile(SIGNATURES_IMAGES.'nocharacter.png');
		exit;
	}

	if(!function_exists( 'imagecreatefrompng'))
	{
		header('Content-type: image/png');
		readfile(SIGNATURES_IMAGES.'nogd.png');
		exit;
	}

	$cached = SIGNATURES_CACHE.$player->getId() . '.png';
	if(file_exists($cached) && (time() < (filemtime($cached) + (60 * $config['signature_cache_time']))))
	{
		header( 'Content-type: image/png' );
		readfile( SIGNATURES_CACHE.$player->getId().'.png' );
		exit;
	}

	require $file;
	header('Content-type: image/png');
	$seconds_to_cache = $config['signature_browser_cache'] * 60;
	$ts = gmdate("D, d M Y H:i:s", time() + $seconds_to_cache) . " GMT";
	header('Expires: ' . $ts);
	header('Pragma: cache');
	header('Cache-Control: public, max-age=' . $seconds_to_cache);
	readfile(SIGNATURES_CACHE . $player->getId() . '.png');
?>
