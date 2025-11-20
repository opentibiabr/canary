<?php
/**
 * Initialize some defaults
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

// load configuration
require_once BASE . 'config.php';
if (file_exists(BASE . 'config.local.php')) {
  // user customizations
  require BASE . 'config.local.php';
}

if (!isset($config['installed']) || !$config['installed']) {
  throw new RuntimeException(
    'MyAAC has not been installed yet or there was error during installation. Please install again.'
  );
}

date_default_timezone_set($config['date_timezone']);
// take care of trailing slash at the end
if ($config['server_path'][strlen($config['server_path']) - 1] !== '/') {
  $config['server_path'] .= '/';
}

// enable gzip compression if supported by the browser
if (
  $config['gzip_output'] &&
  isset($_SERVER['HTTP_ACCEPT_ENCODING']) &&
  strpos($_SERVER['HTTP_ACCEPT_ENCODING'], 'gzip') !== false &&
  function_exists('ob_gzhandler')
) {
  ob_start('ob_gzhandler');
}

// cache
require_once SYSTEM . 'libs/cache.php';
$cache = Cache::getInstance();

// trim values we receive
if (isset($_POST)) {
  foreach ($_POST as $var => $value) {
    if (is_string($value)) {
      $_POST[$var] = trim($value);
    }
  }
}
if (isset($_GET)) {
  foreach ($_GET as $var => $value) {
    if (is_string($value)) {
      $_GET[$var] = trim($value);
    }
  }
}
if (isset($_REQUEST)) {
  foreach ($_REQUEST as $var => $value) {
    if (is_string($value)) {
      $_REQUEST[$var] = trim($value);
    }
  }
}

// load otserv config file
$config_lua_reload = true;
if ($cache->enabled()) {
  $tmp = null;
  if ($cache->fetch('server_path', $tmp) && $tmp == $config['server_path']) {
    $tmp = null;
    if ($cache->fetch('config_lua', $tmp) && $tmp) {
      $config['lua'] = unserialize($tmp);
      $config_lua_reload = false;
    }
  }
}

if ($config_lua_reload) {
  $config['lua'] = load_config_lua($config['server_path'] . 'config.lua');

  // cache config
  if ($cache->enabled()) {
    $cache->set('config_lua', serialize($config['lua']), 120);
    $cache->set('server_path', $config['server_path']);
  }
}
unset($tmp);

if (isset($config['lua']['servername'])) {
  $config['lua']['serverName'] = $config['lua']['servername'];
}

if (isset($config['lua']['houserentperiod'])) {
  $config['lua']['houseRentPeriod'] = $config['lua']['houserentperiod'];
}

if ($config['item_images_url'][strlen($config['item_images_url']) - 1] !== '/') {
  $config['item_images_url'] .= '/';
}

// localize data/ directory based on data directory set in config.lua
foreach (['dataDirectory', 'data_directory', 'datadir'] as $key) {
  if (!isset($config['lua'][$key][0])) {
    break;
  }

  $foundValue = $config['lua'][$key];
  if ($foundValue[0] !== '/') {
    $foundValue = $config['server_path'] . $foundValue;
  }

  if ($foundValue[strlen($foundValue) - 1] !== '/') {
    // do not forget about trailing slash
    $foundValue .= '/';
  }
}

if (!isset($foundValue)) {
  $foundValue = $config['server_path'] . 'data/';
}

$config['data_path'] = $foundValue;
unset($foundValue);

// new config values for compability
if (!isset($config['highscores_ids_hidden']) || count($config['highscores_ids_hidden']) == 0) {
  $config['highscores_ids_hidden'] = [0];
}

$config['account_create_character_create'] =
  config('account_create_character_create') &&
  (!config('mail_enabled') || !config('account_mail_verify'));

// POT
require_once SYSTEM . 'libs/pot/OTS.php';
$ots = POT::getInstance();
require_once SYSTEM . 'database.php';

// twig
require_once SYSTEM . 'twig.php';

define('USE_ACCOUNT_NAME', $db->hasColumn('accounts', 'name'));
define('USE_ACCOUNT_NUMBER', $db->hasColumn('accounts', 'number'));

// load vocation names
$tmp = '';
if ($cache->enabled() && $cache->fetch('vocations', $tmp)) {
  $config['vocations'] = unserialize($tmp);
} else {
  if (!class_exists('DOMDocument')) {
    throw new RuntimeException('Please install PHP xml extension. MyAAC will not work without it.');
  }

  $vocations = new DOMDocument();
  $file = $config['data_path'] . 'XML/vocations.xml';
  if (!@file_exists($file)) {
    $file = $config['data_path'] . 'vocations.xml';
  }

  if (!$vocations->load($file)) {
    throw new RuntimeException(
      'ERROR: Cannot load <i>vocations.xml</i> - the file is malformed. Check the file with xml syntax validator.'
    );
  }

  $config['vocations'] = [];
  foreach ($vocations->getElementsByTagName('vocation') as $vocation) {
    $id = $vocation->getAttribute('id');
    $config['vocations'][$id] = $vocation->getAttribute('name');
  }

  if ($cache->enabled()) {
    $cache->set('vocations', serialize($config['vocations']), 120);
  }
}
unset($tmp, $id, $vocation);

$tmp = '';
$towns = [];
if ($cache->enabled() && $cache->fetch('towns', $tmp)) {
  $towns = unserialize($tmp);
} else {
  if ($db->hasTable('towns')) {
    $query = $db
      ->query(
        'SELECT `towns`.`id`, `towns`.`name` FROM `towns` INNER JOIN `houses`
    ON `towns`.`id` = `houses`.`town_id` GROUP BY `towns`.`id` ORDER BY `towns`.`name`;'
      )
      ->fetchAll(PDO::FETCH_ASSOC);

    foreach ($query as $town) {
      $towns[$town['id']] = $town['name'];
    }

    unset($query);
  } else {
    $towns = config('towns');
  }

  if ($cache->enabled()) {
    $cache->set('towns', serialize($towns), 600);
  }
}

config(['towns', $towns]);

$config['lua']['rateStages'] = loadStagesData($config['server_path'] . 'data/stages.lua');
