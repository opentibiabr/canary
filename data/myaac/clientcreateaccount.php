<?php
/**
 * Create account by client
 *
 * @package   MyAAC
 * @author    Elson <elsongabriel@hotmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */

global $config, $db;
require_once 'common.php';
require_once 'config.php';
require_once 'config.local.php';
require_once SYSTEM . 'functions.php';
require_once SYSTEM . 'init.php';

$request = file_get_contents('php://input');
$result  = json_decode($request);
//log_append('create_account_service.log', "req: $request");

if ($result === null || (isset($result->Type) && isset($result->type))) {
  log_append('create_account_service.log', 'Request error!');
}

$action = mb_strtolower($result->type ?? ($result->Type ?? ''));

$response = null;

switch ($action) {
  case 'getaccountcreationstatus':
    $response = json_encode([
      "Worlds"               => [getServerStatus()],
      "RecommendedWorld"     => configLua('serverName'),
      "IsCaptchaDeactivated" => true
    ]);
    break;

  case 'generatecharactername':
    // todo generate suggested names.
    $response = json_encode([
      "GeneratedName" => ""
    ]);
    break;

  case 'checkcharactername':
    $name     = $result->CharacterName;
    $check    = $db->query("SELECT `name` FROM `players` WHERE `name` = {$db->quote($name)}")->rowCount() == 0;
    $response = json_encode([
      "CharacterName" => $name,
      "IsAvailable" => $check
    ]);
    break;

  case 'checkemail':
    $email      = mb_strtolower($result->Email);
    $check      = filter_var($email, FILTER_VALIDATE_EMAIL) && $db->query("SELECT `email` FROM `accounts` WHERE `email` = {$db->quote($email)}")->rowCount() == 0;
    $response   = json_encode($check ? [
      "IsValid" => true,
      "EMail"   => $email
    ] : [
      "IsValid"      => false,
      "errorCode"    => 59,
      "errorMessage" => "This email address has an invalid format. Please enter a correct email address!",
      "EMail"        => $email
    ]);
    break;

  case 'checkpassword':
    $errors = validatePassword($pass = $result->Password1);
    $response = json_encode([
      "PasswordRequirements"  => [
        "PasswordLength"      => !in_array(0, $errors),
        "InvalidCharacters"   => !in_array(1, $errors),
        "HasLowerCase"        => !in_array(2, $errors),
        "HasUpperCase"        => !in_array(3, $errors),
        "HasNumber"           => !in_array(4, $errors)
      ],
      "Password1"             => $pass,
      "PasswordStrength"      => count($errors) == 0 ? 4 : abs(count($errors) - 4),
      "PasswordStrengthColor" => count($errors) == 0 ? "#20a000" : '#ec644b',
      "PasswordValid"         => count($errors) == 0,
    ]);
    break;

  case 'createaccountandcharacter':
    $email = mb_strtolower($result->EMail);
    try {
      if (filter_var($email, FILTER_VALIDATE_EMAIL) && $db->query("SELECT `email` FROM `accounts` WHERE `email` = {$db->quote($email)}")->rowCount() == 0) {
        $response = json_encode([
          "Success"   => true,
          "AccountID" => createAccount([
            "email"         => $email,
            "password"      => $result->Password,
            "characterName" => stripslashes(ucwords(strtolower($result->CharacterName))),
            "characterSex"  => $result->CharacterSex == 'male' ? 1 : 0,
            //"clientType"      => "Client",
            //"recaptcha2token" => "",
            //"recaptcha3token" => "",
            //"selectedWorld"   => configLua('serverName'),
          ]),
          // "Password" => $result->Password
        ]);
      } else {
        throw new Exception('Email invalid!');
      }
    } catch (Exception $e) {
      log_append('create_account_service.log', "Error caught: {$e->getMessage()}");
      $response = json_encode([
        "errorCode"             => 101,
        "errorMessage"          => $e->getMessage(), //"An internal error has occurred. Please try again later!",
        "Success"               => false,
        "IsRecaptcha2Requested" => false,
      ]);
    }
    break;
}
log_append('create_account_service.log', "response: $response");
die($response);

/**
 * Function to return server status as array to worlds list
 *
 * @return array
 */
function getServerStatus(): array
{
  global $db;
  $playersOnline = $db->query("SELECT COUNT(*) FROM `players_online`")->fetchAll()[0][0] ?? 0;
  $date          = $db->query("SELECT `date` FROM `myaac_changelog`")->fetch()['date'] ?? 0;
  switch (configLua('worldType')) {
    default:
    case 'pvp':
      $pvpType = "Open PVP";
      break;
    case 'no-pvp':
      $pvpType = 'Optional PVP';
      break;
    case 'pvp-enforced':
      $pvpType = 'PVP';
      break;
    case 'retro-pvp':
      $pvpType = 'Retro PvP';
      break;
  }
  return [
    "Name"                        => configLua('serverName'),
    "PlayersOnline"               => intval($playersOnline),
    "CreationDate"                => intval($date),
    "Region"                      => "America",
    "PvPType"                     => $pvpType,
    "PremiumOnly"                 => configLua('onlyPremiumAccount'),
    "TransferType"                => "Blocked",
    "BattlEyeActivationTimestamp" => intval($date),
    "BattlEyeInitiallyActive"     => 0
  ];

}

