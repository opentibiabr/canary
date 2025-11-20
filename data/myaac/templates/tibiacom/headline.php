<?php
//require '../../common.php';

//$text = $_GET['text'];
/*
$page_file = BASE . 'pages/' . PAGE . '.php';
if(!@file_exists($page_file))
{
	$page_file = BASE . 'pages/custom/' . PAGE . '.php';
	if(!@file_exists($page_file))
		die('Page does not exists.');
}
*/
//$file = 'images/header/headline-' . PAGE . '.gif';
//if(!file_exists($file))
//{
if (strlen($_GET['t']) > 100) // max limit
    $_GET['t'] = '';

// set font path
putenv('GDFONTPATH=' . __DIR__);

// create image
$image = imagecreatetruecolor(250, 28);

// make the background transparent
imagecolortransparent($image, imagecolorallocate($image, 0, 0, 0));

// set text
$font = getenv('GDFONTPATH') . DIRECTORY_SEPARATOR . 'martel.ttf';
imagettftext($image, 18, 0, 4, 20, imagecolorallocate($image, 240, 209, 164), $font, $_GET['t']);

// header mime type
header('Content-type: image/gif');

// save image
imagegif($image/*, $file*/);
//}

// output image
//header('Content-type: image/gif');
//readfile($file);
