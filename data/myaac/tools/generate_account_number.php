<?php
/**
 * Account Number Generator
 * Returns json with result
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */

// we need some functions
require '../common.php';
require SYSTEM . 'functions.php';
require SYSTEM . 'init.php';

$hasNumberColumn = $db->hasColumn('accounts', 'number');
do {
  $length = 10;
  $min = (int) (1 . str_repeat(0, $length - 1));
  $max = (int) str_repeat(9, $length);

  try {
    $number = random_int($min, $max);
  } catch (Exception $e) {
    error_('');
  }

  $query = $db->query(
    'SELECT `id` FROM `accounts` WHERE `' .
      ($hasNumberColumn ? 'number' : 'id') .
      '` = ' .
      $db->quote($number)
  );
} while ($query->rowCount() >= 1);

success_($number);

/**
 * Output message & exit.
 *
 * @param string $desc Description
 */
function success_($desc)
{
  echo json_encode([
    'success' => $desc,
  ]);
  exit();
}
function error_($desc)
{
  echo json_encode([
    'error' => $desc,
  ]);
  exit();
}
