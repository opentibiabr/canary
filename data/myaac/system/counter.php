<?php
/**
 * Page views counter
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
define('COUNTER_SYNC', 10); // how often counter is synchronized with database (each x site refreshes)

$views_counter = 1; // default value, must be here!

$cache = Cache::getInstance();
if ($cache->enabled()) {
  $value = 0;
  if (!$cache->fetch('views_counter', $value) || $value <= 1) {
    $value = 0;
    if (fetchDatabaseConfig('views_counter', $value)) {
      $views_counter = $value;
    } else {
      registerDatabaseConfig('views_counter', 2);
    } // save in the database
  } else {
    $views_counter = $value;
  }

  $cache->set('views_counter', ++$views_counter, 60 * 60);
  if ($views_counter > 1 && $views_counter % COUNTER_SYNC == 0) {
    // sync with database
    updateDatabaseConfig('views_counter', $views_counter);
  }
  /*
	{
		$cache->set('views_counter', 1);

		$value = 0;
		if(fetchDatabaseConfig('views_counter', $value))
			$views_counter += $value;
	}*/
} else {
  $value = 0;
  if (!fetchDatabaseConfig('views_counter', $value)) {
    registerDatabaseConfig('views_counter', 1);
  }
  // save in the database
  else {
    $views_counter = $value + 1;
    updateDatabaseConfig('views_counter', $views_counter); // update counter
  }
}
?>
