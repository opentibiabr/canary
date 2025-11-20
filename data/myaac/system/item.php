<?php
/**
 * Item parser
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
require_once SYSTEM . 'libs/items_images.php';

Items_Images::$files = [
  'otb' => SYSTEM . 'data/items.otb',
  'spr' => SYSTEM . 'data/Tibia.spr',
  'dat' => SYSTEM . 'data/Tibia.dat',
];
Items_Images::$outputDir = BASE . 'images/items/';

function generateItem($id = 100, $count = 1)
{
  Items_Images::generate($id, $count);
}

function itemImageExists($id, $count = 1)
{
  if (!isset($id)) {
    throw new RuntimeException('ERROR - itemImageExists: id has been not set!');
  }

  $file_name = $id;
  if ($count > 1) {
    $file_name .= '-' . $count;
  }

  $file_name = Items_Images::$outputDir . $file_name . '.gif';
  return file_exists($file_name);
}

function outputItem($id = 100, $count = 1)
{
  if (!(int) $count) {
    $count = 1;
  }

  if (!itemImageExists($id, $count)) {
    //echo 'plik istnieje';
    Items_Images::generate($id, $count);
  }

  $expires = 60 * 60 * 24 * 30; // 30 days
  header('Content-type: image/gif');
  header('Cache-Control: public');
  header('Cache-Control: maxage=' . $expires);
  header('Expires: ' . gmdate('D, d M Y H:i:s', time() + $expires) . ' GMT');

  $file_name = $id;
  if ($count > 1) {
    $file_name .= '-' . $count;
  }

  $file_name = Items_Images::$outputDir . $file_name . '.gif';
  readfile($file_name);
}
?>