/**
 * Function to check strength of password
 *
 * @param $password
 * @return array|int[]
 */
function validatePassword($password): array
{
  $checks    = [];
  $minLength = 10;
  $invalids  = [' ', '\'', '"', '\\', '/'];

  if (strlen($password) < $minLength) $checks = [0];
  foreach ($invalids as $char) {
    if (strpos($password, $char) !== false) $checks = array_merge($checks, [1]);
  }
  if (!preg_match('/[a-z]/', $password)) $checks = array_merge($checks, [2]);
  if (!preg_match('/[A-Z]/', $password)) $checks = array_merge($checks, [3]);
  if (!preg_match('/[0-9]/', $password)) $checks = array_merge($checks, [4]);
  return $checks;
}

/**
 * Function to create account
 *
 * @param array $data
 * @return false|string
 * @throws Exception
 */
function createAccount(array $data)
{
  global $db, $config, $twig;
  try {
    $account_name = USE_ACCOUNT_NAME ?
      @(explode('@', $data['email']))[0] . date('isH')
      : date('HisdmyHi');

    if (USE_ACCOUNT_NAME && mb_strtolower($account_name) == mb_strtolower($data['password'])) {
      throw new Exception('Password may not be the same as account name.');
    }

    $account_db = new OTS_Account();
    $account_db->find($account_name);
    if ($account_db->isLoaded()) {
      throw new Exception('Account with this name already exist.');
    }

    $info    = json_decode(@file_get_contents('https://ipinfo.io/' . $_SERVER['REMOTE_ADDR'] . '/geo'), true);
    $country = strtolower($info['country'] ?? 'br');

    $new_account = new OTS_Account();
    $new_account->create($account_name);

    $config_salt_enabled = $db->hasColumn('accounts', 'salt');
    if ($config_salt_enabled) {
      $salt             = generateRandomString(10, false, true, true);
      $data['password'] = $salt . $data['password'];
      $new_account->setCustomField('salt', $salt);
    }

    $new_account->setPassword(encrypt($data['password']));
    $new_account->setEMail($data['email']);
    $new_account->setCustomField('created', time());
    $new_account->setCustomField('country', $country);
    $new_account->save();

    $new_account->logAction('Account created.');

    if (($premdays = ($config['account_premium_days'] ?? 0)) > 0) {
      if ($db->hasColumn('accounts', 'premend')) { // othire
        $new_account->setCustomField('premend', time() + $premdays * 86400);
      } else {
        $new_account->setCustomField('premdays', $premdays);
        $lastDay = ($premdays < OTS_Account::GRATIS_PREMIUM_DAYS) ? time() + ($premdays * 86400) : 0;
        $new_account->setCustomField('lastday', $lastDay);
      }
    }

    if (($welcomeCoins = ($config['account_welcome_coins'] ?? 0)) > 0) {
      $coinType = $config['account_coin_type_usage'] ?? 'coins_transferable';
      $new_account->setCustomField($coinType, $welcomeCoins);
    }

    if ($config['mail_enabled'] && $config['account_mail_verify']) {
      $hash = md5(generateRandomString(16, true, true) . $data['email']);
      $new_account->setCustomField('email_hash', $hash);

      $verify_url = getLink('account/confirm_email/' . $hash);
      $body_html  = $twig->render('mail.account.verify.html.twig', array(
        'account'    => $account_name,
        'verify_url' => generateLink($verify_url, $verify_url, true)
      ));

      if (!_mail($data['email'], 'New account on ' . configLua('serverName'), $body_html)) {
        $new_account->delete();
        throw new Exception('An error occurred while sending email! Account not created. Try again. For Admin: More info can be found in system/logs/mailer-error.log');
      }
    } else if ($config['mail_enabled'] && $config['account_welcome_mail']) {
      $mailBody = $twig->render('account.welcome_mail.html.twig', ['account' => $account_name]);
      if (!_mail($data['email'], 'Your account on ' . configLua('serverName'), $mailBody)) {
        throw new Exception('An error occurred while sending email. For Admin: More info can be found in system/logs/mailer-error.log');
      }
    }

    // Start an output buffer
    ob_start();

    // character creation only if start in dawnport
    if (count(config('character_samples')) == 1 && !empty($data['characterName'])) {
      require_once LIBS . 'CreateCharacter.php';
      $createCharacter = new CreateCharacter();
      $errors = [];
      if (!$createCharacter->doCreate($data['characterName'], $data['characterSex'], 0, 0, $new_account, $errors)) {
        throw new Exception('There was an error creating your character. Please create your character later in account management page.');
      }
    }

    // Clear and closes the output buffer
    ob_end_clean();

    return $account_name;
  } catch (Exception $e) {
    throw new Exception($e->getMessage());
  }
}
