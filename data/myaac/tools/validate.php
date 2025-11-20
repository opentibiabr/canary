<?php
/**
 * Ajax validator
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
require SYSTEM . 'login.php';

$error = '';
if (isset($_GET['account'])) {
  $account = $_GET['account'];
  if (USE_ACCOUNT_NAME) {
    if (!Validator::accountName($account)) {
      error_(Validator::getLastError());
    }
  } elseif (!Validator::accountId($account)) {
    error_(Validator::getLastError());
  }

  $_account = new OTS_Account();
  if (USE_ACCOUNT_NAME) {
    $_account->find($account);
  } else {
    $_account->load($account);
  }

  if ($_account->isLoaded()) {
    error_('Account with this name already exist.');
  }

  success_('Good account' . (USE_ACCOUNT_NAME ? ' name' : '') . ' ( ' . $account . ' ).');
} elseif (isset($_GET['email'])) {
  $email = $_GET['email'];
  if (!Validator::email($email)) {
    error_(Validator::getLastError());
  }

  if ($config['account_mail_unique']) {
    $account = new OTS_Account();
    $account->findByEMail($email);
    if ($account->isLoaded()) {
      error_('Account with this e-mail already exist.');
    }
  }

  success_(1);
} elseif (isset($_GET['name'])) {
  $name = strtolower(stripslashes($_GET['name']));
  if (!Validator::characterName($name)) {
    error_(Validator::getLastError());
  }

  if (!admin() && !Validator::newCharacterName($name)) {
    error_(Validator::getLastError());
  }

  require_once LIBS . 'CreateCharacter.php';
  $createCharacter = new CreateCharacter();
  if (!$createCharacter->checkName($name, $errors)) {
    error_($errors['name']);
  }

  success_('Good. Your name will be:<br /><b>' . ucwords($name) . '</b>');
} elseif (isset($_GET['password']) && isset($_GET['password2'])) {
  $password = $_GET['password'];
  $password2 = $_GET['password2'];

  if (!isset($password[0])) {
    error_('Please enter the password for your new account.');
  }

  if (!Validator::password($password)) {
    error_(Validator::getLastError());
  }

  if ($password != $password2) {
    error_('Passwords are not the same.');
  }

  success_(1);
} else {
  error_('Error: no input specified.');
}

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
