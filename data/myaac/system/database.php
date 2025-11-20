<?php
/**
 * Database connection
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

if (
  !isset($config['database_user'][0], $config['database_password'][0], $config['database_name'][0])
) {
  if (isset($config['lua']['sqlType'])) {
    // tfs 0.3
    if (isset($config['lua']['mysqlHost'])) {
      // tfs 0.2
      $config['otserv_version'] = TFS_02;
      $config['database_type'] = 'mysql';
      $config['database_host'] = $config['lua']['mysqlHost'];
      $config['database_port'] = $config['lua']['mysqlPort'];
      $config['database_user'] = $config['lua']['mysqlUser'];
      $config['database_password'] = $config['lua']['mysqlPass'];
      $config['database_name'] = $config['lua']['mysqlDatabase'];
      $config['database_encryption'] = $config['lua']['passwordType'];
    } else {
      $config['otserv_version'] = TFS_03;
      $config['database_type'] = $config['lua']['sqlType'];
      $config['database_host'] = $config['lua']['sqlHost'];
      $config['database_port'] = $config['lua']['sqlPort'];
      $config['database_user'] = $config['lua']['sqlUser'];
      $config['database_password'] = $config['lua']['sqlPass'];
      $config['database_name'] = $config['lua']['sqlDatabase'];

      $config['database_encryption'] = $config['lua']['encryptionType'];
      if (!isset($config['database_encryption']) || empty($config['database_encryption'])) {
        // before 0.3.6
        $config['database_encryption'] = $config['lua']['passwordType'];
      }
    }
  } elseif (isset($config['lua']['mysqlHost'])) {
    // tfs 1.0
    $config['otserv_version'] = TFS_02;
    $config['database_type'] = 'mysql';
    $config['database_host'] = $config['lua']['mysqlHost'];
    $config['database_port'] = $config['lua']['mysqlPort'];
    $config['database_user'] = $config['lua']['mysqlUser'];
    $config['database_password'] = $config['lua']['mysqlPass'];
    $config['database_name'] = $config['lua']['mysqlDatabase'];
    if (!isset($config['database_socket'][0])) {
      $config['database_socket'] = isset($config['lua']['mysqlSock'])
        ? trim($config['lua']['mysqlSock'])
        : '';
    }
    $config['database_encryption'] = 'sha1';
  } elseif (isset($config['lua']['database_type'])) {
    // otserv
    $config['otserv_version'] = OTSERV;
    $config['database_type'] = $config['lua']['database_type'];
    $config['database_host'] = $config['lua']['database_host'];
    $config['database_port'] = $config['lua']['database_port'];
    $config['database_user'] = $config['lua']['database_username'];
    $config['database_password'] = $config['lua']['database_password'];
    $config['database_name'] = $config['lua']['database_schema'];
    $config['database_encryption'] = isset($config['lua']['passwordtype'])
      ? $config['lua']['passwordtype']
      : $config['lua']['password_type'];
    $config['database_salt'] = isset($config['lua']['passwordsalt'])
      ? $config['lua']['passwordsalt']
      : $config['lua']['password_salt'];
  } elseif (isset($config['lua']['sql_host'])) {
    // otserv 0.6.3 / 0.6.4
    $config['otserv_version'] = OTSERV_06;
    $config['database_type'] = $config['lua']['sql_type'];
    $config['database_host'] = $config['lua']['sql_host'];
    $config['database_port'] = $config['lua']['sql_port'];
    $config['database_user'] = $config['lua']['sql_user'];
    $config['database_password'] = $config['lua']['sql_pass'];
    $config['database_name'] = $config['lua']['sql_db'];
    $config['database_encryption'] = isset($config['lua']['passwordtype'])
      ? $config['lua']['passwordtype']
      : $config['lua']['password_type'];
    $config['database_salt'] = isset($config['lua']['passwordsalt'])
      ? $config['lua']['passwordsalt']
      : $config['lua']['password_salt'];
  }
}

if (isset($config['lua']['useMD5Passwords']) && getBoolean($config['lua']['useMD5Passwords'])) {
  $config['database_encryption'] = 'md5';
}

if (!isset($config['database_log'])) {
  $config['database_log'] = false;
}

if (!isset($config['database_socket'])) {
  $config['database_socket'] = '';
}

try {
  $ots->connect([
    'host' => $config['database_host'],
    'port' => $config['database_port'],
    'user' => $config['database_user'],
    'password' => $config['database_password'],
    'database' => $config['database_name'],
    'log' => $config['database_log'],
    'socket' => @$config['database_socket'],
    'persistent' => @$config['database_persistent'],
  ]);

  $db = POT::getInstance()->getDBHandle();
} catch (PDOException $error) {
  if (isset($cache) && $cache->enabled()) {
    $cache->delete('config_lua');
  }

  if (defined('MYAAC_INSTALL')) {
    return; // installer will take care of this
  }

  throw new RuntimeException(
    'ERROR: Cannot connect to MySQL database.<br/>' .
      'Possible reasons:' .
      '<ul>' .
      '<li>MySQL is not configured propertly in <i>config.lua</i>.</li>' .
      '<li>MySQL server is not running.</li>' .
      '</ul>' .
      $error->getMessage()
  );
}
